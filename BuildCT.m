function [CT_Image,CT_Header] = BuildCT(CT)

disp('** Building CT Series into Matrix **')
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
CT_Header.ImagePositionPatient = Origin1;
x0=Origin1(1);
y0=Origin1(2);
z0=Origin1(3);
CT_Header.rows=Info_Last.Rows;
CT_Header.columns=Info_Last.Columns; 
CT_Header.PixelSize=Info_Last.PixelSpacing(1);
CT_Header.PixelSpacing = Info_Last.PixelSpacing;
CT_Header.SliceSpacing = norm(Origin2(3) - Origin1(3));

[CT_Image] = creatCTSeries(CT_Header.rows,CT_Header.columns,length(CT),CT);



end


function [CTRefrenceImage] = creatCTSeries(rows,columns,CTno,CTImageList) 

CTRefrenceImage = zeros(rows,columns,CTno);
SliceLocation = zeros(1,CTno);
CTImageList2 = cell(size(CTImageList));
n=1;
for i=1:CTno
    if CTImageList{i}.Rows == rows
        SliceLocation(n) = CTImageList{i}.SliceLocation;
        CTImageList2{n} = CTImageList{i};
        n = n+1;
    end
end
sortedSliceLocation = sort(SliceLocation);
for i=1:length(sortedSliceLocation)
	[I] = find(sortedSliceLocation(i)==SliceLocation);
	CTRefrenceImage(:,:,i) = double(dicomread(CTImageList2{I}.Filename));
	CTRefrenceImage(:,:,i) = (CTRefrenceImage(:,:,i) .* CTImageList2{I}.RescaleSlope) + CTImageList2{I}.RescaleIntercept;
end

end