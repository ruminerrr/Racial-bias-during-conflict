prac_text = cell(5,4);
for i = 1:5
    num = randi([1,10]);
    prac_text{i,1} = 'ɱ��ʿ��';
    prac_text{i,2} = sprintf('%d��', num);
    prac_text{i,3} = 'ƽ����Ƭ';
    prac_text{i,4} = '���䵼��';
    prac_text{i,5} = '�������䵼��';
end
prac_text{5,3} = '��ľ��Ƭ';
save('E:\Juncheng Lu\EEG\stimuli\practice\prac_text.mat', "prac_text");    