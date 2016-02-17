# powell.lisp

A numerical minimization routines.

    (%i1) load(powell)$
    (%i2) find_minimum(x*(1-x^2), x, 0);
    (%o2) [x=-0.5773502856721247]
    (%i3) find_minimum((3-x-x^2)^2*(4-y)^2, [x,y], [3,3]);
    (%o3) [x=1.302775454752179,y=4.000000065400325]
