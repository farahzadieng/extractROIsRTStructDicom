function [NewCTImage] = deResoloutionizeCT(CT_Image,CT_Header)




newPixelSize = [0.9766 0.9766]';
newSliceSpacing = 3;
[xRD1,yRD1,zRD1] = meshgrid(CT_Header.PixelSpacing(2)*[0:1:size(CT_Image,2)-1],CT_Header.PixelSpacing(1)*[0:1:size(CT_Image,1)-1],CT_Header.SliceSpacing*[0:1:size(CT_Image,3)-1]);
[xRD2, yRD2, zRD2] = meshgrid(CT_Header.PixelSpacing(2)*[0:newPixelSize(2)/CT_Header.PixelSpacing(2):size(CT_Image,2)-1],CT_Header.PixelSpacing(1)*[0:newPixelSize(1)/CT_Header.PixelSpacing(1):size(CT_Image,1)-1],CT_Header.SliceSpacing*[0:newSliceSpacing/CT_Header.SliceSpacing:size(CT_Image,3)-1]);
NewCTImage = interp3 (xRD1, yRD1, zRD1, CT_Image, xRD2, yRD2, zRD2);


end