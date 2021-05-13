function val = evaluationKS(solution,P,O,n,m)

M = sum(sum(P(:,:)));           % Total number of columns in the Gantt Chart
Gantt = zeros(m,M);    % Gantt Chart for each one of the solutions in the population

A = repmat(1:n,[1,m]);
[d,order]=sort(solution);
solution(order)=A;


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

