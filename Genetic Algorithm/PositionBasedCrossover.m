function child = PositionBasedCrossover(Parent1,Parent2,n,m)

%CROSSOVER for RANDOM KEYS REPRESENTATION
child=zeros(1,n*m);
if mod(n*m, 2) == 0   % if n*m is even
    %choose (n*m)/2 random jobs from Parent1
    jobs=sort(randperm(numel(Parent1),(n*m)/2));   
    for i=1:(n*m)/2
        child(jobs(i))=Parent1(jobs(i));
        %removes from parent2 integers with same machine no. chosen from parent 1
        removefromparent2=find(floor(Parent2)==floor(Parent1(jobs(i))));
        %eventually parent2 will be ((n*m)-numel(jobs)) dimensional
        Parent2(removefromparent2(1))=[];
    end
    child(child==0)=Parent2;
else   %if n*m is odd
     %choose ((n*m)+1)/2 random jobs from Parent1
    jobs=sort(randperm(numel(Parent1),((n*m)+1)/2)); 
    for i=1:((n*m)+1)/2
        child(jobs(i))=Parent1(jobs(i));
        %removes from parent2 integers with same machine no. chosen from parent 1
        removefromparent2=find(floor(Parent2)==floor(Parent1(jobs(i)))); 
        Parent2(removefromparent2(1))=[];
    end
    child(child==0)=Parent2;
    
end
end