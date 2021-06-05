function [cutPosition] = deterCut(Image)

Sample = zeros(size(Image,1),size(Image,2),5);
Sample(:,:,1) = Image(:,:,1);
Sample(:,:,2) = Image(:,:,end);
randSamples = randi([2,size(Image,3)-1],1,3);
n = 1;
for i=3:5
    Sample(:,:,i) = Image(:,:,randSamples(n));
    n = n + 1;
end
aboveCut = 40;
belowCut = 370;
leftCut = 50;
rightCut = 470 ;
figure
x = 1;
while x == 1
    for i=1:size(Sample,3)
        subplot(3,2,i)
        imshow(Sample(aboveCut:belowCut,leftCut:rightCut,i),[])
    end
    verInput = input('Type OK if all Cuts are Ok. If else Type right,left, above or below to increase the cut\s','s');
    if lower(verInput) == "ok"
        x = 0;
    elseif lower(verInput) == "left"
        leftCut = leftCut - 5;
    elseif lower(verInput) == "right"
        rightCut = rightCut + 5;
    elseif lower(verInput) == "above"
        aboveCut = aboveCut - 5;
    elseif lower(verInput) == "below"
        belowCut = belowCut + 5;
    else 
        disp('You made a mistake in the input value, try again')
        continue
    end
end

cutPosition = [aboveCut belowCut leftCut rightCut];
close all 
end

