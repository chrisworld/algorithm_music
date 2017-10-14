function out=autowah(in, fc, fb, G, lfofc, lfofh, mix, fs)
% autowah - auto wah wah
% out=autowah(in, fc, fb, G, lfofc, lfofh, mix, fs)

% input parameters:
% in:			input
% fc:			center frequency [Hz]
% fb:			bandwidth [Hz]
% G:			gain [dB]
% lfofc:	LFO center frequency [Hz]
% lfofh:	LFO frequency hub
% mix:		ratio of dry (0) to wet (1)
% fs:			sampling frequency [Hz]

% check parameters
if nargin < 8
	error('example: out=autowah(in, fc, fb, G, lfofc, lfofh, mix, fs)')
end

% theta
len = length(in) + 2;
dth = 2*pi*lfofc/fs;
th = 0 : dth : 2*pi*len*lfofc/fs-dth;

% init vectors
y1 = zeros(len, 1);
y = zeros(len, 1);
x = zeros(len, 1);
x(3 : len) = in;
c = zeros(len, 1);

% coeff
b = (tan(pi * fb / fs) - 1) / (tan(pi * fb / fs) + 1);
c = -cos(2 * pi * (fc + lfofh * cos(th)) / fs);

% equations
for n = 3 : len
	y1(n) = -b*x(n) + c(n)*(1-b)*x(n-1) + x(n-2) - c(n)*(1-b)*y1(n-1) + b*y1(n-2);
	y(n) = ((10^(G/20) - 1) / 2) * (x(n) - y1(n)) + x(n);
end

out = y(3:end) * mix + x(3:end) * (1 - mix);