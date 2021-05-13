function val = evaluationFA(solution,P,O,n,m)

M = sum(sum(P(:,:)));           % Total number of columns in the Gantt Chart
Gantt = zeros(m,M);    % Gantt Chart for each one of the solutions in the population

%code to change from random keys to operation based representation    

A  = repmat([1:n], m, 1);               %For example if position X=[0.2 0.7 0.8 0.4]
A=A(:)';                                %sorting it we get [0.2 0.4 0.7 0.8] 
[d,order]=sort(solution);               %dimensions are now equal to order=(1 4 2 3)
solution(order)=A;                      %we have A=(1 1 2 2)
                                        %order gives the positions for A so we get
                                        %(1 2 2 1) converted to OB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


appearance_matrix = ones(n,1);
min_time = zeros(n,1);
for i=1:n*m
    job = solution(i);
    appearance = appearance_matrix(job);
    time = P(job, appearance);
    machine = O(job, appearance);
    id_all = find(Gantt(machine,:)==0);
    id = id_all(min(find(id_all>min_time(job))));
    temp = id;
    k = id;
    while 1
        if sum(Gantt(machine, k:k+time-1)) == 0
            break
        else
            temp = temp+1;
        end
        k = k+1;
    end
    id = temp;
    Gantt(machine, id:id+time-1) = job;
    appearance_matrix(job) = appearance_matrix(job)+1;
    min_time(job) = id+time-1;
end

zero_col = zeros(m,1);
idx = ismember(Gantt',zero_col','rows');
val=min(find(idx==1));

end