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
## @deftypefn {} {@var{retval} =} ecef2eci (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-10-28

function [R_eci] = ecef2eci(R_ecef, t)

omega_ea = 2*pi/(24*3600); #mean Earth radius [m]
X = R_ecef(1);
Y = R_ecef(2);
Z = R_ecef(3);

R_eci(1) = X * cos(omega_ea * t) - Y * sin(omega_ea * t);
R_eci(2) = X * sin(omega_ea * t) + Y * cos(omega_ea * t);
R_eci(3) = Z;


endfunction
