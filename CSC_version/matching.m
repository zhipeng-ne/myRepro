function [ similarity ] = matching( template ,Chara_1,Chara_2,Chara_3,Chara_4 )
    [tem_w,tem_h] = size(template(:,:,1));
    [res_w,res_h] = size(Chara_1);
    width = min(tem_w,res_w);
    heigh = min(tem_h,res_h);

    TChara_1 = template(:,:,1);
    TChara_2 = template(:,:,2);
    TChara_3 = template(:,:,3);
    TChara_4 = template(:,:,4);

if ~(tem_w == res_w && tem_h==res_h)
    Chara_1 = Chara_1(1:width,1:heigh);
    Chara_2 = Chara_2(1:width,1:heigh);
    Chara_3 = Chara_3(1:width,1:heigh);
    Chara_4 = Chara_4(1:width,1:heigh);
    TChara_1 = TChara_1(1:width,1:heigh);
    TChara_2 = TChara_2(1:width,1:heigh);
    TChara_3 = Chara_3(1:width,1:heigh);
    TChara_4 = TChara_4(1:width,1:heigh);
end
    %   Euclidean distance

    euclidean = (TChara_1-Chara_1).^2;
    dist1= sqrt(sum(euclidean(:)));
    
    euclidean = (TChara_2-Chara_2).^2;
    dist2= sqrt(sum(euclidean(:)));
    
    euclidean = (TChara_3-Chara_3).^2;
    dist3= sqrt(sum(euclidean(:)));
    
    euclidean = (TChara_4-Chara_4).^2;
    dist4= sqrt(sum(euclidean(:)));
    
    similarity = dist1*1/16+dist2*1/8+dist3*1/41+dist4*9/16;
    
%     %   Entropy
%      one = uint8(ones(width,heigh)); 
%     entropy =double(TChara_1).*log2(double(Chara_1+one));
%     %entropy (entropy>0)=1;
%     entropy_1 = sum(entropy(:));
% 
%     entropy =double(TChara_2).*log2(double(Chara_2+one));
%     %entropy (entropy>0)=1;
%     entropy_2 = sum(entropy(:));
%     
%     entropy =double(TChara_3).*log2(double(Chara_3+one));
%     %entropy (entropy>0)=1;
%     entropy_3 = sum(entropy(:));        
%     
%     entropy =double(TChara_4).*log2(double(Chara_4+one));
%     %entropy (entropy>0)=1;
%     entropy_4 = sum(entropy(:));

%     similarity = (entropy_1*(1/16) + entropy_2*(1/8) + entropy_3*(1/4) + entropy_4*(9/16));
    
end