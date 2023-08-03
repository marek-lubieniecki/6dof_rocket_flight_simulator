## Copyright (C) 2019 lubie
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
## @deftypefn {} {@var{retval} =} p_atm_alt (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn
## Author: lubie <lubie@DESKTOP-VSN8JL6>
## Created: 2019-05-07

## Input: altitude [m]
## Output: atmospheric pressure [Pa]
## 
##

function p_atm  = p_atm_alt (h)
  
R   = 8.3144598; # universal gas constant 
g_0 = 9.80665;   # 
M   = 0.0289644;
  

 if (h <= 0)
    p_atm = 101325;
    
  elseif (h <= 11e3)
    P_b = 101325;
    T_b = 288.15;
    L_b = -0.0065;
    h_b = 0;
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
  elseif (h <= 20e3)  
    P_b = 22632;
    T_b = 216.65;
    L_b = 0.000001;
    h_b = 11e3;
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
  elseif (h <= 32e3)      
    P_b = 5474.89;
    T_b = 216.65;
    L_b = 0.001;
    h_b = 20e3;
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
  elseif (h <= 47e3)     
    P_b = 868.02;
    T_b = 228.65;
    L_b = 0.0028;
    h_b = 32e3;
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
  elseif (h <= 51e3)     
    P_b = 110.91;
    T_b = 270.65;
    L_b = 0.000001;
    h_b = 47e3;
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
  elseif (h <= 71e3)    
    P_b = 66.94;
    T_b = 270.65;
    L_b = -0.0028;
    h_b = 51e3;  
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
  elseif (h <= 100e3)    
    P_b = 3.96;
    T_b = 214.65;
    L_b = -0.002;
    h_b = 71e3;
    p_atm = P_b * ( (T_b)/(T_b + L_b * (h - h_b) ) )^((g_0*M)/(R * L_b));
   else 
    p_atm = 1e-4;
endif


endfunction
