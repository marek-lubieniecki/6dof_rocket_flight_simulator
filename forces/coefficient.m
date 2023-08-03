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
## @deftypefn {} {@var{retval} =} drag_coefficient (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: m.lubieniecki <m.lubieniecki@LAP-HG>
## Created: 2019-11-12

function coe = coefficient (Mach, alpha, table)
  
  i = 2;
  j = 2;

  while (table(1,i) < alpha )
    
    i = i + 1;
    
  endwhile
  
  while (table(j,1) < Mach )

    j = j + 1;
    
  endwhile
  
  if Mach <= 0.1
    j = 3;
  endif
  
  if alpha <= 1
    i = 3;
  endif
  
#point, Mach, angle, value  
A = [table(j-1, 1), table(1, i-1), table(j-1, i-1)];
B = [table(j-1, 1), table(1, i)  , table(j-1, i)];
C = [table(j, 1)  , table(1, i-1), table(j, i-1)];
D = [table(j, 1)  , table(1, i)  , table(j, i)];

a1 = (B(3) - A(3)) / (B(2) - A(2));
b1 = B(3) - a1 * B(2);

a2 = (D(3) - C(3)) / (D(2) - C(2));
b2 = D(3) - a2 * D(2);

E = [table(j-1, 1), alpha, a1 * alpha + b1];
F = [table(j, 1)  , alpha, a2 * alpha + b2 ];

a3 = (F(3) - E(3)) / (F(1) - E(1));
b3 = F(3) - a3 * F(1); 

G = [Mach, alpha, a3 * Mach + b3];

coe = G(3);

endfunction
