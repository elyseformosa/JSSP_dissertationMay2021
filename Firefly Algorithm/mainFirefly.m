%% The Job-Shop-Scheduling Problem with Firefly Algorithms
profile on

clear all
clc
n=5;
m=5;
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

%% Initialising Parameters

pop_size = 40;  %25
alpha=0.1;  %1
beta0=0.01;
gamma=0.01; %absorption coefficient
T =100; %maximum number of iterations
VarSize=[1 n*m];
Cost=zeros(T,1);
dif=(1-0)/T;
%Initial population
for i=1:pop_size
    Solutions(i,:)=unifrnd(0,1,VarSize);
end
%Initial evaluation
Eval=zeros(pop_size,1);
for i=1:pop_size
    Eval(i) = evaluationFA(Solutions(i,:),P,O,n,m);
end

%% Firefly Main Loop

for k=1:T 
    for i=1:pop_size
        for j=1:pop_size
            %Brighter/more attractive
            if Eval(i) < Eval(j)
                Solutions(i,:) = Solutions(i,:);
            elseif Eval(i) > Eval(j)
                Xi = Solutions(i,:);
                Xj = Solutions(j,:);
                r = sqrt(sum((Xi - Xj).^2));
                beta = beta0*exp(-gamma*r^2);
                Xnew = Xi + beta.*(Xj-Xi) + alpha.*(unifrnd(0,1,VarSize)-0.5);
                
                %greedy selection
                fnew = evaluationFA(Xnew,P,O,n,m);
                if fnew < Eval(i)
                    Eval(i) = fnew;
                    Solutions(i,:) = Xnew;
                end
            end           
        end
    end
    disp(['Iteration ' num2str(k) ': Makespan = ' num2str(min(Eval))])
    Cost(k)=min(Eval);
    plot(Cost, 'LineWidth',2);
    xlabel('Iteration Number');
    ylabel('Fitness Value')
    set(gca, 'YTick', min(Cost):1:max(Cost))
    title('Convergence vs Iteration')
    grid on
end

profile viewer



