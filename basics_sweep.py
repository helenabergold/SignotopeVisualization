from itertools import *
from basics import *
from copy import copy

def compute_next_signotope_sweep(X_plus,N,r): #greedy, take first element in lex order which is flippble
    
    something_flipped=False
    
    #compute a new flip containg the sweep element, flip from + to - 
    for K in combinations(set(N)-{max(N)},r-1):
        I = K +(max(N),)
        assert(len(I) == r)
        #test flipable from - to +
        if X_plus[I] == +1: continue
        
        is_flipable = True
        for x in set(N) - set(I):
            J = tuple(sorted( I + (x,)))
            if not test_flipable_in_sequence_partial(X_plus,I,J,N,r): 
                is_flipable = False
                break
           
        if is_flipable:
            X_plus[I] = +1
            assert(test_valid_signotope(X_plus, N, r))
            something_flipped = True
            break
    return something_flipped, K, X_plus

def compute_wiring_fixedlength_as_table(X,N,r):
    
    perms = []
    perms.append(list(N))
    j=0    
    something_flipped = True
    n_ext = max(N)+1
    X_ext = {}
    for I in combinations(N,r):
        X_ext[I] = X[I]
    for I in combinations(N,r-1):
        X_ext[I+(n_ext,)] = -1
    #X_ext is signotope of rank r on n+1 elements
    
    while something_flipped:

        something_flipped, K, X_ext = compute_next_signotope_sweep(X_ext,range(n_ext+1),r)
        
        if not something_flipped: break
    
        perms.append(copy(perms[j]))
        
        assert(len(K)==2)
        
        
        diff = perms[j].index(K[0]) - perms[j].index(K[1])
        assert(diff == 1 or diff == -1)
        
        #switch those two entries
        perms[j+1][perms[j].index(K[0])] = K[1]
        perms[j+1][perms[j].index(K[1])] = K[0]
        
        j = j+1 
    return perms

def compute_wiring_fixedlength_as_table_with_fliples(X,N,r,fliples,prefliples):
    
    perms = []
    perms.append(list(N))
    j=0    
    something_flipped = True
    n_ext = max(N)+1
    X_ext = {}
    for I in combinations(N,r):
        X_ext[I] = X[I]
    for I in combinations(N,r-1):
        X_ext[I+(n_ext,)] = -1
    #X_ext is signotope of rank r on n+1 elements
    polygon_list = []
    polygon_prevlist =[]
    for c in fliples:
        polygon_list.append([])
    for c in prefliples:
        polygon_prevlist.append([])
    
    
    while something_flipped:

        something_flipped, K, X_ext = compute_next_signotope_sweep(X_ext,range(n_ext+1),r)
        if not something_flipped: break
    
        perms.append(copy(perms[j]))
        
        assert(len(K)==2)
        
        for c in fliples:
            if K[0] in c:
                if K[1] in c:
                    polygon_list[fliples.index(c)].append((j,perms[j].index(K[0]), perms[j].index(K[1])))
                    
        for c in prefliples:
            if K[0] in c:
                if K[1] in c:
                    polygon_prevlist[prefliples.index(c)].append((j,perms[j].index(K[0]), perms[j].index(K[1])))
                    
        diff = perms[j].index(K[0]) - perms[j].index(K[1])
        assert(diff == -1)
        
        #switch those two entries
        perms[j+1][perms[j].index(K[0])] = K[1]
        perms[j+1][perms[j].index(K[1])] = K[0]
        
        j = j+1 
        assert(len(polygon_list[fliples.index(c)]) ==3 for c in fliples)
        #print(polygon_list)
    return perms, polygon_list, polygon_prevlist