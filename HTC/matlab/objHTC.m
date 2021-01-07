function f = myfun(X);
global mo pmin pgmin pgmax md pmax n 

% min -SW = SC = sum_1^ (pmin*Pg+ 0.5*mo*Pg^2)-(pmax*Pd-0.5*md*Pd^2) 
% st
% rho=pmax-md*Pd
% sum Pg = Pd

Pg1=X(1);
Pg2=X(2);
Ph1=X(3);
Ph2=X(4);
q1=X(5);
q2=X(6);

f=0;
for k=1:n
f=pmin(k)*(Pg1+Pg2)    +    0.5*mo(k)*(Pg1^2+Pg2^2)+f;
end;
% f= 12*(1.15*500+1.15*8*Pg1+1.15*0.0016*Pg1^2)+ 12*(1.15*500+1.15*8*Pg2+1.15*0.0016*Pg2^2);
% f
% pause
