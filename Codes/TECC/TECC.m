% clc; clear;
%
% [x,Fs]= audioread('/home/rajul/ASVspoof2017_V2/ASVspoof2017_V2_train/T_1000190.wav');
function feature = TECC(x,fs)
% hchirp = dsp.Chirp( ...
%     'InitialFrequency', 0,...
%     'TargetFrequency', 10, ...
%     'TargetTime', 10, ...
%     'SweepTime', 100, ...
%     'SampleRate', 50, ...
%     'SamplesPerFrame', 500);
%
% x = (step(hchirp))';
% evenFlag = mod(minute(datetime('now')),2);
% if evenFlag
%     x = fliplr(x);
% end
% plot(x);
% x = x - (flip(x'))';
% x = x(1:ceil(length(x)/2));
% x =filter([1 -0.97],1,x);
Fs = fs;
window_length=round(20*Fs/1000);
window_shift=round(10*Fs/1000);
nFilters=40;
nTaps=512;
e_rms_bw=200;
lowF=10;
hiF=8000;
[fBankG cFr]= GaborFilterBank_linnn_200(nFilters, nTaps, e_rms_bw, Fs, lowF, x);

[row col]=size(fBankG);
for i=1:row
    Y(i,:)=filter(fBankG(i,:),1,x);
    %r(i,:)=real(hilbert(Y(i,:)));
    %a(i,:)=abs(r(i,:));
    TEO(i,:) = ESA(Y(i,:));
    %TEO(i,:) = abs(TEO(i,:));
    %mass(i,:) = signal_mass(Y(i,:));
    %MTEO(i,:) = TEO(i,:)./mass(i,:);
    MTEO(i,:) = medfilt1(TEO(i,:),3);
    F1=enframe(MTEO(i,:),window_length,window_shift);
    avg_TEO(i,:)  = mean(F1');
   
%    avg_TEO(i,:) = diff(avg_TEO1);
%   F2=enframe(MTEO(i,:),window_length,window_shift);
%   avg_MTEO(i,:)=mean(F2');
%   log_avg(i,:)=log(avg_TEO(i,:));
end
 

% TEO = ESA(x);
% mass = signal_mass(x);
% MTEO = TEO./mass;
%
% plot(MTEO,'r');
% hold on;
% plot(TEO,'b');

% plot(MTEO(25,:),'r');
% hold on;
% plot(TEO(25,:),'g');
% hold on;
% plot(MTEO1(25,:),'b');
%% tecc

Nc=40;
SN=log(abs(avg_TEO)+eps);
Ydct=dct(SN);
tecc=Ydct(1:Nc,:);


[~,nanC]  = find(any(isnan(tecc)));
tecc(:,nanC) = [];
[~,infC] = find(any(isinf(tecc)));
tecc(:,infC) = [];

% tecc = cmvn(tecc);

delta=deltas(tecc,3);

double_delta=deltas(delta,3);
tecc = [tecc;delta;double_delta];
tecc = cmvn(tecc,false);
feature = tecc;
end

% l=[0 -1 0 ; -1 5 -1 ; 0 -1 0];
% [rows,cols] = size(tecc);
% feature = zeros(rows,cols);
% for row = 2:rows-1
%     for col = 2:col-1
%         feature(row,col)= sum (sum(tecc(row-1: row+1: col-1: col+1: l )));
%     end
% end
%teccif = cmvn(tecc,true);
%% mtecc
% SN1=log(abs(avg_MTEO)+eps);
% Ydct=dct(SN1);
% mtecc=Ydct(2:Nc+1,:);
%
%
% [~,nanC]  = find(any(isnan(mtecc)));
% mtecc(:,nanC) = [];
% [~,infC] = find(any(isinf(mtecc)));
% mtecc(:,infC) = [];
%
% mtecc = cmvn(mtecc,false);
%
% delta=deltas(mtecc,3);
% double_delta=deltas(delta,3);
% mtecc = [mtecc;delta;double_delta];
% %teccif = cmvn(tecc,true);
% subplot 211;
% imagesc(tecc);
% subplot 212;
% imagesc(mtecc);

