function offspring = crossoverjobbased(Parent1,Parent2,n,m)

Parent1=unique(Parent1,'stable');
Parent2=unique(Parent2,'stable');

if mod(n, 2) == 0          % if number of jobs is even
    jobs=randperm(numel(Parent1),n/2);   %choose n/2 random jobs from Parent1
    for i=1:n/2
        positions1(i)=find(Parent1==jobs(i));  %find positions of these jobs in Parent1
        positions2(i)=find(Parent2==jobs(i));  %find positions of these jobs in Parent2
    end
else   %if n is odd
    jobs=randperm(numel(Parent1),(n+1)/2);  %choose (n+1)/2 random jobs from Parent1
    for i=1:(n+1)/2
        positions1(i)=find(Parent1==jobs(i)); %find positions of these jobs in Parent1
        positions2(i)=find(Parent2==jobs(i)); %find positions of these jobs in Parent2
    end
end

for i=1:n
    
    q=find(Parent2(i)==jobs);        %creates a vector with the jobs chosen 
    if Parent2(i)==jobs(q)           %and placed in original position of 
        offspring(i)=Parent2(i);     %Parent2 and replaces jobs not chosen 
    else offspring(i)=0;             %with 0
    end
end

Parent1(positions1)=[];              %removes the random jobs chosen from 
                                     %parent1

offspring(offspring==0)=Parent1;     %replaces 0 with Parent1 values to
                                     %final offspring
offspring=offspring(repelem(1:n,1,m));         %repeats job number for m times

end