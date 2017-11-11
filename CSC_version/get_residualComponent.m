function  [ model ] = get_residualComponent(Image) 
% Parameter setting
factor    =  2;                 % Change this for different zooming factors e.g. 2, 3 and 4
padPix    =  8;
lambda    =  0.02;
SmoothReg =  30;
load('FiltersW_Factor2.mat');       % Change this for different zooming factors correspondingly e.g. FiltersW_Factor2, FiltersW_Factor3 and FiltersW_Factor4
LRFilterSize = size(LR_filters,1);  %5
HRFilterSize = size(HR_filters,1);  %11
KL = size(LR_filters,3);            %800
KH = size(HR_filters,3);            %1200

% Make sure the size of recovered image will not change
[h, w, c] = size(Image); % 256  256  3
temph = mod(h,factor); % 0
tempw = mod(w,factor); % 0
h=h-temph; % 256
w=w-tempw; % 256
if(c>1)
    temp = double(rgb2ycbcr(Image(1:end-temph,1:end-tempw,:)));
    Image = temp(:,:,1);
else
    Image = double(Image(1:end-temph,1:end-tempw));
end


% Generate LR image for testing
LRimage = double(imresize(Image,1/factor,'bicubic')); %降分辨率
%LRimage=double(Image);
TapLRimage = padarray(LRimage,[padPix,padPix],'replicate','both');

for a=1:4
    TapLRimage = edgetaper(TapLRimage,fspecial('gaussian',LRFilterSize,LRFilterSize/6));   % y
end
%figure,imshow(TapLRimage,[]);

[LRM,LRN] = size(TapLRimage);
HRM = LRM*factor;
HRN = LRN*factor;

% Trans filters to frequency domain

for k=1:KL
    LR_Filters(:,:,k) = psf2otf(rot90(LR_filters(:,:,k),2),[LRM LRN]);
end
for k=1:KH
    HR_Filters(:,:,k) = psf2otf(rot90(HR_filters(:,:,k),2),[HRM HRN]);
end

% Directly enlarge smooth part by interpolation
SM_filter = ones(3,3);                       %fs    3X3低通滤波器
SM_Filter = psf2otf(SM_filter, [LRM LRN]);   %Fs   =fs的快速傅立叶变换  
H_Filter  = psf2otf([1,-1], [LRM LRN]);      %Fdh  =fdh的快速傅立叶变换   fdh=[1,-1]
V_Filter  = psf2otf([1;-1],  [LRM LRN]);     %Fdv  =fdvd的快速傅立叶变换  fdv=[1;-1]

FLR      = fft2(TapLRimage);                 %F(y) =对y进行傅立叶变换     y为LR图                 
FZsm     = (conj(SM_Filter).*FLR)./(conj(SM_Filter).*SM_Filter+SmoothReg*conj(H_Filter).*H_Filter+SmoothReg*conj(V_Filter).*V_Filter);  %Zys
%FZsm     = ifft2(FZsm);
FLRsm    =  SM_Filter.*FZsm;     
%LRsm        = FLRsm;
%LRsm        = ifft2(FLRsm);  %smooth compenent   对FLRsm进行反傅立叶变换

%figure,imshow(LRsm,[]);

% Solving convolutional sparse coding problem
%LR_Z = CSC_ADMM_GPU( LR_Filters, FLR - FLRsm, 1000, lambda, 1.10, 0.05 );
%LR_Z = CSC_ADMM_CPU( LR_Filters, FLR - FLRsm, 1000, lambda, 1.10, 0.05 );
%-----------------------------END------------------------------------------
   %[ LR_Z, residual] = CSC_ADMM_CPU( LR_Filters, FLR - FLRsm, 1000, lambda, 1.10, 0.05 );
   [ LR_Z, residual] = CSC_ADMM_GPU( LR_Filters, FLR - FLRsm, 1000, lambda, 1.10, 0.05 );
   
   for i=1:size(residual,3)       
      temp1(:,:,i) =imresize(residual(:,:,i),factor,'bic');     %放大两倍       
   end 
   temp1=uint8(temp1);
   model = temp1(factor*padPix+1:end-factor*padPix,factor*padPix+1:end-factor*padPix,:);
    clear temp1;
end