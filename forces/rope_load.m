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
## @deftypefn {} {@var{retval} =} rope_load (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-11-18

function F = rope_load (dx, L, max_load)
  
el = dx/L * 100; #elongation

#max elongation - 25%

if el < 16
  
  a =  0.0112;
  b = -0.0704;
  c =  1.1038;
  d =  0.3378;

else
  
  a =  0.0040;
  b = -0.7457;
  c = 31.5480;
  d = -285.13;
endif

 F = a * el^3 + b * el^2 + c * el^1 + d;

F = F * max_load/100;

endfunction
