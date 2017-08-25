function [time_swing, prod_swing_real, prod_swing_reac] = prod_swing_import_total(foldername_swing)



% import the data for the production from the file contained in the folder 
% this folder shoudl contain the only that you want to import


% do not open a file containing data while running this script 
% as it will create a hidden file in the folder


% power production in W and VAr 


%% IMPORTANT: structure of the file

% the structure of the file has to be: 
% #timestamp #power_A.real, #power_A.imag, 
% #power_B.real, #power_B.imag, power_C.real, power_C.imag



%% Code
   
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

    % time vector
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
      time_swing(i) = etime(time(i,:),time(1,:));
    end     
    
    
    
    
    
end