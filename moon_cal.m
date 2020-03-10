%open spectrum
moon = fitsread('moon-005.fit');
dark = fitsread('cal-005__dark.fit');

%figure(1)
%    pcolor(log(moon)), shading flat, colormap bone
    
moon = moon - dark; 
moon = mean(moon(620:640,:));
    

x = [124; 134; 280; 296; 347; 397; 435; 450; 489; 512; ...
    591; 689; 733; 784; 897; 939; 979; 999; 1009; 1031; 1141; ...
    1150; 1198; 1210; 1295; 1311; 1366];
wl = [4159; 4199; 4511; 4545; 4658; 4765; 4861; 4879; 4965; 5016; ...
    5187; 5401; 5496; 5607; 5852; 5944; 6031; 6074; 6097; 6144; 6384; ...
    6410; 6507; 6534; 6717; 6753; 6871];

f = fit(x,wl,'poly4');
wl = (1:length(moon));
wl = f(wl);

%normalize spectrum
moon = (moon - min(moon))/(max(moon) - min(moon)) + 0.01; 

figure(3)
    plot(wl,moon);
    title 'Normalized moon spectrum'
    xlabel 'Wavelenght [Å]'
    ylabel 'Phonton counts' 
    
