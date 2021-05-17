function thunder();
%
% ======================================================
% MATLAB Macro to generate and save a digital thunder
% ======================================================
%
% Initialize the random number generator (choose a different number
% instead of 37 for a different random sequence). Users may also select
% a different way to initialize the random sequence (i.e. according to
% CPU clock,...).
rand('state',51);
'first random number generated is',rand
% Open files to save results
% thunder_path.out  = filename for geometry of lighting channel
% thunder_sound.out = filename for sound pattern
%
fid = fopen('thunder_path51.out','w');
fid2 = fopen('thunder_sound51.out','w');
%
%
% Description of parameters used in the simulation
%      ns = number of segments
%      dl0 = average length of segment (m)
%      x0 = hit position on ground  (x0 = 0)
%      y0 = hit position on ground ( y0 = 0)
%      thetadir = starting direction angle (degrees)
%      xobs = x-position of observer (m)
%      yobs = y-position of observer (m)
%      Tpulse = duration of the original pulse (s)
%      v = speed of sound (m/s)
%      rms = Dispersion of angle difference between segments
%      DD = attenuation length (m)
%
% Setting the parameters
%
rad=0.017453293;
x0=0.0;
y0=0.0;
ns=2000;
dl0=3.0;
v=340.0;
Tpulse=0.005;
thetadir=2.0;
thetadir=thetadir*rad;
rms=30.0;
rms=rms*rad;
xobs=2000.0;
yobs=0.0;
DD=1000.0;
%
a = zeros(1,200000);
y=y0;
x=x0;
theta=thetadir;
theta_ns(1:4) = thetadir;
theta_ns(5:2000) = 0;
x_pos = zeros(1,2000);
y_pos = zeros(1,2000);
%
% Loop on segments
%
for n = 1:ns
    thetamedio=0.0;
    if n <= 4
        thetamedio=thetadir;
   else
      thetamedio=0;
      for k = n-4:n-1
           thetamedio = thetamedio+theta_ns(k)/4.0;
      end
    end
    while 1 > 0
        axlim = 30.0*rad;
        ax = -axlim + 2.0 * axlim * rand;
        ay = exp(-(ax*ax/(sqrt(2.0)*rms))^2);
        if ay > rand 
            break
        end
    end
    dteta = ax;
    theta = thetamedio + dteta;
    if theta > (90.0*rad)
        theta = 90.0*rad;
    end
    if theta < (-90.0*rad)
        theta = -90.0*rad;
    end

    theta_ns(n) = theta;
%
% Exponential distribution of path lengths
%
dl = -dl0*log(rand);
% Evaluation of angle (teta0) between normal to the segment and line 
% connecting center-of-segment to observer
%
    x1=x;
    y1=y;
    y=y+dl*cos(theta);
    x=x+dl*sin(theta);
    x_pos(n) = x;
    y_pos(n) = y;
    x2=x;
    y2=y;
    x3=(x1+x2)/2.;
    y3=(y1+y2)/2.;
    m1=(y2-y1)/(x2-x1);
    m2=(x1-x2)/(y2-y1);
    m3=(y3-yobs)/(x3-xobs);
    teta0=atan( abs( (m3-m2)/(1.+m3*m2)  ) );

    dist=sqrt((x-xobs)^2+(y-yobs)^2);
    phi=v*Tpulse/dl;
%    
% Attenuation factor due to travelled distance
%
    atten=exp(-dist/DD);
%    
% Save geometrical structure of lightning channel
%
    fprintf(fid,'%f  %f \r\n',x_pos(n),y_pos(n));
  
%
% Loop on the sound pattern (sampling at 8 kHz) from 0 to 200 s
% 

    for it = 1:20
%
% Individual waves from each segment
%
        t=single(it)*0.001/8.0;
        tau=(v*t-dist)/dl;
        b=dl*dl/(2.0*dist*v*Tpulse);
        if(sin(teta0) < phi)
            if(tau < (-phi-sin(teta0))) 
                a(it)=a(it)+0.0;
            end
            if(tau > (-phi-sin(teta0)) & tau < (-phi+sin(teta0)))
                a(it)=a(it)-(b/sin(teta0)) * ((tau+sin(teta0))^2-phi^2);
            end
            if(tau > (-phi+sin(teta0)) & tau < (phi-sin(teta0)))
                a(it)= a(it)-4.0*b*tau;
            end
           if(tau > (phi-sin(teta0)) & tau < (phi+sin(teta0)))
                a(it)= a(it)+(b/sin(teta0)) * ((tau-sin(teta0))^2-phi^2);
           end
            if(tau > (phi+sin(teta0))) 
                a(it)=a(it)+0.0;
            end
        else
            if(tau < (-phi-sin(teta0))) 
                a(it)=a(it)+0.0;
            end
           if(tau > (-phi-sin(teta0)) & tau < (phi-sin(teta0)))
                a(it)=a(it)-(b/sin(teta0)) * ((tau+sin(teta0))^2-phi^2);
           end
            if(tau > (phi-sin(teta0)) & tau < (-phi+sin(teta0)))
                a(it)= a(it)+0.0;
            end
            if(tau > (-phi+sin(teta0)) & tau < (phi+sin(teta0)))
                a(it)= a(it)+(b/sin(teta0)) * ((tau-sin(teta0))^2-phi^2);
            end
            if(tau > (phi+sin(teta0))) 
                a(it)=a(it)+0.0;
            end
        end
        a_att(it)=a(it)*atten;
% End of loop on sound pattern        
    end
% End of loop on segments    
end

%
% Normalize sound pattern amplitude between -1 and +1
% 
amax=0.0;
amin=0.0;
fact=1.0;
for i = 1:20
    if(a_att(i) > amax) 
        amax=a_att(i);
    end
    if(a_att(i) < amin)
        amin=a_att(i);
    end
end
if(abs(amax) > abs(amin))
    fact = abs(amax);
end
if(abs(amax) < abs(amin))
    fact = abs(amin);
end
%
% Save sound pattern
%
for i=1:20
    if(abs(a_att(i))>0)
     a_att(i)=a_att(i)/fact;
     fprintf(fid2,'%f  %f \r\n', i, a_att(i));
    end
end
%
% Save sound on a .wav file
%
wavwrite(a_att*10,'thunder51.wav');
%
%
% Plot the geometrical structure of lightning channel
%
%plot(x_pos,y_pos);
%  
%
% Plot the sound pattern
%
%plot(a_att);
%
% Play the sound
%
%sound(a_att);
%
status = fclose(fid);
status2 = fclose(fid2);




