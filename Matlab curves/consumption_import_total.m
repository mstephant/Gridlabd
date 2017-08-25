function [timecons, constant_power_real, constant_power_reac] = consumption_import_total(foldername)


% import the data for the consumption from the file contained in the
% folder 'foldername'
% this folder shoudl contain the only file that you want to import
% 

% do not open a file containing data while running this script 
% as it will create a hidden file in the folder


% power consumption in W and VAr 


%% IMPORTANT: structure of the file

% the structure of the file has to be: 
% #timestamp #sum(measured_real_power) #sum(measured_reactive_power)

%% Code


    D = dir(foldername) ;
    filename = D(3,1).name;
    path = strcat(foldername, '/', filename);
    delimiterIn = ',';
    headerlinesIn = 9;
    A = importdata(path, delimiterIn, headerlinesIn);

 
    constant_power_real(:,1) = A.data(:,1);
    constant_power_reac(:,1) = A.data(:,2);
  

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
      timecons(i) = etime(time(i,:),time(1,:));
    end     
    
    

end    