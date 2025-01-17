%% INSTRUCTIONS

% This script is used to import the data generated from gridlab-d (especially frequency
% from deltamode)

% I use this file to plot for example:
%     - the frequency of all the nodes (on the same graph)
%     - the parameter order (to visualise if the nodes are synchronized in phase, see Rohden' thesis)
%     - the consumption (measured from the triplex meter)
%     - the production of the swing node
%     - the production of solar panels

% The glm should record the interesting properties in different folders.
% Each folder should contain only similar files (same properties, same time
% vector)

% The properties measured by the recorders has to be set in a good order:
% Check each function files to know more



%
% /!\ /!\ /!\ Do not open an output file or a folder containing the output file
% while running this script, as it will create a hidden file in the folder

% -------------------------------------------------------------------------

close all
clear all

%% Change here the folders names 
foldername = '/home/stephant/Desktop/IEEE13/'; % main folder 
folder_nodes = strcat(foldername,'/meters_outputs'); % folder for the recorders of the meters
folder_consumption = strcat(foldername, '/consumption_outputs'); % folder for the recorders of the comsumption
folder_pv_prod = strcat(foldername, '/production_pv_outputs'); % folder for the recorders of the pv production
folder_swing_prod = strcat(foldername, '/production_swing_outputs'); % folder for the recorders of the production of the swing generator


%% If you want to plot the power production from PV
is_pv = 1; % 0 if no pv, 1 if pv





%% ------- Angles and frequency measurements------- 
[time, measured_angle_A, measured_angle_B, measured_angle_C, ...
    measured_frequency_A, measured_frequency_B, measured_frequency_C, ...
    measured_frequency] = nodes_import(folder_nodes);

    %remove the nodes that have 0 angle on the phase    
n_nodes = size(measured_frequency); % count the number of nodes in the grid    
jA=0;
jB=0;
jC=0;
for i=1:n_nodes(2)
    if measured_angle_A(1,i-jA) == 0
        measured_angle_A(:,i-jA) = [];
        jA=jA+1;
    end   
    if measured_angle_B(1,i-jB) == 0
        measured_angle_B(:,i-jB) = [];
        jB=jB+1;
    end  
    if measured_angle_C(1,i-jC) == 0
        measured_angle_C(:,i-jC) = [];
        jC=jC+1;
    end   
end    
n_nodes_A = size(measured_angle_A);
n_nodes_B = size(measured_angle_B);
n_nodes_C = size(measured_angle_C);


% order parameter calculation (for each phases)
r_A = (1/n_nodes_A(2)) * sum( exp(measured_angle_A * 1i),2);
r_B = (1/n_nodes_B(2)) * sum( exp(measured_angle_B * 1i),2);
r_C = (1/n_nodes_C(2)) * sum( exp(measured_angle_C * 1i),2);

r_A = abs(r_A);
r_B = abs(r_B);
r_C = abs(r_C);


% calculation of the average frequency for all the nodes of the grid
% not used 
average_frequency = transpose(measured_frequency);
average_frequency = mean(average_frequency);



% -------plot frequency-------
figure
hold on
for i=1:n_nodes(2)
    plot (time, measured_frequency(:,i))
end    

hold off
title('Frequency of the nodes')
xlabel('time [s]')
ylabel('Frequency [Hz]')
ylim([49 51])
xlim([0 600])



%------- plot parameter order-------
figure
plot(time,r_A, 'red', 'DisplayName', 'Phase A')
hold on 
plot(time,r_B, 'blue', 'DisplayName', 'Phase B')
plot(time,r_C, 'green', 'DisplayName', 'Phase C')
hold off
ylim([0.9 1.1])
xlabel('time [s]')
ylabel('Parameter order')
title('Evolution of the parameter order in time')
legend('show')




%% ------- Consumption data ------- 

% Depending on what you are measuring, you could need the global consumption or the consumption on each of the three phases 
% uncomment one of the two options

% 1. if you want to plot for each of the three phases, use consumption_import 

% [timecons, constant_power_A_real, constant_power_A_reac, ...
%     constant_power_B_real, constant_power_B_reac, ...
%     constant_power_C_real, constant_power_C_reac] = consumption_import(folder_consumption);

% figure
%  plot(timecons, constant_power_A_real, 'r--', 'DisplayName', 'Active power consumption - phase A [W]')
%  hold on
%  plot(timecons, constant_power_B_real, 'b--', 'DisplayName', 'Active power consumption - phase B [W]')
%  plot(timecons, constant_power_C_reac, 'g--', 'DisplayName', 'Active power consumption - phase C [W]')
%  plot(timecons, constant_power_A_reac, 'r:', 'DisplayName', 'Reactive power consumption - phase A [VAr]')
%  plot(timecons, constant_power_B_reac, 'b:', 'DisplayName', 'Reactive power consumption - phase B [VAr]')
%  plot(timecons, constant_power_C_reac, 'g:', 'DisplayName', 'Reactive power consumption - phase C [VAr]')
%  xlabel('time [s]')
%  ylabel('Power consumption [W or VAr]')
%  legend('show')
%  title('Power consumption')
%  hold off


% 2. if you want the global consumption, use the function consumption_import_total

[timecons, constant_power_real, constant_power_reac] = consumption_import_total(folder_consumption);

figure
plot(timecons, constant_power_real, 'r', 'DisplayName', 'Active power consumption [W]')
hold on
plot(timecons, constant_power_reac, 'b', 'DisplayName', 'Reactive power consumption [VAr]')
xlabel('time [s]')
ylabel('Power consumption [W or VAr]')
legend('show')
title('Power consumption')
hold off



%% ------- Swing production data -------
% Depending on what you are measuring, you could need the global production or the production on each of the three phases 
% uncomment one of the two options
 

% 1. production on each phase:
% use the function prod_swing_import

%[timeswing, powers_A_real, powers_A_reac, powers_B_real,...
%    powers_B_reac,powers_C_real, powers_C_reac] = prod_swing_import(folder_swing_prod);

% figure
% plot(timeswing, powers_A_real, 'r--', 'DisplayName', 'Active power production (swing node) - phase A [W]')
%  hold on
%  plot(timeswing, powers_B_real, 'b--', 'DisplayName', 'Active power production (swing node) - phase B [W]')
%  plot(timeswing, powers_C_reac, 'g--', 'DisplayName', 'Active power production (swing node) - phase C [W]')
%  plot(timeswing, powers_A_reac, 'r:', 'DisplayName', 'Reactive power production (swing node) - phase A [VAr]')
%  plot(timeswing, powers_B_reac, 'b:', 'DisplayName', 'Reactive power production (swing node)n - phase B [VAr]')
%  plot(timeswing, powers_C_reac, 'g:', 'DisplayName', 'Reactive power production (swing node) - phase C [VAr]')
%  xlabel('time [s]')
%  ylabel('Power production (swing node) [W or VAr]')
%  legend('show')
%  title('Power production (swing node)')
%  hold off


% 2. global production 
% use the function prod_swing_import_total

[time_swing, power_swing_real, power_swing_reac] = prod_swing_import_total(folder_swing_prod);

figure
plot(time_swing, power_swing_real, 'r', 'DisplayName', 'Active power production (swing node) [W]')
hold on
plot(time_swing, power_swing_reac, 'b', 'DisplayName', 'Reactive power production (swing node) [VAr]')
xlabel('time [s]')
ylabel('Power production (swing node) [W or VAr]')
legend('show')
title('Power production (swing node)')
hold off



%% -------PV production data -------
if is_pv==1
    [timepv, power_real, power_reac] = prod_solar_import(folder_pv_prod);

    
   figure
   plot(timepv,power_real,'r','DisplayName', 'Active power production from PV [W]')
   hold on
   plot(timepv,power_reac,'b','DisplayName', 'Reactive power production from PV [VAr]') 
   xlabel('time [s]')
   ylabel('Pwer production from solar panels [W or VAr]')
   legend('show')
   title('Power production from solar panels')
   hold off
    
    
end   