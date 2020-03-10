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
 %   pcolor(log(vega_lamp)), shading flat, colormap bone

vega_lamp = mean(vega_lamp(600:645,:)); %500 700

figure(3)
    plot(vega_lamp);
%%
x=[368; 379; 444; 466; 476; 509; 539; 566; 571; 595; 609; 659; 719; 746; 777; ...
    848; 875; 900; 912; 919; 932; 968; 988; 1003; 1039; 1056; 1102; 1113; 1148; 1177; 1197; ...
    1208; 1232; 1251; 1262; 1271; 1305; 1384];
wl=[4159; 4199; 4428; 4511; 4545; 4658; 4765; 4861; 4880; 4965; 5016; 5188; 5401; 5496; 5607; ...
    5852; 5944; 6031; 6074; 6097; 6144; 6266; 6334; 6385; 6507; 6563; 6717; 6753; 6871; 6965; 7031; ...
    7067; 7147; 7207; 7245; 7273; 7384; 7635];

yl = wl;

f = fit(x,wl,'poly3');
wl = (1:length(vega_lamp));
wl = f(wl);

%figure(4)
 %   plot(wl,vega_lamp);