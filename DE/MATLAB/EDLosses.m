% Economic Dispatch Program,De Oliveira De Jesus UNIANDES. August 2017
% With Transmission
% No Output limits
% 
% cp: perfect competition
%  
clc
clear all
close all
global mo pmin pgmin pgmax md pmax n Bloss Loss flagx Loss2

%% Generation cost structure
%   alpha ($/h) beta ($/MWh) gamma ($/MW2h) Pmin (MW) Pmax (MW)
PG=[561 7.92 0.001562 0 10000;
    310 7.85 0.00194  0 10000;
    78  7.97 0.00482  0 10000;];%W&W example 3C 
%% Demand cost structure
 pmax=(10)*9.1483;
 md=(10-1)*9.1483/850;
Pdmax=1000;%Mw
%%
Bloss=[0.00003 0.00009 0.00012];
n=size(PG,1);for k=1:n
    mo(k)=PG(k,3)*2;
    pmin(k)=PG(k,2);
    Pgmin(k)=PG(k,4);
    Pgmax(k)=PG(k,5);    
end


% min -SW = SC = sum pmin*Pg+ 0.5*mo*Pg^2-(pmax*Pd-0.5*md*Pd^2) 
% st
% rho=pmax-md*Pd
% sum Pg = Pd

% Solution approach 2 (Interior Point)
x0=zeros(1,n+1); 
LB=zeros(1,n+1);
UB=ones(1,n+1)*100000;
A=[];
Bx=[];
Aeq=[];
Beq=[];
tol1=1e-8;
tol2=1e-8;
tol3=1e-8;
options=optimset('Display','iter','LargeScale','on','ActiveConstrTol',1,'TolFun',tol1,'TolCon',tol2,'TolX',tol3,'MaxIter',250000,'MaxFunEvals',2500000000)
[X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = fmincon('obj',x0,A,Bx,Aeq,Beq,LB,UB,'restrloss')
EXITFLAG
LAMBDA
% Solution approach 2 (Langrange)

X0=[X(1) X(2) X(3) X(4) -LAMBDA.eqnonlin];
X2 = fsolve('objlosses',X0)


ff=0;
for k=1:n
ff=pmin(k)*X(k)+ 0.5*mo(k)*X(k)^2+ff;
end
f= ff-(pmax*X(n+1)-0.5*md*X(n+1)^2);

ff2=0;
for k=1:n
ff2=pmin(k)*X2(k)+ 0.5*mo(k)*X2(k)^2+ff2;
end
f2= ff2-(pmax*X2(n+1)-0.5*md*X2(n+1)^2);

for k=1:n
    lambdaG(k)=-X2(n+2)*(-1+2*Bloss(k)*X2(k))
end
