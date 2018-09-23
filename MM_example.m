% large circle
x = -100:100;
y = -100:100;
[xx yy] = meshgrid(x,y);
u = zeros(size(xx));
u((xx.^2+yy.^2)<50^2)=1;
% small circle
x1 = -20:20;
y1 = -20:20;
[xx1 yy1] = meshgrid(x1,y1);
u1 = zeros(size(xx1));
u1((xx1.^2+yy1.^2)<10^2)=1;
% substitute and plot
u(120:160,40:80) = u1;
imshow(u)
% erode
se=strel('disk',10);
erode = imerode(u,se);
imshow(erode)
% dilate
dilate = imdilate(u,se);
imshow(dilate)
% open
open = imopen(u,se);
imshow(open)
% close
close = imclose(u,se);
imshow(close)
% skeleton
skeleton = bwmorph(u,'skel',Inf);
figure
imshow(skeleton)
% Removes interior pixels
remove = bwmorph(u,'remove',Inf);
figure
imshow(remove)
% Removes spur pixels
spur = bwmorph(u,'spur',Inf);
figure
imshow(spur)
% Removes H-connected pixels
hbreak = bwmorph(u,'hbreak',Inf);
figure
imshow(hbreak)


