%% Despacho Básico (c) 2023
% IELE4109
% Prof. Paulo M. De Oliveira 
% pdeoliv@gmail.com
%%
clear all
clc
close all
global Co a b PdTotal PgMax
%%dataset
Co=[100 200];
a=[20 25]';
b=[0.05 0.10]';
e=[1 1]';
PdTotal=600;
PgMax=[400 300]';
B=diag(b);
lambda=(PdTotal+e'*inv(B)*a)/(e'*inv(B)*e);
alpha=(inv(B)*e)/(e'*inv(B)*e);
beta=(inv(B)*e*(e'*inv(B)*a))/(e'*inv(B)*e)-inv(B)*a;
Pg=alpha*PdTotal+beta;
cost=sum(Co'+a.*Pg+0.5.*b.*Pg.^2);
%% OPTIMIZATION BEGINS HERE
time000=cputime;
%Initial conditions
%     Pg1 Pg2 
x0 = [0 0]';%Bounds
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
global PdTotal PgMax
ceq = PdTotal-sum(x);
c = [];
%c = x-PgMax;
end







