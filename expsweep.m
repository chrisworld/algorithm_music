% expsweep      creates an exponential sweep and its inverse
% 
% [sweep,invsweep]=expsweep(fstart,fend,T,fs,phi)
% 
%   fstart: start frequency (Hz)
%   fend: end frequency (Hz)
%   T: duration of the sweep (s)
%   fs: sampling rate (Hz)
%   phi: optional phase (rad), default: 0 rad <=> sine
%
%   sweep: the sweep
%   invsweep: inverse sweep, inverse with respect to the convolution [*] and 
%             normalized to yield a normalized amplitude spectrum after
%             convolution with the sweep
% 
% [*] Majdak, Balazs, and Laback (2007) J Audio Eng Soc

% Copyright (c) 2004-2010 Piotr Majdak <piotr@majdak.com> (Acoustics Research Institute - Austrian Academy of Sciences)
% Licensed under the EUPL, Version 1.1 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence")
% You may not use this work except in compliance with the Licence. 
% You may obtain a copy of the Licence at: http://ec.europa.eu/idabc/eupl
% Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis, 
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
% See the Licence for the specific language governing  permissions and limitations under the Licence. 


function [sw,isw]=expsweep(fstart,fend,T,fs,phi)

if ~exist('phi','var'), phi=0; end

N=round(T*fs);
T=N/fs;
w1=2*pi*fstart;
w2=2*pi*fend;

A=T*w1/log(w2/w1);
tau=T/log(w2/w1);

t=0:1/fs:T-1/fs;
sw=sin(A*(exp(t/tau)-1)+phi)';

if nargout>1,   % create inverse sweep
    attn=0:-20*log10(w2/w1)/N:20*(-log10(w2/w1)+log10(w2/w1)/N);
    attn=10.^(attn/20)';
    isw=flipud(sw).*attn;

    xf=log10(abs(fft(sw).*fft(isw)));
    g=mean(xf(max([floor(fstart/fs*N) 1]):min([floor(fend/fs*N) N/2])));
    isw=isw./10^g;
end

