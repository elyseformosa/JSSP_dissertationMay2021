%% The Job-Shop-Scheduling Problem with Particle Swarm Optimization (GLN-PSOc)
clear all
clc
profile on 
n = 5;        % Number of Jobs
m = 5;         % Number of Machines

%% Data Generation

Tmax = 7;       % Maximum Time Duration of an Operation

J=[1:1:n];      % Index set of Jobs
M=[1:1:m];      % Index Set of Machines

O=zeros(n,m);   % Matrix containing the sequence of operations (machines) for every job
P=zeros(n,m);   % Matrix containing the processing time of each operation for each job
for j=J
    rng(j+4)    % This command is used to obtain the same rand matrix every time we run the code
    O(j,:)=randperm(m);
    for i=M
        P(j,i)=randi(Tmax);
    end
end

%% Problem

VarSize=[1 n*m];    %Matrix size of decision variables (n*m dimension)
Vmax=0.25;          %max velocity
k=5;                %adjacent neighbours for local best position

%% Parameters

T=500;              %number of iterations
pop_size=10;        %swarm size

dif=(0.9-0.4)/T;       %inertia is linearly decreased at each iteration from 0.9 to 0.4
 cp=0.1;                %personal acceleration coefficient 
 cg=0.1;                %global acceleration coefficient 
 cl=.8;                %local acceleration coefficient
 cn=.8;                %near neighbour acceleration coefficient
local=repmat(1:pop_size,[1,3]);  %used to obtain local points
Pu=0.7;                 %probability used for algorithm
t=1;                    %for near neighbour
%% Initialisation

%particle structure with zeros
Particle.position=zeros(1,n*m);
Particle.velocity=zeros(1,n*m);
Particle.cost=0;
Particle.best.position=zeros(1,n*m);    %personal
Particle.best.cost=0;                   %personal
Particle.local.best.position=zeros(1,n*m);
Particle.local.best.cost=0;
Particle.NearNeighbour.best.position=zeros(1,n*m);
Particle.NearNeighbour.best.cost=0;

%Population array
particle=repmat(Particle,pop_size, 1);       %repeating particle in pop_size rows and 1 column

%Initialize Global Best
GlobalBest.cost=inf;                %holds worst values (it does not exist
GlobalBest.position=zeros(1,n*m);   %before initializing population)

for i=1:pop_size
    particle(i).position=unifrnd(0,1,VarSize); %creating random solutions using uniform(0,1)
    
    %evaluation
    particle(i).cost=evaluationPSO(particle(i).position,P,O,n,m);
    
    particle(i).best.position=particle(i).position; %initializing personal best position
    
    particle(i).best.cost=particle(i).cost;         %initializing personal best cost
    %update global best
    if particle(i).best.cost < GlobalBest.cost %the cost value of the best value of the i
        GlobalBest.cost=particle(i).best.cost; % th particle
        GlobalBest.position=particle(i).best.position;
    end
    
end

%local 5 neighbours
positions = reshape([particle.position],[pop_size,n*m]);
costs = reshape([particle.cost],[pop_size,1]);

for i=1:pop_size
    
    particle(i).local.best.position = Local(costs,positions,i,pop_size,k);
    particle(i).local.best.cost = evaluationPSO(particle(i).local.best.position,P,O,n,m);
end

%near neighbour best position
bestpositions=zeros(pop_size,n*m);
bestcosts=zeros(pop_size,1);

for i=1:pop_size
    bestpositions(i,:)=particle(i).best.position;
    bestcosts(i)=particle(i).best.cost;
end


for i=1:pop_size
    particle(i).NearNeighbour.best.position = NearNeighbour(costs,positions,bestcosts,bestpositions,i,pop_size,n,m);
    particle(i).NearNeighbour.best.cost = evaluationPSO(particle(i).NearNeighbour.best.position,P,O,n,m);
end

BestCosts=zeros(T,1);  %to hold best cost for each iteration
%% PSO
    
for iter=1:T
    u=unifrnd(0,1);
    w=0.9-(dif*iter);
    p = randperm(pop_size,0.5*pop_size);
    for i=1:pop_size/2
        
        %updating velocity (equation 3.2)
        term1=w*particle(p(i)).velocity;
        term2=cp*u*(particle(p(i)).best.position-particle(p(i)).position);
        term3=cg*u*(GlobalBest.position-particle(p(i)).position);
        term4=cl*u*(particle(p(i)).local.best.position-particle(p(i)).position);
        term5=cn*u*(particle(p(i)).NearNeighbour.best.position-particle(p(i)).position);
        particle(p(i)).velocity=term1+term2+term3+term4+term5;
        
        %equation 3.2
        for j=1:n*m
            if particle(p(i)).velocity(j) < - Vmax
                particle(p(i)).velocity(j) = - Vmax;
            elseif particle(p(i)).velocity(j) > Vmax
                particle(p(i)).velocity(j) = Vmax;
            end
        end
        
        %updating position (equation 3.3)
        particle(p(i)).position=particle(p(i)).position+particle(p(i)).velocity;
        
        %evaluation
        particle(p(i)).cost=evaluationPSO(particle(p(i)).position,P,O,n,m);
        
        %updating personal best
        if particle(p(i)).cost<particle(p(i)).best.cost
            particle(p(i)).best.position=particle(p(i)).position;
            particle(p(i)).best.cost=particle((i)).cost;
            
            %if this particle is better than the best than it is probable
            %that it is also better than the global
            %updating global best
            if particle(p(i)).best.cost < GlobalBest.cost
                GlobalBest.cost=particle(p(i)).best.cost;
                GlobalBest.position=particle(p(i)).best.position;
                
            end
        end
        
        %updating local best
        positions = reshape([particle.position],[pop_size,n*m]);
        costs = reshape([particle.cost],[pop_size,1]);
        
        particle(p(i)).local.best.position = Local(costs,positions,p(i),pop_size,k);
        particle(p(i)).local.best.cost = evaluationPSO(particle(p(i)).local.best.position,P,O,n,m);
        
        %updating near neighbour best
        for j=1:pop_size
            bestpositions(j,:)=particle(j).best.position;
            bestcosts(j)=particle(j).best.cost;
        end
        
        
         particle(p(i)).NearNeighbour.best.position = NearNeighbour(costs,positions,bestcosts,bestpositions,p(i),pop_size,n,m);
         particle(p(i)).NearNeighbour.best.cost= evaluationPSO(particle(p(i)).NearNeighbour.best.position,P,O,n,m);
         
    end
    
    %CROSSOVER
    K=[1:pop_size];
    K(p)=[];                    % Create a vector of indices from 1 to pop_size
    for i=1:(0.5*pop_size)        % and then exclude the indices used before
     
        %updating velocity (equation 3.4)
        particle(K(i)).velocity=particle(K(i)).velocity;
        
        %updating position (equation 3.5)
        if unifrnd(0,1) < Pu
            particle(K(i)).position=particle(K(i)).position;
        else
            particle(K(i)).position=GlobalBest.position;
            particle(K(i)).cost=evaluationPSO(particle(K(i)).position,P,O,n,m);
        end
       
        %updating personal best
        if particle(K(i)).cost<particle(K(i)).best.cost
            
            particle(K(i)).best.position=particle(K(i)).position;
            particle(K(i)).best.cost=particle(K(i)).cost;
            
            %if this particle is better than the best than it is probable
            %that it is also better than the global
            %updating global best
            if particle(K(i)).best.cost < GlobalBest.cost
                
                GlobalBest.cost=particle(K(i)).best.cost;
                GlobalBest.position=particle(K(i)).best.position;
            end
            
        end
        
        %updating local best
        
        positions = reshape([particle.position],[pop_size,n*m]);
        costs = reshape([particle.cost],[pop_size,1]);
        
        particle(K(i)).local.best.position = Local(costs,positions,K(i),pop_size,k);
        particle(K(i)).local.best.cost = evaluationPSO(particle(K(i)).local.best.position,P,O,n,m);
        
        %updating near neighbour best
        for j=1:pop_size
            bestpositions(j,:)=particle(j).best.position;
            bestcosts(j)=particle(j).best.cost;
        end
        
        particle(K(i)).NearNeighbour.best.position = NearNeighbour(costs,positions,bestcosts,bestpositions,K(i),pop_size,n,m);
        particle(K(i)).NearNeighbour.best.cost= evaluationPSO(particle(K(i)).NearNeighbour.best.position,P,O,n,m);
   end
   
    BestCosts(iter)=GlobalBest.cost;
    disp(['Iteration ' num2str(iter) ': Makespan = ' num2str(BestCosts(iter))]);
    plot(BestCosts, 'LineWidth',2);
    xlabel('Iteration Number');
    ylabel('Fitness Value')
    set(gca, 'YTick', min(BestCosts):1:max(BestCosts))
    title('Convergence vs Iteration')
    grid on
end
profile viewer
  


