clear
close all
clc

%% Parameters




%Initialize a vector of positions for the robot
x=[]; 
y=[];

%% Robot Initial Pose

x(1) = 12 + 100;
y(1) = 22 + 100;

% Initial Orientation 
theta(1) = pi/15;

% Build Robot Model
ang = 2 * pi * rand(1);


    
%% Move Robot




dt = 0.1;

kp = 0.1;

theta(1) = ang + pi/15;



Kv = 0.07;

i = 1;

kt = 0.03;
kh = 0.5;

d = [];

a = -1;
b = 2;
c = -20;
dis = 0;  
xg = 0:200;
yg = (-a/b) * xg - c / b;
while (1)
    
    d(i) = (a*x(i) + b*y(i) + c)/sqrt(a^2 + b^2);
    
    theta_d = atan2(-a,b);
    
    gamma = -kt * d(i) + kh * (theta_d - theta(i));
    
    xlim([0 200])
    ylim([0 200])

    vel =3;    
    if (gamma > pi/4)
        gamma = pi/4;
    end
    %robot dynamics
    x(i+1) = x(i) + vel * cos(theta(i)) * dt;
    y(i+1) = y(i) + vel * sin(theta(i)) * dt;
    theta(i+1) = theta(i) + gamma * dt;
    
    robot = Robot(x(i),y(i),theta(i));
    plot(robot(:,1),robot(:,2),'-',x,y,'-',xg,yg);
    

    pause(0.01);
  
    if(round(y(i)) == round((-a/b) * x(i) - c / b))
        dis = dis + vel * dt;
    end
    if (dis >= 10)
        disp('success!');
        break;
    end
    i = i + 1;
    
end
plot(d);
