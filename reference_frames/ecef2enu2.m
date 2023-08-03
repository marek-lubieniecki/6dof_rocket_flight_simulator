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
## @deftypefn {} {@var{retval} =} ecef2enu2 (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-10-31



function V_enu = ecef2enu2 (V_ecef, R_ref)

R_geo = ecef2geo(V_ecef);  
phi = deg2rad(R_geo(1)); #latitude
lambda = deg2rad(R_geo(2)); #longitutde
  
M = [-sin(lambda) cos(lambda) 0;  ...
     -sin(phi) * cos(lambda) -sin(phi) * sin(lambda) cos(phi);  ...
      cos(phi) * cos(lambda)  cos(phi) * sin(lambda) sin(phi)];

V_enu = M * [V_ecef(1)-R_ref(1); V_ecef(2)-R_ref(2); V_ecef(3)-R_ref(3)];

endfunction


