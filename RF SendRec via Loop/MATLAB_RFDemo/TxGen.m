function [bitData,info] = TxGen(dataLength,ASMBits)
%Generate length bits
lenBits=de2bi(dataLength,16,'left-msb');
%Generate Preamble bits
preBits=randi([0 1],1,128);
%Generate info bits
info=randi([0 1],1,dataLength);
%Generate packet
bitData=[preBits ASMBits lenBits info];

end

