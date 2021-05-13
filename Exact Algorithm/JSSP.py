from itertools import product
from mip import Model, xsum, BINARY, INTEGER, CONTINUOUS, maximize, minimize, OptimizationStatus
import scipy.io as sio
import numpy as np
import gurobipy as gp
from gurobipy import GRB
import time

n = 15
m = 15

J = {j for j in range(n)}
M = {i for i in range(m)}

times = sio.loadmat('Times.mat')['P']
times = times.tolist()

bigM = sum(times[j][i] for j in J for i in M)

machines = sio.loadmat('Machines.mat')['O'] -1
machines = machines.tolist()

md = gp.Model('JSSP')
start = time.time()

def mycallback(md, where):
  if where == GRB.Callback.MIP:
    time = md.cbGet(GRB.Callback.RUNTIME)
    best = md.cbGet(GRB.Callback.MIP_OBJBST)
    if time > 14400  and best < GRB.INFINITY:
      md.terminate()


C = md.addVar(vtype=GRB.CONTINUOUS)
x = [[md.addVar(vtype=GRB.CONTINUOUS) for j in J] for i in M]
y = [[[md.addVar(vtype=GRB.BINARY) for k in J] for j in J] for i in M]


#md.objective = minimize(C)
#md.objective = C
md.setObjective(C, GRB.MINIMIZE)

md.addConstr(C >= 0, "c0")
#md += C >= 0

for (i,j) in product(M,J):
    md.addConstr(y[i][j][j] == 0, "c1") 
    md.addConstr(x[i][j] >= 0, "c2") 
    
for (i,j,k) in product(M,J,J):
    if k!=j:
        #md += y[i][k][j] == 1 - y[i][j][k]
        mach1 = np.where(np.array(machines[j]) == i)[0][0]
        mach2 = np.where(np.array(machines[k]) == i)[0][0]
        md.addConstr(x[i][k] >= x[i][j] + times[j][mach1] - bigM * (1 - y[i][j][k]), "c3") 
        md.addConstr(x[i][j] >= x[i][k] + times[k][mach2] - bigM * y[i][j][k], "c4")  
        #md += x[i][j] >= x[i][k] + times[j][mach2] - bigM * (1 - y[i][k][j])

for j in J:
    for i in range(1,m):
        md.addConstr(x[machines[j][i]][j] >= x[machines[j][i-1]][j] + times[j][i-1], "c2")  

for j in J:
    md.addConstr(C >= x[machines[j][-1]][j] + times[j][-1], "c2")  


md.optimize(mycallback)
#md.optimize()

print("Completion time: ", C.x)
for (j,i) in product(J,M):
    print("task %d starts on machine %d at time %g " % (j+1, i+1, x[i][j].x))
    
gantt = np.zeros((m, int(np.ceil(C.x))))
for (j,i) in product(J,M):
    mach = np.where(np.array(machines[j]) == i)[0][0]
    t = times[j][mach]
    start_time = int(np.round(x[i][j].x))
    if gantt[i,start_time:start_time+t].sum() > 0:
        print('OPA -- i: %d --- j: %d'%(i, j))
    gantt[i,start_time:start_time+t] = j+1

end = time.time() 
print(f"Runtime of the program is {end - start}")
    
    
    