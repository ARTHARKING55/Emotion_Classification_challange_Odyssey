%% LFCC+LFRCC
clear all; clc; close all;

% Define the base folder containing train, test, and val folders
BaseFolder = "C:\Users\admin\Desktop\ARTH SHAH\Emotion Challange Dataset\Dataset\Audios";

% Define the target folders for train, test, and val
Folders = {'Train','Test', 'Val'};
% Loop through the folders (train, test, val)
for folderIndex = 1:numel(Folders)
    Folder = fullfile(BaseFolder, Folders{folderIndex});
    SaveFolder = fullfile("C:\Users\admin\Desktop\ARTH SHAH\Emotion Challange Dataset\FF\LFCC+LFRCC", Folders{folderIndex});
    
    % List all subfolders in the current train/test/val folder
    Subfolders = dir(Folder);
    Subfolders = Subfolders([Subfolders(:).isdir] & ~ismember({Subfolders(:).name},{'.','..'}));
    
    % Loop through subfolders (classes) within the current train/test/val folder
    for classIndex = 1:numel(Subfolders)
        Subfolder = fullfile(Folder, Subfolders(classIndex).name);
        SaveClassFolder = fullfile(SaveFolder, Subfolders(classIndex).name);
        mkdir(SaveClassFolder);  % Create a subfolder for each class
        
        % List all .wav files in the current class folder
        FileList = dir(fullfile(Subfolder, '*.wav'));
        
        % Loop through .wav files
        for iFile = 1:numel(FileList)
            File = fullfile(Subfolder, FileList(iFile).name);
            [y, fs] = audioread(File);
            [filepath, name, ext] = fileparts(File);
            res = LP_residual_extraction(18,y, fs);
            Window_Length = 25;
            NFFT = 512;
            No_Filter = 40;
            No_coeff = 20;
            low_freq = 0;
            p=40;    % no of filter bank 
            N=400;    % Frame duration
            INC=200;  % Overlap between the frames 
            Nc=20;   % No of coefficients
            high_freq = fs/2;
            [coeffs1, ~, ~] = lfcc_bp(y, fs, Window_Length, NFFT, No_Filter, No_coeff, low_freq, high_freq);
            [coeffs2, ~, ~] = lfcc_bp(res, fs, Window_Length, NFFT, No_Filter, No_coeff, low_freq, high_freq);
            coeffs2=coeffs2';
            coeffs1=coeffs1';
            min_dim = min(size(coeffs1, 2), size(coeffs2, 2));
            coeffs1 = coeffs1(:, 1:min_dim);
            coeffs2 = coeffs2(:, 1:min_dim);
            final=[coeffs1;coeffs2];
            mat_name = strcat(name, '.mat');
            mat_path = fullfile(SaveClassFolder, mat_name);
            save(mat_path, 'final');
        end
    end
end
%% LFCC+MFCC
clear all; clc; close all;

% Define the base folder containing train, test, and val folders
BaseFolder = "C:\Users\admin\Desktop\ARTH SHAH\Emotion Challange Dataset\Dataset\Audios";

% Define the target folders for train, test, and val
Folders = {'Train','Test', 'Val'};
% Loop through the folders (train, test, val)
for folderIndex = 1:numel(Folders)
    Folder = fullfile(BaseFolder, Folders{folderIndex});
    SaveFolder = fullfile("C:\Users\admin\Desktop\ARTH SHAH\Emotion Challange Dataset\FF\LFCC+MFCC", Folders{folderIndex});
    
    % List all subfolders in the current train/test/val folder
    Subfolders = dir(Folder);
    Subfolders = Subfolders([Subfolders(:).isdir] & ~ismember({Subfolders(:).name},{'.','..'}));
    
    % Loop through subfolders (classes) within the current train/test/val folder
    for classIndex = 1:numel(Subfolders)
        Subfolder = fullfile(Folder, Subfolders(classIndex).name);
        SaveClassFolder = fullfile(SaveFolder, Subfolders(classIndex).name);
        mkdir(SaveClassFolder);  % Create a subfolder for each class
        
        % List all .wav files in the current class folder
        FileList = dir(fullfile(Subfolder, '*.wav'));
        
        % Loop through .wav files
        for iFile = 1:numel(FileList)
            File = fullfile(Subfolder, FileList(iFile).name);
            [y, fs] = audioread(File);
            [filepath, name, ext] = fileparts(File);
            res = LP_residual_extraction(18,y, fs);
            Window_Length = 25;
            NFFT = 512;
            No_Filter = 40;
            No_coeff = 20;
            low_freq = 0;
            p=40;    % no of filter bank 
            N=400;    % Frame duration
            INC=200;  % Overlap between the frames 
            Nc=20;   % No of coefficients
            high_freq = fs/2;
            [coeffs1, ~, ~] = lfcc_bp(y, fs, Window_Length, NFFT, No_Filter, No_coeff, low_freq, high_freq);
            [coeffs2] = mfcch(y,fs,p,Nc,N,INC);
            coeffs1=coeffs1';
            min_dim = min(size(coeffs1, 2), size(coeffs2, 2));
            coeffs1 = coeffs1(:, 1:min_dim);
            coeffs2 = coeffs2(:, 1:min_dim);
            final=[coeffs1;coeffs2];
            mat_name = strcat(name, '.mat');
            mat_path = fullfile(SaveClassFolder, mat_name);
            save(mat_path, 'final');
        end
    end
end
%% MFCC+LFRCC
clear all; clc; close all;

% Define the base folder containing train, test, and val folders
BaseFolder = "C:\Users\admin\Desktop\ARTH SHAH\Emotion Challange Dataset\Dataset\Audios";

% Define the target folders for train, test, and val
Folders = {'Train','Test', 'Val'};
% Loop through the folders (train, test, val)
for folderIndex = 1:numel(Folders)
    Folder = fullfile(BaseFolder, Folders{folderIndex});
    SaveFolder = fullfile("C:\Users\admin\Desktop\ARTH SHAH\Emotion Challange Dataset\MFCC+LFRCC", Folders{folderIndex});
    
    % List all subfolders in the current train/test/val folder
    Subfolders = dir(Folder);
    Subfolders = Subfolders([Subfolders(:).isdir] & ~ismember({Subfolders(:).name},{'.','..'}));
    
    % Loop through subfolders (classes) within the current train/test/val folder
    for classIndex = 1:numel(Subfolders)
        Subfolder = fullfile(Folder, Subfolders(classIndex).name);
        SaveClassFolder = fullfile(SaveFolder, Subfolders(classIndex).name);
        mkdir(SaveClassFolder);  % Create a subfolder for each class
        
        % List all .wav files in the current class folder
        FileList = dir(fullfile(Subfolder, '*.wav'));
        
        % Loop through .wav files
        for iFile = 1:numel(FileList)
            File = fullfile(Subfolder, FileList(iFile).name);
            [y, fs] = audioread(File);
            [filepath, name, ext] = fileparts(File);
            res = LP_residual_extraction(18,y, fs);
            Window_Length = 25;
            NFFT = 512;
            No_Filter = 40;
            No_coeff = 20;
            low_freq = 0;
            p=40;    % no of filter bank 
            N=400;    % Frame duration
            INC=200;  % Overlap between the frames 
            Nc=20;   % No of coefficients
            high_freq = fs/2;
            [coeffs1, ~, ~] = lfcc_bp(res, fs, Window_Length, NFFT, No_Filter, No_coeff, low_freq, high_freq);
            [coeffs2] = mfcch(y,fs,p,Nc,N,INC);
            coeffs1=coeffs1';
            min_dim = min(size(coeffs1, 2), size(coeffs2, 2));
            coeffs1 = coeffs1(:, 1:min_dim);
            coeffs2 = coeffs2(:, 1:min_dim);
            final=[coeffs1;coeffs2];
            mat_name = strcat(name, '.mat');
            mat_path = fullfile(SaveClassFolder, mat_name);
            save(mat_path, 'final');
        end
    end
end
