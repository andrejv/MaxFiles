# nintegrate

A wrapper for numerical integration in maxima.

    (%i1) load(nintegrate)$
    (%i2) nintegrate(1/(x^3+a*x+a^2), x, 0, a);
    (%o2) nintegrate(1/(x^3+a*x+a^2),x,0,a)
    (%i3) %, a=10;
    (%o3) 0.04422352152270889
