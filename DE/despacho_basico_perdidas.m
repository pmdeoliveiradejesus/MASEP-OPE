%% Despacho Básico (c) 2023
% IELE4109
% Prof. Paulo M. De Oliveira 
% pdeoliv@gmail.com
%%
clear all
clc
close all
global Co a b PdTotal PgMax B  
 %%dataset
Co=[100 200];
a=[20 25]';
b=[0.05 0.10]';
e=[1 1]';
PdTotal=250;
PgMax=[400 300]';
B=[0.00447422088155192	-0.00223637879086458	-0.00225259337540058;
-0.00223637879086443	0.00447422088155207	-0.00225629805544068;
-0.00225259337540057	-0.00225629805544081	0.00456333229449198];




%% OPTIMIZATION BEGINS HERE
time000=cputime;
%Initial conditions
%     Pg1 Pg2 
x0 = [202.4 51.2]';%Bounds
ub = [];
lb = []';
%Equality linear constraints - Storage model
%FMINCON calculation
options = optimoptions('fmincon');
options.MaxFunctionEvaluations = 5000000;
options.ConstraintTolerance = 1.0000e-12;
options.MaxIterations = 100000;
options.OptimalityTolerance = 1.0000e-12;
options.StepTolerance = 1.0000e-20;
options.Display='iter';
options.Algorithm='interior-point';
[x,fval,exitflag,output,lambda,grad,hessian]=fmincon(@objective_func,x0,[],[],[],[],lb,ub,@network_model,options);

elapsedtime000=cputime-time000 % Set simulation time
exitflag;
%Lagrange multipliers
lambdap=lambda.eqnonlin(:);%
Pg=x;
%% Results
disp('*******************************************************')
fprintf('Optimization results:\n') 
fprintf('Total Cost %6.2f USD/h\n',fval)
fprintf('PG1        %6.2f MW\n',Pg(1))
fprintf('PG2        %6.2f MW\n',Pg(2))
fprintf('lambdaP    %6.2f USD/MWh\n',lambdap)
disp('*******************************************************')
fprintf(' \n')
function [f] = objective_func(x)
global Co a b
f=sum(Co'+a.*x+0.5.*b.*x.^2);%minimization of production cost
end
function [c,ceq] = network_model(x)
global PdTotal PgMax B  
Ploss=([x(1) x(2) -PdTotal]/200)*B*([x(1); x(2);-PdTotal]/200);
ceq = PdTotal+Ploss*200-sum(x);
c = [];
%c = x-PgMax;
end







