clear
close all
clc

%% Parameters



%Initialize a vector of positions for the robot
x=[]; 
y=[];

%% Robot Initial Pose


% initial theta 
theta(1) = pi/15;

% Random theta
ang = 2 * pi * rand(1);

    
%% Move Robot



%time step
dt = 0.1;

kp = 0.1;

theta(1) = ang + pi/15;

x(1) = 12 + 100;

y(1) = 22 + 100;

% random goal
xg = round(150 * rand());
yg = round(150 * rand());

Kv = 0.07;
vel = [];
i = 1;
disp(xg);
disp(yg);
while (1)

    e = atan2((yg - y(i)),(xg - x(i))) - theta(i);
    gamma = kp * atan2(sin(e),cos(e));
    vel(i) = Kv * sqrt((xg - x(i))^2 + (yg - y(i))^2);
    
    xlim([0 200])
    ylim([0 200])
    if (vel(i) > 5)
        vel(i) = 5;
    end
    
    if (gamma > pi/4)
        gamma = pi/4;
    end
    
    %robot dynamics
    x(i+1) = x(i) + vel(i) * cos(theta(i)) * dt;
    y(i+1) = y(i) + vel(i) * sin(theta(i)) * dt;
    theta(i+1) = theta(i) + gamma * dt;
    
    robot = Robot(x(i),y(i),theta(i));
    plot(robot(:,1),robot(:,2),'-',x,y,'-',xg,yg,'*');
    xlim([0 200])
    ylim([0 200])
    pause(0.01)
    
    
    if((round(x(i))==xg && round(y(i))== yg) || vel(i) == 0)
        vel(i) = 0;
        disp('goal');
        break;
    end
    i = i + 1;
    
end
plot(vel);
