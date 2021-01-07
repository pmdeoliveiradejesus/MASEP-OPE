% Economic Dispatch Program,De Oliveira De Jesus UNINADES. August 2017
% Output limits, No Transmission
% 
% cp: perfect competition
%  
clc
clear all
close all
global Acp B mo pmin Pgmin Pgmax md pmax n
%% Generation cost structure
%   alpha ($/h) beta ($/MWh) gamma ($/MW2h) Pgmin (MW) Pgmax (MW)
PG=[0  10 5 2 1.7;
%      0 15 0 2 5;
%      0 5 30 2 10;
%      0 0 50 2 10;
%     0 15 5 2 10;
%     0 7.5 25 2 10;
    0 5 7.5 2 5;];
%% Demand cost structure
md=20;
pmax=100;%$/MWh
Pdmax=6;%MW
%% 
n=size(PG,1);for k=1:n
    mo(k)=PG(k,3)*2;
    pmin(k)=PG(k,2);
    Pgmin(k)=PG(k,4);
    Pgmax(k)=PG(k,5);    
end

for k=1:n
   Limits(k,1)=-pmin(k);
end
   Limits(n+1,1)=-pmax;
   Limits(n+2,1)=0;
for k=1:n
   Limits(n+2+k,1)=Pgmax(k);
end   

% min -SW = SC = sum pmin*Pg+ 0.5*mo*Pg^2-(pmax*Pd-0.5*md*Pd^2) 
% st
% rho=pmax-md*Pd
% sum Pg = Pd

x0=zeros(1,n+1); %pg1 pgi pgn pd
LB=zeros(1,n+1);
UB=ones(1,n+1)*10;
A=[];
Bx=[];
Aeq=[];
Beq=[];
tol1=1e-8;
tol2=1e-8;
tol3=1e-8;
%options=optimset('Display','iter','LargeScale','on','ActiveConstrTol',1,'TolFun',tol1,'TolCon',tol2,'TolX',tol3,'MaxIter',250000,'MaxFunEvals',2500000000)
[X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = fmincon('obj',x0,A,Bx,Aeq,Beq,LB,UB,'restrlimit')
EXITFLAG
LagrangeMultiplier=-LAMBDA.eqnonlin-sum(LAMBDA.ineqnonlin)
KhunTucker=-LAMBDA.ineqnonlin
spotprice=-LAMBDA.eqnonlin


for k=1:n+1
Solcp(1,k)=X(k);
end
Solcp(1,n+2)=spotprice;
for k=1:n
Solcp(1,n+2+k)=KhunTucker(k);
end
for k=1:n
Solcp(1,2*n+2+k)=Limits(n+2+k)-Solcp(1,k);
end
for k=1:n
rho{k}=@(q) -Limits(k,1)+mo(k)*q;
end
rhod=@(q) +pmax-md*q;

for k=1:n
PSP(k)=Solcp(k)*Solcp(n+2)- pmin(k)*Solcp(k)-.5*mo(k)*Solcp(k)^2;
end
PSPcp=sum(PSP)
CSPcp= -Solcp(n+1)*Solcp(n+2)+ pmax*Solcp(n+1)-.5*md*Solcp(n+1)^2
peqmin=Solcp(n+2)-2*PSPcp/Solcp(n+1);
moeq=(Solcp(n+2)-peqmin)/Solcp(n+1);
rhoeq=@(q) +peqmin+moeq*q;
hold on
for k=1:n
fplot(rho(k), [0,Pdmax]);
end
fplot(rhod, [0,Pdmax]);
fplot(rhoeq, [0,Pdmax]);
hold off
xlabel('rho');
ylabel('Pg')
grid on
 title('Perfect Competition')

X0=[0; 0; 0; 0; 0;0; 0; 0];

%% Verifying equilibrium point
%X = fsolve('obj2',X0)
for k=1:n
   B(k,1)=-pmin(k);
end
   B(n+1,1)=-pmax;
   B(n+2,1)=0;
for k=1:n
   B(n+2+k,1)=Pgmax(k);
end   
  
Acp=zeros(2*n+2,3*n+2);
for k=1:n
   Acp(k,k)=mo(k);
   Acp(n+2,k)=-1;
   Acp(k,n+2)=-1;
   Acp(k,n+2+k)=-1;
   Acp(n+2+k,2*n+2+k)=1;
   Acp(n+2+k,k)=1;
end
Acp(n+1,n+1)=-md;
Acp(n+1,n+2)=-1;
for k=1:n
Acp(n+1,n+2+k)=0;
end
Acp(n+2,n+1)=1;
Acp(n+2,n+2)=0;

Acp*Solcp'-B%This relation must equal zero

