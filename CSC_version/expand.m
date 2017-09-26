function [expos, extarget_sz, cen_pos] = expand(pos, target_sz)

padding = 1.5;
win_sz = floor(target_sz * (1 + padding));    
expos = round(pos([2,1]) - win_sz([2,1])/2);  %CSC 左上角位置
extarget_sz  = round(win_sz([2,1]));  %CSC 大小

cen_pos = round(win_sz([2,1])/2);   %KCF中心位置

end