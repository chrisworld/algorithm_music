function y=etc(x,mode)

% y=etc(x,mode)      calc logarithmic energy time curve
%
% x: input vector or matrix
% mode =0:  don't normalize [default]
%      =1:  normalize matrix to the peak value in the matrix
%	   =2:  normalize every vector separately

% Copyright (c) 2004-2010 Piotr Majdak <piotr@majdak.com> (Acoustics Research Institute - Austrian Academy of Sciences)
% Licensed under the EUPL, Version 1.1 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence")
% You may not use this work except in compliance with the Licence. 
% You may obtain a copy of the Licence at: http://ec.europa.eu/idabc/eupl
% Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis, 
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
% See the Licence for the specific language governing  permissions and limitations under the Licence. 



if ~exist('mode','var')  
    mode = 0;
end

if mode == 1
    peak = max(max(x.^2));
    x = (x.^2)/peak;
elseif mode == 2
    peak = max(x.^2);
    peakm = repmat(peak,size(x,1),1);
    x=(x.^2)./peakm;
else
    x = (x.^2);
end

y=10*log10(abs(x+eps));
