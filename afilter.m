function out=afilter2(inp, noise, nonlin, mode)

% afilter2       a dummy filter (another version)
%
% out=afilter(INP) simply filters the INP
% 
% out=afilter(INP, NOI) filters INP and adds white noise, the amount of
% the noise is given by NOI (in dB relative to the signal). Try
% out=afilter(inp, -20);
%
% out=afilter(INP, [], NONLIN) filters INP and adds nonlinear distortions
% with the energy given by NONLIN (in dB).
% out=afilter(INP,[],NONLIN,'softknee') uses a smooth input-output function
% for the signal distortion
%
% out=afilter(INP, NOI, NONLIN) filters INP, adds NONLIN of nonlinear distortions and
% NOI of the noise. Try out=afilter(INP, -20, -20);
%
% 
%

% Piotr Majdak, 2004-2010

out=inp;

Num = [   0.0000
   -0.0001
   -0.0000
    0.0002
    0.0002
   -0.0002
   -0.0003
    0.0001
    0.0002
    0.0000
    0.0004
    0.0001
   -0.0012
   -0.0008
    0.0018
    0.0017
   -0.0014
   -0.0019
    0.0004
    0.0002
    0.0000
    0.0031
    0.0016
   -0.0064
   -0.0052
    0.0069
    0.0080
   -0.0040
   -0.0059
    0.0004
   -0.0028
   -0.0014
    0.0146
    0.0098
   -0.0219
   -0.0216
    0.0184
    0.0256
   -0.0068
   -0.0110
   -0.0000
   -0.0232
   -0.0143
    0.0634
    0.0571
   -0.0869
   -0.1185
    0.0757
    0.1732
   -0.0300
    0.8048
   -0.0300
    0.1732
    0.0757
   -0.1185
   -0.0869
    0.0571
    0.0634
   -0.0143
   -0.0232
   -0.0000
   -0.0110
   -0.0068
    0.0256
    0.0184
   -0.0216
   -0.0219
    0.0098
    0.0146
   -0.0014
   -0.0028
    0.0004
   -0.0059
   -0.0040
    0.0080
    0.0069
   -0.0052
   -0.0064
    0.0016
    0.0031
    0.0000
    0.0002
    0.0004
   -0.0019
   -0.0014
    0.0017
    0.0018
   -0.0008
   -0.0012
    0.0001
    0.0004
    0.0000
    0.0002
    0.0001
   -0.0003
   -0.0002
    0.0002
    0.0002
   -0.0000
   -0.0001
    0.0000];

out=inp;

if exist('nonlin','var')
  if ~isempty(nonlin)
    out2=interp(out,16);   % upsample 16 times to avoid aliasing
    if ~exist('mode','var'), mode='clip'; end
    switch mode
      case 'clip'
        etu=max(out2)*(1-10^(nonlin/20));
        etl=min(out2)*(1-10^(nonlin/20));
        out2(find(out2>etu))=etu;
        out2(find(out2<etl))=etl;
      case 'softknee'
        f=@(x,gain)sign(x).*abs(x).^(1-10^(gain/20));
        out2=f(out2,nonlin);
    end
    out1=decimate(out2,4,10); % downsample
    out=decimate(out1,4,10); % downsample
  end
end

out=fftfilt(Num,out);
out=out(1:length(out));  

if exist('noise','var')
  if ~isempty(noise)
    out=out+randn(length(out),1)*10^(noise/20);
  end
end

