%open spectrum
vega = fitsread('vega5-002_68deg.fit');
flat = fitsread('cal-002__flat.fit');
dark = fitsread('cal-005__dark.fit');
bias = fitsread('cal-005_bias.fit');

%figure(1)
 %  pcolor(log(vega)), shading flat, colormap bone

%rotate vega
xv = [431; 595; 838; 1093];
yv = [504; 501; 495; 488];

f = fit(xv,yv,'poly1');

vega = imrotate(vega,rad2deg(atan(f.p1)),'crop','bilinear');

%figure (2)
%pcolor(log(vega)), shading flat, colormap bone
%%
%rotate flat
xr = [425; 781; 1074; 1307];
yr = [745; 741; 737; 734];

f = fit(xr,yr,'poly1');

flat = imrotate(flat,rad2deg(atan(f.p1)),'crop','bilinear');

flat = mean(flat(487:496,:));
bias = mean(bias(487:496,:));
%%

%correcting spectrum
vega = vega - dark;  %rumore termico
vega = mean(vega(487:496,:));
vega = vega./((flat - bias)/max(flat - bias)); %correzione risposta ccd


x=[360; 371; 436; 459; 469; 501; 531; 558; 564; 588; 651; 710; 738; 769; 840; 867; 893; 924; ...
    961; 980; 1031; 1048; 1059; 1094; 1105; 1140; 1224; 1263];
wl=[4159; 4201; 4426; 4511; 4545; 4658; 4765; 4861; 4879; 4965; 5188; 5400; 5496; 5607; ...
    5862; 5945; 6030; 6143; 6266; 6334; 6506; 6563; 6599; 6717; 6753; 6871; 7147; 7273];

y = wl; %save to have the values to fit

f = fit(x,wl,'poly3');
wl = (1:length(vega));
wl = f(wl);

figure(3)
    plot(wl,vega);
    title 'Vega spectrum'
    xlabel 'Wavelenght [Å]'
    ylabel 'Phonton counts' 
    xlim ([3800 7000]);
