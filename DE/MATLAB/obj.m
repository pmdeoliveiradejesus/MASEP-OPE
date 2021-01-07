function f = myfun(X);
global mo pmin pgmin pgmax md pmax n 

% min -SW = SC = sum_1^ (pmin*Pg+ 0.5*mo*Pg^2)-(pmax*Pd-0.5*md*Pd^2) 
% st
% rho=pmax-md*Pd
% sum Pg = Pd

ff=0;
for k=1:n
ff=pmin(k)*X(k)+ 0.5*mo(k)*X(k)^2+ff;
end
f= ff-(pmax*X(n+1)-0.5*md*X(n+1)^2);
%pause
