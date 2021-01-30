function [t, r] = fdagalaxy(tmax, level, r0, v0, m, nstars)
% Solves nonlinear equation of motion using second order finite 
% difference 

% Input
% tmax: final solution time 
% level:(integer scalar) Discretization level.
% r0: initial positions matrix
% v0: initial velocities  matrix
% m: initial masses matrix
% n: number of stars

%output
% t: vector containing disrete times 
% r: matrix containing computed positions at times t(n)


N = 2 + nstars; %two cores plus the stars

% Time steps 
nt = 2^(level) + 1;
t = linspace(0.0, tmax, nt);
r = zeros(N, 3, nt);
v = zeros(N, 3, nt);

deltat = t(2) - t(1);
%deltat = tmax * 2^(-1*level);

%initialize first two values 
% step 1 
r(:,:,1) = r0;
v(:,:,1) = v0;

% step 2 - kinematics to determine next positions 
astep2 = nbodyaccn(m, r(:,:,1), N);
for i=1:nstars
    for q=1:3
        r(i,q,2) = r(i,q,1) + v(i,q,1)*deltat +0.5*astep2(i,q)*deltat^2;
    end
end

%Evolve to final time with FDA 
for n = 2: nt-1 % time loop 
     afda = nbodyaccn(m, r(:,:,(n)), N);
    for i=1:nstars
        for q=1:3
            r(i,q,(n+1)) = 2*r(i,q,n) - r(i,q,(n-1)) + deltat^2 * afda(i,q);
        end
    end
end

end