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

%Folders to save information 
if exist([filedir, '/DT_centroids'],'dir') == 0
    mkdir(filedir,'/DT_centroids');
end
result_dir1 = [filedir, '/DT_centroids'];

if exist([filedir, '/DT_centroids_BW_image'],'dir') == 0
    mkdir(filedir, '/DT_centroids_BW_image');
end
result_dir2 = [filedir, '/DT_centroids_BW_image'];

if exist([filedir, '/DT_triplot'],'dir') == 0
    mkdir(filedir, '/DT_triplot');
end
result_dir3 = [filedir, '/DT_triplot'];


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
	% perform delaunay traingulation analysis
	DT = delaunayTriangulation(x_centroid, y_centroid);

	% image1 saves centroid positions, with csv file
	image1 = figure;
	plot(x_centroid, y_centroid, 'b*');
	ax = gca;
	ax.YDir = 'reverse'

	%image2 shows centroid positions overlaid on binary image
	image2 = figure;
	imshow(I_im)
	hold on
	plot(x_centroid, y_centroid, 'b*')
	ax = gca
	ax.YDir = 'reverse'

	%image3 triplot of DT analysis using centroid positions
	image3 =figure;
	triplot(DT)
	hold on
	plot(x_centroid, y_centroid, 'r*')
	ax = gca
	ax.YDir = 'reverse'

	% writing graphs to file
	cd (result_dir1)
	Output_Graph = [num2str(g),'_centroids.tif'];
	hold off
	print(image1, '-dtiff', '-r300', Output_Graph);

	cd (result_dir2)
	Output_Graph = [num2str(g),'_centroids_BW_image.tif'];
	hold off
	print(image2, '-dtiff', '-r300', Output_Graph)

	cd (result_dir3)
	Output_Graph = [num2str(g),'_DT_triplot.tif'];
	hold off
	print(image3, '-dtiff', '-r300', Output_Graph)
	
end




