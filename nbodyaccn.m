function [a] = nbodyaccn(m, r, N)
% m: vector of length N containing the particle masses
% r: N x 3 array containing the particle positions
% a: N x 3 array containing the computed particle accelerations
% N: number of elements in position arrays 


for i = 1:N
    if i == 1 %core 1 
        r12 = r(2,:) - r(i,:);
        r12mag = ((r(2,1)-r(1,1))^2 + (r(2,2)-r(1,2))^2 +(r(2,3)-r(1,3))^2)^1.5;
        a(1,1) = (m(2)*r12(1)) / r12mag; % x accel due to core 2 
        a(1,2) = (m(2)*r12(2)) / r12mag;
        a(1,3) = (m(2)*r12(3)) / r12mag;
    elseif i == 2 %core 2
        r21 = r(1,:) - r(i,:); %separation vector for core 2
        r21mag = ((r(1,1)-r(2,1))^2 + (r(1,2)-r(2,2))^2 +(r(1,3)-r(2,3))^2)^1.5;
        a(2,1) = (m(1)*r21(1)) / r21mag;
        a(2,2) = (m(1)*r21(2)) / r21mag;
        a(2,3) = (m(1)*r21(3)) / r21mag;
    else % star: acceleration due to both core 1 and core 2
        rcore1sep = r(1,:) - r(i,:);
        rcore1mag = ((r(1,1)-r(i,1))^2 + (r(1,2)-r(i,2))^2 +(r(1,3)-r(i,3))^2)^1.5;
        rcore2sep = r(2,:) - r(i,:);
        rcore2mag = ((r(2,1)-r(i,1))^2 + (r(2,2)-r(i,2))^2 +(r(2,3)-r(i,3))^2)^1.5;
        
        a(i,1) = ((m(1)*rcore1sep(1)) / rcore1mag) + ((m(2)*rcore2sep(1)) / rcore2mag); 
        a(i,2) = ((m(1)*rcore1sep(2)) / rcore1mag) + ((m(2)*rcore2sep(2)) / rcore2mag); 
        a(i,3) = ((m(1)*rcore1sep(3)) / rcore1mag) + ((m(2)*rcore2sep(3)) / rcore2mag); 

    end
end
end



