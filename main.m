close all
clear 
clc
disp("Start initialisation")

run("config.m"); #load defined data
addpath("reference_frames"); #load functions transforming coordinates
addpath("flow"); #load functions calculating flow and atmospheric properties
addpath("forces"); #load functions calculating forces acting of a rocket

tic #start counting time

#global variables
global data;

#------------------------------------------------------------------------------
#calcuate initial rocket position and attitude
disp("Start initialisation")
initialise;

#------------------------------------------------------------------------------
#calculations without parachute

disp("Start integration")

tspan = [0 1000]; #integration time
R0 = R_lp_ecef;
V0 = [0 0 0];
OMEGA0 = [0 0 0];
M0 = sim.rkt.m_0;
I0 = [sim.rkt.Ix_full sim.rkt.Iy_full sim.rkt.Iz_full];
Y0 = [R0 V0 Q0 OMEGA0 M0 I0]; #state vector at t=0
opts = odeset('MaxStep', 2, 'Events', @landing); #integration options
[t,Y,te,Ye,ie] = ode45(@(t,Y) test_ode(t,Y,sim), tspan, Y0, opts); #integrate

t = t(1:(end-1),:);
Y = Y(1:(end-1),:);
#------------------------------------------------------------------------------
#switch to calculations with parachute

R0_r = Ye(1,1:3);
m0_r = Ye(1,14);
tspan = [0 10];

Y0 = [R0_r m0_r]; #state vector at parachute deployment
opts = odeset('RelTol', 1e-6, 'MaxStep', 2, 'Events', @landing_par); #integration options
[tp,Yp,tep,Yep,ip] = ode45(@(t,Y) parachute_ode(t,Y,sim), tspan, Y0, opts); #integrate

tp = tp(1:(end-1),:);
Yp = Yp(1:(end-1),:);

#------------------------------------------------------------------------------
disp("Start post-processing")

flight = post_processing(t,Y,tp,Yp,te,Ye,sim);

#----------------------------------------------
disp("Start plotting")

plotting


#save ("-mat-binary", "workspace.mat")
time = toc;

disp("Finished in:")
disp(time)


