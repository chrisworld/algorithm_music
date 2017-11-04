function out = allpass1 (sig, fc,fs)

% allpass1              - All pass filter first order
%
% out=allpass1(sig, fc, fs)
% 
% Input parameters:
% - sig:    input signal (row vector)
% - fc:     cut-off frequency
% - fs:     sampling frequency
% Output parameter:
% - out:    output signal (row vector)

% (c) 2002 Piotr Majdak

c=(tan(pi*fc/fs)-1)/(tan(pi*fc/fs)+1);
disp(c);
len=length(sig)+1;
y=zeros(len,1);
x=zeros(len,1);
x(2:len)=sig;

for n=2:len
    y(n)=c*x(n)+x(n-1)-c*y(n-1);
end
out=y(2:end);