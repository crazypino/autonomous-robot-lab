%% Homogeneous Transformation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Code by: Nicola Bezzo (UVA)
% AMR 2019 
% Date: 09/15/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [robot] = Robot(x,y,theta)

center = [x y];




% Robot shape



a = [-6 -3];
b = [6 3];
c = [-6 3];
d = [6 -3];
% Rotation Matrix

rotmat = [cos(theta) -sin(theta); sin(theta) cos(theta)];

rota = (rotmat * (a'));
rotb = (rotmat * (b'));
rotc = (rotmat * (c'));
rotd = (rotmat * (d'));

% Final Robot Configuration after transformation

robot1 = [rota(1) + center(1), rota(2) + center(2)];
robot2 = [rotb(1) + center(1), rotb(2) + center(2)];
robot3 = [rotc(1) + center(1), rotc(2) + center(2)];
robot4 = [rotd(1) + center(1), rotd(2) + center(2)];
robot = [robot3;robot2;robot4;robot1;robot3];
 
end


