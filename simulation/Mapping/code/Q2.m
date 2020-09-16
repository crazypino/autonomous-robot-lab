%workspace
xlim([0 100]);
ylim([0 100]);
map = zeros(100, 100);
rows = 100;
cols = 100;

%initialize goal and Kp
xg = 80;
yg = 20;
kp = 1;


for x = 1:rows
    for y = 1:cols
        map(x,y) = attractive(x,y,xg,yg,kp);
    end
end

[X,Y] = meshgrid(1:100,1:100);
Z = map;
surf(Y,X,Z);

