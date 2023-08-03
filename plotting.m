close all


#------------------------------------------------------------------------------
#figure 1
#plot Earth
figure('name', 'Trajectory in ECEF reference frame')
subplot(1,2,1)
[sim.plt.X, sim.plt.Y, sim.plt.Z] = sphere(40);
mesh (6371*sim.plt.X, 6371*sim.plt.Y, 6371*sim.plt.Z);
axis equal;
hold on
grid minor

#------------------------------------------------------------------------------
#name X-Y-Z ECEF system
xlabel ("X");
ylabel ("Y");
zlabel ("Z");

#------------------------------------------------------------------------------
#plot ENU Coordinate system and rocket trajectory in ECEF system

plot3([R_lp_ecef(1)/1e3 X_enu_ecef(1)/1e3],  [R_lp_ecef(2)/1e3 X_enu_ecef(2)/1e3], [R_lp_ecef(3)/1e3 X_enu_ecef(3)/1e3])
plot3([R_lp_ecef(1)/1e3 Y_enu_ecef(1)/1e3],  [R_lp_ecef(2)/1e3 Y_enu_ecef(2)/1e3], [R_lp_ecef(3)/1e3 Y_enu_ecef(3)/1e3])
plot3([R_lp_ecef(1)/1e3 Z_enu_ecef(1)/1e3],  [R_lp_ecef(2)/1e3 Z_enu_ecef(2)/1e3], [R_lp_ecef(3)/1e3 Z_enu_ecef(3)/1e3])
plot3(Y(:,1)/1e3, Y(:,2)/1e3, Y(:,3)/1e3)
legend('Earth', 'East', 'North', 'Up', 'Trajectory')
#------------------------------------------------------------------------------
#plot 3d rocket trajectory in ecef
subplot(1,2,2)
plot3(Y(:,1)/1e3, Y(:,2)/1e3, Y(:,3)/1e3, 'color','k')
hold on
plot3(Yp(:,1)/1e3, Yp(:,2)/1e3, Yp(:,3)/1e3, 'color','r')
axis equal;
grid minor
legend ('Trajectory - Rocket', 'Trajectory - Parachute')

#------------------------------------------------------------------------------
#figure 2
#plot 3d rocket trajectory in ENU
figure('name', 'Trajectory in ENU reference frame')
plot3(flight.R_rkt_enu(:,1)/1e3, flight.R_rkt_enu(:,2)/1e3, flight.R_rkt_enu(:,3)/1e3, 'color','k')
hold on
plot3(flight.Rp_rkt_enu(:,1)/1e3, flight.Rp_rkt_enu(:,2)/1e3, flight.Rp_rkt_enu(:,3)/1e3, 'color','r')
plot3([0 3], [0 0], [0 0]);
plot3([0 0], [0 3], [0 0]);
plot3([0 0], [0 0], [0 3]);
axis equal;
grid minor
a=1;
l=1;
for i=1:3
plot3([flight.R_rkt_enu(a,1)/1e3 flight.R_rkt_enu(a,1)/1e3 + l*flight.X_enu(a,1)],[flight.R_rkt_enu(a,2)/1e3 flight.R_rkt_enu(a,2)/1e3 + l*flight.X_enu(a,2)],[flight.R_rkt_enu(a,3)/1e3 flight.R_rkt_enu(a,3)/1e3 + l*flight.X_enu(a,3)],'color','r')
plot3([flight.R_rkt_enu(a,1)/1e3 flight.R_rkt_enu(a,1)/1e3 + l*flight.Y_enu(a,1)],[flight.R_rkt_enu(a,2)/1e3 flight.R_rkt_enu(a,2)/1e3 + l*flight.Y_enu(a,2)],[flight.R_rkt_enu(a,3)/1e3 flight.R_rkt_enu(a,3)/1e3 + l*flight.Y_enu(a,3)],'color','b')
plot3([flight.R_rkt_enu(a,1)/1e3 flight.R_rkt_enu(a,1)/1e3 + l*flight.Z_enu(a,1)],[flight.R_rkt_enu(a,2)/1e3 flight.R_rkt_enu(a,2)/1e3 + l*flight.Z_enu(a,2)],[flight.R_rkt_enu(a,3)/1e3 flight.R_rkt_enu(a,3)/1e3 + l*flight.Z_enu(a,3)],'color','g')
a = floor(length(t)/i);
endfor

xlabel ("East [km]");
ylabel ("North  [km]");
zlabel ("Up  [km]");
legend ('Trajectory', 'Eeast', 'North', 'Up', 'Rocket X', 'Rocket Y', 'Rocket Z')
#------------------------------------------------------------------------------
#plot 2d rocket trajectory in ENU - East-North
figure("name", "Trajectory details and velocity","position",[100 50 0.85 * get(0,"screensize")(3:4)])
subplot(2,2,1)
plot(flight.R_rkt_enu(:,1)/1e3, flight.R_rkt_enu(:,2)/1e3, 'color', 'k')
hold on
plot(flight.Rp_rkt_enu(:,1)/1e3, flight.Rp_rkt_enu(:,2)/1e3, 'color', 'r')
axis equal;
grid minor
xlabel ("East [km]");
ylabel ("North [km]");

#------------------------------------------------------------------------------
#plot 2d rocket trajectory in ENU  - East-Up
subplot(2,2,2)
plot(flight.R_rkt_enu(:,1)/1e3, flight.R_rkt_enu(:,3)/1e3, 'color', 'k')
hold on
plot(flight.Rp_rkt_enu(:,1)/1e3, flight.Rp_rkt_enu(:,3)/1e3, 'color', 'r')
axis equal;
grid minor
xlabel ("East [km]");
ylabel ("Up [km]");

#------------------------------------------------------------------------------
#plot velocity over time
subplot(2,2,3)
plot(t, flight.V_rkt_enu(:,4)) 
hold on
plot(t, flight.M_r) 
grid minor
xlabel ("Time [s]");
ylabel ("Up [km]");

subplot(2,2,4)
plot(t, Y(:,11)/(2*pi)) #east
hold on
plot(t, Y(:,12)/(2*pi)) #east
plot(t, Y(:,13)/(2*pi)) #east
grid minor
xlabel ("Time [s]");
ylabel ("Omega [obr/s]");

#------------------------------------------------------------------------------
figure 
subplot(2,1,1)
plot(t, flight.alpha);
hold on
grid minor
plot(t, flight.beta);
legend('alpha', 'beta')
xlabel ("Time [s]");
ylabel ("Angle [deg]");

subplot(2,1,2)
plot(t, flight.Fn_fin);
grid minor