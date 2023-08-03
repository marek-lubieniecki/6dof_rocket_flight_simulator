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
## @deftypefn {} {@var{retval} =} wind_speed (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-11-19

function wind = wind_speed (R_geo, sim)
  
  if R_geo(3) > sim.lpad.wind(end,1)
    azimuth = sim.lpad.wind(end,2);
    speed = 0;
  
  elseif R_geo(3) < sim.lpad.wind(2,1)
    i = 2;
    azimuth = sim.lpad.wind(i-1,2) + (R_geo(3) - sim.lpad.wind((i-1),1))/(sim.lpad.wind(i,1) - sim.lpad.wind((i-1),1)) * (sim.lpad.wind(i,2) - sim.lpad.wind((i-1),2));
    speed = sim.lpad.wind(i-1,3) +   (R_geo(3) - sim.lpad.wind((i-1),1))/(sim.lpad.wind(i,1) - sim.lpad.wind((i-1),1)) * (sim.lpad.wind(i,3) - sim.lpad.wind((i-1),3));  
    
  else
    i = 1;
    while R_geo(3) > sim.lpad.wind(i,1) 
     i = i + 1;
     azimuth = sim.lpad.wind(i-1,2) + (R_geo(3) - sim.lpad.wind((i-1),1))/(sim.lpad.wind(i,1) - sim.lpad.wind((i-1),1)) * (sim.lpad.wind(i,2) - sim.lpad.wind((i-1),2));
     speed = sim.lpad.wind(i-1,3) +   (R_geo(3) - sim.lpad.wind((i-1),1))/(sim.lpad.wind(i,1) - sim.lpad.wind((i-1),1)) * (sim.lpad.wind(i,3) - sim.lpad.wind((i-1),3));  
   endwhile
  
  endif 
    
  east = sin(deg2rad(azimuth)) * speed;
  north = cos(deg2rad(azimuth)) * speed; 
  
  wind = [east north 0];
  
endfunction
