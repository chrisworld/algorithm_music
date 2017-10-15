function out = iircomb(in, d, g, ext)
% in: input vector
% d: delay [samples]
% g: gain in the recursive path (linear)
% ext: extension of the input signal [samples]
% out: output vector

% init vectors
in = [zeros(d+1,1); in; zeros(ext,1)];
y = zeros(length(in),1);
%yh = zeros(length(in),1);
xh = zeros(length(in),1);
y_filt = zeros(length(in),1);

% filter
%A = [1 -0.75];
%B = [0.125 0.125]/1.4125;

b0 = 0.125/1.4125
b1 = 0.125/1.4125
a0 = 1
a1 = -0.75

for n = d+1 : length(in)
	%yh(n) = g*y(n-d);
	%yh(n) = g * filter(B, A, y(n-d));
	xh(n) = y(n-d);
	y_filt(n) = b0*xh(n) + b1*xh(n-1) - a1*y_filt(n-1);
	y(n) = in(n) + g*y_filt(n);
end
out=y(d+1:end);