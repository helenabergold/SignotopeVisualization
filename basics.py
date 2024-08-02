from itertools import *
from ast import *
from sys import *

if 1^1 == 0: assert(int(version.split('.')[0]) >= 3) # use python 3.x or later
if 1^1 == 1: assert(int(version().split()[2].split('.')[0]) >= 9) # use sage 9.x or later

# def permutations(X,r): return itertools.permutations(X,int(r)) # sage 3.X bugfix



def test_valid_signotope(X,elements,rank, debug = False):
	#tests whether a given sign mapping 'X' on 'element' of rank 'rank' 
	# fulfills the monotonicity condition on the r+1 subsets.
	# also works with partial signotopes (not all entries needed)
	# returns True if no conflict, otherwise False
	for I in combinations(elements,rank+1):
		#tuples as sequence
		X_I = [X[J] for J in combinations(I,rank) if J in X] 
		sign_changes = 0 
		for i in range(len(X_I)-1):
			if X_I[i] != X_I[i+1]: 
				sign_changes += 1
			if sign_changes > 1: 
				if debug: print('violations of signotope axioms', I, X_I)
				return False
	return True 


def test_valid_signotope_after_flip(X,elements,rank,flipped_tuple, debug = False):
    #tests whether signotope after a performed flip of one r-tuple is still a signotope
    #For this we only need to test the r+1 subsets containing the flipped tuple. 
    #also works for partial
    #return True if still signotope, otherwise False
	for x in set(elements)-set(flipped_tuple):
		I = list(sorted(flipped_tuple+(x,)))
		X_I = [X[J] for J in combinations(I,rank) if J in X] 
		sign_changes = 0
		for i in range(len(X_I)-1):
			if X_I[i] != X_I[i+1]: 
				sign_changes += 1
			if sign_changes > 1: 
				if debug: print('violations of signotope axioms', I, X_I)
				return False
	return True 


def test_flipable(X,elements,rank,I):
    # tests whether the sign of I can be flipped such that the mapping is still a valid signotope
	s = X[I]
	X[I] = -s
	result = test_valid_signotope_after_flip(X,elements,rank,I)
	X[I] = s
	return result

def test_flipable_in_sequence_partial(X,I,J,N,r): 
    assert(test_valid_signotope(X,N,r))
    assert(len(I) == r)
    assert(len(J) == r+1)
    
    Jr = list(combinations(J,r))
    assert(I in Jr)
    
    iI = Jr.index(I)
    links = range(iI)
    rechts = range(iI+1,r+1)
        
    if len(links) == 0: # I is the leftmost element in sequence
        assert( I == Jr[0])
        if I in X: 
            if Jr[1] in X and X[I] != X[Jr[1]]: 
                return True
        if Jr[1] in X and Jr[-1] in X: 
            if X[Jr[1]] == X[Jr[-1]]:
                return True
    
    if len(rechts) ==0:
        assert( I == Jr[-1])
        if I in X: 
            if Jr[-2] in X and X[I] != X[Jr[-2]]: 
                return True
        if Jr[0] in X and Jr[-2] in X: 
            if X[Jr[0]] == X[Jr[-2]]:
                return True
                
    if len(rechts)>0 and len(links)>0:
        if I in X: 
            if Jr[iI-1] in X and X[I] != X[Jr[iI-1]]: return True
            if Jr[iI+1] in X and X[I] != X[Jr[iI+1]]: return True
        if Jr[iI-1] in X and Jr[iI+1] in X: 
            if X[Jr[iI-1]] != X[Jr[iI+1]]: return True
    return False
	
	
def transpositions(I): 
    #gives the number of transpositions in a permutation
	return sum(1 for (i,j) in combinations(I,2) if i>j)

	
def string_to_signotope(X_str,elements,rank):
    #has a string {+,-}* as input and makes it a signotope by assigning the signs of the string to the tuples in lexicographic order 
	X = {}
	i = 0
	for I in combinations(elements,rank):
		assert(X_str[i] in ["+","-"])
		s = +1 if X_str[i] == "+" else -1
		i += 1
		X[I] = s
	assert(test_valid_signotope(X,elements,rank))
	return X 


def line_to_signotope(line,elements,rank):
    #takes a line and splits it accordingly + removing '\n' to make it a signotope
	if line == "\n": return

	X_str = line.split()[1] if ' ' in line else line
	if X_str[-1] == '\n': X_str = X_str[:-1]

	X = string_to_signotope(X_str,elements,rank)
	#assert(test_valid_signotope(X,elements,rank))
	return X


def signotope_to_string(X,elements,rank):
    #makes a string of the signs in lexicographic order (reverse to string_to_signotope)
	return ''.join('+' if X[I] == +1 else '-' for I in combinations(elements,rank))


def signotope_to_chirotope(X,elements,rank):
    #computes alternating extension, so the signotope becomes a chirotope
	Y = {I:X[tuple(sorted(I))]*(-1)**transpositions(I) for I in permutations(elements,rank)}
	for I in product(elements,repeat=rank):
		if I not in Y: 
			Y[I] = 0
	return Y


def rotate(X,elements,rank):
    #performs the rotation operation once by rotating the first 
    # element '0' which becomes the last afterwards.
	max_element = max(elements)
	assert(elements == list(range(max_element+1)))

	X_rot = {}
	for I in combinations(elements,rank):
		if I[-1] < max_element:
			X_rot[I] = X[tuple(x+1 for x in I)]
		else:
			X_rot[I] = -X[(0,)+tuple(x+1 for x in I[:-1])]
	assert(test_valid_signotope(X_rot,elements,rank))

	return X_rot


def rotate_fliple(I,elements,rank):
	#performs a rotation +1 on every element of I 
	#with respect to n=max_element(elements) +1 (number of elements)
	assert(len(I) == rank)
	n = max(elements)+1
	return tuple(sorted(((i+1)%n for i in I)))


def projection(X,N,r,i):
    X_proj = {}
    for I in combinations(N,r):
        if i not in I: continue
        I_proj = tuple(x for x in I if x<i) + tuple(x-1 for x in I if x>i)
        assert(len(I_proj) ==r-1)
        X_proj[I_proj] = X[I]
    assert(test_signotope_partial(X_proj,range(n-1), r-1))
    return X_proj

