function play_sound();

[time, a_att] = textread('thunder_sound.out', '%f %f');
a_att=a_att*10.0;
sound(a_att);




