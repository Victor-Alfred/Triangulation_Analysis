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

if exist([filedir, '/DT_edgeLens'],'dir') == 0
    mkdir(filedir, '/DT_edgeLens');
end
result_dir4 = [filedir, '/DT_edgeLens'];

%% Analysing each image
for g=1:numel(files_tif)
	cd(filedir);
	I = [num2str(g),'.tif'];
	I_im = imread(I);
    I_im = logical(I_im);
    I_im = bwareaopen(I_im,10); 
	% extract centroid positions from each point
	stat = regionprops(I_im, 'Centroid');   
        for k=1:numel(stat)
            x_centroid(k) = stat(k).Centroid(1);
            y_centroid(k) = stat(k).Centroid(2);
        end
    
	% converting from array to column vector
	x_centroid = x_centroid(:);
	y_centroid = y_centroid(:);
    
    %extract the first k elements of the vector
    x_centroid = x_centroid(1:k);
	y_centroid = y_centroid(1:k);
    
	% perform delaunay triangulation analysis
	DT = delaunayTriangulation(x_centroid, y_centroid);

	% image1 saves centroid positions, with csv file
	image1 = figure; set(gcf,'Visible', 'off');
	plot(x_centroid, y_centroid, 'b*');
	ax = gca;
	ax.YDir = 'reverse'
    
	%image2 shows centroid positions overlaid on binary image
	image2 = figure; set(gcf,'Visible', 'off');
	imshow(I_im)
	hold on
	plot(x_centroid, y_centroid, 'b*')
	ax = gca
	ax.YDir = 'reverse'
    
	%image3 triplot of DT analysis using centroid positions
	image3 =figure; set(gcf,'Visible', 'off');
	triplot(DT)
	hold on
	plot(x_centroid, y_centroid, 'r*')
	ax = gca
	ax.YDir = 'reverse'

	image4 = figure; set(gcf,'Visible', 'on');
	triplot(DT)
	hold on 
	ax = gca
	ax.YDir = 'reverse'
	edges = DT.edges;
	edgeLens = zeros(size(edges,1),1);
	for i = 1:size(edges,1)
	    thisEdgePts = DT.Points(edges(i,:),:);
	    edgeCpt = mean(thisEdgePts,1);
	    edgeLen = sqrt(sum(diff(thisEdgePts,[],1).^2));
	    edgeLens(i) = edgeLen;
	    text(edgeCpt(1),edgeCpt(2),sprintf('%0.1f',edgeLen),'HorizontalAlignment','center')
	end
	hold off

	% writing graphs to file
	cd(result_dir1)
	Output_Graph = [num2str(g),'_centroids.tif'];
	hold off
	print(image1, '-dtiff', '-r300', Output_Graph);

	% write centroid xy positions to csv file
	centroid_xy = [x_centroid, y_centroid];
	csvwrite([num2str(g),'_centroid_xy.csv'], centroid_xy)

	cd(result_dir2)
	Output_Graph = [num2str(g),'_centroids_BW_image.tif'];
	hold off
	print(image2, '-dtiff', '-r300', Output_Graph)

	cd(result_dir3)
	Output_Graph = [num2str(g),'_DT_triplot.tif'];
	hold off
	print(image3, '-dtiff', '-r300', Output_Graph)

	cd(result_dir4)
	Output_Graph = [num2str(g),'_DT_edgeLens.tif'];
	hold off
	print(image4, '-dtiff', '-r300', Output_Graph)

	% write edge lengths to csv file
	csvwrite([num2str(g),'_DT_edgeLens.csv'], edgeLens)

end


