function child = RKmutation(Parent,index,n,m)

Parent([index(1) index(2)]) = Parent([index(2) index(1)]);
child=Parent;

end

