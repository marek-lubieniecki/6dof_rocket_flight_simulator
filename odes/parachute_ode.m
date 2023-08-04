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

function [dX] = parachute_ode(t, X, sim)
global data
# 1 - X
# 2 - Y
# 3 - Z

# 4 - u
# 5 - v
# 6 - w

# 7 - m_r

#------------------------------------------------------------------------------
#constants
omega_ea = [0 0 2 * pi() / (24*3600)]; #rotational velocity of the Earth

#------------------------------------------------------------------------------
#state vector decomposistion

r_r = [X(1) X(2) X(3)];          #rocket position

m   = X(4);
#------------------------------------------------------------------------------
#calculate position in geo to get altitude

R_geo = ecef2geo(r_r);

#calculate astmospheric properties

p_atm = p_atm_alt(R_geo(3));
t_atm = t_atm_alt(R_geo(3));
rho_atm = rho_p_t(p_atm, t_atm, sim.cst.M_air);
a_speed_atm = speed_sound(t_atm);
#q_dyn = 0.5 * rho_atm * norm(v_r)^2;

#wind speed e-n-u with respect to altitude
wind_enu = wind_speed(R_geo, sim);

if t < sim.par.t_open
  
  Cd = sim.par.Cd * t / sim.par.t_open;
  
else
  
  Cd = sim.par.Cd;
  
endif

V_down = sqrt( 2 * X(4) * 9.81 / ((0.3 * sim.rkt.A + Cd * sim.par.A) * rho_atm));

V = [wind_enu(1) wind_enu(2) -V_down];

V_ecef = enu2ecef(V, R_geo, [0 0 0]);

dX(1) = V_ecef(1); #pochodna x - predkosc po x
dX(2) = V_ecef(2); #pochodna y - predkosc po y
dX(3) = V_ecef(3); #pochodna z - predkosc po z

dX(4) = 0;

R_geo(3)


endfunction
