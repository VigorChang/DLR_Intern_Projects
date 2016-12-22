function info = findInfo(demodData,ASMBits)
ASMLength=length(ASMBits);
%Find asynchronous marker
for i=1:1:length(demodData)
    testMarker=demodData(i:(i+ASMLength-1));
    if(testMarker==ASMBits)
        packetStart=i+ASMLength;
        infoStart=packetStart+16;
        display(i);
        break;
    end
end
%Get the length of packet
lengthBits=demodData(packetStart:(packetStart+15));
infoLength=bi2de(lengthBits,'left-msb');
%Get the info
info=demodData(infoStart:(infoStart+infoLength-1));

end

