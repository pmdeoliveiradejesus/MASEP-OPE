function [C,Ceq]= myfun(X);
global mo pmin pgmin pgmax md pmax n Bloss Loss1 Loss2 Pd1 Pd2 q1 q2 Ph1 Ph2 Pg1 Pg2
Pg1=X(1);
Pg2=X(2);
Ph1=X(3);
Ph2=X(4);
q1=X(5);
q2=X(6);

Loss1=0;
for k=1:n
    Loss1=Bloss(k)*Ph1^2+Loss1;
end
Loss2=0;
for k=1:n
    Loss2=Bloss(k)*Ph2^2+Loss2;
end


Ceq(1)=Pg1+Ph1-Pd1-Loss1;
Ceq(2)=Pg2+Ph2-Pd2-Loss2;
% Ceq(3)= q1-330-4.97*Ph1;
% Ceq(4)= q2-330-4.97*Ph2;

if Ph1<1000
Ceq(3)= q1-330-4.97*Ph1;
else
Ceq(3)=q1-5300-12*(Ph1-1000)-0.05*(Ph1-1000)^2;    
end
if Ph2<1000
Ceq(4)= q2-330-4.97*Ph2;
else
Ceq(4)=q2-5300-12*(Ph2-1000)-0.05*(Ph2-1000)^2;    
end
Ceq(5)=q1*12+q2*12-100000;
C=[];
% Ceq
% pause
% Ceq
% C
% pause