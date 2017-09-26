function col = find_min(ratio,Adist)
    index =1;
    min = Adist(1);
    for i = 1 : size(ratio,2)
        if ratio(i) >= 0.75
            if Adist(i) < min
                min = Adist(i);
                index = i;
            end
        end
    end
    col = index;
end