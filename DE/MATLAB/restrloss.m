function [C,Ceq]= myfun(X);
global mo pmin pgmin pgmax md pmax n Bloss Loss
% min -SW = SC = sum_1^ (pmin*Pg+ 0.5*mo*Pg^2)-(pmax*Pd-0.5*md*Pd^2) 
% st
% rho=pmax-md*Pd
% sum Pg = Pd
Loss=0;
for k=1:n
    Loss=Bloss(k)*X(k)^2+Loss;
end
Ceq=sum(X)-2*X(n+1)-Loss;
%Ceq=X(1)+X(2)+X(3)-X(4)-Loss;
C=[];