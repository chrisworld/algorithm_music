function out = iircomb(in, d, g, ext)
% in: input vector
% d:  delay [samples]
% ext: extension of the input signal [samples]
% out: output vector

in=[zeros(d+1,1); in; zeros(ext,1)];
y=zeros(length(in),1);
for n=d+1:length(in)
    yh(n) = g*y(n-d);
    y(n)=in(n)+yh(n);
end
out=y(d+1:end);