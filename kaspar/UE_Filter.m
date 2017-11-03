close all
clear all
pkg load signal   % Nur bei Octave

%=========================================================================

fs=44100;


%=========================================================================
% 4. Filter (IIR)
%=========================================================================

imp=[1; zeros(1023,1)];


% Biquad-Filter
%=========================================================================

out=biquad_lp(imp,16000,0.5,fs);

% Plots___________________________________________________________________
if true
figure
subplot(2,2,1)
plot(out(1:100));
title('Biquad TP: Impulsantwort')
subplot(2,2,3)
spect(fft(out),44100,'a');
title('Amplitudengang')
subplot(2,2,4)
spect(fft(out),44100,'p');
title('Phasengang')
endif



% State Variable Filter
%=========================================================================

fc=5000;
d=0.5;
typ='lp';

% Plots___________________________________________________________________
if false
out=statevar(imp,fc,d,fs,typ);

figure
subplot(2,2,1)
plot(out(1:100));
title('State Variable Filter: Impulsantwort')
subplot(2,2,3)
spect(fft(out),44100,'a');
title('Amplitudengang')
subplot(2,2,4)
spect(fft(out),44100,'p');
title('Phasengang')
endif



% Allpass Filter
%=========================================================================

% Allpass 1. Ordnung
%-------------------

fc=5000;

c=(tan(pi*fc/fs)-1)/(tan(pi*fc/fs)+1);

ord=1;                 % Filterordnung 1
len=length(imp)+ord;   % Initialisierung der Vektoren x, y und a
x=[zeros(ord,1);imp];
ybp=zeros(len,1);
ybs=zeros(len,1);
a=zeros(len,1);

for n=ord+1:len
a(n)=c*x(n)+x(n-1)-c*a(n-1);
ylp(n)=0.5*(x(n)+a(n));
yhp(n)=0.5*(x(n)-a(n));
end
a=a(ord+1:end);
ylp=ylp(ord+1:end);
yhp=yhp(ord+1:end);

% Plots___________________________________________________________________
if false
figure
subplot(2,2,1)
spect(fft(a),fs,'a')
title('Frequenzgang Allpass 1. Ordnung')
axis([0 0.5*fs -5 5])
subplot(2,2,3)
spect(fft(a),fs,'p')
subplot(2,2,2)
spect(fft(ylp),fs,'a','b')
hold on
spect(fft(yhp),fs,'a','r')
axis([0 0.5*fs -60 10])
title('Frequenzgang Filter 1. Ordnung')
legend('LP','HP')
subplot(2,2,4)
spect(fft(ylp),fs,'p','b')
hold on
spect(fft(yhp),fs,'p','r')
legend('LP','HP')
endif



% Allpass 2. Ordnung
%-------------------

fc=10000;   % Grenzfrequenz
fb=2000;   % Bandbreite

b=(tan(pi*fb/fs)-1)/(tan(pi*fb/fs)+1);
c=-cos(2*pi*fc/fs);

ord=2;                 % Filterordnung 2
len=length(imp)+ord;   % Initialisierung der Vektoren x, y und a
x=[zeros(ord,1);imp];
ybs=zeros(len,1);
ybp=zeros(len,1);
a=zeros(len,1);

for n=ord+1:len
a(n)=-b*x(n)+c*(1-b)*x(n-1)+x(n-2)-c*(1-b)*a(n-1)+b*a(n-2);
ybs(n)=0.5*(x(n)+a(n));
ybp(n)=0.5*(x(n)-a(n));
end
a=a(ord+1:end);
ybs=ybs(ord+1:end);
ybp=ybp(ord+1:end);


% Plots___________________________________________________________________
if false
figure
subplot(2,2,1)
spect(fft(a),fs,'a')
title('Frequenzgang Allpass 2. Ordnung')
axis([0 0.5*fs -5 5])
subplot(2,2,3)
spect(fft(a),fs,'p')
subplot(2,2,2)
spect(fft(ybs),fs,'a','b')
hold on
spect(fft(ybp),fs,'a','r')
axis([0 0.5*fs -60 10])
title('Frequenzgang Filter 2. Ordnung')
legend('BS','BP')
subplot(2,2,4)
spect(fft(ybs),fs,'p','b')
hold on
spect(fft(ybp),fs,'p','r')
legend('BS','BP')
endif



% Equalizer
%=========================================================================

% Shelving Filter
%----------------

fc=100;
G=-20;

% Plots___________________________________________________________________
if true

ylp=shelvfilt(imp,fc,G,fs,'lp');
yhp=shelvfilt(imp,fc,G,fs,'hp');

figure
subplot(2,1,1)
spect(fft(ylp),fs,'a','b')
hold on
spect(fft(yhp),fs,'a','r')
title('Frequenzgang Shelving Filter')
legend('LP','HP')
subplot(2,1,2)
spect(fft(ylp),fs,'p','b')
hold on
spect(fft(yhp),fs,'p','r')
legend('LP','HP')
endif


% Peak/Notch Filter
%------------------

fc=10000;
fb=500;
G=6;

y=peakfilt(imp,fc,fb,G,fs);

% Plots___________________________________________________________________
if false
figure
subplot(2,1,1)
spect(fft(peakfilt(imp,fc,fb,6,fs)),fs,'a','b')
hold on
spect(fft(peakfilt(imp,fc,fb,-6,fs)),fs,'a','r')
title('Frequenzgang Peak/Notch Filter')
legend('Peak','Notch')
subplot(2,1,2)
spect(fft(peakfilt(imp,fc,fb,6,fs)),fs,'p','b')
hold on
spect(fft(peakfilt(imp,fc,fb,-6,fs)),fs,'p','r')
legend('Peak','Notch')
endif



% Zeitvariante Filter
%=========================================================================

% Autowah
%--------

fc=10000;
fb=500;
G=12;
lfofc=2;
lfofh=5000;
mix=1;
t=1;
in=randn(t*fs,1);

% Plots und Berechnung____________________________________________________
if false

y=autowah(in,fc,fb,G,lfofc,lfofh,mix,fs);
ynorm=y/max(abs(y));    % Normalisierter Ausgangsvektor

p=audioplayer(ynorm,fs,16);
%playblocking(p);

figure
specgram(y,256,fs)
endif

