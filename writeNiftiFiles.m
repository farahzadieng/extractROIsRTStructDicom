function writeNiftiFiles(CT_Image,CT_Header,Struct_Image,ROInames)

[cutPosition] = deterCut(CT_Image);


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
saveCT(CT_Image(cutPosition(1):cutPosition(2),cutPosition(3):cutPosition(4),:),CT_Header.SliceSpacing2,CT_Header.PixelSpacing2)
for i=2:length(ROInames)
    if any(any(any(Struct_Image{i}))) ~= 0
        saveStruct(Struct_Image{i}(cutPosition(1):cutPosition(2),cutPosition(3):cutPosition(4),:),CT_Header.SliceSpacing2,CT_Header.PixelSpacing2,ROInames(i))
    else
        continue
    end
end

end

function saveCT(CTRefrenceImage,CTSliceSpacing,CTPixelSpacing)
	niftiwrite(CTRefrenceImage,'CT.nii')
	niiInfo = niftiinfo('CT.nii');
	niiInfo.PixelDimensions = [CTPixelSpacing(1) CTPixelSpacing(2) CTSliceSpacing];
	niftiwrite(CTRefrenceImage,'CT.nii',niiInfo)
end

function saveStruct(structuresMatrix,CTSliceSpacing,CTPixelSpacing,ROIname)
	niftiwrite(structuresMatrix,ROIname)
	niiInfo = niftiinfo(ROIname);
	niiInfo.PixelDimensions = [CTPixelSpacing(1) CTPixelSpacing(2) CTSliceSpacing];
	niftiwrite(structuresMatrix,ROIname,niiInfo)
end

