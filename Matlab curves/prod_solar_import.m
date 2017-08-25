function [timepv, power_real, power_reac] = prod_solar_import(foldername_pv)

% import the file contaied in the folder 'foldername_pv'

% this folder shoudl contain the only file that you want to import

% do not open a file containing data while running this script 
% as it will create a hidden file in the folder


%% Important: structure of the file

% the structure of the files has to be: 
% #timestamp #VA_Out.real.real, #VA_Out.imag, 
%

%% Code 
    
    D2 = dir(foldername_pv);
    filename = D2(3,1).name;
    path = strcat(foldername_pv, '/', filename);
    delimiterIn = ',';
    headerlinesIn = 9;
    A = importdata(path, delimiterIn, headerlinesIn);
    power_real = A.data(:,1);
    power_reac = A.data(:,2);
    

  

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
      timepv(i) = etime(time(i,:),time(1,:));
    end     
    
    
    
    
    
end