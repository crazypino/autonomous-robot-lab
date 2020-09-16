%workspace
xlim([0 100]);
ylim([0 100]);
map = zeros(100, 100);



%initialize parameters
r0 = 100;
xg = 80;
yg = 20;
kp = 1;

for x = 1:100 
    for y = 1:100
        
        map(x,y) = repulsive(x,y,r0)+attractive(x,y,xg,yg,kp);

    end
end

[X,Y] = meshgrid(1:100,1:100);
Z = map;
surf(Y,X,Z);