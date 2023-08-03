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
## @deftypefn {} {@var{retval} =} gen_rot (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-11-04

function Vec_out = gen_rot (Vec_in, Vec_rot, angle_rot)

angle_rot = deg2rad(angle_rot);

a = Vec_in * cos(angle_rot);
b = dot(Vec_rot, Vec_in);
c = b  * Vec_rot *  (1 - cos(angle_rot));
d = cross(Vec_rot, Vec_in) * sin(angle_rot);
Vec_out = a + b + c + d;

endfunction
