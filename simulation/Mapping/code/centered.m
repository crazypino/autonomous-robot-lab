function [centered] = centered(x,y,xo,yo,r0)

% min distance
ETA = 100;


dq = sqrt((x-xo)^2 + (y-yo)^2);



if (dq < r0)
    if (dq <= 0.1)
        dq = 0.1;
    end
    centered = 0.5 * ETA * (1.0 / dq - 1.0 / r0)^2;
else
    centered = 0;
end
end