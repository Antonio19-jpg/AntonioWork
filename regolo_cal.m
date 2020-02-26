regolo1 = fitsread('Regolo-0015sec.fit');
regolo2 = fitsread('Regolo-0025sec.fit');
regolo3 = fitsread('Regolo-0035sec.fit');
regolo4 = fitsread('Regolo-0045sec.fit');
dark = fitsread('cal-005__dark.fit');


%mean and normalized in the time ( 5 sec exposition)

regolo = (regolo1 - dark + regolo2 - dark + regolo3 - dark + regolo4 - dark)/20;

%pcolor(log(regolo)), shading flat, colormap bone

regolo = mean(regolo((425:465),:),1);

x=[360; 371; 436; 459; 469; 501; 531; 558; 564; 588; 651; 710; 738; 769; 840; 867; 893; 924; ...
    961; 980; 1031; 1048; 1059; 1094; 1105; 1140; 1224; 1263];
wl=[4159; 4201; 4426; 4511; 4545; 4658; 4765; 4861; 4879; 4965; 5188; 5400; 5496; 5607; ...
    5862; 5945; 6030; 6143; 6266; 6334; 6506; 6563; 6599; 6717; 6753; 6871; 7147; 7273];

f = fit(x,wl,'poly3');
wl = (1:length(regolo));
wl = f(wl);

figure(1)
    plot(wl,regolo);