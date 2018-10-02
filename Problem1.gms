*
*Problme 1
*By Magnus Rimer´
*bxc689
SETS
f indec for formations /f1*f6/
i index of players /1*25/
j inxex of positions /1*10/

quality(i) set of quality players /13,20,21,22/
strength(i) set of strength players /10,12,23/
;

TABLE c(i,j) gain from having player i on pisition j
         1       2       3       4       5       6       7       8       9       10
1        10      0       0       0       0       0       0       0       0       0
2        9       0       0       0       0       0       0       0       0       0
3        8.5     0       0       0       0       0       0       0       0       0
4        0       8       6       5       4       2       2       0       0       0
5        0       9       7       3       2       0       2       0       0       0
6        0       8       7       7       3       2       2       0       0       0
7        0       6       8       8       0       6       6       0       0       0
8        0       4       5       9       0       6       6       0       0       0
9        0       5       9       4       0       7       2       0       0       0
10       0       4       2       2       9       2       2       0       0       0
11       0       3       1       1       8       1       1       4       0       0
12       0       3       0       2       10      1       1       0       0       0
13       0       0       0       0       7       0       0       10      6       0
14       0       0       0       0       4       8       6       5       0       0
15       0       0       0       0       4       6       9       6       0       0
16       0       0       0       0       0       7       3       0       0       0
17       0       0       0       0       3       0       9       0       0       0
18       0       0       0       0       0       0       0       6       9       6
19       0       0       0       0       0       0       0       5       8       7
20       0       0       0       0       0       0       0       4       4       10
21       0       0       0       0       0       0       0       3       9       9
22       0       0       0       0       0       0       0       0       8       8
23       0       3       1       1       8       4       3       5       0       0
24       0       3       2       4       7       6       5       6       4       0
25       0       4       2       2       6       7       5       2       2       0

table d(f,j) table of how many in each position for each formation
         1       2       3       4       5       6       7       8       9       10
f1       1       2       1       1       2       1       1       0       2       0
f2       1       3       0       0       3       1       1       0       1       1
f3       1       2       1       1       3       0       0       1       2       0
f4       1       2       1       1       3       0       0       0       1       0
f5       1       3       0       0       2       1       1       0       1       2
f6       1       2       1       1       3       0       0       2       1       0
;

Variables
         z               The total effectiveness of the formation
         w(i,j)          if player I is in position J    (0 - 1)
         x(f)            if formation f is used          (0 - 1)
;

Binary variables
         w(i,j)
         x(f)
;

Equations
obj              Our objective funtion that tracks for good our formation is
maxform          we must pick excatly one formation
formlimit(j)     given a formationa and position the amount of player in the position is limited
mostone(i)       each player can be at most one position
balance          make sure there is a balance between quality and strength players
;

obj..            z =e= sum((i,j), c(i,j)*w(i,j) );
maxform..        sum(f, x(f))    =e= 1;
formlimit(j)..   sum(i, w(i,j) )- sum(f, d(f,j)*x(f) ) =e= 0;
mostone(i)..     sum(j, w(i,j) ) =l= 1;
balance..        sum(quality(i) ,sum(j, w(i,j))) - sum(strength(i) ,sum(j, w(i,j)))=l= 3;

* Comments on the constraints
* obj adds up the gain we get from having pler i in position j
* maxform says that the numbre of picked formations must be 1, hence we can not pick 2 formations
* Formlimit makes sure we don't pick more players for a given formation that there are space for
* mostone says each player can at most be assigned to one position, this way we don't end up using player i more than once
* balance constraint does so that, if all quality players a chosen at least one of the strength players have to be chosen or the sum will be greater then 3.

Model Formation /all/;
solve Formation USING MIP maximize z;

* In the solution we get a objective of 97 where formation 6 is used.
* If one compare the player/position combinations with Table 2 it does look like a reasonable solution.