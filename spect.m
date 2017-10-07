function spect(s,fs,typ,col)

% spect         - show the amplitude and phase of a vector/spectrum
% spect(s ,fs , typ ,col)
%
% Show the amplitude and phase of a vector/spectrum.
% optional using two subplots in the current figure. Amplitude is in dB. 
% Phase is unwraped by default. 
%
% Parameters: 
% s:    spectrum
% fs:   optional sampling frequency. Default: 48kHz.
% typ:  optional type of the plot:
%       'w': plot whole frequency range (two-sided spectrum)
%       'h': default, plot only first half (up to fs/2, one-sided spectrum)
%       'a': amplitude only, plots in the current (sub)plot
%       'p': phase only, plots in the current (sub)plot
%       '-u': amplitude and phase, no phase unwrap
% col:  optional color and symbol of plot (see PLOT). Default: 'b'
%
% example: spect(fft(rand(1000,1)));

% Copyright (c) 2002-2010 Piotr Majdak <piotr@majdak.com> (Acoustics Research Institute - Austrian Academy of Sciences)
% Licensed under the EUPL, Version 1.1 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence")
% You may not use this work except in compliance with the Licence. 
% You may obtain a copy of the Licence at: http://ec.europa.eu/idabc/eupl
% Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis, 
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
% See the Licence for the specific language governing  permissions and limitations under the Licence. 


uwrp=1;
half=1;
if ~exist('fs','var')
    warning('fs set to 48000Hz');
    fs=48000;
elseif ischar(fs)
    if exist('typ','var')
      col=typ;
    end
    typ=fs;    
    fs=48000;
    warning('fs set to 48000Hz');
end
    % check for typ
if exist('typ','var')
    if typ=='w'
        half=0;
    elseif typ=='h'
        half=1;
    elseif typ=='a'
        half=1;
    elseif typ=='p'
        half=1;
    elseif typ=='-u'
        uwrp=0;
    else
        col=typ;    % typ not given, it must be a col!
    end
else
    half=1;         % 'half' is default
    typ='h';
end

    % check for col
if ~exist('col','var')
    col='b';
end

if half
    fs=fs/2;
    ss=s(1:floor(end/2));
else
    ss=s;
end
len=length(ss);
fax=0:fs/len:fs-fs/len;
if typ ~='a' && typ ~='p'
    subplot(2,1,1);
end
if typ ~='p'
    plot(fax,20*log10(abs(ss)),col);
    ylabel('Magnitude in dB');
    xlabel('Frequency in Hz');
    grid on;
    hold on;
    set(gca,'XLimMode','manual');
    set(gca,'XLim',[0 fs]);
end
if typ ~='a' && typ ~='p'
    subplot(2,1,2);
end
if typ ~='a'
    if uwrp==1
      plot(fax,180/pi*unwrap(angle(ss)),col);
    else
      plot(fax,180/pi*angle(ss),col);
    end
    grid on;
    ylabel('Phase in degrees');
    xlabel('Frequency in Hz');
    hold on;
    set(gca,'XLimMode','manual');
    set(gca,'XLim',[0 fs]);
end
