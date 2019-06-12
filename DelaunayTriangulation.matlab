%% Clear all and initial parameters
clc
clear variables
close all

%% Determining paths and setting folders
currdir = pwd;
addpath(pwd);
filedir = uigetdir();
cd(filedir);

%Folders with thresholded images in tif8 format
files_tif = dir('*.tif');

%Folder to save information 
if exist([filedir, '/DT_analysis'],'dir') == 0
    mkdir(filedir,'/DT_analysis');
end
result_dir = [filedir, '/DT_analysis'];


for g=1:numel(files_tif)
	cd(filedir);
	I = [num2str(g),'.tif'];
	I_im = imread(I);
	I_im = logical(I_im);
	% extract centroid positions from each point
	stat = regionprops(I_im, 'centroid');
	for i=1:length(stat)
		x_centroid(i) = stat(i).Centroid(1);
		y_centroid(i) = stat(i).Centroid(2);
	end
	% converting from array to column vector
	x_centroid = x_centroid(:);
	y_centroid = y_centroid(:);
	% image1 shows centroid positions
	image1 = figure, plot(x_centroid, y_centroid, 'b*');
	ax = gca;
	ax.YDir = 'reverse'
	hold off



	cd (result_dir)
	Output_Graph = [num2str(g),'_centroid positions.tif'];
	hold off
	print(image1, '-dtiff', '-r300', Output_Graph);
end

% Writing graphs for individual images
%Centroid positions



