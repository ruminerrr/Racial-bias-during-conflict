prac_text = cell(5,4);
for i = 1:5
    num = randi([1,10]);
    prac_text{i,1} = '杀死士兵';
    prac_text{i,2} = sprintf('%d名', num);
    prac_text{i,3} = '平民照片';
    prac_text{i,4} = '发射导弹';
    prac_text{i,5} = '放弃发射导弹';
end
prac_text{5,3} = '树木照片';
save('E:\Juncheng Lu\EEG\stimuli\practice\prac_text.mat', "prac_text");    