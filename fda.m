function [t, r] = fda(tmax, level, r0, v0, m)
% Solves nonlinear equation of motion using second order finite 
% difference 

% input
% tmax: final solution time 
% level:(integer scalar) Discretization level.
% r0: initial positions 3x3 matrix
% v0: initial velocities 3x3 matrix
% initial masses 2x2 matrix

%output
% t: vector containing disrete times 
% r: matrix containing computed positions at times t(n)


N = 2;
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

% step 2
astep2 = nbodyaccn(m, r(:,:,1));
for i=1:N
    for q=1:3
        r(i,q,2) = r(i,q,1) + v(i,q,1)*deltat +0.5*astep2(i,q)*deltat^2;
    end
end

%Evolve to final time with FDA 
for n = 2: nt-1 % time loop 
     afda = nbodyaccn(m, r(:,:,(n)));
    for i=1:N
        for q=1:3
            r(i,q,(n+1)) = 2*r(i,q,n) - r(i,q,(n-1)) + deltat^2 * afda(i,q);
        end
    end
end

x1coords = squeeze(r(1,1,:));
y1coords = squeeze(r(1,2,:));

x2coords = squeeze(r(2,1,:));
y2coords = squeeze(r(2,2,:));

plot(x1coords, y1coords)
hold on; 
plot(x2coords, y2coords)


end

