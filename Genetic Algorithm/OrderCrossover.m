function child = OrderCrossover(Parent1,Parent2,n,m)

indx=sort(randperm(n*m,2));
%substring can not start from first position or end at last position of
%chromosome 
while indx(1)==1 || indx(2)==n*m   
indx=sort(randperm(n*m,2));
end

child=zeros(1,n*m);
% copies substring of parent 1 into child
child(indx(1):indx(2))=Parent1(indx(1):indx(2));  
substring=indx(1):1:indx(2);   %gives positions of substring in child

for i=1:nnz(child) %counting nonzero elements of child (length of substring)   
    Removefromparent2 = find(Parent2 == child(substring(i)));
    %removing symbols from parent 2 that are already seen in child
    %so that we do not have illegal offspring
    Parent2(Removefromparent2(1))= [];   
end

child(child==0)=Parent2;

end