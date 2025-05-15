% Call: histeqMax_fast.m
% Histogram Enhancement
% 
% Artyom M. Grigoryan, EE UTSA 2002



function Y_eq=histeqMax_fast2(Y)

       %1. Histogram calculation
       H=hist_my2(Y);
       
       mx=max(max(double(Y)));  % not 255 always
       
       %2. Distribution function (F)
       lengh_H=length(H);
       F=zeros(1,lengh_H);
       F(1)=H(1);
       for r=2:lengh_H
           F(r)=F(r-1)+H(r);
       end

       %3. Inverse transform (FI)
       FI=zeros(1,256);
       for n=1:lengh_H
           r=round(255*(F(n)))+1;
           FI(r)=n;
       end       
       
       %4. Image processing
       [N,M]=size(Y);
       Y_eq1=zeros(N,M);

       Y_eq1=F(round(double(Y+1)));
       
       Y_eq=uint8(zeros(N,M));
       Y_eq=uint8(mx*Y_eq1);  % or 255
      
end