function [prod_pv_real, prod_pv_reac, prod_swing_real, prod_swing_reac] = production_import(foldername)
% import the data for the production from the files contained in the folder 
% this folder shoudl contain only the files that you want to import
% 
% power production in W and VAr 
% 
% the structure of the files has to be: 
% #timestamp #power_A.real, #power_A.imag, 
% #power_B.real, #power_B.imag, power_C.real, power_C.imag

% do not open a file containing data while running this script 
% as it will create a hidden file in the folder


    foldername_pv = strcat(foldername,'/production_pv_outputs');
    foldername_swing = strcat(foldername,'/production_swing_outputs');


    D = dir(foldername_pv);
    % D = . .. file1 file2 file3... --> first two elements are useless
    % n = length(D([D.isdir]==0)); % number of files in the folder


    % import all the files 

    for i=1:length(D([D.isdir]==0)) % number of files in the folder 

        filename = D(i+2,1).name; % +2 because of . .. first elements of D
        path = strcat(foldername_pv, '/', filename);
        delimiterIn = ',';
        headerlinesIn = 9;
        A = importdata(path, delimiterIn, headerlinesIn);

        % create the variable (each column corresponds to one file)
        power_A_real(:,i) = A.data(:,1);
        power_A_reac(:,i) = A.data(:,2);
        power_B_real(:,i) = A.data(:,3);
        power_B_reac(:,i) = A.data(:,4);
        power_C_real(:,i) = A.data(:,5);
        power_C_reac(:,i) = A.data(:,6);


        % sum of the power production of pv:
        prod_pv_real = sum(power_A_real+power_B_real+power_C_real,2);
        prod_pv_reac = sum(power_A_reac+power_B_reac+power_C_reac,2); 


    end

    D2 = dir(foldername_swing);
    filename = D2(3,1).name;
    path = strcat(foldername_swing, '/', filename);
    delimiterIn = ',';
    headerlinesIn = 9;
    A = importdata(path, delimiterIn, headerlinesIn);
    powers_A_real = A.data(:,1);
    powers_A_reac = A.data(:,2);
    powers_B_real = A.data(:,3);
    powers_B_reac = A.data(:,4);
    powers_C_real = A.data(:,5);
    powers_C_reac = A.data(:,6);

    prod_swing_real= sum(powers_A_real + powers_B_real + powers_C_real,2);
    prod_swing_reac = sum(powers_A_reac + powers_B_reac + powers_C_reac,2);  

    
    
end