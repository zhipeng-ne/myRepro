function [exp_pos,position,new_model] = updateModel(im,frame,gt,model)
    padding = 1.5;
    window_sz=gt(1,3:4)*(1+padding);

    expend_pos= gt(1,1:2)+gt(1,3:4)/2-window_sz/2;
    expend_Image=imcrop(im,[expend_pos,window_sz]); 
    if frame == 1
         target_Image = imcrop(im,[gt(1:4)]); 
         new_model = get_residualComponent(target_Image);
         position= [];
         exp_pos = expend_pos;
    end
    if frame ~= 1
        csc_residualModel = get_residualComponent(expend_Image);
        
        
        
    end
    
end