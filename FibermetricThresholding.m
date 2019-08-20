
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
if exist([filedir, '/newthresh_fibermetric'],'dir') == 0
    mkdir(filedir,'/newthresh_fibermetric');
end
result_dir = [filedir, '/newthresh_fibermetric'];

% remove this later
% result_dir = [pwd, '/newthresh_fibermetric'];



%% performs thresholding on images using value defined above
for g=1:numel(files_tif)
	cd(filedir);
	I = [num2str(g),'.tif'];
	I_im = imread(I);
    BW = fibermetric(I_im, 30, 'ObjectPolarity', 'bright', 'StructureSensitivity', 21);
    B = BW > 0.2;
    B2 = bwareaopen(B, 100);
	I_holes = imfill(B2, 'holes');
    I_holes = im2double(I_holes);
	cd(result_dir);
	imwrite(I_holes, [num2str(g),'.tif'], 'Compression', 'none');
end
