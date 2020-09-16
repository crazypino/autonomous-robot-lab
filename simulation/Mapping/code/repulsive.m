 function [repulsive] = repulsive(x,y,r0)

% min distance
ETA = 1000;
dmin = Inf;
for xo = 30:50
    for yo = 50:70
        dq = sqrt((x-xo)^2 + (y-yo)^2);
        if dmin > dq
            dmin = dq;
        end
    end
end
dq = dmin;
if x < 50 && x > 30 && y < 70 && y > 50
    dq = 0;
end


if (dq < r0)
    if (dq <= 0.01)
        dq = 0.5;
    end
    repulsive = 0.5 * ETA * (1.0 / dq - 1.0 / r0)^2;
else
    repulsive = 0;
end
end

    