function [newRSImage] = deResoloutionizeRS(RS_Image,RS_Header)

newPixelSize = [0.9766 0.9766]';
newSliceSpacing = 3;
[xRD1,yRD1,zRD1] = meshgrid(RS_Header.PixelSpacing(2)*[0:1:size(RS_Image,2)-1],RS_Header.PixelSpacing(1)*[0:1:size(RS_Image,1)-1],RS_Header.SliceSpacing*[0:1:size(RS_Image,3)-1]);
[xRD2, yRD2, zRD2] = meshgrid(RS_Header.PixelSpacing(2)*[0:newPixelSize(2)/RS_Header.PixelSpacing(2):size(RS_Image,2)-1],RS_Header.PixelSpacing(1)*[0:newPixelSize(1)/RS_Header.PixelSpacing(1):size(RS_Image,1)-1],RS_Header.SliceSpacing*[0:newSliceSpacing/RS_Header.SliceSpacing:size(RS_Image,3)-1]);
newRSImage = interp3 (xRD1, yRD1, zRD1, RS_Image, xRD2, yRD2, zRD2);
newRSImage(newRSImage<0.5) = 0;
newRSImage(newRSImage>=0.5) = 1;
end