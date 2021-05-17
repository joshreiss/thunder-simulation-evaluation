function out = NWaveSegments_opt_chunk_noWait(numSegs,segLength,xDistance,maxAmp,minAngle,maxAngle,attenuation,stretching);
%JR - my guess NWaveSegments_opt_chunk_noWait(100,5,100,1,0,100,1,50);
%numSegs: number of lightning segments
%segLength: length of each segment (m)
%xDistance: horizontal distance to observer (m)
%maxAmp: maximum amplitude (arbitrary, since amplitude is normalized in this version)
%minAngle: minimum allowable N-wave angle (degrees)
%maxAngle: maximum allowable N-wave angle (degrees)
%attenuation: attenuation per km (arbitrary in current version, the amp. is normalized anyways)
%stretching: duration stretch per km (percentage per km -- this is also arbitrary at the moment)
%soundLength: duration of the sound file (s)
//Amplitude should be based on energy per meter of lightning strike (not implemented), normalized to decibels. Lightning approximated as vertical
//line, with randomized angles for each segment but x values are shared and there is no loss of height due to angle of segment.
%uses midpoint of each segment for parameter calculations
l = segLength/2;
c = 344;//speed of sound
angle = pi/180*abs(rand(1,numSegs)*(maxAngle-minAngle) + minAngle);//randomize angle of each segment
for i = 1:numSegs //Calculating time-invariant parameters
   r(i) = sqrt(xDistance^2 + (segLength*i-l)^2);//calculate the distance from observer of each segment
   timeToObserver(i) = r(i)/c;//compute time taken to reach observer
   %compute amplitudes and wave durations of each segment (at observer's position)
   %amplitude(i) = maxAmp - attenuation*r(i)/1000; %linear decay over distance (unrealistic)
   %amplitude(i) = maxAmp*(1 - r(i)*attenuation/1000); %percentage decay over distance (slightly more realistic)
   amplitude(i) = 1; %DEBUG -- amplitude doesn't affect anything at this time due to normalization of results
   duration(i) = (l/c)*(1+(stretching/1000)*r(i)); %wave will stretch out over distance
   %compute partial-solution parameters for each segment
   B(i) = (amplitude(i)*l^2)/(2*r(i)*c*duration(i));
   Phi(i) = c*duration(i)/l;
   absSine = abs(sin(angle(i)));
   %compute zero-crossings of each wave,
   %start with the coefficients of the quadratic formula
   %positive pulse...
   A = -(c^2)/(l^2);
   C = (2*c/l)*(r(i)/l - absSine);
   D = Phi(i)^2 - (r(i)^2)/(l^2) + (2*r(i)*absSine)/l - absSine^2;
   %negative pulse...
   E = A;
   F = (2*c/l)*(r(i)/l + absSine);
   G = Phi(i)^2 - (r(i)^2)/(l^2) - (2*r(i)*absSine)/l - absSine^2;
   %then calculate the zero-crossings of each pulse using the quadratic formula
   zeroCross(i,1) = (-C + sqrt(C^2 - 4*A*D))/(2*A);
   zeroCross(i,2) = (-C - sqrt(C^2 - 4*A*D))/(2*A);
   zeroCross(i,3) = (-F + sqrt(F^2 - 4*E*G))/(2*E);
   zeroCross(i,4) = (-F - sqrt(F^2 - 4*E*G))/(2*E);
end %i
zeroCross = sortrows(zeroCross);//sort the zero crossings to make sure they are ascending
soundStart = round(min(min(zeroCross)) * 44100 - 0.5);//start point of file will be first zero crossing
soundEnd = round(max(max(zeroCross)) * 44100 + 0.5);//end point of file will be last zero crossing
soundLength = soundEnd - soundStart;//length of sound file, in samples
%compute thunder signature in chunks
chunks = [];
chunkSize = 0.05; %(seconds)
chunkSamps = chunkSize * 44100;
numChunks = round(soundLength/chunkSamps - 0.5) + 1;
for k = 1:numChunks
	for (j = 1:chunkSamps) {
    thunder(j) = 0;%init the sample value to 0
    t = (j-1+soundStart)/(44100) + (k-1)*chunkSize;//Increment time variable with offset for chunk and for starting time
    for (i = 1:numSegs) {//Calculate the current sample for each component pulse wave
      if (((t>zeroCross(i,1)) & (t<zeroCross(i,2))) | ((>zeroCross(i,3)) & (t<zeroCross(i,4)))) {//Only calculate current NWave if there is significant data at this sample
        segPoints(i) = NWavePoint(t,c,l,r(i),Phi(i),B(i),angle(i));
        thunder(j) = thunder(j) + segPoints(i);
      }  else segPoints(i) = 0;
    }
	}
    chunks = [chunks thunder];//append current results to total file
end %k
out = chunks/abs(max(chunks));%normalize and output
