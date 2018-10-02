*Problme 3
*By Magnus Rimer´
*bxc689

SETS
i set of nodes nodes /i1*i8/
k set of keys  /k1*k30/
;
alias(i,j)
*so we can look at (i,i) coordinates.
;
VARIABLES
z         number of connections
w(i,k)    if node i has key k
x(i,j,k)  if nodes i and j both have key k
y(i,j)    if nodes i and j have at least q keys in commen
;
BINARY VARIABLES
w(i,k)
x(i,j,k)
y(i,j)
;

EQUATIONS
connections              the amount of nonnections
memory(i)                make sure the memory cap is respected
maxkey(k)                each key can only be used T=4 times
connected1(i,j,k)        first set of logical equation to see if two nodes have a key in common
connected2(i,j,k)        second set of logical equations to see if two nodes have a key in common
morethanq1(i,j)          first set of logical qeuations to check if node i and j have 3 or more keys in connon
morethanq2(i,j)          first set of logical qeuations to check if node i and j have 3 or more keys in connon
;

connections..            z =e= sum((i,j)$(ord(i) > ord(j)),y(i,j));
memory(i)..              sum(k, 186*w(i,k)) =l= 700;
maxkey(k)..              sum(i, w(i,k)) =l= 4;
connected1(i,j,k)..      w(i,k)+w(j,k) -2*x(i,j,k) =g= 0;
connected2(i,j,k)..      w(i,k)+w(j,k) -1/2*x(i,j,k) =l= 1.5;
morethanq1(i,j)..        sum(k,x(i,j,k))-3*y(i,j) =g= 0;
morethanq2(i,j)..        sum(k,x(i,j,k))-27.5*y(i,j) =l= 2.5;

* Comments to the constraints:
* The first should be pretty cear that is the sum of y(i,j) and y(i,j)=1 if node
* i and j share at least 3 keys. Here we summon over the lower inxed triangle
* so we don't count y(i,j) = y(j,i) twice.
* The memory constraints says that we cannot use more memory in each node that we have
* The max key stop us from giving every node the same keys, and limit out use of each
* key to 3.
* The last 4 constraints all keep tack of the logic:
* the connected contraints make sure that w(i,k)+w(j,k) >= 2 <=> x(i,j,k)=1
* hence x(i,j,k) is an indicator of weather or not node i and j share key k.
* similairly the 'morethanq' makes sure that sum_k x(i,j,k) >= 3 <=> y(i,j)=1
* hence y(i,j) indicate id node i and j have at least 3 keys in common.
* the equatuions are based of the recipe on side 11 in the 'theUseOfVariables'-pdf.


Model KeyProblem /all/;
solve KeyProblem USING MIP maximize z;

* Comments on solution
* By looking at the solution we see that we get some clusting where the first
* cluster when i ran it is node  1,5,7,8 and the other one is 2,3,4,6 where
* the first cluster uses key 1,2,12 and the second cluster use key 8,26,29.
* This gives us a total of 12 connected nodes.

* Comments on the way of modeling
* it should be clear here that there is quite a lot of redundent variables and
* also constraints since x(i,j,k)=x(j,i,k) same is true for y(i,j). So we could
* have defined the variables (and therefore also the constraints) only to live
* on the set (i,j) where i<j. The argument to do so is that the amoiunt of
* variables and constaints will be more than halfed and hence the problem would
* be easier to solve.
* The reason to keep them is to have consistent definitions, if the variables
* where used. If er used the set (i,j) where i<j then what variable would tell
* us if j is connected to i, this would be y(i,j), that would be a bit messy and
* we would lose the 'completeness'. The other reason is that i found it easier
* to model it this way.
