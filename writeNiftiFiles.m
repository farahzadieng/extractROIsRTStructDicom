function writeNiftiFiles(CT_Image,CT_Header,Struct_Image,ROInames)

[cutPosition] = deterCut(Struct_Image{2});

disp('deter cut')
OutputAddress = input('Input folder address to store Output files (Press ENTER to set Default Dir. = D:\\Output)\n','s');
if isempty(OutputAddress)
    OutputAddress = 'D:\Output';
    mkdir(OutputAddress)
end
if ~isfolder(OutputAddress)
    mkdir(OutputAddress)
    cd(OutputAddress)
else
    cd(OutputAddress)
end



[CT_Image] = deArtifactCTSeeding(CT_Image,Struct_Image);
disp('deartfact ct')
saveCT(CT_Image(cutPosition(1):cutPosition(2),cutPosition(3):cutPosition(4),:),CT_Header.SliceSpacing2,CT_Header.PixelSpacing2,'CT_cropped.nii')
disp('crop ct')
while size(CT_Image,1) < 512 || size(CT_Image,2) < 512 
    if size(CT_Image,1) < 512
        
        CT_Image(end+1,:,:) = 0;
        disp('added a col')
    end
    if size(CT_Image,2) < 512
        CT_Image(:,end+1,:) = 0;
        disp('added a row')
    end
end
disp('fix ct size')
saveCT(CT_Image,CT_Header.SliceSpacing2,CT_Header.PixelSpacing2,'CT_512x512.nii')
disp('not crppped')
fileID = fopen('D:\Matlab\Projects\extractRS\sizeInf.txt','w');
fprintf(fileID,'row ind is between %u and %u \ncol ind is between %u and %u \n',cutPosition(1),cutPosition(2),cutPosition(3),cutPosition(4));
fprintf(fileID,'Size is %ux%u\n',(cutPosition(2)-cutPosition(1)+1),(cutPosition(4)-cutPosition(3)+1));
fprintf(fileID,'=======================================\n=======================================\n');
fclose(fileID);
for i=3:length(ROInames)
    if any(any(any(Struct_Image{i}))) ~= 0
        saveStruct(Struct_Image{i}(cutPosition(1):cutPosition(2),cutPosition(3):cutPosition(4),:),CT_Header.SliceSpacing2,CT_Header.PixelSpacing2,ROInames(i))
        
    else
        continue
    end
end
while size(Struct_Image{2},1) < 512 || size(Struct_Image{2},2) < 512 
    if size(Struct_Image{2},1) < 512
        Struct_Image{2}(end+1,:,:) = 0;
        
    elseif size(Struct_Image{2},2) < 512 
        Struct_Image{2}(:,end+1,:) = 0;
    end
end
saveStruct(Struct_Image{2},CT_Header.SliceSpacing2,CT_Header.PixelSpacing2,"Body_512x512.nii")
end

function saveCT(CTRefrenceImage,CTSliceSpacing,CTPixelSpacing,ctFileName)
	niftiwrite(CTRefrenceImage,ctFileName)
	niiInfo = niftiinfo(ctFileName);
	niiInfo.PixelDimensions = [CTPixelSpacing(1) CTPixelSpacing(2) CTSliceSpacing];
	niftiwrite(CTRefrenceImage,ctFileName,niiInfo)
end

function saveStruct(structuresMatrix,CTSliceSpacing,CTPixelSpacing,ROIname)
	niftiwrite(structuresMatrix,ROIname)
	niiInfo = niftiinfo(ROIname);
	niiInfo.PixelDimensions = [CTPixelSpacing(1) CTPixelSpacing(2) CTSliceSpacing];
	niftiwrite(structuresMatrix,ROIname,niiInfo)
end

