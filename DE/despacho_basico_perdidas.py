#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 30 15:31:35 2023

@author: pm.deoliveiradejes
"""

import numpy as np
from scipy.optimize import fmin_slsqp
#database
pmin = [0,0]
pmax = [400,300]
a = np.diag([0.05,0.1])
b = np.array([20,25])
d =250
B=np.array([[0.00447422088155192,	-0.00223637879086458,	-0.00225259337540058],
[-0.00223637879086443,	0.00447422088155207,	-0.00225629805544068],
[-0.00225259337540057,	-0.00225629805544081,	0.00456333229449198]])
 
# Define objective function
def objective(x):
    Pg=np.array([x[0],x[1]])
    #print(Pg)
    Cost =0.5*Pg@a@Pg.T+b@Pg 
    return Cost

# Define constraints function
def eqconstraints(x):
    P=np.array([x[0]/200,x[1]/200,-d/200])
    Ploss=200*P@B@P.T
    eq = sum(x)-d-Ploss
    return eq

def ieqconstraints(x):
    P=np.array([x[0]/200,x[1]/200,-d/200])
    Ploss=200*P@B@P.T
    ieq = -Ploss+30
    return ieq


# Set initial values and bounds
x0 = [0,0]
bounds = [(0, 4000), (0, 3000)]

# Run optimization
x, fval, y, z ,info = fmin_slsqp(func=objective, x0=x0, f_eqcons=eqconstraints,f_ieqcons=ieqconstraints, bounds=bounds, disp=True, full_output=True)

P=np.array([x[0]/200,x[1]/200,-d/200])
Ploss=200*P@B@P.T


# Print results
print("Cost:",fval) # Losses
print("Converge?",info) # Converge?
# Solutions
print("Pg1 (MW):", x[0])
print("Pg2 (MW):", x[1])
print("Losses (MW)",Ploss)
