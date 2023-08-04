#rocket data and setttings

#------------------------------------------------------------------------------
#SIMULATION sim

#------------------------------------------------------------------------------
#CONSTANTs 
sim.cst.R = 8.314;
sim.cst.sigma = 5.67e-8; 
sim.cst.M_air = 0.0289644;
sim.cst.kappa_air = 1.4;
sim.cst.prandtl_air = 0.71;

#------------------------------------------------------------------------------
#LAUNCHPAD sim
#launchpad location
sim.lpad.latitude = 54.569286; #N-S | Ustka 54.569286| Drawsko 53.413141 | Kiruna 67.851380#
sim.lpad.longitude = 16.777846; #E-W | Ustka 16.777846| Drawsko  15.737282 | Kiruna 20.224509#
sim.lpad.attitude = 100; # [m]
sim.lpad.R_lp_geo = [sim.lpad.latitude sim.lpad.longitude sim.lpad.attitude];
#launchrail attitude

sim.lpad.azimuth = 0; # 0 - north, 90 - east, 180 - south, 270 - west 
sim.lpad.elevation = 89; # 90 - zenit
sim.lpad.length = 12; 
sim.lpad.height = sim.lpad.attitude + sin(deg2rad(sim.lpad.elevation)) * sim.lpad.length ;

#load wind profile

sim.lpad.wind = dlmread('wind_profile.csv'); 

#------------------------------------------------------------------------------
#ROCKET 
sim.rkt.d = 0.45;
sim.rkt.A =  pi * sim.rkt.d^2 / 4;
sim.rkt.l = 11.2;
 
 
sim.rkt.m_k = 300; # masa korpusu
sim.rkt.m_pay = 50; # masa payloadu
sim.rkt.m_ox = 540; # masa utleniacza
sim.rkt.m_fu = 73; # masa paliwa
sim.rkt.m_prop = sim.rkt.m_ox + sim.rkt.m_fu; # masa materia³ów pêdnych
sim.rkt.m_0 = sim.rkt.m_k + sim.rkt.m_pay + sim.rkt.m_ox + sim.rkt.m_fu; # masa startowa
sim.rkt.m = sim.rkt.m_0; # masa w czasie lotu
sim.rkt.prop_perc = (sim.rkt.m_0 - sim.rkt.m)/sim.rkt.m_prop;

sim.rkt.Ix_full = 25062308/1e6; #[kg * m2]
sim.rkt.Iy_full = 6401780085.50/1e6; #[kg * m2]
sim.rkt.Iz_full = 6401780085.50/1e6; #[kg * m2]

sim.rkt.Ix_empty = 11429900.78/1e6; #[kg * m2]
sim.rkt.Iy_empty = 4166963974.90/1e6; #[kg * m2]
sim.rkt.Iz_empty = 4166963974.90/1e6; #[kg * m2]



#------------------------------------------------------------------------------
#AERODYNAMICS

sim.aero.C_a = dlmread('c_a.csv');
sim.aero.C_n = dlmread('c_n.csv');
sim.aero.C_s = dlmread('c_s.csv');
sim.aero.cop = dlmread('cop.csv');
#C_a = coefficient(M_r, alpha, sim.aero.C_a);  # axial force
#C_n = coefficient(M_r, alpha, sim.aero.C_n);  # normal force
#C_s = coefficient(M_r, beta,  sim.aero.C_s);  # side force
#cop = coefficient(M_r, alpha, sim.aero.cop);  # centre of pressure
 
#------------------------------------------------------------------------------
#ENGINE sim
sim.eng.d_th = 0.090;
sim.eng.A_ratio = 8;
sim.eng.T_c = 2100; # temperatura w komorze spalania [K]
sim.eng.t_0 = 0;
sim.eng.t_t = 35;

sim.eng.Pc = dlmread('Pc.csv');

sim.eng.A_th = sim.eng.d_th^2 * pi/4;
sim.eng.A_ex = sim.eng.A_ratio * sim.eng.A_th;
sim.eng.d_ex = sqrt(4*sim.eng.A_ex/pi);

#w³asciwosci spalin
sim.eng.kappa = 1.2;
sim.eng.M = 0.025;

sim.eng.critical_ratio = (2 / (sim.eng.kappa + 1))^(sim.eng.kappa/(sim.eng.kappa-1));

#------------------------------------------------------------------------------
#parachute

sim.par.altitude = 6.5e3; #wysokoœæ wyzwolenia spadochronu
sim.par.d = 4.5;
sim.par.Cd = 0.65;
sim.par.L = 8;
sim.par.m = 15;
sim.par.max_load = 72e3; 
sim.par.t_open = 0.5;

sim.par.v0 = 5;
sim.par.A = sim.par.d^2 * pi/4;

#------------------------------------------------------------------------------
sim.fin.Cn =  dlmread('c_n_fins.csv');