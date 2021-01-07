% HTC Economic Dispatch Program,De Oliveira De Jesus UNIANDES. August 2017
% With Transmission
% No Output limits
% Elastic demand
% cp: perfect competition
%  
clc
clear all
close all
global mo pmin pgmin pgmax md pmax n Bloss Loss1 Loss2 flagx Loss2 Pd1 Pd2 q1 q2 Ph1 Ph2 Pg1 Pg2

%% Generation cost structure
%   alpha ($/h) beta ($/MWh) gamma ($/MW2h) Pmin (MW) Pmax (MW)
PG=[1.15*500 1.15*8 1.15*0.0016 150 1500;];%W&W example 7b 
%% Demand cost structure
Pd1=1200;%Mw
Pd2=1500;%MW
%%
Bloss=[0.00008];
n=size(PG,1);for k=1:n
    mo(k)=PG(k,3)*2;
    pmin(k)=PG(k,2);
    Pgmin(k)=PG(k,4);
    Pgmax(k)=PG(k,5);    
end

% Pg1=X(1);
% Pg2=X(2);
% Ph1=X(3);
% Ph2=X(6);
% q1=X(5);
% q2=X(6);

% Solution approach 2 (Interior Point)
x0=zeros(1,6);
LB=zeros(1,6);
UB=ones(1,6)*100000;
A=[];
Bx=[];
Aeq=[];
Beq=[];
tol1=1e-8;
tol2=1e-8;
tol3=1e-8;
options=optimset('Display','iter','LargeScale','on','ActiveConstrTol',1,'TolFun',tol1,'TolCon',tol2,'TolX',tol3,'MaxIter',250000,'MaxFunEvals',2500000000)
[X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = fmincon('objHTC',x0,A,Bx,Aeq,Beq,LB,UB,'restrlossHTC')
EXITFLAG
LAMBDA
LAMBDA.eqnonlin
% Solution approach 2 (Langrange)
lambda1=(9.2+0.0036*X(1))
lambda2=(9.2+0.0036*X(2))
eta=(1-.00016*X(3))*lambda1/(4.97)
etar=(1-.00016*X(4))*lambda2/(4.97)

