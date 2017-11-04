function out=shelvfilt(in,fc,G,fs,typ)

% shelvfilt        - shelving filter, first order
% out=shelvfilt(in,fc,g,fs)
%
% input parameters:
% in:   input signal
% fc:   cut-off frequency [Hz]
% G:    gain [dB]
% fs:   sampling frequency [Hz]
% typ:  type of filter ('lp', 'hp'), optional (default='lp')


c=(tan(pi*fc/fs)-1)/(tan(pi*fc/fs)+1);
H=10^(G/20)-1;
H=H/2;
if ~exist('typ')
    k=1;
elseif typ=='hp'
    k=-1;
else
    k=1;
end
len=length(in)+1;
y=zeros(len,1);
x=zeros(len,1);
yh=zeros(len,1);
x(2:len)=in;

for n=2:len
    yh(n)=c*x(n)+x(n-1)-c*yh(n-1);
    y(n)= H*(x(n)+k*yh(n))+x(n);
end
out=y(2:end);