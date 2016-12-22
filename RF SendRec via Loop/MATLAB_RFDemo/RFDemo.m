close all;
clear all;
clc;
%Setting
dataLength=1366;
bitRate=1E6;
numSample=16;
%ASM bits
ASMBits=[1 0 1 1 0 0 1 0 ... B2
         1 0 0 0 1 0 1 0 ... 8A
         0 0 0 0 1 1 1 0 ... 0E
         1 1 0 0 0 1 0 1 ... A5
         1 0 1 1 0 0 1 0 ... B2
         1 0 0 0 1 0 1 0 ... 8A
         0 0 0 0 1 1 1 0 ... 0E
         1 1 0 0 0 1 0 1 ... A5
         ];
%Generate info bits
[bitData,info]=TxGen(dataLength,ASMBits);
%Add some head bits and tail bits
hBits=randi([0 1],1,18);
tBits=randi([0 1],1,50);
bitData=[hBits bitData tBits];
%DQPSK Modulation
[iSig,qSig]=dqpskModulator(bitData,bitRate,numSample);
%DQPSK Demodulation
demodData=dqpskDemodulator(iSig,qSig,bitRate,numSample);
%Find packet
infoDemod=findInfo(demodData,ASMBits);

error=length(find(info~=infoDemod));
display(error);