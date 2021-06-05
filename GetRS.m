function [CTList,RSList] = GetRS(dicomlist1)
warning('off')

n1 = 1; n2 = 1; n3 = 1;
pBar = waitbar(0,'Scanning DICOM directory ...');
    for i=1:length(dicomlist1)
        pCount = i / length(dicomlist1);
        waitbar(pCount,pBar,'Scanning DICOM directory ...');
        if dicomlist1(i).bytes > 0
            if dicominfo(dicomlist1(i).FullDir).Modality == "CT"
                CTList(n1) = dicomlist1(i);
                n1 = n1+1;
            elseif dicominfo(dicomlist1(i).FullDir).Modality == "RTSTRUCT"
                RSList(n2) = dicomlist1(i); 
                n2 = n2+1;
            end
        end
    end
    close(pBar)

end



