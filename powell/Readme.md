# powell.lisp

A numerical minimization routines.

    (%i1) load(powell)$
    (%i2) expr: x^4-4*x^2-x+1;
    (%o2) x^4-4*x^2-x+1
    (%i3) find_minimum(expr, x, 0);
    (%o3) [x=1.472996835046074]
    (%i4) find_minimum_brent(expr, x, -2, 0);
    (%o4) [x=-1.346997558773415]
    (%i5) find_minimum_brent(expr, x, 0, 2);
    (%o5) [x=1.472996578503818]
    (%i6) expr: (x^2+y^4-x*y);
    (%o6) y^4-x*y+x^2
    (%i7) find_minimum(expr, [x,y], [1,1]);
    (%o7) [x=0.1767766601260948,y=0.3535533377325652]

