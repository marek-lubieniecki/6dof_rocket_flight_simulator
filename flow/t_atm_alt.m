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
## @deftypefn {} {@var{retval} =} t_atm_alt (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-05-21

function t_atm = t_atm_alt (h)
  
  

 if (h <= 0)
    t0 = 288.15;
    dt = 0;
    h0 = 0;
    
  elseif (h <= 11e3)
    t0 = 288.15;
    dt = -0.0065;
    h0 = 0;
    
  elseif (h <= 20e3)
    t0 = 216.65;
    dt = 0;    
    h0 = 11e3;
    
  elseif (h <= 32e3)
    t0 = 216.65;
    dt = 0.001;    
    h0 = 20e3;
       
  elseif (h <= 47e3)
    t0 = 228.65;
    dt = 0.0028;  
    h0 = 32e3;
      
  elseif (h <= 51e3)
    t0 = 270.65;
    dt = 0; 
    h0 = 47e3;  
    
  elseif (h <= 85e3)
    t0 = 270.65;
    dt = -0.00246; 
    h0 = 51e3;    
    
  else 
    t0 = 186.95;
    dt = 0;
    h0 = 85e3;    
 endif



    t_atm = t0 + dt*(h-h0);


endfunction
