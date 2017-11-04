% parameter
fs = 44100;
fc = 10000;
G = 0.2;
typ = 'lp';

% shelvfilt
imp = [1; zeros(1024,1)];
%out = shelvfilt(imp, fc, G, fs, typ);
out = allpass1 (imp, fc,fs);
spect(fft(out), fs);

