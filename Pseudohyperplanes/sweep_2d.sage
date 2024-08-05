#!/usr/bin/env python
# coding: utf-8

from itertools import *
from ast import *
from sys import *
from sage.misc.table import *
path.append('../')
from basics_poset import *
from basics import *
from basics_sweep import *

#input and basic definitions
r = int(argv[1])
assert( r == 4)
n = int(argv[2])
N = range(n)

f = open(argv[3])
#line = '+++++-+-++++-++----+++-+++++-++-+++----------+++--+--+++++-++-+++--+++'
#line = '+++++'
#line = '+'


line = f.readline()
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

#print(''.join('+' if X[I] ==+1 else '-' for I in reversed(list(combinations(range(n),r))))) #print line in reversed order
#print('X[1,3,4,8]', X[0,2,3,7])
#print('X[2,3,7,8]', X[1,2,6,7])
#exit()

for J in combinations(N,r-1):
    for x in set(N)-set(J):
        I = tuple(J+(x,))
        print( tuple(i+1 for i in I), X[tuple(sorted(I))]*((-1)**transpositions(I)))

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
while True:
    
    minimal =  Poset.minimal_elements()
    print('minimal elements',minimal)
        
    
    perms, polygon_list, polygon_prevlist = compute_wiring_fixedlength_as_table_with_fliples(X_proj, N,r-1,list(minimal),list(minimal_prev))

    print('poly_list',polygon_list)
    plt = point2d([])

    if 1: #plot the triangles which get flipped
        for ip,p in enumerate(polygon_list):
            polygon_pts = []
            j,n1,n2 = p[0]
            #print(j,n1,n2)
            polygon_pts.append((j+1,n2))
            polygon_pts.append((j+0.5,n1+0.5))
            polygon_pts.append((j+1,n1))
            
            j,n1,n2 = p[1]
            #print(j,n1,n2)
            polygon_pts.append((j,n2))
            polygon_pts.append((j+0.5,n1+0.5))
            polygon_pts.append((j+1,n2))
            
            j,n1,n2 = p[2]
            #print(j,n1,n2)
            polygon_pts.append((j,n1))
            polygon_pts.append((j+0.5,n1+0.5))
            polygon_pts.append((j,n2))
                
            #plt += polygon(polygon_pts, color = 'green', alpha =0.5)
            
            c = minimal[ip]
            if c in {(0,2,4),(0,2,6),(0,4,6),(2,4,6),(1,3,5),(1,3,7),(1,5,7),(3,5,7)}:
                plt += polygon(polygon_pts, color = 'green', alpha =0.8)
            else:
                plt += polygon(polygon_pts, color = 'green', alpha =0.4)
                
                        
    if 1: #plot the triangles which have been flipped
        for ip,p in enumerate(polygon_prevlist):
            polygon_pts = []
                       
                       
            j,n1,n2 = p[2]
            #print(j,n1,n2)
            polygon_pts.append((j,n1))
            polygon_pts.append((j+0.5,n1+0.5))
            polygon_pts.append((j,n2))
            
            j,n1,n2 = p[1]
            #print(j,n1,n2)
            polygon_pts.append((j+1,n1))
            polygon_pts.append((j+0.5,n1+0.5))
            polygon_pts.append((j,n1))
            
            j,n1,n2 = p[0]
            #print(j,n1,n2)
            polygon_pts.append((j+1,n2))
            polygon_pts.append((j+0.5,n1+0.5))
            polygon_pts.append((j+1,n1))
            
            c = minimal_prev[ip]
            if c in {(0,2,4),(0,2,6),(0,4,6),(2,4,6),(1,3,5),(1,3,7),(1,5,7),(3,5,7)}:
                plt += polygon(polygon_pts, color = 'red', alpha =0.8)
            else:
                plt += polygon(polygon_pts, color = 'red', alpha =0.4)
                    
    
    
    if 1: # output of 2d sweep versions.
        complete_path = []
        for j in range(n):
            path = []
            for k in range(len(perms)):
                index = perms[k].index(j)
                path.append((k,index))
            complete_path.append(path)
        
        colors =['aqua', 'chocolate', 'deepskyblue', 'darkgoldenrod', 'darkslateblue', 'darkred', 'indigo', 'indianred']

        plt += sum(list_plot(complete_path[j], plotjoined=True, color = colors[j], thickness =1.5,frame= False, axes = False, aspect_ratio = 2) for j in N)
        #.save('sweep'+str(n)+'_'+str(r)+'_'+str(i)+'.png', frame = False, axes = False)
        
    
                        
    sign_proj.append(''.join('+' if X_proj[I] ==+1 else '-' for I in reversed(list(combinations(range(n),r-1))))) 
    #plt += text(''.join('+' if X_proj[I] ==+1 else '-' for I in reversed(list(combinations(range(n),r-1)))),(10,-1), fontsize = 10, color = 'black')
    plt.save('sweep'+str(n)+'_'+str(r)+'_'+str(i)+'.pdf', axes =False, frame = False, aspect_ratio = 2)
    multiplot.append(plt)
        
    if not minimal: break
    
    minimal_prev = minimal
        
    for c in minimal:
        
        assert(len(c) == 3)
        X_proj[c] = +1
        assert(test_valid_signotope(X_proj,N, r-1))

    elements = set(elements)-set(minimal)
    Poset = Poset.subposet(elements)
    
    #print(table(columns = perms, align='center'))
    
    i = i+1
    
length = len(multiplot)
print(length)
multi_graphics([(multiplot[length-j-1],(0.01+0.25*(j%4), 0.01+0.2 *((length-j)//4), 0.24, 0.19)) for j in range(length) ]).save('multi'+str(n)+'_'+str(r)+'.pdf')

