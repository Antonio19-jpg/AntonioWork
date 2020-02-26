data = importdata('fhr7001.dat');

regolo1 = fitsread('Regolo-0015sec.fit');
regolo2 = fitsread('Regolo-0025sec.fit');
regolo3 = fitsread('Regolo-0035sec.fit');
regolo4 = fitsread('Regolo-0045sec.fit');
dark = fitsread('cal-005__dark.fit');


%mean and normalized in the time ( 5 sec exposition)

regolo = (regolo1 - dark + regolo2 - dark + regolo3 - dark + regolo4 - dark)/20;

%pcolor(log(regolo)), shading flat, colormap bone

regolo = mean(regolo((425:465),:),1);


%calibrating the flux
x=[360; 371; 436; 459; 469; 501; 531; 558; 564; 588; 651; 710; 738; 769; 840; 867; 893; 924; ...
    961; 980; 1031; 1048; 1059; 1094; 1105; 1140; 1224; 1263];
wl=[4159; 4201; 4426; 4511; 4545; 4658; 4765; 4861; 4879; 4965; 5188; 5400; 5496; 5607; ...
    5862; 5945; 6030; 6143; 6266; 6334; 6506; 6563; 6599; 6717; 6753; 6871; 7147; 7273];

f = fit(x,wl,'poly3');
wl = (1:length(regolo));
wl = f(wl);

lambda = linterp(data(:,1),data(:,2)/(10^16),wl);

R = vegaspline(wl)./esospline(wl);

plot(wl,R);

%migliora le spline, meno righe

function yy = linterp(x,y,xx)
%LINTERP Linear interpolation.
%
% YY = LINTERP(X,Y,XX) does a linear interpolation for the given
%      data:
%
%           y: given Y-Axis data
%           x: given X-Axis data
%          xx: points on X-Axis to be interpolated
%
%      output:
%
%          yy: interpolated values at points "xx"

% R. Y. Chiang & M. G. Safonov 9/18/1988
% Copyright 1988-2004 The MathWorks, Inc.
%       $Revision: 1.1.6.1 $
% Added allocation of output vector to speed operation
% 14 Jan 2014
%
% All Rights Reserved.
% ------------------------------------------------------------------

nx = max(size(x));
nxx = max(size(xx));
if xx(1) < x(1)
   error('You must have min(x) <= min(xx)..')
end
if xx(nxx) > x(nx)
   error('You must have max(xx) <= max(x)..')
end
%
yy = zeros(size(xx));   % Pre-allocate output vector
j = 2;
for i = 1:nxx
   while x(j) < xx(i)
         j = j+1;
   end
   alfa = (xx(i)-x(j-1))/(x(j)-x(j-1));
   yy(i) = y(j-1)+alfa*(y(j)-y(j-1));
end
end
%
% ------ End of INTERP.M % RYC/MGS %