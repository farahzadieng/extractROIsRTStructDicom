function [dcm_main2] = GetDicomList(CurrentAddress)


Address = input('Enter main DICOM Directory Address:\n','s');
cd(Address)
dcm_main = dir('*.dcm');
[dcm_main] = AddFields(dcm_main);


disp('Enter other Dictories to scan for dicom; Enter NO to skip')
Address2 = input('Enter main DICOM Directory Address:\n','s');

if lower(Address2) ~= "no"
	cd(Address2)
	dcm_sec = dir('*.dcm');
	[dcm_sec] = AddFields(dcm_sec);
	[dcm_main2] = JoinStructs(dcm_main,dcm_sec);
end


cd(CurrentAddress)

end



function [a] = AddFields(a)

for i=1:length(a)
   a(i).FullDir = [a(i).folder,'\',a(i).name];
end

end

function [c] = JoinStructs(a,b)

for i=1:length(a)
	c(i) = a(i);
end
for i=1:length(b)
	c(length(a)+i) = b(i);
end

end