*
*Problme 3
*By Magnus Rimer´
*bxc689

SETS
v set of ships /v1*v5/
r routes       /asia,china/
p ports        /p1*p8/

Table T(v,r) time it takes for ship v to travel route r (in days)
         asia    china
v1       14.4    21.2
v2       13.0    20.7
v3       14.4    20.6
v4       13.3    19.2
v5       12.0    20.1
;

TABLE C(v,r) for for ship v to sail route r  (in mllions)
         asia    china
v1       1.41    1.9
v2       3.0     1.5
v3       0.4     0.8
v4       0.5     0.7
v5       0.7     0.8
;

TABLE A(p,r) if port p on route r (0 - 1)
         asia    china
p1       1       0
p2       1       0
p3       1       1
p4       0       1
p5       0       1
p6       1       1
p7       1       0
p8       0       1
;

PARAMETERS
F(v) cost of useing ship v  (in millions)
         /v1     65
         v2      60
         v3      92
         v4      100
         v5      110/

G(v) Amout if days a year the ship can sail  (in days)
         /v1     300
         v2      250
         v3      350
         v4      330
         v5      300/
D(p) the amout if times a port need to be visited of it's getting used
         /p1     15
         p2      18
         p3      32
         p4      32
         p5      45
         p6      32
         p7      15
         p8      18/
;

VARIABLES
z        Total cost in millions
W(v)     If ship v is bought or no (0 - 1)
y(p)     if we use port p (0 - 1)
x(v,r)   The amount of times ship v sails route r.
;

BINARY VARIABLES
         w(v)
         y(p)
;

INTEGER VARIABLES
         x(v,r)
;

EQUATIONS
cost             our cost equation
days(v)          makes sure we only use ships we have bought and that we don't overuse the once we have.
portsused        makes sure we service enough ports
portsenough(p)   makes sure we visit each serviced port the required times
incomp1          takes care of the first incompatible constraint  ( singapore and osaka)
incomp2          takes care of the second  incompatible constraint  ( incheon and victoria)
;
cost..           z =e= sum(v , W(v)*F(v) ) + sum((v,r), x(v,r)*C(v,r));
days(v)..        sum(r,x(v,r)*T(v,r)) - w(v)*G(v) =l= 0;
portsused..      sum(p,y(p)) =g= 5;
portsenough(p).. sum((v,r), x(v,r)*A(p,r)) =g= D(p)*y(p);
incomp1..        y("p1")+y("p7") =l= 1;
incomp2..        y("p2")+y("p8") =l= 1;

* comments on the constaints
* the Objectie funtions is the cost of ships + cost for ship v to take route r times the amount of times it's done
* The days(v) constraint says that for all ships the total about sailed must be weakly less than the total days it can sail
* The third constraing says that we need to pick at least 5 ports that we service
* portsenough(p) make sure that for each port if it's chosen as being served that it is visited at least D(p) times
* The last 2 constraints make sure we don't service borh Singapore and Osaka and the same for Incheon and Victoria

Model FleetPlanning /all/;
solve FleetPlanning USING MIP MINIMIZING z;

*When we sove the model we get a total cost of 297.450 millions.
*If one check the sulution, it's easy to check that 5 ports are serviced
*The asia route is sailed a total of 15 times and chine is sailed 32 times. The Incompability comstaint is also hold.