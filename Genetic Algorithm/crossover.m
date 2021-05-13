function child = crossover(Parent1,Parent2,index,n,m)
child = [Parent1(1:index) Parent2(index+1:end)];

for i=1:n                            % for each job:
    temp = find(child==i);           % temp is the vector which contains the position of each job in child
    len_temp = length(temp);         % len_temp counts how many times a job appears in child
    if len_temp > m                  % we check whether a job appears more than m times (meaning that this is an infeasible child)
       diff = len_temp - m;          % diff is a scalar indicating how many times beyond m a job appers in child
       to_replace = temp(randperm(len_temp, diff)); % pick up "diff" components of temp that are going to be replaced
       child(to_replace) = -1;       % Substitute these elements by -1
    end
end

% For example: for n=m=3, a possible infeasible child is [3 2 2 1 3 2 1 1 1]
% Then, for i=1, temp = [4 7 8 9], len_temp = 4 > 3, diff = 4 - 3 = 1
% and then we select diff=1 random number between 1 and 4. Say 3. 
% Therefore to_replace =  temp(3) = 8
% Thus, the child becomes child = [3 2 2 1 3 2 1 -1 1].

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

% Continuing the previous example: child = [3 2 2 1 3 2 1 -1 1]
% for i=3, temp = [1 5], len_temp = 2 < 3, diff = 3 - 2 = 1
% no_values = 8
% Then, we select diff=1 random number between 1 and 1. Here necessarily only 1.
% to add = no_values(1) = 8
% child(8) = 3
% Thus, child = [3 2 2 1 3 2 1 3 1], which is now a feasible solution

end

