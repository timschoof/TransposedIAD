function l = MyLogistic(x, mu, slope, chance)

if nargin()<4
    chance=0;
end
y = exp(slope*x+mu);
l = chance + (1-chance)* (y./(1+y));

