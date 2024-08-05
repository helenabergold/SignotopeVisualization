#!/usr/bin/env python
# coding: utf-8

from sys import path
from itertools import *
#from ast import *
from copy import copy
from sage.misc.table import *
path.append('../')
from basics_poset import *
from basics import *
from basics_sweep import *

#input and basic definitions


if 1:
    r = args[1]
    assert ( r == 4 )
    n = args[2]
    line = args[3]
#else: 
#   r = int(argv[1]) 
#   assert ( r == 4 )
#    n = int(argv[2])
#    from sys import *
#    f = open(argv[3])
#    line = f.readline()
#    if not line: exit('no input')
#    print()
#    print( "input",line,)


N = range(n)










#############################################################
#### actual program
#############################################################
b = []
path3d = []
for j in N:
    path3d.append([])
    

#line = f.readline()
if not line: exit('no input')
print()
print("input",line,)


X = {}
X_str = line.split()[1] if ' ' in line else line
if X_str[-1] == '\n': X_str = X_str[:-1]

#if X_str[0] == '+': continue

i = 0
for I in combinations(N,r):
    s = +1 if X_str[i] == "+" else -1
    i += 1
    X[I] = s
        

Poset = compute_poset(X,N,r)
#H = Poset(relations).hasse_diagram()
#H.plot().save("hasse"+str(n)+str(r)+str(i)+".png")

X_proj ={}
for I in combinations(N,r-1):
    X_proj[I] = -1
perms = compute_wiring_fixedlength_as_table(X_proj, N,r-1)


i =0

elements = list(combinations(N,r-1))
while True:
    
    if 0: # output of 2d sweep versions.
        complete_path = []
        for j in range(n):
            path = []
            for k in range(len(perms)):
                index = perms[k].index(j)
                path.append((k,index))
            complete_path.append(path)

        colors = ['red', 'blue', 'darkgreen', 'darkviolet', 'darkgrey', 'orange', 'black', 'darkolivegreen']

        sum(list_plot(complete_path[j], plotjoined=True, color = colors[j], frame = False) for j in N).save('sweep'+str(n)+'_'+str(r)+'_'+str(i)+'.png', frame = False, axes = False)
        
    assert(len(perms) == binomial(n,2)+1)
    for j in N: # i is level of sweep, j is color = element, k level in PLA
        for k in range(len(perms)):
            index = perms[k].index(j)
            path3d[j].append((k, 100-i, index))
    
    i = i+1
    
    minimal =  Poset.minimal_elements()
    print(minimal)
        
    if not minimal: break
        
    for c in minimal: 
        assert(len(c) == 3)
        X_proj[c] = +1
        assert(test_valid_signotope(X_proj,N, r-1))
        
    perms = compute_wiring_fixedlength_as_table(X_proj, N,r-1)
    
    elements = set(elements)-set(minimal)
    Poset = Poset.subposet(elements)
    #print(''.join('+' if X_proj[I] ==+1 else '-' for I in combinations(range(n),r-1)))
    #print(table(columns = perms, align='center'))
    
    
    
    
 
#####################################
#### visualization
########################################
colors = ['green', 'blue', 'darkgreen', 'darkviolet', 'greenyellow','dodgerblue' , 'darkolivegreen', 'blueviolet']
if r==4 and n ==6:
    colors = ['red','blue','seagreen','violet','orange','brown']
if r==4 and n==8:
    colors =['aqua', 'chocolate', 'deepskyblue', 'darkgoldenrod', 'darkslateblue', 'darkred', 'indigo', 'indianred']

#colors =['green', 'blue', 'red', 'orange']
#colors = colormaps.Accent
l=[]
pts = []
for j in reversed(list(N)):
    l.append(list_plot3d(path3d[j] , color = colors[j], frame = False))
    #for p in path3d[j]:
    #    pts.append(point3d(p , size=100, color = 'red', #opacity=0.8, 
    #                     figsize = 40, frame = False))
    #    break
L = sum(l[j] for j in N)#.save('3dplot'+'.png')
#Green = sum(l[j] for j in N if j%2 ==0)+sum(p for p in pts)
#Blue = sum(l[j] for j in N if j%2 ==1)
#for i, j in combinations(N,2):
#    show(l[i]+l[j])
#show(Green)
#show(Blue)
show(L)
#print('end')
#print("start nodejs")
#L.show(viewer="nodejs")

