function out=statevar(in,fc,d,fs,typ)

% statevar - digital state variable filter
% out=statevar(in,fc,d,fs, [typ])
% input
%
% parameters:
% in:		input signal
% fc:		cut-off frequency [Hz]
% d:		damping factor
% fs: 	sampling frequency
% typ: 	type of filter ('lp', 'bp', 'hp'), optional (default='lp')

% check parameters
if nargin < 5
	typ = 'lp';
end
if nargin < 4
	error('example: out=statevar(in,fc,d,fs,(typ))')
end

% coeff
F = 2 * sin(pi * fc / fs);
Q = 2 * d;
len = length(in) + 1;

% init vectors
yh = zeros(len, 1);
yb = zeros(len, 1);
yl = zeros(len, 1);
x = zeros(len, 1);
x(2 : len) = in;

% equations
for n = 2 : len
	yh(n) = x(n) - yl(n-1) - Q * yb(n-1);
	yb(n) = F * yh(n) + yb(n-1);
	yl(n) = F * yb(n) + yl(n-1);
end

switch lower(typ)
	case('lp')
		out = yl(2:end);
	case('bp')
		out = yb(2:end);
	case('hp')
		out = yh(2:end);
	otherwise
		out = yl(2:end);
end
end