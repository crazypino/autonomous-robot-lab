%% place robot
x_robot = [];
y_robot = [];
theta_robot = [];
x_robot(1) = 30;
y_robot(1) = 45;
theta_robot(1) = pi/3;

% landmark
landmark = [25 25; 25 70; 70 25; 70 70; 10 40; 80 60];
%% generate particles

x = unifrnd(0,100,1,1000);
y = unifrnd(0,100,1,1000);
theta = unifrnd(-pi,pi,1,1000);


%% prediction
n_iter = 10;
i = 2;
% weights

w = zeros(1,1000);


%esitimation
x_esi = zeros(1,n_iter);
y_esi = zeros(1,n_iter);
error_x = zeros(1,n_iter);
error_y = zeros(1,n_iter);


vel = 4;
for i = 2:n_iter
    % update robot
    x_robot(i) = x_robot(i-1) + vel*cos(theta_robot(i-1));
    y_robot(i) = y_robot(i-1) + vel*sin(theta_robot(i-1));
    theta_robot(i) = theta_robot(i-1) + 0.2;
    
    %update particles
    for j = 1:1000
        x(j) = x(j) + vel*cos(theta(j))+ sqrt(0.5)*randn(1);
        y(j) = y(j) + vel*sin(theta(j))+ sqrt(0.5)*randn(1);
        theta(j) = theta(j) + 0.2;
        sum_prob = 1;
        for k = 1:6
            m = sqrt((x_robot(i)-landmark(k,1))^2+(y_robot(i)-landmark(k,2))^2);
            dist = sqrt((x(j)-landmark(k,1))^2+(y(j)-landmark(k,2))^2);
            prob = normpdf(m,dist,sqrt(8));
            
            sum_prob = sum_prob * prob;
            
        end
        w(j) = sum_prob;
        
    end
    disp(w);
    %normalize weights
    w_sum = sum(w);
    
    for j = 1:1000
        w(j) = w(j)/w_sum;
    end
    
    % resample
    u = unifrnd(0,1,1000);
    k = 1;
    wc = cumsum(w);
    xminus = zeros(1,1000);
    yminus = zeros(1,1000);
    ind = zeros(1,1000);
    for h = 1:1000
        while (wc(k) < u(h))
            k = k + 1;
        end
        
        ind(h) = k;
    end
    wminus = zeros(1,1000);
    for j = 1:1000
        wminus(j) = w(ind(j));
        xminus(j) = x(ind(j));
        yminus(j) = y(ind(j));
    end
    
    wminus_sum = sum(wminus);
    x = xminus;
    y = yminus;
    for j = 1:1000
        w(j) = wminus(j)/wminus_sum;
    end
    
    %esitimate
    x_sum = 0;
    y_sum = 0;
    for j = 1:1000
        x_sum = x_sum + x(j)*w(j);
        y_sum = y_sum + y(j)*w(j);
    end
    x_esi(i) = x_sum;
    y_esi(i) = y_sum;
    %disp(y_esi(i));
    
    error_x(i) = x_robot(i) - x_esi(i);
    error_y(i) = y_robot(i) - y_esi(i);
    robot = Robot(x_robot(i),y_robot(i),theta_robot(i));
    plot(robot(:,1),robot(:,2),'-',x_robot(i),y_robot(i),'-',x,y,'*');
    %hold on;
    %scatter(x,y);
    %hold on;
    
    xlim([0 100])
    ylim([0 100])
    pause(0.5)
end
plot(error_x);
hold on;
plot(error_y);
hold on;
legend('error_x', 'error_y');
xlim([0 10])
ylim([-30 30])



    