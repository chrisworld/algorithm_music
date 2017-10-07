% ------------------------------------------
% problem 1.3: 3 cos signals overlapping
% ------------------------------------------

% time, sample
t = 2.268e-3;
fs = 44100;
N = round(t*fs); 

% signal frequencies
f1 = 1000;
f2 = 4410;
f3 = 13000;

% phi
phi1 = 0;
phi2 = 0;
phi3 = pi/4;
%phi3 = 0

% amplitude
A1 = 1;
A2 = 1;
A3 = 0.5;

% theta
dTH1=2*pi*f1/fs;
dTH2=2*pi*f2/fs;
dTH3=2*pi*f3/fs;
TH1 = 0 : dTH1 : 2*pi*N*f1/fs-dTH1;
TH2 = 0 : dTH2 : 2*pi*N*f2/fs-dTH2;
TH3 = 0 : dTH3 : 2*pi*N*f3/fs-dTH3;

figure 1;
s1 = A1 * cos(TH1);
s2 = s1 + A2 * cos(TH2);
s3 = s2 + A3 * cos(TH3 + phi3);
plot (s1);
hold on
plot(s2,'r')
plot(s3,'g')
title('Blau: f=1000Hz, Rot: f=1000Hz & f=4410Hz, Gruen: f=1000Hz & f=4410Hz & f=13000');
xlabel('Signalfolge in Samples');
ylabel('Amplitude');
grid on


% ------------------------------------------
% problem 2.3: 3 cos signals overlapping
% ------------------------------------------

% noise signal
n1 = ((rand(1 ,N)) - 0.5) * 0.5;
s4 = s1 + n1;
plot (s4, 'k') 

% axis
f_axis = 0 : fs/N : fs-fs/N;
f_axis5 = 0 : fs/N/5 : fs-fs/N/5;
f_axis10 = 0 : fs/N/10 : fs-fs/N/10;

% FFT
S3 = fft(s3, N);
S35 = fft(s3, 5*N);
S310 = fft(s3, 10*N);

% plot
figure 2;
subplot(2,1,1);
plot(f_axis10, abs(S310), 'r')
hold on
stem(f_axis, abs(S3))
axis([0 22050 0 60])
title('FFT of s3 = 1kHz + 4.41kHz + 13kHz(+45°)');
xlabel('Frequency in [Hz]');
ylabel('Magnitude');

subplot(2,1,2);
plot(f_axis, angle(S3))
axis([0 22050 -pi pi])
grid on
xlabel('Frequency in [Hz]');
ylabel('Angle in [rad]');

% windowing
s3_hann = s3 .* hann(N)';

% FFT
S3_hann = fft(s3_hann, N);

% plot
figure 3;
subplot(2,1,1);
stem(f_axis, abs(S3_hann))
axis([0 22050 0 60])
title('FFT of s3 = 1kHz + 4.41kHz + 13kHz(+45°) mit Hanning window');
xlabel('Frequency in [Hz]');
ylabel('Magnitude');

subplot(2,1,2);
plot(f_axis, angle(S3_hann))
axis([0 22050 -pi pi])
grid on
xlabel('Frequency in [Hz]');
ylabel('Angle in [rad]');

% plot
figure 4;
subplot(2,1,1);
stem(f_axis10, abs(S310))
axis([0 22050 0 60])
title('FFT of s3 = 1kHz + 4.41kHz + 13kHz(+45°) high sampling fft');
xlabel('Frequency in [Hz]');
ylabel('Magnitude');

subplot(2,1,2);
plot(f_axis10, unwrap(angle(S310)))
axis([0 22050])
grid on
title('Unwraped');
xlabel('Frequency in [Hz]');
ylabel('Angle in [rad]');
