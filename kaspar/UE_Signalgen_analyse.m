close all
clear all
pkg load signal   % Nur bei Octave

%=========================================================================

fs=44100;


%=========================================================================
% 1 Signalgenerierung
%=========================================================================

t=2.268e-3;      % Zeitfenster

N=round(fs*t);   % Anzahl der Samples


f1=1000;
A1=1;
dTH1=2*pi*f1/fs;
TH1=0:dTH1:(N-1)*dTH1;         % ist das
TH1=0:dTH1:2*pi*N*f1/fs-dTH1;  % gleiche

s1=A1*cos(TH1);
%--------------

f2=4410;
A2=1;
dTH2=2*pi*f2/fs;
TH2=0:dTH2:(N-1)*dTH2;

s2=s1+A2*cos(TH2);
%-----------------

f3=13000;
A3=0.5;
phi3=45;
dTH3=2*pi*f3/fs;
TH3=0:dTH3:(N-1)*dTH3;

s3=s2+A3*cos(TH3+phi3*2*pi/360);
%-------------------------------

sn=(rand(1,N)-0.5).*0.5;    % Noise Signal
s4=s1+sn;
%--------


% Plot____________________________________________________________________
if false
figure
hold all
plot(s1, 'b')
plot(s2, 'r')
plot(s3, 'g')
plot(s4, 'm')
title('Signalgenerierung')
legend('s1','s2','s3','s4')
ylabel('Amplitude')
xlabel('Samples')
grid   % Raster
endif



%=========================================================================
% 2. Signalanalyse
%=========================================================================

f2=abs(fft(s2));

fax=0:fs/N:fs-fs/N;               % Frequenzachsenvektor
fax10=0:fs/(N*10):fs-fs/(N*10);   % genauerer Frequenzachsenvektor

% Plot____________________________________________________________________
if false
figure
hold all
f10=abs(fft(s2,10*N));
stem(fax,f2,'b')
plot(fax10,f10,'g')
axis([0 8000 0 55])
title('Sinc Impulse durch Fensterungseffekte')
legend('fft100','fft1000')
xlabel('Frequency in Hz')
ylabel('Amplitude')
grid
endif



% Frequenzgang von s3
%-------------------------------------------------------------------------
fax=0:fs/N:fs-fs/N;
fs3=(fft(s3));

% Plot____________________________________________________________________
if false
figure
subplot(2,1,1)
stem(fax,abs(fs3),'b')
axis([0 22050 0 55])
title('Frequenzgang von s3 (Rechteckfenster)')
xlabel('Frequency in Hz')
ylabel('Amplitude')
subplot(2,1,2)
plot(fax,unwrap(angle(fs3)))
xlabel('Frequency in Hz')
ylabel('Phase')
axis([0 22050 -pi pi])
grid
endif



% Verschiedene Fensterfunktionen
%-------------------------------------------------------------------------

n=10;
faxn=0:fs/(n*N):fs-fs/(n*N);


% 1. Rechteck
%------------
Rec=rectwin(N).';
s3Rec=s3.*Rec;
fRec=fft(s3Rec,n*N);

% 2. Dreieck
%------------
Tri=triang(N).';
s3Tri=s3.*Tri;
fTri=fft(s3Tri,n*N);

% 3. Hann
%------------
Han=hann(N).';
s3Han=s3.*Han;
fHan=fft(s3Han,n*N);

% 4. Hamming
%------------
Ham=hamming(N).';
s3Ham=s3.*Ham;
fHam=fft(s3Ham,n*N);

% 5. Kaiser
%------------
Kai=kaiser(N,0.8).';
s3Kai=s3.*Kai;
fKai=fft(s3Kai,n*N);


% Plots___________________________________________________________________
if false
figure

subplot(5,2,1)   % Rechteck
plot(faxn,abs(fRec))
title('Rechteck')
ylabel('Amplitude')
xlabel('Frequency')
axis([0 22050 0 55])
grid
subplot(5,2,2)
plot(Rec)
axis([0 100 0 1.2])
xlabel('Samples')

subplot(5,2,3)   % Dreieck
plot(faxn,abs(fTri))
title('Dreieck')
ylabel('Amplitude')
xlabel('Frequency')
axis([0 22050 0 55])
grid
subplot(5,2,4)
plot(Tri)
axis([0 100 0 1.2])
xlabel('Samples')

subplot(5,2,5)   % Hann
plot(faxn,abs(fHan))
title('Hann')
ylabel('Amplitude')
xlabel('Frequency')
axis([0 22050 0 55])
grid
subplot(5,2,6)
plot(Han)
axis([0 100 0 1.2])
xlabel('Samples')

subplot(5,2,7)   % Hamming
plot(faxn,abs(fHam))
title('Hamming')
ylabel('Amplitude')
xlabel('Frequency')
axis([0 22050 0 55])
grid
subplot(5,2,8)
plot(Ham)
axis([0 100 0 1.2])
xlabel('Samples')

subplot(5,2,9)   % Kaiser
plot(faxn,abs(fKai))
title('Kaiser')
ylabel('Amplitude')
xlabel('Frequency')
axis([0 22050 0 55])
grid
subplot(5,2,10)
plot(Kai)
axis([0 100 0 1.2])
xlabel('Samples')
endif