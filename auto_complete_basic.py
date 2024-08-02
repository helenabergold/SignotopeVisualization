from itertools import *
from copy import *
from basics import *

def test_signotope_partial(X,N,r, debug = False): 
	#tests if a partial mapping fullfills the signotope axioms,i.e. the monotonicity
	#returns True or False 
	print('should be replaced with test_valid_signotope')


def complete_partialsignotope(X_partial,N,r, debug = False):
	# Adds new tuples to the partial signotope if between two + or to - or left/ right of +/-
	#i.e. computes one step of the transitive closure
	#returns if there are new set tuples (if X_partial is already the transitve closure), and the transitive closure
	X = copy(X_partial)
	changed = False
	for I in combinations(N,r):
		if I in X: continue
		tuple_set = False
		for x in set(N)-set(I):
			J = tuple(sorted(I + (x,)))
			Jr = list(combinations(J,r))
			iI = Jr.index(I)
			left = range(iI)
			right = range(iI+1,r+1)
			
			# Case1 : between two plus/ two minus
			for a in left:
				if tuple_set: break
				if Jr[a] not in X: continue
				for b in right:
					if tuple_set: break 
					if Jr[b] not in X: continue
					if X[Jr[a]] == X[Jr[b]]:
						X[I] = X[Jr[a]]
						tuple_set = True
						changed = True
						if debug: print('new set tuple', I, X[I])
						
			# Case2 : left or right of a sign change 
			for a,b in combinations(left,2):
				if tuple_set: break
				if Jr[a] not in X: continue
				if Jr[b] not in X: continue
				if X[Jr[a]] != X[Jr[b]]:
					X[I] = X[Jr[b]]
					tuple_set = True
					changed = True
					if debug: print('new set tuple', I, X[I])
							
							
			for a,b in combinations(right,2):
				if tuple_set: break
				if Jr[a] not in X: continue
				if Jr[b] not in X: continue
				if X[Jr[a]] != X[Jr[b]]:
					X[I] = X[Jr[a]]
					tuple_set = True
					changed = True
					if debug: print('new set tuple', I, X[I])
			
			
	return test_valid_signotope(X,N,r), changed, X

def signotope_complete(X_partial,N,r):
	print('use complete_partialsignotope(X_partial,N,r, debug = False)')


def signotope_complete_wo_assert(X_partial,N,r):
	print('use complete_partialsignotope(X_partial,N,r, debug = False)')


def compute_transitiveclosure(X_partial,N,r, debug = False):
	#computes the complete transitve closure by using complete_partialsignotope(X_partial,N,r) until there is no change.
	#returns if the closure is a partial signotope, the number of new set tuples and the transitive closure 
	ct = -1
	X = X_partial
	changed = True
	while changed:
		ct = ct +1
		is_signotope, changed, X = complete_partialsignotope(X,N,r)
	return test_valid_signotope(X,N,r, debug), ct, X

def signotope_closure(X_partial,N,r, debug = False):
	print('use compute_transitiveclosure(X_partial,N,r, debug = False)')
	print('output: is_signotope, ct, X')

def signotope_closure_wo_assert(X_partial,N,r):
	print('use compute_transitiveclosure(X_partial,N,r, debug = False)')
	print('output: is_signotope, ct, X')
		
def signotope_complete_with_fliples(X_partial,N,r,fliples, debug = False):
	X = X_partial
	changed = False
	for I in fliples:
		assert(len(I) == r) 
		
		for x in set(N)-set(I):
			J = tuple(sorted(I + (x,)))
			Jr = list(combinations(J,r))
			iI = Jr.index(I)
			
			left = range(iI)
			right = range(iI+1,r+1)
			
			# Case 1: fliple is on the leftmost side. all the other signs have to be equal
			if len(left) == 0:
				for b in right:
					if Jr[b] not in X: continue
					sign = X[Jr[b]]
					for b1 in set(right)-{b}:
						if Jr[b1] not in X:
							X[Jr[b1]] = sign
							changed = True
							if debug: print('left of fliple', Jr[b1], X[Jr[b1]])
						assert(X[Jr[b1]] == sign)
					break
						
			# Case 2: fliple on the rightmost side, all others equal, symmetric to case 1
			if len(right) == 0:
				for a in left:
					if Jr[a] not in X: continue
					sign = X[Jr[a]]
					for a1 in set(left)-{a}:
						if Jr[a1] not in X:
							X[Jr[a1]] = sign
							changed = True
							if debug: print('right of fliple', Jr[a1], X[Jr[a1]])
						assert(X[Jr[a1]] == sign)
					break
							
			#Case 3: fliple in the middle, left and right of fliple are different signs
			cont = True 
			if len(right)>0 and len(left)>0:
				for a in left:
					if Jr[a] not in X: continue
					cont = False
					sign = X[Jr[a]]
					for a1 in set(left)-{a}:
						if Jr[a1] not in X:
							X[Jr[a1]] = sign
							changed = True
							print(Jr[a1], X[Jr[a1]])
						if debug: print(I, x,a)
						assert(X[Jr[a1]] == sign)
					for b in right:
						if Jr[b] not in X:
							X[Jr[b]] = -sign
							changed = True
							if debug: print(Jr[b], X[Jr[b]])
						assert(X[Jr[b]] == -sign)
					if not cont: break 
				
				if cont:
					for b in right:
						if Jr[b] not in X: continue
						sign1 = X[Jr[b]]
						for b1 in set(right)-{b}:
							if Jr[b1] not in X:
								X[Jr[b1]] = sign1
								changed = True
								if debug: print(Jr[b1], X[Jr[b1]])
							assert(X[Jr[b1]] == sign1)
						for a in left:
							if Jr[a] not in X:
								X[Jr[a]] = -sign1
								changed = True
								if debug: print(Jr[a], X[Jr[a]])
							assert(X[Jr[a]] == -sign1)
		
	return test_valid_signotope(X,N,r, debug),changed,X

def signotope_closure_with_fliples(X_partial,N,r,fliples, debug = False):
	ct = 0
	X = X_partial
	changed = True
	while changed:
		ct = ct +1
		is_signotope1, changed1, X = signotope_complete_with_fliples(X,N,r,fliples, debug)
		if not is_signotope1: error('not a partial signotope')
		is_signotope2, changed2, X = complete_partialsignotope(X,N,r, debug)
		if not is_signotope2: error('not a partial signotope')
		changed = changed1 + changed2
		
	return ct, X

def test_flipable_partial(X,I,N,r):
	#tests whether a tuple I can be a fliple
	assert(len(I) == r)
	for x in set(N)-set(I):
		J = tuple(sorted(I + (x,)))
		Jr = list(combinations(J,r))
		iI = Jr.index(I)
			
		left = range(iI)
		right = range(iI+1,r+1)
			
		# Case 1: I on the leftmost position. False if right of fliple two different signs
		if len(left) == 0:
			for b1, b2 in combinations(right,2):
				if Jr[b1] not in X: continue
				if Jr[b2] not in X: continue
				if X[Jr[b1]] != X[Jr[b2]]:
					return False
						
		# Case 2: I on the rightmost position. False if on the left of fliple two different signs
		if len(right) == 0:
			for a1,a2 in combinations(left,2):
				if Jr[a1] not in X: continue
				if Jr[a2] not in X: continue
				if X[Jr[a1]] != X[Jr[a2]]:
					return False
							
		#Case 3: I in the middle, left and right same sign: false
		#TODO if two different signs on one side, also false
		if len(right)>0 and len(left)>0:
			for a in left:
				if Jr[a] not in X: continue
				for b in right:
					if Jr[b] not in X: continue
					if X[Jr[a]] == X[Jr[b]]:
						return False
	return True


def list_blocking_elements(X,I,N,r):
	#computes the sorted list of blocking tuples for a possible fliple I , i.e. the r+1 subsets 
	#(determined by one additional element x) which block that I can be a fliple
	list_blocking = set()
	for x in set(N)-set(I):
		J = tuple(sorted(I + (x,)))
		Jr = list(combinations(J,r))
		iI = Jr.index(I)
			
		left = range(iI)
		right = range(iI+1,r+1)
			
		# Case 1: fliple leftmost position, blocking if there are two different signs right of it
		if len(left) == 0:
			for b1, b2 in combinations(right,2):
				if Jr[b1] not in X: continue
				if Jr[b2] not in X: continue
				if X[Jr[b1]] != X[Jr[b2]]:
					list_blocking.add(x)

						
		# Case 2: fliple rightmost position, blocking if there are two different signs left of it
		if len(right) == 0:
			for a1,a2 in combinations(left,2):
				if Jr[a1] not in X: continue
				if Jr[a2] not in X: continue
				if X[Jr[a1]] != X[Jr[a2]]:
					list_blocking.add(x)
							
		#Case 3: fliple in the middle, blocking element if left and right same signs
		if len(right)>0 and len(left)>0:
			for a in left:
				if Jr[a] not in X: continue
				for b in right:
					if Jr[b] not in X: continue
					if X[Jr[a]] == X[Jr[b]]:
						list_blocking.add(x)
	return list(sorted(list_blocking))
