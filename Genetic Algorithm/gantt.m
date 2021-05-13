function gantt(solution,n,m,P,O,J)

M = sum(sum(P(:,:)));           % Total number of columns in the Gantt Chart
Gantt = zeros(m,M);    % Gantt Chart for each one of the solutions in the population

appearance_matrix = ones(n,1);
min_time = zeros(n,1);
for i=1:n*m
    job = solution(i);
    appearance = appearance_matrix(job);
    time = P(job, appearance);   %outputs processing time for corresponding operation
    machine = O(job, appearance); %outputs machine no. for corresponding operation
    %finds the next starting time for an operation for some machine
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
val=min(find(idx==1));             %gives makespan
for ix = 1:m
    r     = Gantt(ix, :);
    Y{ix} = r(1:find(r, 1, 'last'));
    lengthforGantt(ix)=size(Y{1,ix},2);
end
w=max(lengthforGantt);
%Changing every row to same length by adding 0s
for j=1:m
    if size(Y{1,j},2)<w
        add0s=w-size(Y{1,j},2);
        Y{1,j}=[Y{1,j} zeros(1,add0s)];
    end
    %concatenating the rows to form the schedule
    L(j,:)=Y{1,j};
end

z=1;
%CREATING GANTT CHART
z=size(Gantt,1);
G=imagesc(L)
set(gca,'YTick',[1:z]);
ylabel('Machines')
xlabel('Time in Units')
title(['Gantt Chart for ',num2str(n),' Jobs and ',num2str(z),' Machines'])

myColorMap=jet(n+1)
myColorMap(1,:) = 1;
colormap(myColorMap);
hold on

%// colorbar
caxis([0, n+1])
c = colorbar;
c.Ticks = (1:n+1)+0.5;
c.TickLabels = {strcat('Job ',num2str(J'))};

end
