function  model = Filter_Z(Image) 
    factor    =  2;                 % Change this for different zooming factors e.g. 2, 3 and 4
    %padPix    =  8;
    lambda    =  0.02;
    SmoothReg =  30;
    load('LR400.mat');       % Change this for different zooming factors correspondingly e.g. FiltersW_Factor2, FiltersW_Factor3 and FiltersW_Factor4
    LRFilterSize = size(LR_filters,1);  
    %HRFilterSize = size(HR_filters,1);  
    KL = size(LR_filters,3);            
    %KH = size(HR_filters,3);            

    % Make sure the size of recovered image will not change
    [h, w, c] = size(Image); 
    temph = mod(h,factor); 
    tempw = mod(w,factor); 
    h=h-temph; 
    w=w-tempw; 
    if(c>1)
        temp = double(rgb2ycbcr(Image(1:end-temph,1:end-tempw,:)));
        Image = temp(:,:,1);
    else
        Image = double(Image(1:end-temph,1:end-tempw));
    end

    % Generate LR image for testing
   % LRimage = double(imresize(Image,1/factor,'bicubic'));
    LRimage = double((Image));
    TapLRimage = padarray(LRimage,[8,8],'replicate','both');
    for a=1:4
        TapLRimage = edgetaper(TapLRimage,fspecial('gaussian',LRFilterSize,LRFilterSize/6));
    end
    [LRM,LRN] = size(TapLRimage);
    %HRM = LRM*factor;
    %HRN = LRN*factor;

    % Trans filters to frequency domain

    for k=1:KL
        LR_Filters(:,:,k) = psf2otf(rot90(LR_filters(:,:,k),2),[LRM LRN]);
    end
%     for k=1:KH
%         HR_Filters(:,:,k) = psf2otf(fliplr(flipud(HR_filters(:,:,k))),[HRM HRN]);
%     end

    % Directly enlarge smooth part by interpolation
    SM_filter = ones(3,3);
    SM_Filter = psf2otf(SM_filter, [LRM LRN]);
    H_Filter  = psf2otf([1,-1], [LRM LRN]);
    V_Filter  = psf2otf([1;-1],  [LRM LRN]);

    FLR      = fft2(TapLRimage);
    FZsm     = (conj(SM_Filter).*FLR)./(conj(SM_Filter).*SM_Filter+SmoothReg*conj(H_Filter).*H_Filter+SmoothReg*conj(V_Filter).*V_Filter);
    FLRsm    =  SM_Filter.*FZsm;
   % LRsm        = ifft2(FLRsm);
    %HRsm        = imresize(LRsm,factor,'bic');

    % Solving convolutional sparse coding problem
    %LR_Z = CSC_ADMM_GPU( LR_Filters, FLR - FLRsm, 1000, lambda, 1.10, 0.05 );
   [ LR_Z, Chara_100, Chara_200, Chara_300, Chara_400] = CSC_ADMM_CPU( LR_Filters, FLR - FLRsm, 1000, lambda, 1.10, 0.05 );
   
   temp=uint8(Chara_100(9:(size(Chara_100,1)-8),9:(size(Chara_100,2)-8)));
   %temp2= imresize(temp,factor,'bic');
   clear Chara_100; Chara_100=temp; clear temp;clear temp2;
   model(:,:,1)=Chara_100;
   temp=uint8(Chara_200(9:(size(Chara_200,1)-8),9:(size(Chara_200,2)-8)));
%   temp2= imresize(temp,factor,'bic');
   clear Chara_200; Chara_200=temp; clear temp;clear temp2;
   model(:,:,2)=Chara_200;
   temp=uint8(Chara_300(9:(size(Chara_300,1)-8),9:(size(Chara_300,2)-8)));
%   temp2= imresize(temp,factor,'bic');
   clear Chara_300; Chara_300=temp; clear temp;clear temp2;
   model(:,:,3)=Chara_300;
   temp=uint8(Chara_400(9:(size(Chara_400,1)-8),9:(size(Chara_400,2)-8)));
 %  temp2= imresize(temp,factor,'bic');
   clear Chara_400; Chara_400=temp; clear temp;clear temp2;
   model(:,:,4)=Chara_400;   
   %model(:,:,1:4) = [ Chara_100, Chara_200, Chara_300, Chara_400];

end