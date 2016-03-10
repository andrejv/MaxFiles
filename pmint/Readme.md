# pmint.mac

A maxima implementation of [Poor Man's integrator](http://www-sop.inria.fr/cafe/Manuel.Bronstein/pmint/).

    (%i1) load(pmint)$
    (%i2) pmint(x*sin(x), x);
    (%o2) (tan(x/2)^2*x-x+2*tan(x/2))/(tan(x/2)^2+1)
    (%i3) pmint(1/(x+sqrt(x^2+1)), x);
    (%o3) log(sqrt(x^2+1)+x)/2+x/(2*(sqrt(x^2+1)+x))
