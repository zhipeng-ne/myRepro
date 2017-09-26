function [Entropy,ADist] = Eudist2(csc_model, Chara_100, Chara_200, Chara_300, Chara_400)

    TChara_100 = csc_model(:,:,1);
    TChara_200 = csc_model(:,:,2);
    TChara_300 = csc_model(:,:,3);
    TChara_400 = csc_model(:,:,4);

    a = size(TChara_100, 1);
    b = size(TChara_100, 2);
    c = size(Chara_100,1);
    d = size(Chara_100,2);
    width=min(a,c);
    heigh=min(b,d);

if ~(a==c && b==d) 
    Chara_100 = Chara_100(1:width,1:heigh);
    Chara_200 = Chara_200(1:width,1:heigh);
    Chara_300 = Chara_300(1:width,1:heigh);
    Chara_400 = Chara_400(1:width,1:heigh);
    TChara_100 = TChara_100(1:width,1:heigh);
    TChara_200 = TChara_200(1:width,1:heigh);
    TChara_300 = Chara_300(1:width,1:heigh);
    TChara_400 = TChara_400(1:width,1:heigh);        
    % Chara_100 = imresize(Chara_100,[a,b],'bicubic');    
    % Chara_200 = imresize(Chara_200,[a,b],'bicubic');
    % Chara_300 = imresize(Chara_300,[a,b],'bicubic');
    % Chara_400 = imresize(Chara_400,[a,b],'bicubic');
end

    one = uint8(ones(size(Chara_100,1),size(Chara_100,2)));
    
    Eu100 = (TChara_100 - Chara_100).^2;
     Dist100 = sqrt(sum(Eu100(:)));    
    entropy =double(TChara_100).*log2(double(Chara_100+one));
    entropy_1 = sum(entropy(:));
     
    Eu200 = (TChara_200 - Chara_200).^2;
     Dist200 = sqrt(sum(Eu200(:)));
     entropy =double(TChara_200).*log2(double(Chara_200+one));
    entropy_2 = sum(entropy(:));
     
    Eu300 = (TChara_300 - Chara_300).^2;
     Dist300 = sqrt(sum(Eu300(:)));
    entropy =double(TChara_300).*log2(double(Chara_300+one));
    entropy_3 = sum(entropy(:));
    
    Eu400 = (TChara_400 - Chara_400).^2;
     Dist400 = sqrt(sum(Eu400(:)));
    entropy =double(TChara_400).*log2(double(Chara_400+one));
    entropy_4 = sum(entropy(:));
    
    ADist = (Dist100*(1/16) + Dist200*(1/8) + Dist300*(1/4) + Dist400*(9/16));
    Entropy = (entropy_1*(1/16) + entropy_2*(1/8) + entropy_3*(1/4) + entropy_4*(9/16));
end