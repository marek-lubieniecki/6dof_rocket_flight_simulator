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
## @deftypefn {} {@var{retval} =} geo2ecef (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-10-28

function [R] = geo2ecef(R_geo)

latitude  = R_geo(1);
longitude = R_geo(2);
altitude  = R_geo(3);

a = 6378137; #pó³oœ wielka
b = 6356752; #pó³oœ ma³a

e = sqrt(1-(b/a)^2);
N = a / sqrt(1- e^2 * (sin(deg2rad(latitude)))^2);

R(1) = (N+altitude) * cos(deg2rad(latitude)) * cos(deg2rad(longitude));  #X
R(2) = (N+altitude) * cos(deg2rad(latitude)) * sin(deg2rad(longitude)); #Y
R(3) = ((b/a)^2*N+altitude) * sin(deg2rad(latitude)); #Z

endfunction


