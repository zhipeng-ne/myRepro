function samples=get_Samples(im,pos,target_sz) %(x  y  width heigh)
    num=250;
    padding=1.5;
    
    pos_center=pos+target_sz/2;
    window_sz=target_sz*(1+padding);
    
    LU_pos=pos_center-window_sz/2;
    %To prevent cross-border
    LU_pos(LU_pos < 1 ) =1; 
    RD_pos=pos_center+window_sz/2;
    if (RD_pos(1)>size(im,1))
        RD_pos(1) = size(im,1);
    end
    if (RD_pos(2)>size(im,2))
        RD_pos(2) = size(im,2);
    end
    pos_range=RD_pos-LU_pos-target_sz;
    
    %pos_range= window_sz-target_sz;
    
    ran_pos=[pos_range(1)*rand(1,num)',pos_range(2)*rand(1,num)']';
    samples=repmat([0 0 0 0]',[1,num]);
    samples(1:2,:)=round(ran_pos);
    samples(3:4,:)=repmat(target_sz',[1,num]);

end