

mpt=0.5; % kg
A=1; % s
Tt=7; % s
diam=0.05; %m
Cd=0.3;
Isp=120;    %m/s
Mpl=1.5; %Kg

[ mpv, tv , t , y , acc ]= bengala(mpt, A, Tt, Isp, Mpl, diam, Cd );


figure
subplot(3,1,1)
plot(tv,mpv)
title('Mass flow versus time')
xlabel('time(s)')
ylabel('massflow (kg/s)')

subplot(3,1,2)
plot(t,y)
title('State Variables vs time')
legend('Height (m)','Velocity (m/s)','Mass (Kg)')
xlabel('time(s)')


%1- compute Maximum height

thmax=interp1(y(50:end,2),t(50:end),0);   %maximum height will be reached when velocity changes from positive to negative
yhmax=interp1(t,y,thmax);   %once time for hmax is found, we can get the state of the rocket at that time

fprintf('1- Maximum height: %f [m]\n',yhmax(1))


subplot(3,1,3)
plot(t, acc)
title('Acceleration vs time')
xlabel('time(s)')
ylabel('acceleration (m/s2)')

accmax=max(acc);

fprintf('2- Acceleració màxima assolida: %f [m/s2]\n',accmax)

%3- With A=1, which value for Tt will maximize height if an acceleration of 50m/s2 is not to be exceeded?

matTt=linspace(1,15,1500);
maxyhmax=0;


for i=1:length(matTt)
    [ mpv, tv , t , y , acc ]= bengala(mpt, A, matTt(i), Isp, Mpl, diam, Cd );
    
    %check amximum acceleration
    accmax(i)=max(acc);
    
    %check maximum height
    thmax=interp1(y(50:end,2),t(50:end),0);   
    yhmax(i)=interp1(t,y(:,1),thmax);   

    
    if accmax(i)<50 && yhmax(i)>maxyhmax

        mpvmax=mpv;
        tvmax=tv;
        tmax=t;
        ymax=y;
        maxacc=acc;
        
        maxAccmax=accmax(i);
        maxyhmax=yhmax(i);
        maxTt=matTt(i);
    end
    
end

figure
subplot(2,1,1)
plot(matTt,yhmax)
title('Maximum altitude as function of Tt')
xlabel('Tt time(s)')
ylabel('Maximum altitude reached (m)')

subplot(2,1,2)
plot(matTt,accmax)
title('Maximum acceleration as function of Tt')
xlabel('Tt time(s)')
ylabel('Maximum aacceleration reached (m/s2)')

fprintf('3- Maximum height if 50m/s2 are not exceeded, A=1: %f [m] \n',maxyhmax)
fprintf('   Tt: %f [s] \n',maxTt)
fprintf('   Maximum acceleration: %f [s] \n',maxAccmax)

figure
subplot(3,1,1)
plot(tvmax,mpvmax)
title('Burn profile for maximum altitude')
xlabel('time(s)')
ylabel('Mass flow')


subplot(3,1,2)
plot(tmax,ymax)
title('State Variables vs time for maximum altitude')
legend('Height (m)','Velocity (m/s)','Mass (Kg)')
xlabel('time(s)')

subplot(3,1,3)
plot(tmax, maxacc)
title('Acceleration vs time for maximum altitude')
xlabel('time(s)')
ylabel('acceleration (m/s2)')