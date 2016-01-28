function [ mpv, tv , t , y , acc ] = solidRocket(mpt, A, Tt, Isp, Mpl, diam, Cd )
%This function computes the performance of a solid rocket


%data
rho=1.22; %kg/s
S=pi*(diam/2)^2;    %m2
g=9.81;     %m/s2 



%mpFun plot in order to check if the profile of flow mass is correct
tv=linspace(0,Tt,500);
for i=1:length(tv)
    mpv(i)=mpfun(tv(i),mpt,A,Tt);
end



%Integration of mpfun in order to obtain total fuel mass
mympfun=@(t) mpfun(t,mpt,A,Tt);     %an auxiliary function must be created in order to reduce the number of variables from 4 to 1
total=integral(mympfun,0,Tt);       %Kg

if abs(total-mpt)>1e-3
    error('uhh?? Integration is not correct!');
end

%Vector y is an state vector, being y(1) height, y(2) velocity and
%y(3) mass, while dydt will be  velocity, acceleration and mp

dydt=@(t,y) [ y(2);...
              Isp*g*mympfun(t)/y(3)-g-0.5*rho*abs(y(2))*y(2)*S*Cd/y(3);...
              -mympfun(t)];
          
y0=[0;0;Mpl+mpt];        %Initial conditions vector

[t,y]=ode45(dydt,[0 50],y0);     %Solving the EDO



%Acceleration computation

for i=1:length(t)
    der=dydt(t(i),y(i,:));
    acc(i)=der(2);
end


end

