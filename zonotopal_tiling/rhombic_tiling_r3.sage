from sys import *
from itertools import *

path.append('../')
from basics_poset import *

r = int(argv[1])
n = int(argv[2])
N = range(n)

assert(r ==3)

f = open(argv[3])

colors = rainbow(n)
colors = ['blue','green','red']

input_line = f.readline()
if not input_line: exit('no input')
print()
print( "input",input_line,)


X = {}
X_str = input_line.split()[1] if ' ' in input_line else input_line
if X_str[-1] == '\n': X_str = X_str[:-1]

i = 0
for I in combinations(N,r):
    s = +1 if X_str[i] == "+" else -1
    i += 1
    X[I] = s


def P(i): return vector([sin((i/n)*pi),-cos((i/n)*pi)])
def V(i): return P(i+1)-P(i)


pts = [P(i) for i in range(2*n)]



R = [P(i) for i in range(n+1)]
print("R",len(R))
plt = point2d([])
#pslines = point2d([])



#initialize the current lines, plot boundary edges from one side
current_lines = []
pslines_table = []
#for i in range(n-1,-1,-1):
for i in N:
    A = R[i]
    B = R[i+1]
    plt += line([A,B],color=colors[i%3], thickness = 3)
    #plt += point2d(A, color = 'black', size = 22)
    
    pslines_table.append([])
    pslines_table[i].append(1/2*(A+B))
    
    current_lines.append([i,A,B])
    current_perms = [i for (i,A,B) in current_lines]
    
    #A2 =(-A[0],A[1])
    #B2 =(-B[0],B[1])
    #plt += line([A2,B2],color=colors[(n-1-i)%n], thickness = 5)


Poset = compute_poset(X,N,r)
elements = list(combinations(N,r-1))
while True:
    minimal =  Poset.minimal_elements()
    #print i,'minimal elements', minimal
        
    if not minimal: break
               
    for c in minimal: 
        assert(len(c) == 2)
        
        k = current_perms.index(c[0])
        l = current_perms.index(c[1])
        diff = k-l
        #diff = current_perms.index(c[0]) - current_perms.index(c[1])
        assert(diff == 1 or diff == -1)
        
        #switch the two entries
        [i,A,B] = current_lines[k]
        [j,C,D] = current_lines[l]        

        
        assert(i ==c[0] or i==c[1])
        assert(j ==c[0] or j==c[1])
        
        assert( B ==C )
        
        E = A+D-B
        
        current_lines[k] = [j,A,E]
        current_lines[l] = [i,E,D]
        
        current_perms = [i for (i,A,B) in current_lines]
        
        pslines_table[j].append(1/2*(A+E))
        pslines_table[i].append(1/2*(E+D))
        
        #plot the segments
        
        plt += line([A,E],color=colors[j%3], thickness = 2)
        plt += line([E,D],color=colors[i%3], thickness = 2)
        
        #plt += point2d(A, color = 'black', size = 22)
        #plt += point2d(D, color = 'black', size = 22)
        #plt += point2d(E, color = 'black', size = 22)
        #plt += point2d(B, color = 'black', size = 22)
        #plt += point2d(C, color = 'black', size = 22)
        
        current_perms = [i for (i,A,B) in current_lines]
         
    #j = j+1
    elements = set(elements)-set(minimal)
    Poset = Poset.subposet(elements)



plt.save("tiling"+str(n)+".pdf",aspect_ratio=1,axes=False)
pslines_plot= point2d([])


for j in N:
    pslines_plot += list_plot(pslines_table[j] , color = colors[j%3], aspect_ratio=1, thickness = 2, axes=False, plotjoined=True)


pslines_plot.save('pslines'+str(n)+".pdf", axes = False, aspect_ratio=1)
#plt + pslines_plot.save('both'+str(n)+".pdf", axes = False, aspect_ratio=1)



