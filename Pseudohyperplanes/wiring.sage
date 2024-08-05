#!/usr/bin/env python
# coding: utf-8

# In[16]:


from itertools import *
from ast import *
from sys import *
from copy import copy
from sage.combinat.posets.posets import FinitePoset
from sage.misc.table import *
path.append('../')
from basics_poset import *
from basics import *
from basics_sweep import *


#input and basic definitions
r = int(argv[1])
assert( r == 3)
n = int(argv[2])
N = range(n)
f = open(argv[3])


line = f.readline()
if not line: exit('no input')
print()
print("input",line,)

#input and basic definitions
#r = 3
#n = 23
#N = range(n)


#line = '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+++--++-+-+--++++++++--------------++++-++-+++--+++++++++++++++-++++++++--+-+--++++++++-+-+--++++++++++++-++++++++-----++-+++++--++++++++--++++++++-+++++++++++++++++++++++--++++-++++++++-++++++++++++++++++++++++--+++++++-++++++++-+++++++-+++++++++++++++-++++++++--+-+--++++++++-++++-++++++++++++-++++++++----++++++++++-++++++++--++++++++-++++++++++++++++++++++++++++++++++++++++++++--------------+-++-++-++++-+++++++++++++++-++++++++--+--------++++-+-+---++-++++++++-++++++++--------+++++--++++++++---++-++++-++++++++++++++++++-++++--++++-++++++++-+++++-+++++++-+++++++++++++++-++++++++--+-+--++++++++-++++-++++++++++++-++++++++-----++++++++--++++++++--++++++++-+++++++++++++++++++++++--++++-++++++++--++++++++++++++++++++--+--------++-+-+-+---++-++++++++-++++++++--------+--++--+++-++++---+--++++-++++++++++++++++++-++++--++++-++++++++--+-++--+--------+----+-+------++--+++--++--++----------+---+--++--++--------++---+++-++--+++++++++--++----++---++--++---------++++++++++++++++++++++++++--------+---+++++++++++---++-++++++++++++++++++++++++++++--++++-++++++++----+++++++++++++++--------+---+--++++++++------++---++++++++++++++++++-++++--+++--++++++++--------------+----------+---------+----+++-+++++++++++++--+-----+----++--++++------+++++++++++++++++++++++++++++++++++++++++++++--++++-++++++++---+++------+----+++++++++++++++++--+-----+----+++-++++------++++++++++++++++++++++++--++++-++++++++-----+++++++++------------------++++-----------------------------------------++++++++------+++++++++------++++------------++++'
#line = '+++++'
#line = '+'



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
#perms = compute_wiring_fixedlength_as_table(X_proj, N,r-1)

minimal_prev = []

i =0

multiplot = []
sign_proj = []

elements = list(combinations(N,r-1))

perms = [list(N)]
j=0

while True:
    
    minimal =  Poset.minimal_elements()
    print('minimal elements',minimal)
    
    perms.append(copy(perms[j]))
    for K in minimal:
        
        assert(len(K) ==2)
        diff = perms[j].index(K[0]) - perms[j].index(K[1])
        assert(diff == 1 or diff == -1)
        
        #switch those two entries
        perms[j+1][perms[j].index(K[0])] = K[1]
        perms[j+1][perms[j].index(K[1])] = K[0]
        
    j = j+1 
        
    if not minimal: break

    elements = set(elements)-set(minimal)
    Poset = Poset.subposet(elements)
    
   
    
if 1: # output of 2d sweep versions.
    complete_path = []
    for j in range(n):
        path = []
        for k in range(len(perms)):
            index = perms[k].index(j)
            path.append((k,index))
        complete_path.append(path)
        
#colors =['aqua', 'chocolate', 'deepskyblue', 'darkgoldenrod', 'darkslateblue', 'darkred', 'indigo', 'indianred']
colors = rainbow(n)

plt = sum(list_plot(complete_path[j], plotjoined=True, color = colors[j] , thickness =1.5,frame= False, axes = False, aspect_ratio = 2) for j in N).save('foo.pdf', frame = False, axes = False)
        
