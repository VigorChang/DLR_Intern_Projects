function demodData = dqpskDemodulator(rx_i,rx_q,bitRate,numSample)
%Setting
T=1/bitRate;
%sample points
t=T/numSample:T/numSample:T;

%DQPSK Demodulation
rxIMulti=zeros(1,length(rx_i));
rxQMulti=zeros(1,length(rx_q));
for i=17:1:length(rx_i)
    %inphase
    rxIMulti(i)=rx_i(i)*rx_i(i-numSample);
    %quadrature
    rxQMulti(i)=rx_q(i)*rx_q(i-numSample);
end

rxIData=[];
rxQData=[];
for i=1:1:length(rxIMulti)/numSample
    %inphase
    z_i=rxIMulti((i-1)*numSample+1:i*numSample);
    z_i_intg=trapz(t,z_i)*(2/T);
    if(z_i_intg<0)
        rx_i_data=1;
    else
        rx_i_data=0;
    end
    %quadrature
    z_q=rxQMulti((i-1)*numSample+1:i*numSample);
    z_q_intg=trapz(t,z_q)*(2/T);
    if(z_q_intg<0)
        rx_q_data=1;
    else
        rx_q_data=0;
    end
    rxIData=[rxIData rx_i_data];
    rxQData=[rxQData rx_q_data];
end

demodData=zeros(1,2*length(rxIData));
demodData(1:2:2*length(rxIData)-1)=rxIData;
demodData(2:2:2*length(rxIData))=rxQData;

end

