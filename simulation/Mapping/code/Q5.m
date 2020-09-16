%workspace
xlim([0 100]);
ylim([0 100]);
map = zeros(100, 100);

%calculate potential field
r0 = 100;
xg = 80;
yg = 20;
kp = 0.1;

for x = 1:100
    for y = 1:100
        
        map(x,y) = repulsive(x,y,r0)+attractive(x,y,xg,yg,kp);

    end
end

[X,Y] = meshgrid(1:100,1:100);
Z = map;
surf(Y,X,Z);

%parameters
xs = 10;
ys = 80;

dt = 0.1;
x = [];
y = [];
j = 1;
x(1) = 10;
y(1) = 80;

vx = [];
vy = [];
vx(1) = 0;
vy(1) = 0;

while (1)
    
    if round(x(j)) == round(xg) && round(y(j))== round(yg)
        disp('goal');
        break;
    end
    if x(j) > 100 || x(j) < 0 || y(j) < 0 || y(j) > 100
        disp('out');
        break;
    end
    
    % calculate the force and orientation
    force = Force(x(j),y(j),xg,yg,r0,kp);
    
    vx(j+1) = vx(j) + force(1);
    vy(j+1) = vy(j) + force(2);
    
    % max v = 5
    if vx(j+1)^2 + vy(j+1)^2 > 25
        vx(j+1) = 5 * cos(force(3));
        vy(j+1) = 5 * sin(force(3));
    end
    
    % move the robot
    x(j+1) = x(j) + vx(j+1)*dt;
    y(j+1) = y(j) + vy(j+1)*dt;     
    
    
    plot(x,y,'-',xg,yg,'*');
    hold on;
    xlim([0 100]);
    ylim([0 100]);
    pause(0.01);
    j = j+1;
end

    
            
    
