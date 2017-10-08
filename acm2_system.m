% ------------------------------------------
% problem 3.1: ytemidentification
% ------------------------------------------

% params
N = 200;
n_bits = 8;

% input signals
imp = [1; zeros(N,1)];

% system pie average
y_imp1 = asystem(imp);
%y_imp2 = asystem(imp,-40);
%y_imp3 = asystem(imp,-10);
for ii=1:4
	o(:,ii) = asystem(imp,-40);
end
y_imp2 = mean(o');
for ii=1:4
	o(:,ii) = asystem(imp,-10);
end
y_imp3 = mean(o');


% mls
m = mls(n_bits);
d = xcorr([m;m;m], m)/length(m);

% system with mls
y_mls1 = asystem([m; m; m]);
y_mls2 = asystem([m; m; m], -40);
y_mls3 = asystem([m; m; m], -10);

h_mls1 = xcorr(y_mls1, m)/length(m);
h_mls1 = h_mls1((4*length(m):5*length(m)-1));
h_mls2 = xcorr(y_mls2, m)/length(m);
h_mls2 = h_mls2((4*length(m):5*length(m)-1));
h_mls3 = xcorr(y_mls3, m)/length(m);
h_mls3 = h_mls3((4*length(m):5*length(m)-1));

% plot
figure 1;
subplot(2,2,1);
plot(h_mls2)
hold on
plot(y_imp2, 'r--')
title('asystem mls -40db');
xlabel('samples');
ylabel('magnitude');
grid on
subplot(2,2,3);
plot(etc(h_mls2))
hold on
plot(etc(y_imp2), 'r--')
title('asystem mls -40db');
xlabel('samples');
ylabel('magnitude db');
grid on
subplot(2,2,2);
plot(h_mls3)
hold on
plot(y_imp3, 'r--')
title('asystem mls -10db');
xlabel('samples');
ylabel('magnitude');
grid on
subplot(2,2,4);
plot(etc(h_mls3))
hold on
plot(etc(y_imp3), 'r--')
title('asystem mls -10db');
xlabel('samples');
ylabel('magnitude db');
grid on

% check mls code
%hr = xcorr(y_mls2, m)/length(m);
%hr = hr(4*length(m):5*length(m)-1);
%figure 2;
%plot(hr)
%plot(etc(hr))

% analyse system
fs = 48000;
figure 2;
title('asystem fft');
spect(fft(y_imp1), fs)

% sweep
[sw, isw] = expsweep(50,18000,1,48000);

figure 3;
spect(fft(sw),48000);

figure 4;
subplot(1,2,1);
specgram(sw,256,48000);
subplot(1,2,2);
% entspricht: spectrogram(sw,256,128,256,48000,'yaxis');
specgram(isw,256,48000);

nges = length(sw) + length(isw) - 1;
d = real(ifft(fft(sw,nges) .* fft(isw,nges)));

figure 5;
plot(etc(d))
%spect(fft(d))

% system with sweep and nonlinear
lag = 255;
y_sw1 = asystem([sw; zeros(lag,1)], []); 
y_sw2 = asystem([sw; zeros(lag,1)], [], -40); 
y_sw3 = asystem([sw; zeros(lag,1)], [], -10); 

figure 6;
subplot(1,3,1)
specgram(y_sw1,256,48000);
subplot(1,3,2)
specgram(y_sw2,256,48000);
subplot(1,3,3)
specgram(y_sw3,256,48000);

nges = length(sw) + length(isw) + lag - 1;
h_sw1 = real(ifft(fft(y_sw1,nges) .* fft(isw,nges)));
h_sw1 = h_sw1(length(sw) : length(sw) + lag);
h_sw2 = real(ifft(fft(y_sw2,nges) .* fft(isw,nges)));
h_sw2 = h_sw2(length(sw) : length(sw) + lag);
h_sw3 = real(ifft(fft(y_sw3,nges) .* fft(isw,nges)));
h_sw3 = h_sw3(length(sw) : length(sw) + lag);


% plot sweep to imp
figure 7;
subplot(2,2,1);
plot(h_sw2)
hold on
plot(y_imp2, 'r--')
title('asystem sweep -40db');
xlabel('samples');
ylabel('magnitude');
grid on
subplot(2,2,3);
plot(etc(h_sw2))
hold on
plot(etc(y_imp2), 'r--')
title('asystem sweep -40db');
xlabel('samples');
ylabel('magnitude db');
grid on
subplot(2,2,2);
plot(h_sw3)
hold on
plot(y_imp3, 'r--')
title('asystem sweep -10db');
xlabel('samples');
ylabel('magnitude');
grid on
subplot(2,2,4);
plot(etc(h_sw3))
hold on
plot(etc(y_imp3), 'r--')
title('asystem sweep -10db');
xlabel('samples');
ylabel('magnitude db');
grid on

% plot sweep to mls
figure 8;
subplot(2,2,1);
plot(h_sw2)
hold on
plot(h_mls2, 'r--')
title('asystem sweep -40db');
xlabel('samples');
ylabel('magnitude');
grid on
subplot(2,2,3);
plot(etc(h_sw2))
hold on
plot(etc(h_mls2), 'r--')
title('asystem sweep -40db');
xlabel('samples');
ylabel('magnitude db');
grid on
subplot(2,2,2);
plot(h_sw3)
hold on
plot(h_mls3, 'r--')
title('asystem sweep -10db');
xlabel('samples');
ylabel('magnitude');
grid on
subplot(2,2,4);
plot(etc(h_sw3))
hold on
plot(etc(h_mls3), 'r--')
title('asystem sweep -10db');
xlabel('samples');
ylabel('magnitude db');
grid on

% audio
% create recorder object with CH channels

% choose output
out = m;
out = sw;
CH = 1;
% record and play
r = audiorecorder(fs, 16, CH); 
p = audioplayer(out, fs);
record(r);
playblocking(p);
stop(r);
Y = getaudiodata(r);

figure 9;
spect(fft(Y), fs)

figure 10;
specgram(Y,256,48000);
