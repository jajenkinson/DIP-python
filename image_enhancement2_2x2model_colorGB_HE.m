%   call: image_enhancement2_2x2modelRGBandHE.m
%   from: image_enhancement2_2x2modelRGBandHE.m
%   opengl('save', 'software');
%
%   Demo code for gradient-based HE
%   Code for John for practice.
%
%	Artyom M. Grigoryan, May 30-June 1, 2025


 clear all;   close all    

 % kk is parameter to do/not the rotation

 % Test images:
 % Y=imread('IMG_3883.jpeg','jpeg');  kk=1;     % !!!
   Y=imread('IMG_7471.PNG','png'); kk=0;        % !!!
 
 [N,M,L]=size(Y);                     % image size: 2316 x 3088 x 3
 r2=max(max(max( double(Y) )));       % maximum of the image

 % EMEC measure of the image by blocks L7xL5 
 L7=5; L5=5; % L5=7; L7=5;  can also be used
 E1c=emec2(Y,N,M,L7,L5);  % emec=17.5228

 % --------------- Plot the original image --------------
 h_f=figure;
 set(h_f,'Name','Project GB-HE / color HE');  
 colormap(gray(r2));  % or colormap(gray(r2));

 disp('  Display the original image (or rotated) ')
 subplot(1,2,1);
 image(Y); axis image;  
 h_t=title('The original image');
 set(h_t,'FontName','Times','FontSize',10);

 pause(1)
 % Not necessary for above png-images 
 % For RGB - we need to rotate the image
 disp('  It takes time in MATLAB to do such a rotation')
 if kk==1
    Yrotate=uint8(zeros(M,N,3));
    for m=1:M
         for n=1:N
            Yrotate(m,n,:)=Y(n,m,:);
        end
    end
    Y=Yrotate; clear Yrotate;
    [N,M,L]=size(Y);    % image size:  3088 x 2316 x 3

    image(Y); axis image;  axis off 
    stitle=sprintf('Original [EMEC %4.2f]',E1c);
    h_t=title(stitle);
    set(h_t,'FontName','Times','FontSize',10);
    pause(1) 
 end

 % --------------------------------------------------
 % Image colors in the RGB model:
 Y1 = double(Y(:,:,1));     % red colors
 Y2 = double(Y(:,:,2));     % green colors
 Y3 = double(Y(:,:,3));     % blue colors

% ---------------------------------------------------
 disp(' Part I / Model 2x2 composition (done)');

% Model 2x2 of the RGB image: 
% Compose the first component: Different ways can be used
% Try the both cases and see whihc one is better 
  Y0=zeros(N,M);
% ----------------------------------------
% 21a1=1/3; a2=1/3; a3=1/3;
% Y0=round(a1*Y1+a2*Y2+a3*Y3);
% ----------------------------------------
% 2. The brightness/intensity of the image 
  a1=0.3; a2=0.59; a3=0.11;     
  Y0=round(a1*Y1+a2*Y2+a3*Y3);
% ----------------------------------------
  mm1=double(max(max(Y0))); mn1=double(min(min(Y0)));
  a=mm1; b=mn1;  % range [a,b]=[0,255]

% Model 2x2: image X of twice size    !!!
N2=2*N; M2=2*M;
X=zeros(N2,M2);

X(1:2:N2,1:2:M2)=Y0; 
X(1:2:N2,2:2:M2)=Y1;
X(2:2:N2,1:2:M2)=Y2;
X(2:2:N2,2:2:M2)=Y3;
 
% EME measure of this gray image
E1=eme2(X,L7,L5); %  15.4843

    
disp(' Part II / Gradient-based HE (GB-HE): ' );
disp('       WAIT A LITTLE ')

% ------------------      PART II     ------------------
% ========== Gradient-based color HE ===================
% -----------------  Model 2x2 -------------------------
% In this gradient-based HE, the HE is aonly applied on
% the smooth (flat) areas of the image, not on the pixels
% on edges and contors. 
% Thus, smoth and gradient operators can be used. 
% After HE, all edges (gradient) pixels 
% will be added to HE, to get the final result.  
% Here, the linear combination can be considered:
%    Image = a1*(HE) + a2 (gradient image)
% For these images, a1=1 and a2=1 [1.25 is better?] are used.
% -------------------------------------------------------
%  LPF ((low pass filtered) 
%  Histogram Equalization on the LPF image
%  HPF image is composed by the gradient operator
%  Example (other matrices can also be used):
    h =[ 1   1   1
         1   8   1
         1   1   1]/16;   
    % 16 is the sum of all coefficients
    % -------------------
    % h =[ 0   1   0
    %      1   8   1
    %      0   1   0]/12;   
    % 
   % GB-HE  for a2=2
   [Xs,Xg]=histeq_smoothing2(X,h); 

   k_towork=1;
   a2=1.25;  % default 

disp('  We can select the parameter of the GB-HE' );
while (k_towork==1) 

   disp('  Set parameter a2 fo Image=(HE) + a2*(Gradient)' );
   disp('  It may vary from image to image');
   prompt = "    What is the value of a2=1,1.1,1.25,1.5,1.75,2,...?  "; 
   a2 = input(prompt);

   X_eq2= double(Xs) + a2*double(Xg);
 
   % The scaling of the image
   mm3=max(max(X_eq2)); mn3=min(min(X_eq2));   
   X_eq2=((X_eq2-mn3)/(mm3-mn3))*(a-b)+b;
   %  
   X_eq2=round(X_eq2);
   E3=eme2(X_eq2,L5,L7);    

    % ---------------------------------------------------
    % Compose new color image, GB-HE image
    % Inverse transform from 2x2 model: 
    Xc3=zeros(N,M,3);
    Xc3(:,:,1)=X_eq2(1:2:N2,2:2:M2);
    Xc3(:,:,2)=X_eq2(2:2:N2,1:2:M2);
    Xc3(:,:,3)=X_eq2(2:2:N2,2:2:M2);
    Xc3=uint8(Xc3);
    E3c=emec2(Xc3,N,M,L7,L5);  

    disp('  Results: ');
    % -----------------  NEW RESULTS ----------------
    h_s2=subplot(1,2,2); 
    image(Xc3); axis image; 
    set(h_s2,'FontName','Times','FontSize',8);
    s_title=sprintf('Enhanced image [a=%4.2f]',a2); 
    h_t1=title(s_title);
    set(h_t1,'FontName','Times','FontSize',10); 
 
    fprintf('  EMECs of original and new images: %6.4f  and  %6.4f \n',E1c,E3c);

   prompt = "    Do you want to continue Yes(1) / No(0) ?  "; 
   k_towork = input(prompt);
   
  if (k_towork~=0) 
    h_s1=subplot(1,2,1); 
    image(Xc3); axis image; 
    set(h_s1,'FontName','Times','FontSize',8);
    s_title=sprintf('Enhanced image [a=%4.2f]',a2); 
    h_t1=title(s_title);
    set(h_t1,'FontName','Times','FontSize',10); 

    subplot(1,2,2);
    image(Y); axis image;  
    h_t=title('The original image');
    set(h_t,'FontName','Times','FontSize',10);
   else
    subplot(1,2,1);
    image(Y); axis image;  
    h_t=title('The original image');
    set(h_t,'FontName','Times','FontSize',10);
  end

end
disp('  End of the code. ')   


