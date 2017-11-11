function [ similarity ] = matching( template ,Chara_200,Chara_400,Chara_600,Chara_800 )
    [tem_w,tem_h] = size(template(:,:,1));
    [res_w,res_h] = size(Chara_200);
    width = min(tem_w,res_w);
    heigh = min(tem_h,res_h);

    TChara_200 = template(:,:,1);
    TChara_400 = template(:,:,2);
    TChara_600 = template(:,:,3);
    TChara_800 = template(:,:,4);

if ~(tem_w == res_w && tem_h==res_h)
    Chara_200 = Chara_200(1:width,1:heigh);
    Chara_400 = Chara_400(1:width,1:heigh);
    Chara_600 = Chara_600(1:width,1:heigh);
    Chara_800 = Chara_800(1:width,1:heigh);
    TChara_200 = TChara_200(1:width,1:heigh);
    TChara_400 = TChara_400(1:width,1:heigh);
    TChara_600 = Chara_600(1:width,1:heigh);
    TChara_800 = TChara_800(1:width,1:heigh);
end
    %   Euclidean distance

    %   Entropy
    one = uint8(ones(width,heigh)); 
    entropy =double(TChara_200).*log2(double(Chara_200+one));
    entropy_1 = sum(entropy(:));

    entropy =double(TChara_400).*log2(double(Chara_400+one));
    entropy_2 = sum(entropy(:));
    entropy =double(TChara_600).*log2(double(Chara_600+one));
    entropy_3 = sum(entropy(:));        
    
    entropy =double(TChara_800).*log2(double(Chara_800+one));
    entropy_4 = sum(entropy(:));

    similarity = (entropy_1*(1/4) + entropy_2*(1/4) + entropy_3*(1/4) + entropy_4*(1/4));
    
end