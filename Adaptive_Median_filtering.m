
%% Clear all and initial parameters
clc
clear variables
close all

%% Determining paths and setting folders
currdir = pwd;
addpath(pwd);
filedir = uigetdir();
cd(filedir);

%Folders with average projections of images in tif8
files_tif = dir('*.tif');

%Folder to save information 
if exist([filedir, '/Threshold_img'],'dir') == 0
    mkdir(filedir,'/Threshold_img');
end
result_dir = [filedir, '/Threshold_img'];


%% define the sensitivity value to be used for adaptive thresholding
sensitivity = inputdlg('Please enter threshold sensitivity between 0 and 1: ','sensitivity');
 while (isnan(str2double(sensitivity)) || str2double(sensitivity)<0 || str2double(sensitivity)>1)
     sensitivity = inputdlg('Please enter threshold sensitivity between 0 and 1: ','sensitivity');
end
sensitivity = str2double(sensitivity);

%% define the size of small objects to be removed using bwareaopen function
small_object_size = inputdlg('Please enter pixel size: ','small_object_size');
 while (isnan(str2double(small_object_size)) || str2double(small_object_size)<0)
     small_object_size = inputdlg('Please enter positive number: ','small_object_size');
end
small_object_size = str2double(small_object_size);

%% performs adaptive thresholding on images using value defined above
for g=1:numel(files_tif)
	cd(filedir);
	I = [num2str(g),'.tif'];
	I_im = imread(I);
	BW = imbinarize(I_im, adaptthresh (I_im, sensitivity)); % use 0.2
    J = medfilt2(BW); imshow(J)
    BW2 = bwareaopen(J, small_object_size);  % use 50
	I_holes = imfill(BW2, 'holes');
    I_holes = im2double(I_holes); imshow(I_holes)
	cd(result_dir);
	imwrite(I_holes, [num2str(g),'.tif'], 'Compression', 'none');
	dlmwrite('sensitivity.txt',sensitivity)
    dlmwrite('bwareaopen_value.txt',small_object_size)
end
