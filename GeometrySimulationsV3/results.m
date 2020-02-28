load('geometry_results.mat');

min_depth = 1;
max_depth = 50;
min_width = 1;
max_width = 60;
freq = 10;

index = 1;

for x=min_depth:max_depth
  for y=min_width:max_width
    if(x*y==400)
      SLOT_PITCH=20+y;
      POLE_PITCH=2*SLOT_PITCH;
      xforce(index) = outputWSTForcex(x,y);
      yforce(index) = outputWSTForcey(x,y);
      hlosses(index) = outputHLosses(x,y);
      tlosses(index) = outputTLosses(x,y);
      speed(index) = 2*freq*POLE_PITCH;
      index=index+1;
    end
  end
end

figure(1);
plot(xforce);

figure(2);
plot(speed);
