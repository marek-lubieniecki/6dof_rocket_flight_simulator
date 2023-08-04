## Copyright (C) 2019 m.lubieniecki
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} test_oder (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-10-30

function [dX] = test_ode(t, X, sim)
global data
# 1 - X
# 2 - Y
# 3 - Z

# 4 - u
# 5 - v
# 6 - w

# 7 - q1
# 8 - q2
# 9 - q3
# 10 - q4

# 11 - omega_pitch
# 12 - omega_yaw
# 13 - omega_roll

# 14 - m
# 15 - I1
# 16 - I2
# 17 - I3

cog = 6.1;

#------------------------------------------------------------------------------
#constants
omega_ea = [0 0 2 * pi() / (24*3600)]; #rotational velocity of the Earth

#------------------------------------------------------------------------------
#state vector decomposistion

r = [X(1) X(2) X(3)];          #rocket position
v = [X(4) X(5) X(6)];          #rocket velocity
q = [X(7) X(8) X(9) X(10)]/norm([X(7) X(8) X(9) X(10)]);
epsilon = q(1:3);  #vector part of the quaternion
eta = q(4);                   #scalar part of the quaternion
omega = [X(11); X(12); X(13)]; #angular velocity of the rocket
m = X(14);                     #mass
I = [X(15); X(16); X(17)];     #moments of inertia

#------------------------------------------------------------------------------
#calculate position in geo to get altitude

R_geo = ecef2geo(r);

#calculate astmospheric properties

p_atm = p_atm_alt(R_geo(3));
t_atm = t_atm_alt(R_geo(3));
rho_atm = rho_p_t(p_atm, t_atm, sim.cst.M_air);
a_speed_atm = speed_sound(t_atm);


#wind speed e-n-u with respect to altitude

wind_enu = wind_speed(R_geo, sim);


wind_ecef = enu2ecef(wind_enu, R_geo, [0 0 0]);

v = v - wind_ecef';

q_dyn = 0.5 * rho_atm * norm(v)^2;
#------------------------------------------------------------------------------
#calculate rocket motion properties
C = qua2mat(q);
velocity = C' * v';

M_r = norm(v)/a_speed_atm;

if (norm(velocity) == 0) || (R_geo(3) < sim.lpad.height )
  alpha = 0;
  beta = 0;  
else

  c_alpha = dot([1 0], [velocity(1) velocity(3)]) / (norm([1 0]) * norm([velocity(1) velocity(3)]));
  alpha = rad2deg(acos(c_alpha));

  if velocity(3) > 0
    alpha = - alpha;
  endif

  c_beta = dot([1 0], [velocity(1) velocity(2)]) / (norm([1 0]) * norm([velocity(1) velocity(2)]));
  beta = rad2deg(acos(c_beta));

  if velocity(2) > 0
    beta = - beta;
  endif
endif


#------------------------------------------------------------------------------
#calculate aerodynamic coefficients and properties

C_a = coefficient(M_r, abs(alpha), sim.aero.C_a);  # axial force
C_n = coefficient(M_r, abs(alpha), sim.aero.C_n);  # normal force
C_s = coefficient(M_r, abs(beta),  sim.aero.C_s);  # side force
cop = coefficient(M_r, abs(alpha), sim.aero.cop);  # centre of pressure

#------------------------------------------------------------------------------
#calculate forces acting on the rocket 

#GRAVITY
F_g = 9.81 * X(14) * -r/norm(r);

#THRUST

[F_engine, m_dot] = engine_thrust(t, sim.eng, sim.cst, p_atm);

F_T = [1 0 0] * F_engine;


#AXIAL FORCE

F_A =        [-1 0 0] * C_a    * q_dyn * sim.rkt.A;
F_A_slizg =  [-1 0 0] * 0.006  * q_dyn * sim.rkt.A;

F_A = F_A + F_A_slizg;

#NORMAL FORCE

F_N = sign(alpha) * [0 0 1] * (C_n) * q_dyn * sim.rkt.A;

#SIDEFORCE

F_S = sign(beta) * [0 1 0] * (C_s) * q_dyn * sim.rkt.A;

#OTHER

#TOGHETER

#FORCE IN BODY AXIS
F_b = F_T + F_A + F_N + F_S;

#FORCE IN REFERENCE FRAME
F_eci = F_g;

#TOTAL FORCE

[F_b_eci,] = quatrotate (F_b', q);

F = F_eci + F_b_eci';
#------------------------------------------------------------------------------
#rocket translation dynamics
a = F/X(14) - 2 * cross(omega_ea,v) - cross(omega_ea, cross(omega_ea,r));

#------------------------------------------------------------------------------
#calculate torques acting on the rocket

#Rolling moment - X axis

L = 0;

#Pitching moment - Y axis
 
M = sign(alpha) * norm(F_N) * (cop - cog) - 0 * omega(2) + .03 * q_dyn * sim.rkt.A * sim.rkt.d;

#Yawing moment - Y axis

N = -sign(beta) * norm(F_S) * (cop - cog) - 0 * omega(3);

T = [L M N];

#------------------------------------------------------------------------------
#rocket rotation kinematics

dEpsilon(1) = 0.5 * (         eta * omega(1) - epsilon(3) * omega(2) + epsilon(2) * omega(3));
dEpsilon(2) = 0.5 * (  epsilon(3) * omega(1)        + eta * omega(2) - epsilon(1) * omega(3));
dEpsilon(3) = 0.5 * (- epsilon(2) * omega(1) + epsilon(1) * omega(2)        + eta * omega(3));
dEta = - 0.5 * (epsilon(1) * omega(1) + epsilon(2) * omega(2) + epsilon(3) * omega(3));

#dEpsilon1 = 0.5 * (eta * eye(3) + vec_x(epsilon)) * omega;
#dEta1 = -0.5 * epsilon * omega;
#------------------------------------------------------------------------------
#rocket rotation dynamics

d_omegax = (T(1) - (I(3) - I(2))*omega(2)*omega(3))/I(1);
d_omegay = (T(2) - (I(1) - I(3))*omega(1)*omega(3))/I(2);
d_omegaz = (T(3) - (I(2) - I(1))*omega(3)*omega(2))/I(3);

#-------------------------------------------------------------------------------
#change of moments of inertia
#calculate current rate of propellant consumption
if m_dot == 0
  dIx = 0;
  dIy = 0;
  dIz = 0;
else 
  t_consumption = sim.rkt.m_prop / m_dot;
  dIx = -(sim.rkt.Ix_full - sim.rkt.Ix_empty)/t_consumption;
  dIy = -(sim.rkt.Iy_full - sim.rkt.Iy_empty)/t_consumption;
  dIz = -(sim.rkt.Iz_full - sim.rkt.Iz_empty)/t_consumption;
endif

#-------------------------------------------------------------------------------

dX(1) = X(4); #pochodna x - predkosc po x
dX(2) = X(5); #pochodna y - predkosc po y
dX(3) = X(6); #pochodna z - predkosc po z

dX(4) = a(1); #pochodna u 
dX(5) = a(2); #pochodna v 
dX(6) = a(3); #pochodna w 


dX(7) = dEpsilon(1);
dX(8) = dEpsilon(2);
dX(9) = dEpsilon(3);
dX(10) = dEta;

dX(11) = d_omegax;
dX(12) = d_omegay;
dX(13) = d_omegaz;

dX(14) = -m_dot; # -m_dot
dX(15) = dIx;
dX(16) = dIy;
dX(17) = dIz;


R_geo(3)

endfunction
