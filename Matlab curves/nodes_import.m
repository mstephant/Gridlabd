function [t, measured_angle_A, measured_angle_B, measured_angle_C, ...
    measured_frequency_A, measured_frequency_B, measured_frequency_C, ...
    measured_frequency] = nodes_import(foldername)

% This function imports the data from the files contained in the folder 'foldername'
% This folder shoudl contain only the files that you want to import


% Do not open a file containing data while running this script 
% as it will create a hidden file in the folder

% angles in rad, frequency inHz



%% IMPORTANT: structure of the files 

% The structure of the files has to be: 
% #timestamp #measured_angle_A #measured_angle_B #measured_angle_C 
% #measured_frequency_A #measured_frequency_B #measured_frequency_C #measured_frequency

%% Code


    D = dir(foldername) ;
    % D = . .. file1 file2 file3... --> first two elements are useless
    % n = length(D([D.isdir]==0)); % number of files in the folder


    % import all the files 

    for i=1:length(D([D.isdir]==0)) % number of files in the folder

        filename = D(i+2,1).name; % +2 because of . .. first elements of D
        path = strcat(foldername, '/', filename);
        delimiterIn = ',';
        headerlinesIn = 9;
        A = importdata(path, delimiterIn, headerlinesIn);

        % create the variable (each column corresponds to one file)
        measured_angle_A(:,i) = A.data(:,1);
        measured_angle_B(:,i) = A.data(:,2);
        measured_angle_C(:,i)= A.data(:,3);

        measured_frequency_A(:,i) = A.data(:,4);
        measured_frequency_B(:,i) = A.data(:,5);
        measured_frequency_C(:,i) = A.data(:,6);
        measured_frequency(:,i) = A.data(:,7);

    end


    % import time vector
    d = A.textdata(10:end,1);
    l = size(d);

    for i=1:l(1)
        a =size(d{i});
        if a(2) ==  23
            s = d{i};
            d{i}=strcat(s(1:19),'.000');
        else
            d{i}=d{i}(1:23);

        end  
    end
    time = datevec(d , 'yyyy-mm-dd HH:MM:SS.FFF');

    for i = 1:length(time)
      t(i) = etime(time(i,:),time(1,:));
    end 
    % t is a time vector in seconds, starting at the beginning of the
    % simulation

end

