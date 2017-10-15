% ------------------------------------------
% problem: Hallsimulator
% ------------------------------------------

% parameter
fcl = 2000;
c = 340;
fs = 44100;
x1 = 6;
x2 = 4;
y1 = 2;
y2 = 4;

% input
N = 2048;
imp = [1; zeros(N,1)];


% distance
d0 = y2;
d1 = y2 + 2*y1;
d2 = sqrt(y2^2 + (2*x2)^2);
d3 = sqrt((2*x1)^2 + y2^2);

% delay in seconds
dt = 1 / fs;
T = dt * N;

% delay samples
delay0_samples = round(d0/c/dt * (N/fs));
delay1_samples = round(d1/c/dt * (N/fs));
delay2_samples = round(d2/c/dt * (N/fs));
delay3_samples = round(d3/c/dt * (N/fs));

% direct source
dline0 = [zeros(delay0_samples,1); imp];

% reflections
y_wall = statevar(imp, fcl, 0.7, fs, 'lp');

dline1 = [zeros(delay1_samples,1); y_wall];
dline2 = [zeros(delay2_samples,1); y_wall];
dline3 = [zeros(delay3_samples,1); y_wall];

z0 = zeros(delay0_samples,1);
z1 = zeros(delay1_samples,1);
z2 = zeros(delay2_samples,1);
z3 = zeros(delay3_samples,1);

imp = [imp; z0; z1; z2; z3];
dline0 = [dline0; z1; z2; z3];
dline1 = [dline1; z0; z2; z3];
dline2 = [dline2; z0; z1; z3];
dline3 = [dline3; z0; z1; z2];

out = imp + 1/d0 * dline0 + 1/d1 * dline1 + 1/d2 * dline2 + 1/d3 * dline3;

% low pass for the wall

figure 1;
plot(out)
grid on


% ------------------------------------------
% problem: iir delays
% ------------------------------------------

% input
N = 1024;
imp = [1; zeros(N,1)];

% parameters
d = 100;
g = 0.5;
L = 17;
fcl = 2000;
ext = 0;

out = iircomb(imp, d, g, ext);
figure 3;
stem(out)
grid on

% check filter
%A = [1 -0.75];
%B = [0.125 0.125]/1.4125;
%h_lp = filter(B, A, imp);
figure 2;
spect(fft(out(80:150)), fs);
grid on

