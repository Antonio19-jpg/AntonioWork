%open spectrum
vega_lamp = fitsread('vega5_lamp.fit');

%figure(1)
%    pcolor(log(vega_lamp)), shading flat, colormap bone

%rotate the image
x = [842; 1170; 1201; 1299; 1336; 1378];

wl = [738; 732; 732; 730; 729; 728];

f = fit(x,wl,'poly1');

vega_lamp = imrotate(vega_lamp,rad2deg(atan(f.p1)));

%figure(2)
%    pcolor(log(vega_lamp)), shading flat, colormap bone

vega_lamp = mean(vega_lamp(500:700,:));

%figure(3)
%    plot(vega_lamp);
%%
x=[360; 371; 436; 459; 469; 501; 531; 558; 564; 588; 651; 710; 738; 769; 840; 867; 893; 924; ...
    961; 980; 1031; 1048; 1059; 1094; 1105; 1140; 1224; 1263];
wl=[4159; 4201; 4426; 4511; 4545; 4658; 4765; 4861; 4879; 4965; 5188; 5400; 5496; 5607; ...
    5862; 5945; 6030; 6143; 6266; 6334; 6506; 6563; 6599; 6717; 6753; 6871; 7147; 7273];

f = fit(x,wl,'poly3');
wl = (1:length(vega_lamp));
wl = f(wl);

figure(4)
    plot(wl,vega_lamp);
