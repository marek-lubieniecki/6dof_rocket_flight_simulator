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
## @deftypefn {} {@var{retval} =} ecef2geo2 (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-10-31

function R_geo = ecef2geo(R_ecef)
  
#----------------------
if norm(R_ecef) == 0
  
  R_geo = [0 0 0];
  
else
  
  # --- WGS84 constants
  a = 6378137.0;
  f = 1.0 / 298.257223563;
  # --- derived constants
  b = a - f*a;
  e = sqrt(a^2 - b^2)/a;
  clambda = atan(R_ecef(2)/R_ecef(1));
  p = sqrt(R_ecef(1)^2 + R_ecef(2)^2);
  h_old = 0.0;
  # first guess with h=0 meters
  theta = atan(R_ecef(3)/p*(1.0-e^2));
  cs = cos(theta);
  sn = sin(theta);
  N = a^2 / sqrt((a*cs)^2 + (b*sn)^2);
  h = p/cs - N;

  while abs(h-h_old) > 1.0e-6
        h_old = h;
        theta = atan(R_ecef(3)/(p*(1.0-e^2*N/(N+h))));
        cs = cos(theta);
        sn = sin(theta);
        N = a^2/sqrt((a*cs)^2.0+(b*sn)^2);
        h = p/cs - N;
  endwhile
    
  R_geo = [rad2deg(theta) rad2deg(clambda) h];
endif

endfunction





