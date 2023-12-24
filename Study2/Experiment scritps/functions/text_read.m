function text_data = text_read(~)
text_data = zeros(4,48);
for i = 1:4
    for j = 1:2
        for k = 1:24
            if j == 1
                soldier_num = randi([1,5]);
            else
                soldier_num = randi([6,10]);
            end
            text_data(i,24*j+k-24) = soldier_num;
        end
    end
end
end

