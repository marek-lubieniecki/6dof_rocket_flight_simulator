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
## @deftypefn {} {@var{retval} =} engine_thrust (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-11-08

function [F_engine, m_dot] = engine_thrust (t, eng, cst, p_atm)
  
#warunki w komorze spalania
#P_c = eng.Pc_1 - t/eng.t_t * (eng.Pc_1 - eng.Pc_2); 


if (t > eng.Pc(end,1)) || (t < eng.Pc(1,1))
  P_c = p_atm;
elseif t == 0
  P_c = p_atm;
else
  i = 1;
  while eng.Pc(i,1) < t
    i = i +1;
  endwhile
  P_c = eng.Pc(i-1,2) + (t - eng.Pc(i-1,1)) / (eng.Pc(i,1) - eng.Pc(i-1,1)) * (eng.Pc(i,2) - eng.Pc(i-1,2));
  P_c = P_c * 1e5;
endif



 if (t < eng.t_t)  #obliczenia silnika

    #calculate critical pressure ratios
    if (p_atm / P_c) > eng.critical_ratio
      F_engine = 300*9.81; 
      m_dot = 1;
    else
    
    #przekroj krytyczny
    
    P_t = P_c * (2/(eng.kappa + 1)) ^ (eng.kappa/(eng.kappa-1));
    T_t = eng.T_c * (2/(eng.kappa + 1));
    rho_t = rho_p_t(P_t, T_t, eng.M);
    v_t = speed_sound(T_t);
    m_dot = v_fun(eng.kappa) * P_c * eng.A_th / sqrt(cst.R/eng.M * eng.T_c);
    
    # ekspansja dla dyszy o danym stosunku przekrojów
    f = @(x) ratios(x, eng.A_ratio, eng.kappa);
    [press_ratio,fval] = fsolve(f,0.001);

    U_ex  = sqrt(2* eng.kappa / (eng.kappa - 1) * cst.R/eng.M * eng.T_c * (1 - press_ratio ^ ((eng.kappa - 1)/eng.kappa)));
    P_ex  = P_c * press_ratio;
    F_engine = m_dot * U_ex + eng.A_ex * (P_ex - p_atm);
    I_sp = F_engine/(m_dot * 9.81);
    
    endif
  else 
    
    F_engine = 0;
    m_dot = 0;
endif

endfunction
