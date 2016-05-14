%%

k = 1:30;
[B,XY] = bucky;
gplot(B(k,k),XY(k,:),'-*')
axis square

%% test gplot

A = zeros(7,7);
A(1,4) = 1;
A(4,1) = 1;
A(2,3) = 1;
A(3,2) = 1;
A(5,4) = 1;
A(4,5) = 1;
A(3,6) = 1;
A(6,3) = 1;
A(6,7) = 1;
A(7,6) = 1;

xy = [0,2;1,2;0,1;1,1;0,0;1,0;2,0];
gplot(A,xy);

path = astar_graph(sparse(A),xy,4, 7);