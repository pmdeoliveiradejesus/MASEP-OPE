#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 30 14:47:57 2023

@author: pm.deoliveiradejes
"""

import numpy as np
import cvxpy as cvx
#database
pmin = [0,0]
pmax = [400,300]
a = np.diag([0.05,0.1])
b = np.array([20,25])
d =250

# begin optimization 
p = cvx.Variable(np.size(b))
obj = cvx.Minimize(1/2*cvx.quad_form(p,a)+b.T@p)
#obj = cvx.Minimize(1/2*p.T@a@p+b@p+b@p)
res = [sum(p) == d,p>=pmin, p<=pmax]
Model = cvx.Problem(obj,res)
Model.solve()
print(p.value)
print(obj.value)
print('Incremental Cost:',res[0].dual_value)

def IsSD(M):   
    Lmin = min(np.linalg.eigvals(M))   
    if (Lmin==0):       
        print('Positive semidefinite')   
    if (Lmin>0):       
        print('Positive definite')   
    if (Lmin<0):       
        print('It is not positive semidefinte')
        
IsSD(a)