close all
clear all
%pkg load signal   % Nur bei Octave

%=========================================================================

fs=44100;


%=========================================================================
% 7. Zeitverzoegerungsglieder
%=========================================================================


% FIR-Kammfilter
%=========================================================================

% Delay Line
del=10;
in=[1;zeros(49,1)];
gain=0.5;

dline=[zeros(del,1); in];
in=[in; zeros(del,1)];
out=in+gain.*dline;

% Plots___________________________________________________________________
if false
stem(out)
figure
spect(fft(out,1024),fs)
end



% Hallalgorithmen
%=========================================================================

% Hallsimulation (FIR, Spiegelquellen 1. Ordnung)
%------------------------------------------------

X1=6;
X2=4;
Y1=2;
Y2=4;
c=340;
fc=2000;   % TP 1. Ordnung
in=[1;zeros(1023,1)];

% Distanzen
d0=Y2;
d1=2*Y1+Y2;
d2=2*sqrt(X2^2+(0.5*Y2)^2);
d3=2*sqrt(X1^2+(0.5*Y2)^2);

% Delay in Samples
% v=d/t, del=fs*t
del0=round(fs*d0/c);
del1=round(fs*d1/c);
del2=round(fs*d2/c);
del3=round(fs*d3/c);

% Gain
g0=d0/d0;
g1=d0/d1;
g2=d0/d2;
g3=d0/d3;

len=length(in)+del3;
y0=zeros(len,1);
y1=zeros(len,1);
y2=zeros(len,1);
y3=zeros(len,1);

% Filterung
y0(del0+1:del0+length(in))=g0*in;
y1(del1+1:del1+length(in))=g1*allpassfilt1(in,fc,fs);
y2(del2+1:del2+length(in))=g2*allpassfilt1(in,fc,fs);
y3(del3+1:del3+length(in))=g3*allpassfilt1(in,fc,fs);

y=y0+y1+y2+y3;

if false
plot(y)
title('Impulsantwort FIR Spiegelquellen')
end



% Hallsimulation (IIR)
%---------------------

L=0.5;
G=-1;
fc=2000;
c=340;
in=[1;zeros(1023,1)];
ext=200;

d=round(fs*L/c);   % Delay in Samples


y=iircomb(in, d, G, ext);

if false
plot(y)
title('Impulsantwort IIR Kammfilter')
figure
spect(fft(y),fs)
title('Frequenzgang IIR Kammfilter')
end



% Delay Line Effekt (Allgemein)
%=========================================================================

fs=48000;
imp=[1;zeros(511,1)];

ystereo=audioread('piano1.wav');%(16000:end,:);
yl=ystereo(:,1);
yr=ystereo(:,2);
yl=yl/max(max(abs(yl)),max(abs(yr)));   % Normalisieren
%yr=yr/max(max(abs(yl)),max(abs(yr)));

in=yl;

% Parameter
ext=5000;
fc=10;      % TP 1. Ordnung fuer Rauschen
fm=3;       % Modulationsfrequenz
m=20;       % Modulationshub in Samples
BL=0;
FF=1;        
FB=0;    % Feedback Zweig
delay=0;   % Delay in ms



% Berechnung
%-----------
if false

d=round(fs*delay*10^(-3));   % Delay in Samples

% Initialisierung
x=[zeros(d+m+1,1);in;zeros(ext,1)];
xh=zeros(length(x),1);
yd=zeros(length(x),1);
y=zeros(length(x),1);
dv=zeros(length(x),1);

s=sinsig(fm,length(x(d+m+2:end)),fs);
n=randn(length(x(d+m+2:end)),1);
n=allpassfilt1(n,fc,fs,'lp');    % TP 1. Ordnung
n=allpassfilt1(n,fc,fs,'lp');
n=n/max(abs(n));

% Sinusmoduliertes Delay
if true
dv(d+m+2:end)=d+m+1+round(m*s(:));   % Verzoegerung um d+m+1
else
% TP Noisemoduliertes Delay
dv(d+m+2:end)=d+m+1+round(m*n(:));
end


% Loop
for n=d+m+2:length(x)
  xh(n)=x(n)+FB*xh(n-dv(n));
  yd(n)=FF*xh(n-dv(n));
  y(n)=yd(n)+BL*xh(n);
end

y=y(d+m+2:end);
in=[zeros(m+1,1);in];   % Verzoegerung des Eingangssignals um m+1
y(1:length(in))=y(1:length(in))+in;
y=y/max(abs(y));

figure 2
subplot(2,1,1)
plot(yl,'b')
hold on
plot(y,'r')
axis([0 length(y) -1 1])
title('Eingangs- und Ausgangssignal')
legend('Original','Bearbeitet')
subplot(2,1,2)
plot(dv(d+m+2:end))
title('Mod(n) des Delays')

p=audioplayer(y,fs,16);
%playblocking(p);
end
