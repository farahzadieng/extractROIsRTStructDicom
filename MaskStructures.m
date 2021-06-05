function [MaskData,roiList] = MaskStructures(CT,RS)

disp('** Making structure Masks**')
ImagePositionPatient = zeros(length(CT),4);
n = 0;
for i=1:length(CT)
   ImagePositionPatient(n+1,:)=[n+1,CT{i}.ImagePositionPatient']; 
   n = n + 1;
end

for i=1:size(ImagePositionPatient,1)
    ImagePositionPatient(i,5)=(ImagePositionPatient(i,2:4)-ImagePositionPatient(1,2:4))/(ImagePositionPatient(2,2:4)-ImagePositionPatient(1,2:4))*norm(ImagePositionPatient(2,2:4)-ImagePositionPatient(1,2:4));
end

SliceLocationSort = sortrows(ImagePositionPatient,5);
Info_Last=CT{SliceLocationSort(end,1)}; 
Info_Last2=CT{SliceLocationSort(end-1,1)};
Origin1=Info_Last.ImagePositionPatient;
Origin2=Info_Last2.ImagePositionPatient;
% CT_Header.ImagePositionPatient = Origin1;
x0=Origin1(1);
y0=Origin1(2);
z0=Origin1(3);
CT_Header.rows=Info_Last.Rows;
CT_Header.columns=Info_Last.Columns; 
CT_Header.PixelSize=Info_Last.PixelSpacing(1);
CT_Header.PixelSpacing = Info_Last.PixelSpacing;
CT_Header.SliceSpacing = norm(Origin2(3) - Origin1(3));
 

roiCount = length(fieldnames(RS.ROIContourSequence));
% Save Structure List
roiList = cell(roiCount,3);
for i=1:roiCount
    ROI_Number=eval(['RS.StructureSetROISequence.Item_',num2str(i),'.ROINumber']);
    ROI_Name=eval(['RS.StructureSetROISequence.Item_',num2str(i),'.ROIName']);
    roiList{i,1}=i;
    roiList{i,2}=ROI_Number;
    roiList{i,3}=ROI_Name;
end

% for i=1:roiCount
%     ROI_Number=eval(['RS.StructureSetROISequence.Item_',num2str(i),'.ROINumber']);
%     ROI_Name=eval(['RS.StructureSetROISequence.Item_',num2str(i),'.ROIName']);
%     roiList{i,1}=i;
%     roiList{i,2}=ROI_Number;
%     roiList{i,3}=ROI_Name;
% end

for i=1:roiCount
    try
        NumberOfContourSeq = length(fieldnames(eval(['RS.ROIContourSequence.Item_',num2str(i),'.ContourSequence'])));
    catch
        ContourSlice=zeros(1,2);
        continue
    end
    for ContourDataIndex=1:NumberOfContourSeq
        ContourData=eval(['RS.ROIContourSequence.Item_',num2str(i),'.ContourSequence.Item_',num2str(ContourDataIndex),'.ContourData']);
        ContourData_Voxels=zeros(eval(['RS.ROIContourSequence.Item_',num2str(i),'.ContourSequence.Item_',num2str(ContourDataIndex),'.NumberOfContourPoints']),3);
        NumberOfContoursPoints = eval(['RS.ROIContourSequence.Item_',num2str(i),'.ContourSequence.Item_',num2str(ContourDataIndex),'.NumberOfContourPoints']);
        NumberOfContourData = length(eval(['RS.ROIContourSequence.Item_',num2str(i),'.ContourSequence.Item_',num2str(ContourDataIndex),'.ContourData']));
        for ContourPointNo=1:NumberOfContoursPoints
            ContourData_Voxels(ContourPointNo,1)=round((ContourData(3*ContourPointNo-2,1)-x0)/Info_Last.PixelSpacing(1));
            ContourData_Voxels(ContourPointNo,2)=round((ContourData(3*ContourPointNo-1,1)-y0)/Info_Last.PixelSpacing(2));
            ContourData_Voxels(ContourPointNo,3)=round((ContourData(3*ContourPointNo,1)-z0)/CT_Header.SliceSpacing);
        end
        StructureContourData{ContourDataIndex}=ContourData_Voxels;
        ContourSlice(ContourDataIndex,:)=[ContourDataIndex,ContourData_Voxels(1,3)];
    end
    ContourGroupIndexStructure{i}=ContourDataIndex;
    Structure{i}=StructureContourData;
    ContourGroupXCTsliceStructure{i}=ContourSlice;
    clear ContourGroupDATA_Structure
    clear ContourGroupIndexStructure
    clear ContourGroupXCTslice
    clear StructureContourData
    clear ContourSlice
end

EMPTYIMAGE=zeros(CT_Header.rows,CT_Header.columns);
for i=1:length(Structure)
    StructureContourData = Structure{i};
    ContourSlice = ContourGroupXCTsliceStructure{i};
    if isempty(ContourSlice)
        continue
    end
    for SliceIndex=1:length(CT)
        [I]=find(ContourSlice(:,2)==SliceIndex-1);
        if length(I)>0
            MaskSlice=zeros(CT_Header.rows,CT_Header.columns);
            for k=1:length(I)
                ContourSlice2D=StructureContourData{I(k)};
                ContourMask=roipoly(MaskSlice,ContourSlice2D(:,1),ContourSlice2D(:,2));
                MaskSlice=MaskSlice+ContourMask;
                checkFill = 0;
            end
        else
            checkFill = 1;
        end
        
        if checkFill == 0
            MASK{SliceIndex}=MaskSlice;
        else
            MASK{SliceIndex}=EMPTYIMAGE;
        end
    end
    StructMask{i}=MASK;
end

MaskData = StructMask;

end

