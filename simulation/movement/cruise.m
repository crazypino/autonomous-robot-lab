clear
close all
clc

%% Parameters

% Workspace Size

%Velocity (constant for this demo example) 
vel = [];
vel(1) = 0;

%Steering angle


%Initialize a vector of positions for the robot
x=[]; 
y=[];

%% Robot Initial Pose

% Initial Orientation 
theta(1) = pi/15;

% Build Robot Model
ang = 2 * pi * rand(1);


%%%%% PID %%%%%%

Kp = 0.5;
Ki = 0.1;
Kd = 0.5;
integ = 0;
output = 0;
pre_error = 0;
ref = 3;
    
%% Move Robot


%time step
dt = 0.1;

kp = 0.3;

theta(1) = ang + pi/15;
xg = [];
yg = [];
x(1) = 12 + 100;
y(1) = 22 + 100;
xg(1) = round(150 * rand());
yg(1) = round(150 * rand());
xg(2) = round(150 * rand());
yg(2) = round(150 * rand());
xg(3) = round(150 * rand());
yg(3) = round(150 * rand());


Kv = 0.03;

i = 1;
j = 1;
while (1)
    error = ref - vel(i);
    integ = integ + error;
    deriv = (error - pre_error);
    output = Kp * error + Ki * integ +Kd * deriv;
    pre_error = error;
    vel(i+1) = vel(i) + output*dt - 0.01 * vel(i);
    
    xlim([0 200])
    ylim([0 200])

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    e = atan2((yg(j) - y(i)),(xg(j) - x(i))) - theta(i);
    gamma = kp * atan2(sin(e),cos(e));
    
    if (vel(i) > 5)
        vel(i) = 5;
    end
    
    if (gamma > pi/4)
        gamma = pi/4;
    end
    %robot non-holonomic dynamics (as seen in class)
    x(i+1) = x(i) + vel(i) * cos(theta(i)) * dt;
    y(i+1) = y(i) + vel(i) * sin(theta(i)) * dt;
    theta(i+1) = theta(i) + gamma * dt;
    
    robot = Robot(x(i),y(i),theta(i));
    plot(robot(:,1),robot(:,2),'-',x,y,'-',xg(1),yg(1),'*',xg(2),yg(2),'*', xg(3),yg(3),'*');

    xlim([0 200])
    ylim([0 200])
    pause(0.01)
    i = i + 1;
    disp(j);
    if(round(x(i))==xg(j) && round(y(i))== yg(j))
        j = j + 1;
        
    end
    if(j == 4)
        disp('success!');
        break;
    end    
    
    
end
plot(vel);