% single galaxy at rest, and verify that stars remain on circular orbits
nstars = 100; % number of stars
tmax = 10;
level = 5;
rsep = 5; % initial separation between cores
m1 = 1; % mass core 1 
m2 = 0; % mass core 2, change to 0 once test done 
msum = m1+m2;
r1 = (m2 / msum)*rsep; %radius core 1
r2 = (m1 / msum)*rsep; %radius core 2
v1 = sqrt(m2*r1)/rsep; %velocity core 1
v2 = sqrt(m1*r2)/rsep; %velocity core 2

%initial positions and velocities of cores and stars 
rcores = [r1 0 0 ; -r2 0 0];
vcores = [3 v1 0; 3 -v2 0];
m = [m1 , m2];



% Stars ******************** 
rstars = zeros(nstars, 3);
vstars = zeros(nstars, 3);

rng(0,'twister'); %initialize random number generator 
minval = 1; % min value of star radii
maxval = 5; %max value of star radii
radii = (maxval-minval).*rand(nstars,1) + minval; 

minphi = 0;
maxphi = 360;
angles = (maxphi-minphi).*rand(nstars,1) + minphi; %random angular positions for stars

% fill in matrix of star positions
%edit this so that direction can be cw or ccw of velocities
for i=1:nstars
    rstars(i,1) = radii(i)*cosd(angles(i)); %x
    rstars(i,2) = radii(i)*sind(angles(i)); %y
    rstars(i,3) = 0; %z
    vstars(i,1) = (sqrt((m(1))/radii(i)))*(-sind(angles(i))) + 3;
    vstars(i,2) = (sqrt((m(1))/radii(i)))*(cosd(angles(i)));
    vstars(i,3) = 0;
end

% combine initial position matrix of cores and stars
r0 = [rcores ; rstars];
v0 = [vcores ; vstars];

[t,r] = fdagalaxy(tmax, level, r0, v0, m, nstars);
