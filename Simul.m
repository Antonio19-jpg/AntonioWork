%settings
Mmin = 0.5;           %min/max mass values
Mmax = 20;
A = 500;              %sky dimension
fr = 3;               %fraction of Mmin determining mean of gaussian noise
dim = 3;              %dimension (pixels) of PSF, must be odd integer
sigmapsf = 1;         %sigma of PSF  

%creating different fields and images via custom functions stated below

S = Crea_s(Mmin,Mmax,A);                        %generating field

P_s = PSF_s(S,dim,sigmapsf);                    %convolving field with PSF

B_s = Back_s(S,fr, Mmin, A);                    %adding background to original field 

PB_s = PSF_s(B_s,dim,sigmapsf);               %convolving noisy field with PSF

%reconstructing fields using findmax
%reconstructing original field convolved with PSF

Ps = findmax(P_s,0,dim,Mmin);

%reconstructing noisy field convolved with PSF    %base Mmin/fr + 5 * (Mmin/(10 * fr))

Bs = findmax(B_s,Mmin/fr + 5 * (Mmin/(10 * fr)),dim,Mmin);

%count number of star and compare the skies

Compare_s(S,Ps,dim);       %analysis of convolution between psf and original sky
Compare_s(S,Bs,dim);       %analysis of convolution between psf and original sky plus background


function S = Crea_s(Mmin,Mmax,A) 
%randomly genereates an A-by-A field with values in [Mmin;Mmax]
%returns field

rng(42);                                      %setting seed
R = rand(A);                                  %random matrix to set stars
S = zeros(A);                                 %starting from empty field (zeros)
a = 1/(1/Mmin - 1/Mmax);                      %normalization for IMF going as m^(-2)

%for the whole field
for i = 1:A
    for j = 1:A
        if R(i,j) >= 0.998                    % setting limit to choose randoms to populate field
            P = rand; 
            S(i,j) = Mmin*a/(a-Mmin*P);       % replacing chosen randoms in field, anywhere else 0
        end
    end
end
end

function P_s = PSF_s(C, dim, sigma) 
%creates a PSF over field C, with stdev sigma and size dim (pixels)
%returns field convolved with PSF

P_s = imgaussfilt(C, sigma, 'FilterSize', dim);
end

function B_s = Back_s(C, fr, Mmin, A) 
%adds gaussian background to a given A-by-A field C
%gaussian with mean = Mmin/fr and stdev = mean/10, only positives are accepted
%returns noisy field

bkg = abs(normrnd((Mmin/fr),Mmin/(10*fr),A));     %creating gaussian positive noise
%bg = histogram(bkg)
B_s = bkg+C;                                      %summing noise to field
end

function Compare_s(A,B,dim)

%The function compare the reconstructed sky with the original one to count the
%number of recognised stars, unrecognised stars and false ones.
%A is the original matrix, B is the reconstructed one, dim is the dimension
%of the PSF.

side = (dim-1)/2;

%coping the matrices in a bigger one to prevent problems with the edges.

A = Copy_m(A,side);
B = Copy_m(B,side);

%finding all the stars in the original sky.

[j,k] = find(A);

% setting the recognised stars count to 0

rec_star = 0;

% setting the unrecognised stars count to 0

unrec_star = 0;

for n = 1:length(j)
    s = find(B(j(n) - side : j(n) + side, k(n) - side : k(n) + side));
    if s ~= 0
        rec_star = rec_star + 1;
    else
        unrec_star = unrec_star + 1;
    end
    B(j(n) - side : j(n) + side, k(n) - side : k(n) + side) = 0;  %"cleaning" the analyzed part
end

%stars not deleted are false stars

m = find(B);
 
false_star = length(m)

unrec_star
rec_star
end

function B = Copy_m(A,side)
%copies matrix A inside a larger one, to avoid matrix boundary conditions
s = size(A);                                                     %reading size of A
B = zeros(s + side * 2);                                         %creating empty matrix, adding a 'frame' to A
B(side + 1 : length(B) - side, side + 1 : length(B) - side) = A; %copying it inside
end

function B = findmax(A,threshold,dim,Mmin)

side = (dim - 1)/2;

%iteratively scans field to find maxima and deconvolves PSF from it
%dim is size of PSF, A is the sky to reconstruct
%threshold is the minimum value for something to be read as a 'star'

m = max(A,[],'all');                             %finding absolute maximum
A1 = Copy_m(A,side);                             %creating 'scan' matrix 
B = zeros(size(A));                              %creating empty matrix to save the found stars

while m >threshold                              %while max is over treshold value
    
    [j,k] = find(A1==m);                         %keep scanning
    
    %copying in correct position in B
    star = sum(A1(j - side : j + side, k - side : k + side), 'all');
    
    if star >= Mmin
        B(j - side , k - side) = star;
    end
    
    A1(j - side : j + side , k - side : k + side) = 0;  %'cleaning'  frame
    m = max(max(A1));                                   %finding next maximum
end
end
