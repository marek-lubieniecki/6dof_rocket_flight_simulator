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
## @deftypefn {} {@var{retval} =} vec_x (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: lubie <lubie@DESKTOP-VSN8JL6>
## Created: 2019-11-01

function vec_out = vec_x (vec_in)

vec_out = [ 0         -vec_in(3)  vec_in(2); ...
            vec_in(3)  0         -vec_in(1); ...
           -vec_in(2)  vec_in(1)  0;];
endfunction
