function child = mutation(Parent,index,n,m)


while Parent(index(1))==Parent(index(2))
    % making sure that identical jobs are not picked up
    index = randperm(n*m,2);
end

Parent([index(1) index(2)]) = Parent([index(2) index(1)]);
child=Parent;
end