function [attractive] = attractive(x,y,xg,yg,kp)
attractive = 0.5 * kp * ((x-xg)^2 + (y-yg)^2);
end