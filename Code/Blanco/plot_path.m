function plot_path()

[x1, y1] = textread('thunder_path37.out', '%f %f'); 
[x2, y2] = textread('thunder_path39.out', '%f %f'); 
[x3, y3] = textread('thunder_path41.out', '%f %f'); 
[x4, y4] = textread('thunder_path43.out', '%f %f'); 
[x5, y5] = textread('thunder_path45.out', '%f %f'); 
[x6, y6] = textread('thunder_path47.out', '%f %f'); 
[x7, y7] = textread('thunder_path49.out', '%f %f'); 
[x8, y8] = textread('thunder_path51.out', '%f %f'); 

subplot(2,3,1); plot(x1,y1)
title('\bf ')
xlabel('\bf x (m)')
ylabel('\bf y (m)')
subplot(2,3,2); plot(x2,y2)
title('\bf ')
xlabel('\bf x (m)')
ylabel('\bf y (m)')
subplot(2,3,3); plot(x3,y3)
title('\bf ')
xlabel('\bf x (m)')
ylabel('\bf y (m)')
subplot(2,3,4); plot(x4,y4)
title('\bf ')
xlabel('\bf x (m)')
ylabel('\bf y (m)')
subplot(2,3,5); plot(x5,y5)
title('\bf ')
xlabel('\bf x (m)')
ylabel('\bf y (m)')
subplot(2,3,6); plot(x6,y6)
title('\bf ')
xlabel('\bf x (m)')
ylabel('\bf y (m)')


print -dpng thunder_pathes



