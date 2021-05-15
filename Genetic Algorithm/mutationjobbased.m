function child = mutationjobbased(Parent,n,m)

Parent=unique(Parent,'stable');      %gives unique values in their original order

index = randperm(n,2);   %finds two random numbers

Parent([index(1) index(2)]) = Parent([index(2) index(1)]);
child=Parent(repelem(1:n,1,m));    %repeat n jobs for m times ex. [4 4 4 3 3 3 2 2 2 1 1 1]
end
