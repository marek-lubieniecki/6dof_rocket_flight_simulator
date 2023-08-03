clc
clear all
C0 = [0.50662	0.10723	0.85547; 0.86104	-0.012133	-0.5084; -0.044136	0.99416	-0.098475];
Q0 = mat2qua(C0);
[a, C1] = quatrotate([1; 0; 0], Q0)
Q1 = mat2qua(C1)
[b, C2] = quatrotate([1; 0; 0], Q1)
Q2 = mat2qua(C2)