function [RS] = VerifyUID(RSList)

%Report Findings 
disp(['>>> Found ',num2str(length(RSList)),' structure sets'])
disp(['>>> RTSTRUCTURE INFORMATION'])
disp(' ')

warning('error', 'images:dicominfo:fileVRDoesNotMatchDictionary')

for i=1:length(RSList)
    [Info] = readDCM(RSList(i).FullDir);
    disp('****************************')
    fprintf(2,'** RS %d Contains following Structures:\n',i)
    GetSturctures(Info)    
end

disp('*************************')
RSinput = input('Input desired RT Struct file index: \n');
RS = readDCM(RSList(RSinput).FullDir);

end

function GetSturctures(info)
for j=1:length(fieldnames(info.ROIContourSequence))
    disp(['        ',num2str(j),') ',eval(['info.StructureSetROISequence.Item_',num2str(j),'.ROIName'])])
end
end

function [Info] = readDCM(name)
try
    Info = dicominfo(name);
catch
    Info = dicominfo(name,'UseVRHeuristic',false);
end
end