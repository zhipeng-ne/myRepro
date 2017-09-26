function ratio = get_overlappingRatio(rec1,rec2)
    RD_pos1=rec1(1:2)+rec1(3:4);
    RD_pos2=rec2(1:2)+rec2(3:4);

    a=rec1(3);
    b=rec1(4);
    c=rec2(3);
    d=rec2(4);

    overlapX=a+c-(max(RD_pos1(1),RD_pos2(1))-min(rec1(1),rec2(1)));
    overlapY=b+d-(max(RD_pos1(2),RD_pos2(2))-min(rec1(2),rec2(2)));
    
    if overlapX<=0 ||overlapY <=0 
        ratio = 0;
    else 
        area = rec1(3)*rec1(4);
        overlap_area=overlapX*overlapY;
        ratio= overlap_area/area;
    end   
end