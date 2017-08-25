function [timecons, constant_power_A_real, constant_power_A_reac, ...
    constant_power_B_real, constant_power_B_reac, ...
    constant_power_C_real, constant_power_C_reac] = consumption_import(foldername)


% import the data for the consumption from the file contained in the
% folder 'foldername'
% this folder shoudl contain the only file that you want to import
% 


% do not open a file containing data while running this script 
% as it will create a hidden file in the folder

% power consumption in W and VAr 


%% IMPORTANT: structure of the file 
% 
% the structure of the file has to be: 
% #timestamp #constant_power_A_real #constant_power_A_reac 
% #constant_power_B_real #constant_power_B_reac
% #constant_power_C_real #constant_power_C_reac


%% Code

    D = dir(foldername) ;
    filename = D(3,1).name;
    path = strcat(foldername, '/', filename);
    delimiterIn = ',';
    headerlinesIn = 9;
    A = importdata(path, delimiterIn, headerlinesIn);

    % create the variable (each column corresponds to one file)
    constant_power_A_real(:,1) = A.data(:,1);
    constant_power_A_reac(:,1) = A.data(:,2);
    constant_power_B_real(:,1)= A.data(:,3);

    constant_power_B_reac(:,1) = A.data(:,4);
    constant_power_C_real(:,1) = A.data(:,5);
    constant_power_C_reac(:,1) = A.data(:,6);

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
      timecons(i) = etime(time(i,:),time(1,:));
    end     
    
    

end    