function  particleNearNeighbourBestposition = NearNeighbour(costs,positions,bestcosts,bestpositions,i,pop_size,n,m)

FDR=zeros(pop_size-1,n*m);
pni=zeros(1,n*m);
bestpositions(i,:)=[];
bestcosts(i,:)=[];

for j=1:pop_size-1
   
    FDR(j,:)=(costs(i,:)-bestcosts(j,:))./abs(bestpositions(j,:)-positions(i,:));
    
end
FDR(isnan(FDR))=0;
maxFDR=max(FDR);
       %since some values are 0/0 I replace NaN by 0

for d=1:n*m    
    positionNN=find(FDR(:,d)==maxFDR(d));  
    pni(d)=bestpositions(positionNN(1),d);
end

particleNearNeighbourBestposition=pni;
%max FDR takes maximum of each column of the FDR matrix
%essentially it creates a new position by finding the position 
%of the maximum of each column
end