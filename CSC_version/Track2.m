function [is_change,exp_pos,position,new_model,new_entropy] = Track2(im, frame, gt,model,entropy)
     is_change = 1;
    padding = 1.5;
    window_sz=gt(1,3:4)*(1+padding);

    expend_pos= gt(1,1:2)+gt(1,3:4)/2-window_sz/2;
    expend_Image=imcrop(im,[expend_pos,window_sz]); 
    %figure,imshow(expend_Image);
    if frame == 1
         target_Image = imcrop(im,[gt(1:4)]); 
         new_model = Filter_Z(target_Image);
         position= [];
         exp_pos = expend_pos;
         new_entropy = [];
    end
    if frame ~= 1
        csc_model = Filter_Z(expend_Image);
        Temp_100 = csc_model(:,:,1);
        Temp_200 = csc_model(:,:,2);
        Temp_300 = csc_model(:,:,3);
        Temp_400 = csc_model(:,:,4);

        Boxs = get_Samples(expend_Image,gt(1,1:2),gt(1,3:4));
        Samples = Boxs';
        Samples=Samples(:,1:4);
        
        %Samples(end+1,:)=[gt(1,1:2)-expend_pos,gt(1,3:4)];
        Samples(:,3:4) = repmat(gt(1,3:4)',[1,size(Samples,1)])';
        %Samples(n+1,:)=[0 0 0 0];
        %Samples(end,:)=[round(gt(1,1:2)-expend_pos),gt(1,3:4)];
        n = size(Samples,1);
        if n == 0
            Samples=[round(gt(1,1:2)-expend_pos),gt(1,3:4)];
            n=n+1;
        end 
        Adist = [];
        overlap=[];
        Entropy = [];
        for i = 1 : n
            sub_Chara_100 = imcrop(Temp_100,Samples(i, 1:4));
            sub_Chara_200 = imcrop(Temp_200,Samples(i, 1:4));
            sub_Chara_300 = imcrop(Temp_300,Samples(i, 1:4));
            sub_Chara_400 = imcrop(Temp_400,Samples(i, 1:4));
            [temp_entropy,ADist] = Eudist2( model(:,:,1:4),sub_Chara_100,sub_Chara_200, sub_Chara_300, sub_Chara_400);

            ratio = get_overlappingRatio([round(gt(1,1:2)-expend_pos),gt(1,3:4)],Samples(i, 1:4));  
            overlap=[overlap,ratio];
      
            %ADist=(1-ratio)*ADist;
            Adist = [Adist,ADist];
            Entropy = [Entropy,temp_entropy];
        end
         col = find_min(overlap,Adist);
         temp_pos=Samples(col(1), 1:4);
         
%          temp =[];
%          index = 1;
%          figure,imshow(expend_Image,'border','tight','initialmagnification','fit');hold on;
%          for i =1:size(Samples,1)
%              x = Samples(i,1)+round(gt(1,3)/2); 
%              y = Samples(i,2)+round(gt(1,4)/2);
%              plot(x,y,'.','MarkerSize',10,'MarkerEdgeColor','r');
%             if mod(i,10) == 0
%                 %rectangle('Position',Samples(i,1:4),'EdgeColor','r');
%                 plot(x,y,'.','MarkerSize',10,'MarkerEdgeColor','y');
%                 temp(index,:) = [x,y];
%                 index = index + 1;
%             end
%          end
%          figure,imshow(expend_Image,'border','tight','initialmagnification','fit');hold on;
%          for i =1:size(temp,1)-5
%              plot(temp(i,1),temp(i,2),'.','MarkerSize',10,'MarkerEdgeColor','y');
%              rectangle('Position',[temp(i,:)-round(gt(1,3:4)/2),gt(1,3:4)],'EdgeColor','r');
%          end 
         
        entropy(frame) = Entropy(col);
        
        for i=1 : n
           Samples(i,1:2)=round(Samples(i,1:2)+expend_pos); 
        end    
        
        gt=Samples(col(1), 1:4);
        position = gt(1,1:2);  
        exp_pos = expend_pos;
         if entropy(frame) < (entropy(frame - 1)*0.5)
             new_model = model ;
             clear model ; 
             is_change = 0;
             entropy(frame) = entropy(frame - 1);
         else     
            clear model; 
            new_model = csc_model;
           
         end 
        new_entropy=entropy;
    end
    
    
end
    