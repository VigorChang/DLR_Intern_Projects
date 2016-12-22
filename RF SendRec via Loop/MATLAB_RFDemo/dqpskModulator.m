function [iSig,qSig] = dqpskModulator(infoBit,bitRate,numSample)
%Setting
f0=bitRate;
T=1/bitRate;
t=T/numSample:T/numSample:T;

%DQPSK Modulation
spData=reshape(infoBit,2,length(infoBit)/2);

i_data=real(dpskmod(spData(1,:),2));
q_data=real(dpskmod(spData(2,:),2));

y_i=[];
y_q=[];
for i=1:length(infoBit)/2
    y1=i_data(i).*cos(2*pi*f0*t);
    y2=q_data(i).*sin(2*pi*f0*t);
    y_i=[y_i y1];
    y_q=[y_q y2];
end

iSig=y_i;
qSig=y_q;


end

