function child = crossover2point(Parent1,Parent2,n,m)
%TWO POINT CROSSOVER
indx=sort(randperm(n*m,2));   %random number in ascending order
child = [Parent1(1:indx(1)) Parent2(indx(1)+1:indx(2)) Parent1(indx(2)+1:end)];

for i=1:n                            % for each job:
    temp = find(child==i);           % temp is the vector which contains the position of each job in child
    len_temp = length(temp);         % len_temp counts how many times a job appears in child
    if len_temp > m                  % we check whether a job appears more than m times (meaning that this is an infeasible child)
       diff = len_temp - m;          % diff is a scalar indicating how many times beyond m a job appers in child
       to_replace = temp(randperm(len_temp, diff)); % pick up "diff" components of temp that are going to be replaced
       child(to_replace) = -1;       % Substitute these elements by -1
    end
end

for i=1:n
    temp = find(child==i);          % temp is the vector which contains the position of each job in child     
    len_temp = length(temp);        % len_temp counts how many times a job appears in child
    if len_temp < m                 % we check whether a job appears less than m times (meaning that this is an infeasible child)
       diff = m - len_temp;         % diff is a scalar indicating how many times less than m a job appers in child
       no_values = find(child == -1); % The indices of child at which -1 appears.
       to_add = no_values(randperm(length(no_values), diff)); % Randomly select diff indices from no_values
       child(to_add) = i;           % Substitute these elements by i
    end
end
end