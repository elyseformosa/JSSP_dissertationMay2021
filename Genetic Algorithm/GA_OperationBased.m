%% The Job-Shop-Scheduling Problem with Genetic Algorithms
clear all
clc
profile on 

n = 5;         % Number of Jobs
m = 5;         % Number of Machines

%% (Synthetic) Data Generation

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

%% Genetic Algorithm Set-Up

%% Generation of the Initial Population

pop_size = 100;             % Number of generated solutions (has to be divided by 4!!!)
gen = 200;                  % Number of generations
o = numel(O);               % Total number of operations for all jobs

%OPERATION-BASED REPRESENTATION
A = repmat(1:n,[1,m]);      % Matrix with job repetitions
Solutions = zeros(pop_size,o);
for i=1:pop_size
    B = randperm(o);
    Solutions(i,:) = A(B);  % Random Initial Population
end

Init_Solutions = Solutions;

for i=1:pop_size
    Init_cost = evaluation(Solutions(i,:),P,O,n,m);
end

Initial_cost=min(Init_cost)
BestCosts=zeros(gen,1);
%% Genetic Algorithm
Solution_Eval = zeros(pop_size,1);

for i=1:gen
       
    % CROSSOVER
    p = randperm(pop_size,pop_size/2);                                              % Select 50% of the population for crossover
    for j=1:pop_size/4
        index=randi(o);
        %ONE POINT CROSSOVER
        offspring = crossover(Solutions(p(2*j-1),:),Solutions(p(2*j),:),index,n,m); % Select pairs of solutions to do the crossover
        
        %ORDER CROSSOVER(uncomment to use this operator and comment the
        %other crossover operators)
        %offspring = OrderCrossover(Solutions(p(2*j-1),:),Solutions(p(2*j),:),n,m);
        
        %TWO POINT CROSSOVER(uncomment to use this operator and comment the
        %other crossover operators)
        %offspring = crossover2point(Solutions(p(2*j-1),:),Solutions(p(2*j),:),n,m);
                
        % The following 3 lines of code are used in order to check out that an offspring is feasible
        for k=1:n
            if length(find(offspring==k))~=m
                flag=1
            end
        end
        
        val_offspring = evaluation(offspring,P,O,n,m);
        
        if Solution_Eval(p(2*j-1))~=0 && Solution_Eval(p(2*j))~=0
            if Solution_Eval(p(2*j-1)) > val_offspring
                Solutions(p(2*j-1),:) = offspring;
                Solution_Eval(p(2*j-1)) = val_offspring;
                continue;
            elseif Solution_Eval(p(2*j)) > val_offspring
                Solutions(p(2*j),:) = offspring;
                Solution_Eval(p(2*j)) = val_offspring;
            end
        else
            if Solution_Eval(p(2*j-1))==0
                Solution_Eval(p(2*j-1))=evaluation(Solutions(p(2*j-1),:),P,O,n,m);
            elseif Solution_Eval(p(2*j))==0
                Solution_Eval(p(2*j-1))=evaluation(Solutions(p(2*j-1),:),P,O,n,m);
            end
            
            if Solution_Eval(p(2*j-1)) > val_offspring
                Solutions(p(2*j-1),:) = offspring;
                Solution_Eval(p(2*j-1)) = val_offspring;
                continue;
            elseif Solution_Eval(p(2*j)) > val_offspring
                Solutions(p(2*j),:) = offspring;
                Solution_Eval(p(2*j)) = val_offspring;
            end
        end
    end
    
    K=[1:pop_size];
    K(p)=[];                    % Create a vector of indices from 1 to pop_size and then exclude the indices used to do the crossover
    for j=1:pop_size/2
        index=randperm(n*m,2);
        %MUTATION FOR OPERATION BASED REPRESENTATION
        offspring_mut = mutation(Solutions(K(j),:),index,n,m);
        
        val_offspring_mut = evaluation(offspring_mut,P,O,n,m);
        
        if Solution_Eval(K(j))~=0
            if Solution_Eval(K(j)) > val_offspring_mut
                Solutions(K(j),:) = offspring_mut;
                Solution_Eval(K(j)) = val_offspring_mut;
                continue;
            end
        else
            Solution_Eval(K(j))=evaluation(Solutions(K(j),:),P,O,n,m);
                   
            if Solution_Eval(K(j)) > val_offspring_mut
                Solutions(K(j),:) = offspring_mut;
                Solution_Eval(K(j)) = val_offspring_mut;               
            end
        end
    
    end
     Cost(i)=min(Solution_Eval);
     disp(['Generation ' num2str(i) ': Makespan = ' num2str(Cost(i))])
end
profile viewer
 MinMakespan=find(Solution_Eval==min(Solution_Eval));
 gantt(Solutions(MinMakespan(1),:),n,m,P,O,J)