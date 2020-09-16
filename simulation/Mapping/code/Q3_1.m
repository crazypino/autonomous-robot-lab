%workspace
xlim([0 100]);
ylim([0 100]);
map = zeros(100, 100);
rows = 100;
cols = 100;


%parameter
r0 = 10;

for x = 1:100
    for y = 1:100
        
        map(x,y) = centered(x,y,20,80,r0);

    end
end

[X,Y] = meshgrid(1:100,1:100);
Z = map;
surf(Y,X,Z);
