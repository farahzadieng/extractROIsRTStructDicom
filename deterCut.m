function [cutPosition] = deterCut(body)

for i=1:size(body,3) 
    [rowIdx] = find(any(body(:,:,i),2)==1);
    [colIdx] = find(any(body(:,:,i),1)==1);
    leftVec(i) = min(colIdx);
    rightVec(i) = max(colIdx);
    upVec(i) = min(rowIdx);
    downVec(i) = max(rowIdx);
end

leftCut = min(leftVec);
rightCut = max(rightVec);
upCut = min(upVec);
downCut = max(downVec);

while rem(downCut-upCut,16) ~= 0
    upCut = upCut - 1;
end

c = 1;
while rem(rightCut-leftCut,16) ~= 0
    if rem(c,2) == 0
        rightCut = rightCut + 1;
    else
        leftCut = leftCut - 1;
    end
    c = c+1;
end

cutPosition = [upCut downCut leftCut rightCut];
end

