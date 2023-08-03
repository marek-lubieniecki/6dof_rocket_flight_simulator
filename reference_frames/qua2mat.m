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
## @deftypefn {} {@var{retval} =} qua2mat (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: lubie <lubie@DESKTOP-VSN8JL6>
## Created: 2019-11-13

function C = qua2mat (q)
  
  x = q(1);
  y = q(2);
  z = q(3);
  w = q(4); 
 
  
  C = [ (1 - 2 * y^2 - 2 * z^2) (2*x*y - 2*z*w)          (2*x*z + 2*y*w); ...
        (2*x*y + 2*z*w)         ( 1 - 2 * x^2 - 2 * z^2) (2*y*z - 2*x*w); ...
        (2*x*z - 2*y*w)         (2*y*z + 2*x*w)          (1-2*x^2-2*y^2)];

endfunction
