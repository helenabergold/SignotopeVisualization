from sage.combinat.posets.posets import FinitePoset
from sage.all import *
from itertools import *

def compute_poset(X,N,r):
    relations = DiGraph()
    for I in combinations(N,r):
        JJ = [J for J in combinations(I,r-1)]
        if X[I] == +1:
            for J1,J2 in combinations(JJ,2):
                relations.add_edge(J1,J2)
        else:
            for J1,J2 in combinations(JJ,2):
                relations.add_edge(J2,J1)
    
    return FinitePoset(relations)