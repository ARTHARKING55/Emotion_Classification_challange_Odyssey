function [filterbank, fx] = GaborFilterBank_linnn_200 (nFilters, nTaps, e_rms_bw, SampleRate, lowF, hiF)
	% [filterbank centerFrequency]= GaborFilterBank (nFilters, nTaps, e_rms_bw, SampleRate), lowF, hiF)
	%
	%
	% pykfec - pyknogram frequency estimated coefficients toolbox for Matlab/Octave
	% Copyright (C) <2008>  <Marco.Grimaldi@gmail.com>
	%
	%
	% Creates a bank of Gabor filters linearly spaced beween lowF and HiF
	% Input and Outputs are as follows:
	% Input:
	% 	nFilters:		number of desired filters in the bank
	% 	nTaps:			number of taps in each filter
	% 	e_rms_bw:		Effective RMS BandWidth 
	%	SampleRate:		sample-rate of the signal to be processed
	%	lowF:			lowest frequency in the filterbank	
	%	hiF:			highest frequency in the filterbank
	%
	% Output:
	%	filterbank: 		matrix nFilters x nTaps containing the filterbank
	%	centerFrequency:	vector containing the (normalized) center frequency of each filter
% clc;close all;clear all;
%     [x,fs]=audioread('F:\IEEEWIE\NATURAL\p228_026.wav');
% addpath(genpath('F:\IEEEWIE\gmm_test\voicebox'));
% SampleRate=16000;
% nFilters=40;
% nTaps=512;
% e_rms_bw=160;
% lowF=100;
% hiF=8000;
%     
    fx=[lowF;hiF];
    fx=frq2mel(fx); %convert limits to erb
    %fx=linspace(fx(1),fx(2),nFilters)';     % centre frequencies in spacing units
%     fx=erb2frq(fx);                         %back to Hz
    %bandwidth
%     bx=1.019;
% bx=100;
bx=200;
bx=bx(ones(nFilters,1));
%    bwf=fx;
%     [dum,bwf]=frq2erb(fx);
%     bx=bx.*bwf;
% 	
    
    alpha = bx./SampleRate;
    
    fx=fx/SampleRate; % normaliced centre frequencie
    
    filterbank = zeros (nFilters,nTaps);
        for i=1:nFilters
            filterbank(i,:) = Gabor(alpha(i),fx(i),nTaps);
            filterbank(i,:) = scalefilter(filterbank(i,:) ,fx(i)/0.5);
        end
    

 end