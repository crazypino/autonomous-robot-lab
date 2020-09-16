%Initialize a vector of positions for the robot
x=[]; 
y=[];
x(1) = 20;
y(1) = 25;
%% Robot Initial Pose

%time step
dt = 0.1;

% goal
xg = 50;
yg = 65;


%%%%% PID %%%%%%

Kp = 3;
Ki = 0.5;
Kd = 0.1;
integ = 0;
output = 0;
pre_error = 0;
ref = 5;


%% parameters for kalman filter



% posterior
xhat = [];
yhat = [];
xhat(1) = 20;
yhat(1) = 25;
% cor of posterior
P_x = [];
P_y = [];
P_x(1) = 0;
P_y(1) = 0;

% prior 
xhatminus = [];
yhatminus = [];
xhatminus(1) = 0;
yhatminus(1) = 0;
% cor of prior
Pminus_x = [];
Pminus_y = [];
Pminus_x(1) = 0;
Pminus_y(1) = 0;

Q = 1e-5;
% Kalman Gain
K_x = [];
K_y = [];
K_x(1) = 0;
K_y(1) = 0;

% sensor
xs1 = [];
ys1 = [];
xs1(1) = 20;
ys1(1) = 25;

xs2 = [];
ys2 = [];
xs2(1) = 20;
ys2(1) = 25;

vel = [];
vel(1) = 0.2;
i = 2;

e = atan2((yg - y(1)),(xg - x(1)));
theta = atan2(sin(e),cos(e));

dis = [];
dis(1) = 50;

while (1)
    u = 0.03*randn(1);
    error = ref - vel(i-1);
    integ = integ + error;
    deriv = (error - pre_error);
    output = Kp * error + Ki * integ +Kd * deriv;
    pre_error = error;
    vel(i) = vel(i-1) + output*dt - 0.01 * vel(i-1) + u;
    
    
    x(i) = x(i-1) + vel(i) * cos(theta) * dt ;
    y(i) = y(i-1) + vel(i) * sin(theta) * dt ;
    
    dis(i) = sqrt((x(i)-xg)^2 + (y(i)-yg)^2);   
    
    
    %esitimate prior x,y
    xhatminus(i) = xhat(i-1) + vel(i) * cos(theta) * dt ;
    yhatminus(i) = yhat(i-1) + vel(i) * sin(theta) * dt;
    
    
    %senor x,y
    
    
    
    R = sqrt(1/(1/6 + 1/4))*randn(1);
    R1 = sqrt(6)*randn(1);
    R2 = sqrt(4)*randn(1);
    xs1(i) = x(i) + R1;
    ys1(i) = y(i) + R1;
    
    xs2(i) = x(i) + R2;
    ys2(i) = y(i) + R2;
    
    xs = (6*xs1(i) + 4*xs2(i))/10; 
    ys = (6*ys1(i) + 4*ys2(i))/10; 
    % update prior cov
    Pminus_x(i) = P_x(i-1) + Q;
    Pminus_y(i) = P_y(i-1) + Q;
    
    
    %Kalman Gain update
    K_x(i) = Pminus_x(i)/(Pminus_x(i) + R);
    K_y(i) = Pminus_y(i)/(Pminus_y(i) + R);
    
    
    %update esitimate x,y
    
    xhat(i) = xhatminus(i)+K_x(i)*(xs-xhatminus(i));
    yhat(i) = yhatminus(i)+K_y(i)*(ys-yhatminus(i));
    
    % update cov
    P_x(i) = (1-K_x(i))*Pminus_x(i);
    P_y(i) = (1-K_y(i))*Pminus_y(i);
    
    if((round(x(i))==xg && round(y(i))== yg))
        
        disp('goal');
        
        break;
    
     
    end
    i = i + 1;
    
end

figure(1);
scatter(xhat,yhat);
title('estimated robot position');
xlim([0 100])
ylim([0 100])
figure(2);
plot(vel);
title('velocity');
figure(3);
plot(dis);
title('distance to the goal');


figure(4);
scatter(xhat,yhat);
hold on;
scatter(xs1,ys1);
hold on;
scatter(xs2,ys2);
hold on;
plot(x,y);
hold on;
legend('KF', 'sensor1', 'sensor2','robot');
title('sensors and estimation');