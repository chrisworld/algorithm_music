close all
clear all
pkg load signal   % Nur bei Octave

%=========================================================================

fs=44100;


%=========================================================================
% 3. Systemidentifikation
%=========================================================================


% 1. Impulsantwort (ideale Messung)
%-------------------------------------------------------------------------

imp=[1;zeros(511,1)];   % Anregungsimpuls
Himp=asystem(imp);

% Plots___________________________________________________________________
if false
figure
subplot(2,2,1)
plot(Himp)
title('Impulsantwort (ideale Messung)')
ylabel('Amplitude')
xlabel('Sample')
subplot(2,2,2)
plot(etc(Himp))
ylabel('Amplitude in dB')
xlabel('Sample')
axis([0 512 -200 0])
subplot(2,2,3)
spect(fft(Himp),fs,'a')
title('Amplitudengang')
subplot(2,2,4)
spect(fft(Himp),fs,'p')
title('Phasengang')
endif



% 2. MLS
%-------------------------------------------------------------------------

m=mls(9);   % Length=2^9=512 Samples

if true

% Einmalige Messung
ymls=asystem([m;m;m],-20);
Hmls=xcorr(ymls,m)/length(m);           % Berechnet Kreuzkorrelation
Hmls=Hmls(4*length(m):5*length(m)-1);   % Länge der Impulsantwort
Hmls=Hmls+(1/(length(m)+1));            % Amplitudenoffset rausrechnen
else

% Mehrfache Messung
for i=1:16
ymls(:,i)=asystem([m;m;m],-20);
H=xcorr(ymls(:,i),m)/length(m);
H=H(4*length(m):5*length(m)-1);
Hi(:,i)=H+(1/(length(m)+1));
end
Hmls=mean(Hi.');
endif


% Plots___________________________________________________________________
if false
figure
subplot(2,2,1)
plot(Hmls)
title('Impulsantwort MLS')
ylabel('Amplitude')
xlabel('Sample')
subplot(2,2,2)
plot(etc(Hmls))
ylabel('Amplitude in dB')
xlabel('Sample')
axis([0 512 -200 0])
subplot(2,2,3)
spect(fft(Hmls),fs,'a')
title('Amplitudengang')
subplot(2,2,4)
spect(fft(Hmls),fs,'p')
title('Phasengang')
endif



% 3. Exponentieller Sweep
%-------------------------------------------------------------------------

fu=50;      % Untere Frequenz des Sweeps
fo=18000;   % Obere Frequenz des Sweeps
t=1;        % Dauer das Sweeps in Sekunden
[sw,isw]=expsweep(fu,fo,t,fs);

lag=511;
nges=length(sw)+length(isw)+lag-1;
ysw=asystem([sw;zeros(lag,1)],-50,-10);       % Filterung des Sweeps

H=real(ifft(fft(ysw,nges).*fft(isw,nges)));   % Berechnung der Impulsantw.
Hsw=H(length(sw):length(sw)+lag);


% Klirrfaktor
%------------

nmax=6;   % Maximale Anzahl der Teiltöne

n=round(t*fs-t*fs*log(1:nmax)/log(fo/fu));
hm=zeros(lag+1,nmax);
hamp=zeros(fs/2,nmax);
for i=1:nmax
hm(:,i)=H(n(i):n(i)+lag);
htemp=abs(fft(hm(:,i),fs));
htempdB=20*log10(htemp);
hamp(:,i)=htemp(1:fs/2);
hampdB(:,i)=htempdB(1:fs/2);
end
clear htemp;
clear htempdB;

fk=2759;
zk=sum(hamp(fk,2:nmax).^2);
nk=hamp(fk,1).^2+zk;
k=(sqrt(zk/nk)).*100;   % Klirrfaktor bei f=fk

% Plots___________________________________________________________________
if false
figure
subplot(2,2,1)
plot(Hsw)
title('Impulsantwort Sweep')
ylabel('Amplitude')
xlabel('Sample')
subplot(2,2,2)
plot(etc(Hsw))
ylabel('Amplitude in dB')
xlabel('Sample')
axis([0 512 -200 0])
subplot(2,2,3)
spect(fft(Hsw),fs,'a')
title('Amplitudengang')
subplot(2,2,4)
spect(fft(Hsw),fs,'p')
title('Phasengang')

figure
subplot(2,2,1)
specgram(ysw,512,fs)
title('Spectrogram')
subplot(2,2,2)
plot(etc(H))
axis([10000 150000 -120 0])
title('Impulsantwort mit harmonischen Verzerrungen')
subplot(2,2,3)
for i=1:nmax
plot(hampdB(:,i))
hold all
end
title('Amplituden der Teiltoene')
axis([0 10000 -110 0])
endif



% Durchmessen der Soundkarte
%-------------------------------------------------------------------------

bitrate=16;
ch=1;
delmax=20000;   % Maximales Delay in Samples

% Impuls
%-------
if false
l=511;
in=[1;zeros(delmax+l,1)];
r = audiorecorder(fs,bitrate,ch);   % create recorder object
p = audioplayer(in,fs,bitrate);     % create player object

record(r);           % start recording
playblocking(p);     % play OUT and wait until done
stop(r);             % stop recording
Y=getaudiodata(r);   % retrieve the recorder data to Y

delay=sysimp(Y,fs,l)
endif


% Sweep
%------
if false
t=5;
fu=20;
fo=20000;
delmax=20000;   % Max Delay in Samples

sw=expsweep(fu,fo,t,fs);
in=[sw;zeros(delmax,1)];

r = audiorecorder(fs,bitrate,ch);
p = audioplayer(in,fs,bitrate);

record(r);
playblocking(p);
stop(r);
Y=getaudiodata(r);

del=1;
while Y(del++)<0.01    % Checkt Delay
end
Y=Y(del:length(sw)+del-1);    % Kürzt Systemantwort

k=syssweep(Y,fs,fu,fo,t,lag,nmax,fk)
endif


% MLS
%----
if false
m=mls(9);   % Length=2^9=512 Samples
n=1;

in=[m;m;m;zeros(delmax,1)];
r = audiorecorder(fs,bitrate,ch);
p = audioplayer(in,fs,bitrate);

for i=1:n
record(r);
playblocking(p);
stop(r);
Ytemp=getaudiodata(r);
del=1;   % Delay Check
while Ytemp(del++)<0.01    % Checkt Delay
end
Y(:,i)=Ytemp(del:del+3*length(m)-1);    % Kürzt Systemantwort
end
sysmls(m,Y,fs,n);
endif

