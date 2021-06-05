function [MR_T1,MR_T1_info,MR_T2,MR_T2_info] = GetMRs(dicomlist)

MRCount = 0;
pBar = waitbar(0,'Scanning for MR Files...');
for i=1:length(dicomlist)
    pCount = i / length(dicomlist);
    waitbar(pCount,pBar,'Scanning for MR Files...');
    if dicomlist(i).bytes>0
        try
            if length(dicominfo(dicomlist(i).FullDir).Modality)==2
                if dicominfo(dicomlist(i).FullDir).Modality == "MR"
                    MRCount = MRCount + 1;
                    MRList{MRCount} = dicominfo(dicomlist(i).FullDir);
                end
            end
        catch
            continue
        end
    end
end
close(pBar) 


ClassID = {};
ClassIndex = [];
disp('** Finding Series Descriptions **')

for i=1:MRCount
    classIDStr = string(MRList{i}.SeriesDescription);
    if length(ClassID)>0
        m = [];
        for j=1:length(ClassID)
            m(j) = strcmp(ClassID{j},classIDStr);
        end
        if ~any(m)
            ClassID{end+1} = classIDStr;
            ClassIndex(end+1) = i;
            
        end
    else
        ClassID{1} = classIDStr;
        ClassIndex = i;
    end
end

disp(['Found ',num2str(length(ClassID)),' study intances in MR series'])
for i=1:length(ClassID)
    subplot(round(length(ClassID)/2),2,i)
    imshow(dicomread(MRList{ClassIndex(i)}.Filename),[])
    title([num2str(i),') ',MRList{ClassIndex(i)}.SeriesDescription])
end

T1index = input('Input T1 Series Desired Study Intance Number: (Type none if none)\n','s');
T2index = input('Input T2 Series Desired Study Intance Number: (Type none if none)\n','s');

[MR_T1,MR_T1_info] = ExtractMR(T1index,ClassID,MRCount,MRList);
[MR_T2,MR_T2_info] = ExtractMR(T2index,ClassID,MRCount,MRList);

close all 

end

function [MR,MRINFO] = ExtractMR(index,ClassID,MRCount,MRList)

if lower(index) == "none"
    MR = {};
    MRINFO = {};
else
    
    w1 = ClassID{str2num(index)};
    n=1;
    MR_T = {} ;
    for i=1:MRCount
        if strcmp(string(MRList{i}.SeriesDescription),w1{1})
            MR_T{n} = MRList{i};
            n = n+1;
        end
    end
    [MR_T] = removeDuplicate(MR_T);
    [MR,MRINFO] = SortImage(MR_T);
end

end

function [newMR,info] = SortImage(MRIList)
Count = length(MRIList);
info.Rows = MRIList{1}.Rows;
info.Columns = MRIList{1}.Columns;
info.PixelSpacing = MRIList{1}.PixelSpacing;
info.SliceThickness = MRIList{1}.SliceThickness;
info.Length = Count;

MRRefrenceImage = zeros(info.Rows,info.Columns,Count);

PositionOfImage = zeros(1,Count);
for i=1:Count
    PositionOfImage(i) = MRIList{i}.ImagePositionPatient(3);
end
SortedPostions = sort(PositionOfImage);

for i=1:Count
    MRRefrenceImage(:,:,i) = double(dicomread(MRIList{i}.Filename));
end

newMR = zeros(size(MRRefrenceImage));
for i=1:Count
    [I] = find(PositionOfImage(i) == SortedPostions);
    newMR(:,:,I(1)) = MRRefrenceImage(:,:,i);
end

end

function [MR_T2] = removeDuplicate(MR_T)

for i=1:length(MR_T)
	SOPInstanceUID(i) = string(MR_T{i}.SOPInstanceUID);
end

[uniqueSOP,r_uniqueSOP] = unique(SOPInstanceUID);

n= 1;
for i=1:length(uniqueSOP)
	MR_T2{n} = MR_T{r_uniqueSOP(i)};
	n = n + 1;
end

end
