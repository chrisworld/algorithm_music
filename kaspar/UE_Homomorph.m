close all
clear all
pkg load signal   % Nur bei Octave

%=========================================================================

fs=44100;


%=========================================================================
% 8. Homomorphe Signalverarbeitung
%=========================================================================


% 8.1 Dynamik
%=========================================================================

fs=48000;
fc=70;

ystereo=audioread('piano2.wav');
p=audioplayer(ystereo,fs,16);
%playblocking(p);
yl=ystereo(:,1);
yr=ystereo(:,2);

% Plots und Berechnungen__________________________________________________
if true
figure
subplot(2,2,1)
plot(yl)
title('Eingangssignal')

% Logarithmierung
yllog=log10(abs(yl)+0.0001);

subplot(2,2,2)
plot(yllog)
title('Logarithmiertes Eingangssignal')

% FFT
YL=fft(yllog);

subplot(2,2,3)
spect(YL,fs,'a')
title('FFT des logarithm. Signals')

% Fensterung
W=ones(length(YL),1);
bin=round(fc*length(YL)/fs);
dyn=interp1(0:bin/2:bin,[0 0.5 1],0:1:bin);
W(1:length(dyn))=dyn;
W(end-length(dyn)+1:end)=fliplr(dyn);

SL=W.*YL;
DL=(-W+1).*YL;

subplot(2,2,4)
plot(W(1:3*bin),'b')
hold on
plot(-W(1:3*bin)+1,'r')
title('Fensterung der FFT')
legend('Signal','Dynamik')

% Rueckrechnen der Signale
sllog=real(ifft(SL));   % IFFT
dllog=real(ifft(DL));

sl=10.^sllog;         % Entlogarithmieren
dl=10.^dllog;
sl=sl.*sign(yl);      % Wiederherstellung des Vorzeichens
sl=sl/max(abs(sl));   % Normalisieren
dl=dl/max(abs(dl));

figure
subplot(2,1,1)
plot(yl/max(abs(yl)),'b')
hold on
plot(dl,'r')
title('Getrennte Dynamik und Signal')
subplot(2,1,2)
plot(sl,'r')
hold on
plot(yl,'b')
title('Originalsignal und bearbeitetes')

p=audioplayer(sl,fs,16);
%playblocking(p);
endif