function smooth = get_smoothComponent2(Image)
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
%    LRimage = double(imresize(Image,1/factor,'bicubic'));
    LRimage=double(Image);
    TapLRimage = padarray(LRimage,[8,8],'replicate','both');
    for a=1:4
        TapLRimage = edgetaper(TapLRimage,fspecial('gaussian',LRFilterSize,LRFilterSize/6));
    end
    [LRM,LRN] = size(TapLRimage);
    %HRM = LRM*factor;
    %HRN = LRN*factor;

    % Trans filters to frequency domain

%     for k=1:KL
%         LR_Filters(:,:,k) = psf2otf(rot90(LR_filters(:,:,k),2),[LRM LRN]);
%     end
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
    LRsm        = ifft2(FLRsm);
    %HRsm        = imresize(LRsm,factor,'bic');
    smooth = LRsm;
    temp=smooth(9:(size(smooth,1)-8),9:(size(smooth,2)-8));
    clear smooth; smooth=temp; clear temp;

end