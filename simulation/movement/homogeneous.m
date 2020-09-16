

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Code by: Qimin Luo (UVA)
% AMR 2019 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
clc



%Velocity (constant for this demo example) 
vel = 5;

%Steering angle
steering = pi/6; 

%Initialize a vector of positions for the robot
x=[]; 
y=[];

%% Robot Pose

x(1) = 12;
y(1) = 22;

% Initial Orientation 
theta(1) = pi/15;

% Build Robot Model
ang = 2 * pi * rand(1);
ini_robot = Robot(100,100,ang);

c = ini_robot(1,:);
b = ini_robot(2,:);
d = ini_robot(3,:);
a = ini_robot(4,:); 
robot = Robot(100 + x(1), 100 + y(1) ,ang + theta(1));
xlim([0 200]);
ylim([0 200]);
plot(ini_robot(:,1),ini_robot(:,2),'-', robot(:,1),robot(:,2),'-');

  

