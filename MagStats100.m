function ymat=MagStats(MAG)
% input: raw magnetogram image
% output: extracted numerical features

% extract year, date, time from directory
directory = '/Users/gg/Documents/MSc_Project/MAG_200108_part/smart2_cube_20010830_1247.fits';
Magfiles=dir(directory);
filename=Magfiles.name;
ar_date=str2num(filename(13:20));
ar_time = str2num(filename(22:25));
year = str2num(filename(13:16));
date = str2num(filename(17:20));


tic
Mag = MAG;

% find the coordinates of the magnetogram in the original Sun image
[row,col] = find(Mag);
row_loc = (min(row)+max(row))/2.0;
col_loc = (min(col)+max(col))/2.0;
             
% set disk structuring element with radius 1 and threshold value
se=strel('disk',1);
thresh=5;
        
% morphological opening
Mag_opened = imopen(Mag,se);
% thresholding
Mag_thres_image=thresfilter(Mag_opened,thresh);

% morphological opening and thresholding to inverted magnetogram
invMag=Mag*-1;
invMag_opened = imopen(invMag,se);
invMag_thres_image=thresfilter(invMag_opened,thresh);
        
% figure 3.5 
% 0:background 2:white 1:black
seeds2=(2*Mag_thres_image+invMag_thres_image);
h1 = figure
imshow(seeds2,[min(min(seeds2)),max(max(seeds2))]);
dir1 = '/Users/gg/Documents/MATLAB/MSc_Project_Code/sunspots/beta/seeds/';
temp_name1 = strcat('seeds',num2str(ar_date,'%08d'),'T',num2str(ar_time,'%04d'),'.png');
saveas(h1,fullfile(dir1,temp_name1))
t1 = toc;
        
% [9]:area ratio (B/W), [3]:A(B), [7]:A(W)
tic
stat1=computestat(seeds2);
ratio = stat1(9);
Ab = 1-stat1(3);
Aw = 1-stat1(7);
t2 = toc;
        
% figure 3.6 - voronoi diagram
tic
temp=voronoi2(seeds2);
% disk SE with radius 1
se=strel('disk',1);
% morphological opening
temp_opened=imopen(temp,se);
temp=temp_opened-1;
h3 = figure
imshow(temp);
dir3 = '/Users/gg/Documents/MATLAB/MSc_Project_Code/sunspots/beta/voronoi/';
temp_name3 = strcat('voronoi',num2str(ar_date,'%08d'),'T',num2str(ar_time,'%04d'),'.png');
saveas(h3,fullfile(dir3,temp_name3))
        
% figure 3.6 - skeleton
% Removes interior pixels
temp=bwmorph(temp,'remove',Inf);
% Removes H-connected pixels
temp=bwmorph(temp,'hbreak',Inf);
% Removes spur pixels
temp=bwmorph(temp,'spur',Inf);
% removes pixels on the boundaries of objects but does not allow objects to break apart
temp=bwmorph(temp,'skel',Inf);
[rtemp,ctemp]=size(temp);
% skeleton diagram
skeleton=temp(2:(rtemp-1),2:(ctemp-1));
h2 = figure
imshow(skeleton);
dir2 = '/Users/gg/Documents/MATLAB/MSc_Project_Code/sunspots/beta/skeleton/';
temp_name2 = strcat('skeleton',num2str(ar_date,'%08d'),'T',num2str(ar_time,'%04d'),'.png');
saveas(h2,fullfile(dir2,temp_name2))
t3 = toc;
        
% skeleton image, skeleton list
tic
[skel_image,skel_list]=traceskeleton2(skeleton,8);
temp_image=skeleton-(skel_image>0);
skel_list2=skel_list;
while (length(skel_list2)>0)
    [skel_image2,skel_list2]=traceskeleton2(temp_image,8);
    temp_image=temp_image-(skel_image2>0);
    if (length(skel_list2)>(length(skel_list)))
        skel_image=skel_image2;
        skel_list=skel_list2;
    end
end

% C1, C2, C
tic
stat2=computecurvature(skel_list);
t4 = toc;
         
% degree of mixture 
tic
Mix1=CHMix(seeds2);
Mix2=computemix(seeds2,0.2);
t5 = toc;        

% area-ratio, A(B), A(W), C1, C2, C, mixing (David), mixing (Thomas)
ymat=[year,date,ar_time,min(row),max(row),row_loc,min(col),max(col),col_loc,ratio,Ab,Aw,stat2,Mix1,Mix2];
xlswrite('ymat_temp.csv', ymat)

end


