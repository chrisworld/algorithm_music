% ------------------------------------------
% problem 4.3: state var filter
% ------------------------------------------

% parameter
fs = 44100;
% low pass
fcl = 5000;
% band pass
db = 0.2;
% high pass
fch = 4000;


imp = [1; zeros(1024,1)];

% low pass
for dl = 0.4 : 0.2 : 1.4 
	out = statevar(imp, fcl, dl, fs, 'lp');
	figure 1;
	spect(fft(out), fs);
	hold on
	grid on
end

% band pass
for fcb = 2000 : 1000 : 5000
	out = statevar(imp, fcb, db, fs, 'bp');
	figure 2;
	spect(fft(out), fs);
	hold on
	grid on
end

% high pass
for dh = 0 : 0.1 : 0.3 
	out = statevar(imp, fch, dh, fs, 'hp');
	figure 3;
	spect(fft(out), fs);
	hold on
	grid on
end

% ------------------------------------------
% problem 4.7: peak filter
% ------------------------------------------

G = 3;
fc = 5000;
fb = 1000;

out = peakfilt(imp, fc, fb, G, fs);
figure 4;
spect(fft(out), fs);
hold on
grid on


% ------------------------------------------
% problem: autowah
% ------------------------------------------

G = 40;
N = 2 * fs;
noise = randn(1, N);
fc = 1000;
fb = 500;
lfofc = 1;
lfofh = 200; 
mix = 1;
out = autowah(noise, fc, fb, G, lfofc, lfofh, mix, fs);

figure 5;
specgram(out, 256, fs);

% audio out
% choose output
p = audioplayer(out, fs);
playblocking(p);