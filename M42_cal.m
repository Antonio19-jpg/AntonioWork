%open spectrum
M42 = fitsread('M42-013.fit');

%figure(1)
%    pcolor(log(M42)), shading flat, colormap bone

M42 = mean(M42(590:595,:));

x = [355; 366; 454; 464; 496; 526; 556; 553; 582; 597; ...
    647; 709; 736; 768; 836; 863; 888; 900; 907; 921; 991; ...
    997; 1028; 1036; 1044; 1055; 1091; 1102; 1137; 1166; 1197; 1221; 1260; ...
    1295; 1332; 1374];
wl = [4159; 4199; 4511; 4545; 4658; 4765; 4861; 4879; 4965; 5016; ...
    5187; 5401; 5496; 5607; 5852; 5944; 6031; 6074; 6097; 6144; 6384; ...
    6410; 6507; 6534; 6563; 6602; 6717; 6753; 6871; 6965; 7067; 7147; 7273; ...
    7384; 7509; 7635];
f = fit(x,wl,'poly3');
wl = (1:length(M42));
wl = f(wl); 

figure(3)
    plot(wl,M42);
    title 'M42 spectrum'
    xlabel 'Wavelenght [�]'
    ylabel 'Phonton counts' 
