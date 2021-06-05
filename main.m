%% main application 
clear; close all 
CurrentAddress = pwd;
addpath(CurrentAddress) 

%% Get DICOMLIST
% Get Structure containing all DCM data
[dicomlist] = GetDicomList(CurrentAddress);

%Get A List for CT Images and RT Structures
[CTList,RSList] = GetRS(dicomlist);

%% Get Lists 
%Get Desired RT Structure file
[RS] = VerifyUID(RSList);
%Get Corresponding CT Images to RS; CT Slices stores as a cell
[CT] = GetCTImage(CTList,RS);

%% ReRosultioning CT Series 
%Create a Matrix of sorted CT Images 
[CT_Image,CT_Header] = BuildCT(CT);
%Change CT Image Resolution; CT_Image2 is the output for CT Images
[CT_Image2] = deResoloutionizeCT(CT_Image,CT_Header);

%Assign Resulting Resolution to Header with New Values
CT_Header.PixelSpacing2 = [0.9766 0.9766]';
CT_Header.PixelSize2 = 0.9766; 
CT_Header.SliceSpacing2 = 3;
CT_Header.rows2 = size(CT_Image2,1);
CT_Header.columns2 = size(CT_Image2,2);
%% Structure Image 
%Get masked roi's based on original pixel size
[MaskData,roiList] = MaskStructures(CT,RS);
%deresolutionize RS images and Make desired Images 
[ROIdata,roiList,SkippedROIs] = RSImage(CT_Image,MaskData,roiList,CT_Header);

writeNiftiFiles(CT_Image2,CT_Header,ROIdata,roiList)
rmpath(CurrentAddress)
