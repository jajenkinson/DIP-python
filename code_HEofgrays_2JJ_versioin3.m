%  Call: code_HEofgrays_2JJ_version3.m
%  from: code_HEofgrays_2JJ.m
%  Image processing by the histogram (HE)
%
%  This demo code uses the functions: 
%  hist_my2.m - to calculate the histogram
%  histeqMax_fast2.m (Art) - to compute the HE
% 
%  Artyom Grigoryan, San Antonio / 02/15/2022-2025
%  -------------------------------------------------  
       
clear all; close all;

disp('Start the code for Histogram Equalization (HE):');

%   2. Read the image in the jpeg format:    

      Y=imread('IMG_3883.jpeg','jpeg');    % color image
    % Y=imread('IMG_3881.jpeg','jpeg');    % color image
    % Y=imread('IMG_7486.jpeg','jpeg');    % color image
     [N,M,L]=size(Y);   % image size: 2316 x 3088 x 3

    h_f=figure;
    set(h_f,'Name','Project 1 DIP / HE');  
    colormap(gray(255));

    % You can rotate this image
    % for m=1:M
    %     for n=1:N
    %         Y1(m,n,:)=Y(n,m,:);
    %     end
    % end
    % Y=Y1;

    subplot(1,2,1);
    image(Y); % axis off
    axis image;  %axis normal
    h_t=title('The original color image');
    set(h_t,'FontName','Times','FontSize',10);

    Y1=double(Y);
    Xgray=(Y1(:,:,1)+Y1(:,:,2)+Y1(:,:,3))/3;    % gray image
    Xgray=round(Xgray);
    % image transposition (rotation by 180 degree)
    Xgray=Xgray';       
    
    r1=min(min(Xgray));  r2=max(max(Xgray));  
    fprintf('  Image range:  [%g, %g] \n',r1,r2); % [0,255]
    
    subplot(1,2,2);
    image(Xgray);  axis image; axis off;  
    h_t=title('Gray image (Average of 3 colors)');
    set(h_t,'FontName','Times','FontSize',10);


    % Histogram Equalization of the image (by Art)
    disp('Press a key to run code of HE');
    pause

%   3. HE of the grayscale image 
    X_eq=histeqMax_fast2(Xgray);

    h_f=figure;
    set(h_f,'Name','Project 1 DIP / HE');  
    colormap(gray(r2));

    subplot(1,2,1);
    image(Xgray);  axis image; axis off;  
    h_t=title('Gray image');
    set(h_t,'FontName','Times','FontSize',10);

  
    % ------------------------------------
    subplot(1,2,2);
    image(X_eq);
    axis('image'); axis('off');
    h_title=title('HE (by Art)'); 
    set(h_title,'Color',[0 0 0],'FontName','Times','FontSize',10);
   
    % ------------------------------------
    % Calculate the charactristics of the images
    H=hist_my2(Xgray);   % histogram of Xgray
    H2=hist_my2(X_eq');  % histogram of HE
 
    mH=mean(H);   mH2=mean(H2);
    mmean1=mean(mean(Xgray));        % mean of the original image
    mmean3=mean(mean(double(X_eq))); % ........... HE (by Art)

    fprintf('1:   Means of images %6.4f, %6.4f \n',mmean1,mmean3);
    fprintf('2:     ... histograms %8.6f, %6.6f  \n', mH,mH2);
    
  
    disp('End of the code / Art');

    % print -dtiff fig3HE.tiff
