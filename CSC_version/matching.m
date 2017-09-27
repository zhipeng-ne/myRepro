function [ similarity ] = matching( template ,residual )
    [tem_w,tem_h] = size(template);
    [res_w,res_h] = sizze(residual);
    width = min(tem_w,res_w);
    heigh = min(tem_h,res_h);
    if ~(tem_w == res_w && tem_h==res_h)
        template = template(1:width,1:heigh);
        residual = residual(1:width,1:heigh);
    end
    %   Euclidean distance
    
    temp = (template - residual).^2;
    eu_distance = sqrt(sum(temp(:)));
    similarity = eu_distance;
        
    %   Entropy
    
%     one  = ones(res_w,res_h);
%     entropy = template.* log2(residual+one);
%     similarity = entropy;
    %   Cosine distance
end