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
## @deftypefn {} {@var{retval} =} post_processing (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-12-10

function flight = post_processing (t,Y,tp,Yp,te,Ye,sim)
  
#------------------------------------------------------------------------------
#calculate interesting
for i=1:length(t)
  
  #
  R_rkt_enu(i,:) = ecef2enu2([Y(i,1) Y(i,2) Y(i,3)], sim.lpad.R_lp_ecef);    #trajectory in ENU
  V_rkt_enu(i,1:3) = ecef2enu2([Y(i,4) Y(i,5) Y(i,6)], [0 0 0]);               #velocity vector in ENU
  V_rkt_enu(i,4) = sqrt(V_rkt_enu(i,1)^2+V_rkt_enu(i,2)^2+V_rkt_enu(i,3)^2); #velocity magnitude 

  
  #rocket axis in ECEF
  [X_ecef(i,:), C] = quatrotate ([1 0 0]', [Y(i, 7:10)]); 
  [Y_ecef(i,:), C] = quatrotate ([0 1 0]', [Y(i, 7:10)]);
  [Z_ecef(i,:), C] = quatrotate ([0 0 1]', [Y(i, 7:10)]);
  
  #rocket axis in ENU
  X_enu(i,:) = ecef2enu3(X_ecef(i,:), sim.lpad.R_lp_geo, [0 0 0]);
  Y_enu(i,:) = ecef2enu3(Y_ecef(i,:), sim.lpad.R_lp_geo, [0 0 0]);
  Z_enu(i,:) = ecef2enu3(Z_ecef(i,:), sim.lpad.R_lp_geo, [0 0 0]);
  

 
 
  #calculate angle of attack and sideslip angle
  q = Y(i, 7:10);
  v = Y(i, 4:6);
  C = qua2mat(q);
  velocity = C' * v';
   
  if (norm(velocity) == 0) || (R_rkt_enu(i,3) < sim.lpad.height )
    alpha(i) = 0;
    beta(i) = 0;  
  else
    c_alpha = dot([1 0], [velocity(1) velocity(3)]) / (norm([1 0]) * norm([velocity(1) velocity(3)]));
    alpha(i) = rad2deg(acos(c_alpha));

    if velocity(3) > 0
      alpha(i) = -   alpha(i);
    endif
    
    c_beta = dot([1 0], [velocity(1) velocity(2)]) / (norm([1 0]) * norm([velocity(1) velocity(2)]));
    beta(i) = rad2deg(acos(c_beta));

    if velocity(2) > 0
      beta(i) = - beta(i);
    endif
  endif
 
   #Dynamic pressure, Mach number
  p_atm = p_atm_alt(R_rkt_enu(i,3));
  t_atm = t_atm_alt(R_rkt_enu(i,3));
  rho_atm = rho_p_t(p_atm, t_atm, sim.cst.M_air);
  a_speed_atm = speed_sound(t_atm);
  M_r(i) = V_rkt_enu(i,4) / a_speed_atm;
  
  #engine thrust
  [F_t(i), m_dot(i)] = engine_thrust (t(i), sim.eng, sim.cst, p_atm);
 
  #Fin load
  
  #Axial
  
  #Normal
  Cn = coefficient(M_r(i), abs(alpha(i)), sim.fin.Cn);
  flight.Fn_fin(i) = sign(alpha(i)) * Cn * sim.rkt.A * 0.5 * rho_atm * V_rkt_enu(i,4)^2;
  
  #Total force 
 
 
endfor

for i=1:length(tp)
Rp_rkt_enu(i,:) = ecef2enu2([Yp(i,1) Yp(i,2) Yp(i,3)], sim.lpad.R_lp_ecef);
endfor


#ROCKET
flight.R_rkt_enu = R_rkt_enu;
flight.V_rkt_enu = V_rkt_enu;
flight.X_enu = X_enu;
flight.Y_enu = Y_enu;
flight.Z_enu = Z_enu;


flight.F_t = F_t;
flight.m_dot = m_dot;

flight.alpha = alpha;
flight.beta = beta;
flight.M_r = M_r;

#PARACHUTE
flight.Rp_rkt_enu = Rp_rkt_enu;


#SUMMARY

#maksymalna prêdkoœæ 
flight.sum.V_max = max(V_rkt_enu(:,4));

#maksymalna wysokoœæ
flight.sum.Alt_max = max(R_rkt_enu(:,3));

#miejsce l¹dowania bez spadochronu
flight.sum.Landing_no_par = R_rkt_enu(end,1:2);

#miejsce l¹dowania ze spadochronem
flight.sum.Landing_with_par = Rp_rkt_enu(end,1:2);

#czas spadania - bez spadochronu
flight.sum.T_total_no_par = t(end);

#czas spadania - ze spadochronem
flight.sum.T_total_with_par = te(2) + tp(end);



endfunction
