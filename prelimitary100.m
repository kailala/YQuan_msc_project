
load( 'b.mat' );

% my data
directory = '/Users/gg/Documents/MSc_Project/MAG_200108_part/smart2_cube_20010830_1247.fits';
Magfiles=dir(directory);
filename=Magfiles.name
ar_date=str2num(filename(13:20));
ar_time = str2num(filename(22:25));

% find how many layers in image cube
image_cube = fitsread(directory);
[nrow,ncol,nlay]=size(image_cube);

% imshow magnetogram image
MAG = image_cube(:,:,9);
h0 = figure
imshow(MAG,[-100,100]);
dir0 = '/Users/gg/Documents/MATLAB/MSc_Project_Code/sunspots/beta/raw/';
temp_name0 = strcat('raw',num2str(ar_date,'%08d'),'T',num2str(ar_time,'%04d'),'_lay42.png');
saveas(h0,fullfile(dir0, temp_name0))

% store in the magnetogram matrix containing images for beta class evolving over time
b(:,:,100) = MAG;
save('b.mat', 'b' );

% imshow original image
MAG_orig = sum(image_cube,3);
h = figure
imshow(MAG_orig,[-100,100])
dir = '/Users/gg/Documents/MATLAB/MSc_Project_Code/sunspots/beta/orig/';
temp_name = strcat('orig',num2str(ar_date,'%08d'),'T',num2str(ar_time,'%04d'),'.png');
saveas(h,fullfile(dir,temp_name))

% imshow background image
MAG_back = image_cube(:,:,1);
figure
imshow(MAG_back,[-100,100]);
