function  particlelocalbestposition =Local(costs,positions,i,pop_size,k)

local=repmat(1:pop_size,[1,3]);  %used to obtain local points
localpoints=find(local==i);

kpoints=localpoints(2);

localposition=[local(kpoints-2:kpoints+2)];
%particle(localposition).position
v=zeros(1,k);
for y=1:k
    v(y)=costs(local(localposition(y)));
end
%particlelocalbestcost=min(v);
pts=find(v==min(v));
particlelocalbestposition=positions(localposition(pts(1)),:);

end