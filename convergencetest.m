% Convergence testing 
[t6, r6] = fda(tmax, 6, r0, v0, m);
[t7, r7] = fda(tmax, 7, r0, v0, m);
[t8, r8] = fda(tmax, 8, r0, v0, m);

% Plot the solution for different level values 
r6plot = squeeze(r6(1,1,:));
r7plot = squeeze(r7(1,1,:));
r8plot = squeeze(r8(1,1,:));

clf;
hold on;
plot(t6, r6plot, 'g-.+'); 
plot(t7, r7plot, 'b-.*');
plot(t8, r8plot, 'r-.o');

% Downsample level 6 and 7 arrays so they have same length as 5
r7plot = r7plot(1:2:end);
r8plot = r8plot(1:4:end);

%Differences in grid functions 
dr67 = r6plot - r7plot;
dr78 = r7plot - r8plot;

%plot differences 
clf; 
hold on; 
plot(t6, ddr67, 'r-.o');
plot(t6, dr78, 'g-.+');

% now scale
dr78 = 4 * dr78;
clf; 
hold on; 
plot(t6, dr67, 'r-.o'); 
plot(t6, dr78, 'g-.+');
%these are nearly coincident 
%grid spacing will be reduced by factor of 2 relative to 8 
[t9, r9] = fda(tmax, 9, r0, v0, m);

r9plot = squeeze(r9(1,1,:));
r9plot = r9plot(1:8:length(r9plot));
dr89 = r8plot - r9plot;
dr89 = 16 * dr89;
plot(t6, dr89, 'b-.*'); 


