function [exp_pos,position,new_model] = updateModel(im,frame,gt,last_model)
    padding = 1.5;
    window_sz=gt(1,3:4)*(1+padding);

    expend_pos= gt(1,1:2)+gt(1,3:4)/2-window_sz/2;
    expend_Image=imcrop(im,[expend_pos,window_sz]); 
    
    expend_pos(expend_pos<0) = 1;
    
    if frame == 1
         target_Image = imcrop(im,[gt(1:4)]); 
         new_model = get_residualComponent(target_Image);
         position= [];
         exp_pos = expend_pos;
    end
    
    similarity=[];
    overlap =[];
    if frame ~= 1
        expImg_residual = get_residualComponent(expend_Image);
        samples = get_Samples(expend_Image,gt(1,3:4));
        
        for i = 1:size(samples,1)
           sub_model = imcrop(expImg_residual,samples(i,1:4)); 
           
           temp = matching(last_model,sub_model);          
           ratio = get_overlappingRatio([round(gt(1,1:2)-expend_pos),gt(1,3:4)],samples(i,1:4));
           similarity=[similarity,temp];
           overlap=[overlap,ratio];
           
        end
        col = find_min(overlap,similarity);
        temp_pos = samples(col(1),1:2);
        temp_pos=round(temp_pos+expend_pos); 
        
        position = temp_pos;
        exp_pos = expend_pos;
        new_model = expImg_residual;
    end
    
end