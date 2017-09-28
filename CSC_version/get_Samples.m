function samples=get_Samples(expand_img,target_sz) %(x  y  width heigh)
    num=250;
    
    image_sz = [size(expand_img,2),size(expand_img,1)];
    
    pos_range= image_sz - target_sz;
    
    ran_pos=[pos_range(1)*rand(1,num)',pos_range(2)*rand(1,num)'];
    samples=repmat([0 0 0 0]',[1,num])';
    samples(:,1:2)=round(ran_pos);
    samples(:,3:4)=repmat(target_sz',[1,num])';
end