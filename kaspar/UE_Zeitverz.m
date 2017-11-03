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


y=iirkamm(in,d,G,fs,fc,ext);

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

ystereo=audioread('piano2.wav');%(16000:end,:);
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
delay=0;   % Delay in m楳��I�`X��Q�<�nzOȇ�;ĄK���SΠ�G8'��Vwf��dˢ8��a���s�+#r�H'�5u�k3��b�nw���G)V\�>R=k4�v�b�]�<�V3�~�o�EG�ͽ!��ury�u�FB ��X8��G�W>��� �e�68<��گ�5���^��y6�+���-�5���>��K�:o����x`��������H�(^�W�ǈ�H/���v���¾��U�57s�i)"O,Q:�!�9��}��2�P�#h�"C���MmRJ1m�Ԡ��=K]�}=)Cg��ʳ���3�G��)�hY�M�>�p�q�{W��FR�9�Tb��*�ԚH#M�Wi�*m>|�ҡا��y�mY���H>S�
�0T��QHE���.^��R����4Ky4��FW�Z�y��9��
��Z���W%o;Ƕ��b��V᥏c�h�����k+4~�
mR�O�A�k���*� �8�S��&�#�R��溊L����q�WM�2�� ��}]IG���T];��n9��%@u��\$�Km3�6rx�y0���v�(����5�"%*9��spb�W' ���]A85��**l5)��S`GzŽ#�R�%X0=3^���f���{Yw5m���$�n���?M�I�Hga���5�r��g����lii���;�� p3]��
���=��!�Wm�>�M�����d$p{�|��xm�9<(��ĸ5c恵Z�h.�d��S<-ue����e��0��h���Q�-OMm\^و�»�z�uF��]M���.K���6M�k�����iz�u���b�r���s���l*��Wނ���5���e�,kF[��$)��+����ϰ�N��L�HP:��1�2�S��QR�nǫ'wbYe�k�é5���wA�?�QK��5sq\�wW-������Oֽ�b"��[�Lݑ�e �ݰ���]>�w,sD�7�O#���������Z|�$l�'NA&�=4����R�#:�Y�\JJ�F{�IHX������b#ws�pN���y�*�4M�s��}��_�:�خ�$�o횣8u���+�����hZS�J&e���P��1�SRVvAQ�f��<㸦%Åpq�zכ��%WI�1m'06��