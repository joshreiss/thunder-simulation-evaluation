function plot_path()

[x1, y1] = textread('thunder_path37.out', '%f %f'); 
[x2, y2] = textread('thunder_sound_37_m2500.out', '%f %f'); 
[x3, y3] = textread('thunder_sound_37_2000.out', '%f %f'); 
[x4, y4] = textread('thunder_sound_37_m100.out', '%f %f'); 

subplot(2,2,1); plot(x1,y1)
title('\bf ')
xlabel('\bf x')
ylabel('\bf y')
subplot(2,2,2); plot(x2*0.001/8,y2)
title('\bf x(Obs)=-2500 m')
xlabel('\bf t (s)')
ylabel('\bf A(t)')
subplot(2,2,3); plot(x3*0.001/8,y3)
title('\bf x(Obs)=+2000 m')
xlabel('\bf t (s)')
ylabel('\bf A(t)')
subplot(2,2,4); plot(x4*0.001/8,y4)
title('\bf x(Obs)=-100 m')
xlabel('\bf t (s)')
ylabel('\bf A(t)')

print -dpng multipattern



