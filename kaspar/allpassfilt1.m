function out=allpassfilt1(in,fc,fs,typ)

% allpassfilt1 - All pass filter first order, lp/hp
% 
% Input parameters:
% - in:     input signal (Spaltenvektor)
% - fc:     cut-off frequency
% - fs:     sampling frequency
% - typ:    'lp' or 'hp', default 'lp'
% Output parameter:
% - out:    output signal (Spaltenvektor)

% Filtertyp
if ~exist('typ') || typ=='lp'
  sig=1;
elseif typ=='hp'
  sig=-1;
else
  disp('Wrong type')
  out=0;
  return
endif

c=(tan(pi*fc/fs)-1)/(tan(pi*fc/fs)+1);

ord=1;                 % Filterordnung 1
len=length(in)+ord;    % Initialisierung der Vektoren x, y und a
x=[zeros(ord,1);in];
y=zeros(len,1);
a=zeros(len,1);

for n=ord+1:len
a(n)=c*x(n)+x(n-1)-c*a(n-1);
y(n)=0.5*(x(n)+sig*a(n));

end
a=a(ord+1:end);
out=y(ord+1:end);