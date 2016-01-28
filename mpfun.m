function [ ret ] = mpfun(tv,mpt,A,Tt)

for i=1:length(tv)
    t=tv(i);
    if t<0 || t>Tt
        ret(i)=0;
        continue;
    end

    B=2*mpt/Tt; % kg/s

    if t<A
        ret(i)=B*t;
    else
        ret(i)=B-B/(Tt-A)*t+A*B/(Tt-A);
    end

end

end

