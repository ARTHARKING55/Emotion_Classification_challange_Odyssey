% This function is the modified version of the fucntion mfcch
% wherein we have used 30 filters in the simulation of triangualr filter bank
% according to the formula p=floor(3*log(Fs));
% but in the mfcchm we will be using p as user defined parameter 
% Function to find the mel-frequeny cepstrum coefficients (MFCC) of the signal
%
% Input Parameters
% x=Speech Signal whise LPC model has to be found 
% Fs=Sampling frequency of the signal in Hz
% N=Frame duration
% INC=Overlap between the frames
% p= Number filters used in Mel-filterbank 
% Output Parameter
% cep = Each column of cep corresponds to the MFCC's per frame
% 
% This function is created by Hemant A. Patil, IIT Kharagpur
% Date:- 19/04/2003

function [cep]=mfcch(x,Fs,p,Nc,N,INC)

%Step I Enter the signal
% If x is a row vector, make it a column vector
if size(x,1)==1
   x=x(:);
end
n=length(x);
% p=40;    % no of filter bank 
% N=30;    % Frame duration
% INC=15;  % Overlap between the frames 
% Nc=13;   % No of coefficients
% Step II Frame blocking 
  F=v_enframe(x,N,INC);
  [nf nx]=size(F);
  n=nx;
  % Step III Hamming Windowing
  Xw=[];
  for i=1:nf
     xw=[];
     for j=1:nx
      w(j)=0.54-0.46*cos(2*pi*j/(N-1));
      xw(j)=F(i,j)*w(j);
      % if xw == 0.0000
      %     xw= 0.0001;
     end
     xw=xw';
     % disp(xw);
     Xw=[Xw,xw];
     % some Xw are 0 ...
  end
  % Step V Pre-emphasis of the Hamming Windowed Speech
  num=[1 -0.97];
  den=[1];
  for i=1:nf
     Xwemp(:,i)=filter(num,den,Xw(:,i)); 
  end    
     
% StepIV Finding the magnitude spectrum of windowed speech
for i=1:nf
   Xk(:,i)=abs(fft(Xwemp(:,i)));
end
 
% Step V Generation of mel_spaced filterbank matrix 
f0=700/Fs;
fn2=floor(n/2);
lr=log(1+0.5/f0)/(p+1);
% Convert to fft bin numbers with 0 for DC term
bl=n*(f0*(exp([0 1 p p+1]*lr)-1));
b1=floor(bl(1))+1;
b2=ceil(bl(2));
b3=floor(bl(3));
b4=min(fn2,ceil(bl(4)))-1;
pf=log(1+(b1:b4)/n/f0)/lr;
fp=floor(pf);
pm=pf-fp;
r=[fp(b2:b4) 1+fp(1:b3)];
c=[b2:b4 1:b3]+1;
v=2*[1-pm(b2:b4) pm(1:b3)];
m=sparse(r,c,v,p,1+fn2); % mel-spaced filterbank
%subplot(2,2,1)
%plot(linspace(0, (Fs/2), 1+fn2), m)
%xlabel('Frequency (Hz)');
%ylabel('Frequency Response Magnitude');
%title('Mel-spaced filterbank');

% Step VI To find the mel-scale spectrum
   n2=1+floor(n/2);
   Sk=[];
   sk=[];
   
   for i=1:nf
       sk=m*Xk(1:n2,i);  
       sk=sk.^2;   % Subband energy of each mel filter output
       Sk=[Sk sk];
    end
    
 % Step VII To find the cepstrum of mel-spectrum
 % first take the logarithm of the mel-spectrum
 Sl=[];
 sl=[];
 for i=1:nf
    sl=log(Sk(:,i)); %Log-mel-spectrum
    Sl=[Sl sl];
 end
 %StepVII To take inverse fourier tranform 
  % Here since the mel-spectrum coefficients and 
  % their logarithm are real numbers so instead 
  % of IFFT we will take dct
 cep=[];
  for i=1:nf 
     cn=[];
     for n=1:Nc
         c=0;
         for k=1:p
             c=c+Sl(k,i)*cos(n*(k-0.5)*pi/p);
         end
         cn=[cn;c];
      end
         cep=[cep cn];% Each column of cep corresponds to the MFCC's per frame
         % delta = Deltas(cep', 1)';
         % double_delta = Deltas(delta', 1)';
  end
end 
% function D = Deltas(x, hlen)
%     win = hlen:-1:-hlen;
%     xx = [repmat(x(:, 1), 1, hlen), x, repmat(x(:, end), 1, hlen)];
%     D = filter(win, 1, xx, [], 2);
%     D = D(:, hlen*2+1:end);
%     D = D ./ (2 * sum((1:hlen).^2));
% end
