# pmint.mac

A maxima implementation of [Poor Man's integrator](http://www-sop.inria.fr/cafe/Manuel.Bronstein/pmint/).

    (%i1) load(pmint);
    (%o1) "/Users/andrej/Projects/MaxFiles/pmint/pmint.mac"
    (%i2) pmint(x*sin(x), x);
    (%o2) (tan(x/2)^2*x-x+2*tan(x/2))/(tan(x/2)^2+1)
