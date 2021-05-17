function plot_pattern();

[time, amp] = textread('thunder_sound.out', '%f %f'); 
plot(time*0.001/8,amp)




