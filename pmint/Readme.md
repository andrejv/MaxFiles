# pmint.mac

A Maxima/wxMaxima implementation of [Poor Man's integrator](http://www-sop.inria.fr/cafe/Manuel.Bronstein/pmint/).

    (%i1) load(pmint)$
    (%i2) pmint(x*sin(x), x);
    (%o2) (tan(x/2)^2*x-x+2*tan(x/2))/(tan(x/2)^2+1)
    (%i3) pmint(1/(x+sqrt(x^2+1)), x);
    (%o3) log(sqrt(x^2+1)+x)/2+x/(2*(sqrt(x^2+1)+x))


/**************************************
 *
 *  Examples from the Maple program page:
 *
 *   (+)  (x^7-24*x^4-4*x^2+8*x-8)/(x^8+6*x^6+12*x^4+8*x^2);    <-  set gcd to spmod!
 *   (++) (x-tan(x))/tan(x)^2 + tan(x);
 *   (++) (1+x+x*exp(x))*(x+log(x)+exp(x)-1)/(x+log(x)+exp(x))^2/x;
 *   (++) exp(-x^2)*erf(x)/(erf(x)^3-erf(x)^2-erf(x)+1);
 *   (++) (x-airy_ai(x)*airy_dai(x))/(x^2-airy_ai(x)^2);
 *   (++) x^2*airy_ai(x);
 *   (++) Bessel functions : bessel_j(n+1,x)/bessel_j(n,x)
 *   (++) Bessel functions :  (n*bessel_j(n,x))/x-bessel_j(n+1,x)
 *   (--) whittaker_w - not defined in maxima [see (**)]
 *   (++) lambert_w(x);  
 *   (+)  sin(lambert_w(x));   <- takes a long time
 *   (+)  ((x^2+2)*lambert_w(x^2)^2 + x^2*(2*lambert_w(x^2)+1))/x/(1 + lambert_w(x^2))^3;
 *   (--) (2*lambert_w(x^2)*(lambert_w(x^2)+a*x)*cos(lambert_w(x^2))+a*x*(lambert_w(x^2)+1)+2*lambert_w(x^2))/
 *           (x*(lambert_w(x^2)+1)*(lambert_w(x^2)+a*x));
 *
 *
 *   (++)  omega(x) [see (*)]
 *   (++)  (1 + omega(x) * (2 + cos(omega(x)) * (x + omega(x)))) / (1 + omega(x)) / (x + omega(x));
 *
 *
 *   (++) correct and agrees with maple answer
 *   (+)  correct but differs from maple answer
 *   (--) failes (or takes too long)
 *   (-)  wrong
 *
 *  (*) the Omega function is not supported in Maxima but can be defined as
 *  omega(x) := lambert_w(exp(x)) 
 *
 *  (**)  Whittaker function
 *
 *     whittaker_w(x,m,n) = WhittakerW(m,n,x)
 *     whittaker_w1(x,m,n) = WhittakerW(m+1,n,x)
 *     gradef(whittaker_w(x,m,n), (1/2-m/x)*whittaker_w(x,m,n)-whittaker_w1(x,m,n))
 *     gradef(whittaker_w1(x,m,n), ((m+1)/x-1/2)*whittaker_w1(x,m,n) - (n^2-(m+1/2)^2)*whittaker_w(x,m,n)/x)
 *
 *   (++) whittaker_w1(x,m,n)/whittaker_w(x,m,n)
 *
 *
 **************************************/
