function [fixedRDImage] = RegistRD(RDInfo,CT_Header,CT_Image)

disp('** Registering Dose Map **')
RDdata = dicomread(RDInfo.Filename);
RDImage = squeeze(double(RDdata)*RDInfo.DoseGridScaling);

[fixedRDImage] = RDResFix(RDInfo,RDImage,CT_Header.PixelSpacing,CT_Header.SliceSpacing,CT_Image,CT_Header.ImagePositionPatient);

end

function [Slice] = RDResFix(RDInfo,RDImage,CTPixelSpacing,CTSliceSpacing,CTRefrenceImage,CTImagePosition)
	RDPixelSpacing = RDInfo.PixelSpacing;
	RDImagePosition = RDInfo.ImagePositionPatient;
	RDSliceSpacing = RDInfo.GridFrameOffsetVector(3) - RDInfo.GridFrameOffsetVector(2);
	[xRD1,yRD1,zRD1] = meshgrid(RDPixelSpacing(2)*[0:1:size(RDImage,2)-1],RDPixelSpacing(1)*[0:1:size(RDImage,1)-1],RDSliceSpacing*[0:1:size(RDImage,3)-1]);
	[xRD2, yRD2, zRD2] = meshgrid(RDPixelSpacing(2)*[0:CTPixelSpacing(2)/RDPixelSpacing(2):size(RDImage,2)-1],RDPixelSpacing(1)*[0:CTPixelSpacing(1)/RDPixelSpacing(1):size(RDImage,1)-1],RDSliceSpacing*[0:CTSliceSpacing/RDSliceSpacing:size(RDImage,3)-1]);
	NewRDImage = interp3 (xRD1, yRD1, zRD1, RDImage, xRD2, yRD2, zRD2);
	clear RDImage
	RDImage = NewRDImage;
	clear NewRDImage
	ReLocated = zeros(size(CTRefrenceImage));

	SpacingRatio = [CTPixelSpacing(1), CTPixelSpacing(2), CTSliceSpacing];
	NewRDImagePostion = (RDImagePosition - CTImagePosition);
	for i=1:length(NewRDImagePostion)
		NewRDImagePostion(i) = round(NewRDImagePostion(i) / SpacingRatio(i)) + 1;
	end
	for l=1:size(RDImage,3)
		for i=1:size(RDImage,1)
			for j=1:size(RDImage,2)
				ReLocated(NewRDImagePostion(2)+i,NewRDImagePostion(1)+j,l) = RDImage(i,j,l);
			end
		end
	end

	Slice = zeros(size(CTRefrenceImage));
	for i=1:size(ReLocated,3)
		Slice(:,:,i) = ReLocated(:,:,i);
    end

end



