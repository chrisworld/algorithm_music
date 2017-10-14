function out=peakfilt(in,fc,fb,G,fs)
% peakfilt - peak filter, second order
% out=peakfilt(in,fc,fb,G,fs)
%
% parameters:
% in:		input signal
% fc:		cut-off frequency [Hz]
% fb:		bandwidth [Hz]
% G: 		gain [dB]
% fs: 	sampling frequency

% check parameters
if nargin < 5
	error('example: out=peakfilt(in,fc,fb,G,fs')
end

% coeff
len = length(in) + 2;
b = (tan(pi * fb / fs) - 1) / (tan(pi * fb / fs) + 1);
c = -cos(2 * pi * fc / fs);

% init vectors
y1 = zeros(len, 1);
y = zeros(len, 1);
x = zeros(len, 1);
x(3 : len) = in;

% equations
for n = 3 : len
	y1(n) = -b * x(n) + c * (1 - b) * x(n-1) + x(n-2) - c * (1 - b) * y1(n-1) + b * y1(n-2);
	y(n) = ((10^(G/20) - 1) / 2) * (x(n) - y1(n)) + x(n);
end

out = y(3:end);