function plot_geometry();

[x_pos, y_pos] = textread('thunder_path.out', '%f %f'); 
plot(x_pos,y_pos)




