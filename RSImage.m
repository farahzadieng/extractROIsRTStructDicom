function [ROIdata,roiList,SkippedROIs] = RSImage(CTRefrenceImage,MaskData,ROIList,OriginalHeader)

printROIList(ROIList)
[ROI,roiList] = GetROIInputs;
ROIdata = cell(size(ROI));
for ROIindex=1:length(ROI)
    strucMat = zeros(size(CTRefrenceImage));
    if ROI(ROIindex) == 0
        ROIdata{ROIindex} = strucMat;
        SkippedROIs = ROIindex;
    else
        for j=1:size(strucMat,3)
            strucMat(:,:,j) = MaskData{ROI(ROIindex)}{j};
        end
        ROIdata{ROIindex} = deResoloutionizeRS(strucMat,OriginalHeader);
    end
end
end

function [ROI,roiList] = GetROIInputs()
    roiList = ["PTV Total","Body","Bladder","Rectum","L Femur","R Femur","Rectal Wall"];
    ROI = zeros(size(roiList));
    for m=1:size(roiList,2)
        message = sprintf('Please Input ROI Number refered to %s ; leave EMPTY if none:',roiList(m));
        ROIindex = input([message,'\n']);
        if ~isempty(ROIindex)
            ROI(m) = ROIindex;
        else
            ROI(m) = 0;
        end
    end
end

function printROIList(s)
    disp('ROI numbers and names are stored as :')
    for i=1:size(s,1)
       fprintf('%d)\t%s\n',s{i,1},s{i,3}) 
    end
end