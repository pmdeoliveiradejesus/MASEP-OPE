function f = myfun(X2);
global pmin mo md pmax Bloss Loss2 n flagx
for k=1:n
f(k)=pmin(k)+mo(k)*X2(k)+X2(n+2)*(-1+2*Bloss(k)*X2(k));
end
f(n+1)=pmax-md*X2(n+1)-X2(n+2);
Loss2=0;
for k=1:n
    Loss2=Bloss(k)*X2(k)^2+Loss2;
end
flagx=0;
for k=1:n

    flagx=X2(k)+flagx;
end
f(n+2)=flagx-X2(n+1)-Loss2;

