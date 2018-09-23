function ymat1=MatrixStats(Mat)
% input: raw magnetogram matrix
% output: numerical feature matrix

[nrow,ncol,nlay]=size(Mat);

% initialise matrix for storing numerical features
ymat1 = zeros(nlay,14);
for i = 1:nlay
    tic
    Mag = Mat(:,:,i);
    % to check the coordinates of i-th layer of magnetogram matrix
    [row,col] = find(Mag);
    row_loc = (min(row)+max(row))/2.0;
    col_loc = (min(col)+max(col))/2.0;
        
    % set disk structuring element with radius 1 and threshold value  
    se = strel('disk',1);
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
    
    % figure 3.6 - skeleton
    % Removes interior pixels
    temp=bwmorph(temp,'remove',Inf);
    % Removes H-connected pixels
    temp=bwmorph(temp,'hbreak',Inf);
    % Removes spur pixels
    temp=bwmorph(temp,'spur',Inf);
    % removes pixels on the boundaries of objects but does not 
    % allow objects to break apart
    temp=bwmorph(temp,'skel',Inf);
    [rtemp,ctemp]=size(temp);
    skeleton=temp(2:(rtemp-1),2:(ctemp-1));
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
    stat2=computecurvature(skel_list);
         
    % degree of mixture 
    Mix1=CHMix(seeds2);
    Mix2=computemix(seeds2,0.2);
         
    % area-ratio, A(B), A(W), C1, C2, C, mixing (David), mixing (Thomas)
    ymat1(i,:)=[min(row),max(row),row_loc,min(col),max(col),col_loc,ratio,Ab,Aw,stat2,Mix1,Mix2];
end

xlswrite('ymat_bgd_t10.csv', ymat1)
end



