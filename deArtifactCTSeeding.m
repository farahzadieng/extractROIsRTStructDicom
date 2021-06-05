function [ct] = deArtifactCTSeeding(ct,roiData)

[r,c,v] = ind2sub(size(ct),find(ct>3000));

if length(r) > 0
    targetVol = roiData{1};
    [r1,c1,v1] = ind2sub(size(targetVol),find(targetVol==1));
    for i=1:length(r1)
        prostateVector(i) = ct(r1(i),c1(i),v1(i));
    end
    prostateMean = mean(prostateVector);
    for j=1:length(r1)
        if ct(r1(j),c1(j),v1(j)) > prostateMean+200
            ct(r1(j),c1(j),v1(j)) = prostateMean;
        end
    end
end

end