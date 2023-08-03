#initiation of reference frames ECI (inertial), ECEF (Earth-locked)
#transforming XYZ coordinates
sim.data.t = 0;
R_lp_geo = [sim.lpad.latitude sim.lpad.longitude sim.lpad.attitude]; #coordinates from config.m
R_lp_ecef = geo2ecef(R_lp_geo); #
R_lp_eci = ecef2eci(R_lp_ecef, sim.data.t); #

sim.lpad.R_lp_geo = R_lp_geo;
sim.lpad.R_lp_ecef = R_lp_ecef;

#------------------------------------------------------------------------------
#calculate coordinates of ENU axis in ECEF
X_enu_ecef = enu2ecef ([1e6 0 0], R_lp_geo, R_lp_ecef); #ENU - EAST
Y_enu_ecef = enu2ecef ([0 1e6 0], R_lp_geo, R_lp_ecef); #ENU - NORTH
Z_enu_ecef = enu2ecef ([0 0 1e6], R_lp_geo, R_lp_ecef); #ENU - UP

#------------------------------------------------------------------------------
#calculate initial rocket vector in ENU and ECEF coordinate systems
X_rkt_enu0(1) = sin(deg2rad(sim.lpad.azimuth));
X_rkt_enu0(2) = cos(deg2rad(sim.lpad.azimuth));
X_rkt_enu0(3) = tan(deg2rad(sim.lpad.elevation));
X_rkt_enu0    = X_rkt_enu0 / norm([X_rkt_enu0]);

Z_rkt_enu0(1) = sin(deg2rad(sim.lpad.azimuth+180));
Z_rkt_enu0(2) = cos(deg2rad(sim.lpad.azimuth+180));
Z_rkt_enu0(3) = tan(deg2rad(90-sim.lpad.elevation));
Z_rkt_enu0    = Z_rkt_enu0 / norm([Z_rkt_enu0]);

Z_rkt_enu0    = gen_rot(Z_rkt_enu0, X_rkt_enu0, 0);

Y_rkt_enu0    = cross(Z_rkt_enu0, X_rkt_enu0);
Y_rkt_enu0    = Y_rkt_enu0 / norm([Y_rkt_enu0]);


X_rkt_ecef0 = enu2ecef(X_rkt_enu0, R_lp_geo, [0 0 0]); 
Y_rkt_ecef0 = enu2ecef(Y_rkt_enu0, R_lp_geo, [0 0 0]); 
Z_rkt_ecef0 = enu2ecef(Z_rkt_enu0, R_lp_geo, [0 0 0]); 

#------------------------------------------------------------------------------
#calculate initial quaternion rocket -> ecef

C0 =  [dot(X_rkt_ecef0,[1 0 0]) dot(X_rkt_ecef0,[0 1 0]) dot(X_rkt_ecef0,[0 0 1]); ...
       dot(Y_rkt_ecef0,[1 0 0]) dot(Y_rkt_ecef0,[0 1 0]) dot(Y_rkt_ecef0,[0 0 1]); ...                                                          ];
       dot(Z_rkt_ecef0,[1 0 0]) dot(Z_rkt_ecef0,[0 1 0]) dot(Z_rkt_ecef0,[0 0 1])];
C0 = C0';
Q0 = mat2qua(C0);
Q0 = Q0/norm(Q0);