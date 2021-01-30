%Initial conditions for galaxies
%-------------------------------

nstars = 10000; % number of stars per core
tmax = 65;
level = 5;
nt = 2^(level) + 1;
m1 = 1; % mass core 1 
m2 = 1; % mass core 2 

%initial positions and velocities of cores
rcores = [-5 -7 0; 5 7 0]; %xyz of core 1, xyz of core 2
vcores = [0.15 0 0; -0.15 0 0];

%matrix of masses
m = [m1 , m2]; 

% Make stars
% --------------

%Initialize position and velocity matrices
rstars = zeros(nstars, 3); 
vstars = zeros(nstars, 3);

%Generate random radii for stars 
rng(0,'twister'); %initialize random number generator 
minval = 1; % min value of star radii
maxval = 5; %max value of star radii
radii = (maxval-minval).*rand(nstars,1) + minval; 

%Generate random angular positions for stars
minphi = 0;
maxphi = 360;
angles = (maxphi-minphi).*rand(nstars,1) + minphi; 

% Fill in matrix of star positions

% If ccw is set to -1, then the rotation direction of stars is
% counter-clockwise. If ccw=1, then rotation is clockwise 
ccw = 1;
for i=1:(nstars/2) %core 1 stars
    rstars(i,1) = (radii(i)*cosd(angles(i))) + rcores(1,1); %x
    rstars(i,2) = (radii(i)*sind(angles(i))) + rcores(1,2); %y
    rstars(i,3) = 0; %z
    vstars(i,1) = ((sqrt((m(1))/radii(i)))*(ccw*sind(angles(i)))) +vcores(1,1);
    vstars(i,2) = ((sqrt((m(1))/radii(i)))*(ccw*-cosd(angles(i)))) +vcores(1,2);
    vstars(i,3) = 0;
end

for i=((nstars/2)+1):nstars %core 2 stars
    rstars(i,1) = (radii(i)*cosd(angles(i))) + rcores(2,1); %x
    rstars(i,2) = (radii(i)*sind(angles(i))) + rcores(2,2); %y
    rstars(i,3) = 0; %z
    vstars(i,1) = ((sqrt((m(2))/radii(i)))*(ccw*sind(angles(i)))) +vcores(2,1);
    vstars(i,2) = ((sqrt((m(2))/radii(i)))*(ccw*-cosd(angles(i)))) +vcores(2,2);
    vstars(i,3) = 0;
end
    
% combine initial position and velocity matricies of cores and stars
r0 = [rcores ; rstars];
v0 = [vcores ; vstars];


%Use finite difference function to get position matrices to use in
%animation
%---------------------------------------------------------
[t1, pos] = fdagalaxy(tmax, level, r0, v0, m, nstars);



%Animation: specifications taken from bounce.m 
%----------------------------------------------
plotenable = 1;
pausesecs = 0.01;
% Ball has a (marker) size of 15 ...
ballsize = 2;
% ... it's red ...
ballcolor = 'r';
% ... and it's plotted as a circle.
ballmarker = 'o';
avienable = 1;
% If plotting is disabled, ensure that AVI generation
% is as well
if ~plotenable
   avienable = 0;
end
% Name of avi file.
avifilename = 'galaxy.avi';
% Presumed AVI playback rate in frames per second.
aviframerate = 25;
if avienable
   aviobj = VideoWriter(avifilename);
   open(aviobj);
end
for t = 1:nt
    
   if plotenable
      clf;
      hold on;
      axis square;
      box on;
      xlim([-20, 1 + 20]);
      ylim([-20, 1 + 20]);
      % Draw the ball. 
      plot(pos(:,1,t), pos(:,2,t), 'Linestyle', 'none', 'Marker', ballmarker, 'MarkerSize', ballsize, ...
         'MarkerEdgeColor', ballcolor, 'MarkerFaceColor', ballcolor);
      % Force update of figure window.
      drawnow;
      if avienable
         if t == 0
            framecount = 5 * aviframerate ;
         else
            framecount = 1;
         end
         for iframe = 1 : framecount
            writeVideo(aviobj, getframe(gcf));
         end
      end
      % Pause execution to control interactive visualization speed.
      pause(pausesecs);
   end
end

if avienable
   close(aviobj);
   fprintf('Created video file: %s\n', avifilename);
end
