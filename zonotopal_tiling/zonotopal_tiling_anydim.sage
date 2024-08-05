#from sys import *
#argv = [None,3,8]
#argv = [None,2,9]

# start with load('rhombic_tiling_cyclic_anydim.sage') in console or jupyter
# for 3d viewer copy paste and run in sage terminal or sage notebook; html page can be saved for later usage

#argv = [None,4,6]
from itertools import *
import re # regular expressions

r = int(argv[1])
d = r-1
n = int(argv[2])
N = range(n)

#f = open(argv[3])

input_line = argv[3]
#input_line = f.readline()
#if not input_line: exit('no input')
#print()
#print( "input",input_line,)


NICER_COORDINATES = True

mc = lambda x: vector([x^k for k in range(1,d+1)])

directions = [mc(i)/(i) for i in [(100 if NICER_COORDINATES else 1)+i for i in N]]

print("directions",directions)

unit_vec = lambda i: vector(i*[0]+[1]+(n-1-i)*[0])
zero_vec = vector(n*[0])
rep2pnt = lambda v: sum([v[i]*directions[i] for i in N])


vertrep = [zero_vec]
for i in N:
	print("direction",i)
	print("vertrep",vertrep)
	vertices = [rep2pnt(x) for x in vertrep]
	#print("vertices",vertices)

	q = directions[i]

	P = Polyhedron(vertices + [v+q for v in vertices])
	P_V = [v.vector() for v in P.vertices()]

	for v in copy(vertrep):
		v_pnt = rep2pnt(v)+q
		if v_pnt in P_V:
			vertrep.append(v+unit_vec(i))

	print("vertrep len:",len(vertrep))


vertrep = [tuple(v) for v in vertrep] # vectors are not hashable in sage


vertices = {tuple(x):rep2pnt(x) for x in vertrep}

P = Polyhedron(vertices.values())
P_V = [v.vector() for v in P.vertices()]
outer_verts = [v for v in vertrep if rep2pnt(v) in P_V] 
print("outer_verts",outer_verts)


def compute_edges(vertices):
	edges = []
	for (u,v) in combinations(vertices,2):
		diff = [i for i in N if u[i] != v[i]]
		if len(diff) == 1:
			edges.append((u,v,diff[0]))
	return edges

edges = compute_edges(vertices)
print("edges",len(edges),edges)
num_edges = len(edges)

if 1: 
	#test valid 
	print("vertrep",vertrep)
	for v in vertrep:
		v = ''.join(str(x) for x in v)
		if d==2: assert(re.match('^0*1*0*$',v))
		if d==3: assert(re.match('^1*0*1*0*$',v))

	missing = []
	for v in product([0,1],repeat=n):
		if tuple(v) not in vertrep:
			missing.append(v)
			v = ''.join(str(x) for x in v)
			if d==2: assert(not re.match('^0*1*0*$',v))
			if d==3: assert(not re.match('^1*0*1*0*$',v))
	print("missing",missing)



if not input_line:
	if d==3 and n==8:
		sig_str = '+++++-+-++++-++----+++-+++++-++-+++----------+++--+--+++++-++-+++--+++' # lasagne
	if d==3 and n==6:
		sig_str = '++++++---+---++' #example diss helena 
	if d==2 and n==9:
		sig_str = '++++++++++++++++++-+--+++--+------+++-+---------++++-+-+--+-+--+---------++++--+--++' #proper ringel
	if d==2 and n==4:
		sig_str = '--++' # some

else:
	sig_str= input_line

print("sig_str",sig_str)

assert(len(list(combinations(N,d+1))) == len(sig_str))
sig = {I:sig_str[i] for i,I in enumerate(combinations(N,d+1))}
to_flip = [I for I in sig if sig[I] == '+']

if 0:
	# compute flip sequence
	to_flip = []
	while '-' in sig.values():
		succ = 0
		for I in sig:
			if sig[I] == '-':
				sig[I] = '+'
				valid = 1
				for J in combinations(N,d+2):
					packet = ''.join(sig[K] for K in combinations(J,d+1))
					if packet.count('+-')+packet.count('-+') > 1:
						valid = 0
						break 
				if valid: 
					succ += 1
					to_flip.append(I)
					break
				else:
					sig[I] = '-' #revert and try next
		assert(succ)
	print("flip sequence to all+:",to_flip)


while to_flip:
	print()
	print("TO FLIP:",len(to_flip))

	#print("edges",len(edges),edges)

	# compute flipables
	G = Graph([(tuple(u),tuple(v),c) for (u,v,c) in edges])
	flipable = [v for v in set(vertices)-set(outer_verts) if G.degree(v) == d+1]
	#print("flipable",flipable)

	succ = 0
	for f in flipable:
		f_colors = tuple(sorted([c for (_,_,c) in G.edges(f)]))
		#print(f,"->",f_colors)

		#if f_colors == to_flip[-1]:
		if f_colors in to_flip:
			to_flip.remove(f_colors)
			print("flip",f_colors)
			print("delete vertex",f,vertices[f])
			del vertices[f]
			g = tuple((1-f[c] if c in f_colors else f[c]) for c in N)
			vertices[g] = rep2pnt(g)
			print("added vertex",g,vertices[g])
			edges = compute_edges(vertices)
			assert(num_edges == len(edges))
			print("recomputed edges")
			succ = 1
			break

	assert(succ)

print("all flipped!")


if NICER_COORDINATES:
	# nicer coordinates via shearing
	for j in reversed(range(d)):
		max_coord = [max(v[i] for v in vertices.values()) for i in range(d)]
		for v in vertices:
			vertices[v] = vector(vertices[v][i]/max_coord[i]-(vertices[v][j]/max_coord[j] if i < j else 0) for i in range(d))

	print("nicer coordinates for vertices",len(vertices),vertices)




#colors = rainbow(n)
colors = ['red','blue','seagreen','violet','orange','brown']
if 0:
	# plot tiling
	plt = sum(line([vertices[u],vertices[v]],color=colors[c]) for (u,v,c) in edges)
	plt += point(vertices.values())
	if 0: plt += sum(text(str(v),vertices[v]) for v in vertices)
	print("write to file")
	plt.plot().save(f'tiling_{d}_{n}.png')
	print("start nodejs")
	plt.show(viewer="nodejs")



if 1:
	# plot tiling
	G = Graph(edges)

	lines = []
	for c in N:
		c_edges = [(u,v) for (u,v,cc) in edges if c == cc]

		for (u,v) in c_edges:
			if d==2:
				for x in set(G.neighbors(u))-{v}:
					y = vertices[x] + vertices[v]-vertices[u]
					if y in vertices.values():
						uv_half = (vertices[v]-vertices[u])/2
						lines.append(line([vertices[u]+uv_half,vertices[x]+uv_half],color=colors[c]))

			if d==3:
				for x,y in combinations(set(G.neighbors(u))-{v},2):
					dir0 = vertices[v]-vertices[u]
					dir1 = vertices[x]-vertices[u]
					dir2 = vertices[y]-vertices[u]

					pos_z = vertices[u]+dir1+dir2
					pos_x1 = vertices[x]+dir0
					pos_y1 = vertices[y]+dir0
					pos_z1 = pos_z+dir0
                    
					if 0: #plots the planes as intermediate value
						if pos_z in vertices.values() and pos_x1 in vertices.values() and pos_y1 in vertices.values() and pos_z1 in vertices.values():
							uv_half = dir0/2
							lines.append(line([vertices[u]+uv_half,vertices[x]+uv_half],color=colors[c]))
							lines.append(line([vertices[u]+uv_half,vertices[y]+uv_half],color=colors[c]))
							lines.append(line([pos_z+uv_half,vertices[x]+uv_half],color=colors[c]))
							lines.append(line([pos_z+uv_half,vertices[y]+uv_half],color=colors[c]))




				

	plt = sum(lines)
	plt += sum(line([vertices[u],vertices[v]],color=colors[c],thickness = 5, frame = False) for (u,v,c) in edges)
	plt += point3d(vertices.values(), size = 10, color = 'black')
	if 0: plt += sum(text(str(v),vertices[v]) for v in vertices)
	print("write to file")
	plt.plot().save(f'wires_{d}_{n}.png')
	print("start nodejs")
	plt.show(viewer="nodejs")
    
