function [CT] = GetCTImage(CTList,RS)

RSRefUID = RS.ReferencedFrameOfReferenceSequence.Item_1.FrameOfReferenceUID;

n=1;
pBar = waitbar(0,'Scanning CT Series ...');
for i=1:length(CTList)
    pCount = i / length(CTList);
    waitbar(pCount,pBar,'Scanning CT Series ...');
   if CTList(i).bytes > 0
        Info = dicominfo(CTList(i).FullDir);
        if strcmp(RSRefUID,Info.FrameOfReferenceUID)
            CTinfo2{n} = Info;
            CTList2(n) = CTList(i);
            n = n +1;
            
        end
   end
end
close(pBar)

%Devide by folder
mainFolder = CTList2(1).folder;
c = 1 ; cc = 1;
for i=1:length(CTList2)
   if strcmp(mainFolder,CTList2(i).folder)
       CTinfo3{c} = CTinfo2{i};
       c = c + 1;
   else
        CTinfo4{cc} = CTinfo2{i};
        cc = cc + 1;
   end
    
end

if length(CTinfo3) == length(CTinfo4) 
    CT1 = CTinfo3;
else
    subplot(1,2,1)
    imshow(dicomread(CTinfo3{20}.Filename),[])
    title(['Series 1 with ',num2str(length(CTinfo3)),' intances'])
    subplot(1,2,2) 
    imshow(dicomread(CTinfo4{20}.Filename),[])
    title(['Series 2 with ',num2str(length(CTinfo4)),' intances'])
    W = input('Please input desired CT Series 1 or 2 \n');
    if W==1
        CT1 = CTinfo3;
    elseif W == 2
        CT1 = CTinfo4;
    end 
end
close all 
[CT] = verifyCT(CT1);
end

function [CT2] = verifyCT(CT)
n= 1;
    for i=1:length(CT)
       if CT{i}.Rows == 512
           CT2{n} = CT{i};
           n = n + 1;
       end
    end
    
end

