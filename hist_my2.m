%	Call: hist_my2(Y) / short version of hist_my
%   calculate the histogram of Y 
%
%   Art M. Grigoryan, EE TAMU 1998


function H=hist_my2(Y)

	[N1,N2]=size(Y);
	r2=round(max(max(double(Y))))+1; 	
		
	H=zeros(1,r2+1);
	for n=1:N1
        for m=1:N2
            r=round(double(Y(n,m)))+1; 
            H(r)=H(r)+1;
        end
    end
   H=(H/N1)/N2;	  %  The histogram normalization

 
   
		