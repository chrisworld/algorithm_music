function out = allpass2 (sig, fc,fb,fs)

% allpass2              - All pass filter second order
%
% out=allpass2(sig, fc, fb, fs)
% 
% Input parameters:
% - sig:    input signal (row vector)
% - fc:     cut-off frequency
% - fb:     bandwidth
% - fs:     sampling frequency
% Output parameter:
% - out:    output signal (row vector)

c=(tan(pi*fb/fs)-1)/(tan(pi*fb/fs)+1);
d=-cos(2*pi*fc/fs);
len=length(sig)+2;
y=zeros(len,1);
x=zeros(len,1);
x(3:len)=sig;

for n=3:len
    y(n) = -c*x(n)+d*(1-c)*x(n-1)+x(n-2)-d*(1-c)*y(n-1)+c*y(n-2);
end
out=y(3:end);