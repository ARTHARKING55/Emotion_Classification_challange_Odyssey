clear all; clc; close all;

% Define the base folder containing train, test, and val folders
BaseFolder = "audio path here";

% Define the target folders for train, test, and val
Folders = {'Train','Test', 'Val'}; % Folder names here
% Loop through the folders (train, test, val)
for folderIndex = 1:numel(Folders)
    Folder = fullfile(BaseFolder, Folders{folderIndex});
    SaveFolder = fullfile("save directory path here", Folders{folderIndex});
    
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
            final = mfcch(y,fs,p,Nc,N,INC);
            final=final';
            mat_name = strcat(name, '.mat');
            mat_path = fullfile(SaveClassFolder, mat_name);
            save(mat_path, 'final');
        end
    end
end
