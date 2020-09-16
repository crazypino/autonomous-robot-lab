function [force]=Force(x,y,xg,yg,r0,kp)
% min distance
ETA = 100;
dmin = Inf;

for xo = 30:50
    for yo = 50:70
        dq = sqrt((x-xo)^2 + (y-yo)^2);
        if dmin > dq
            dmin = dq;
            xmin = xo;
            ymin = yo;
        end
    end
end

dq = dmin;
if x < 50 && x > 30 && y < 70 && y > 50
    dq = 0;
end

if dq < 1
    dq = 1;
end

%repulsive force
theta = atan2(y-ymin,x-xmin);
delta = ETA*(1/dq - 1/r0)*(1/(dq^2));
delta_x_rep = delta*cos(theta);
delta_y_rep = delta*sin(theta);

%attractive force
theta_goal = atan2(y-yg,x-xg);
d = sqrt((x-xg)^2+(y-yg)^2);
delta_x_att = -kp*d*cos(theta_goal);
delta_y_att = -kp*d*sin(theta_goal);

%total force and orientation
delta_x = delta_x_rep + delta_x_att;
delta_y = delta_y_rep + delta_y_att;

th = atan2(delta_y, delta_x);
 


force = [delta_x delta_y th];

