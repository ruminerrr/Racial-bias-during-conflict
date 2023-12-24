function image_data = image_read(idx)

image_data = cell(4,48);

switch idx
    case 1 % Asian
        for i = 1:2 % 4 block
            for j = 1:2 % lowConflict/highConflict
                for k = 1:24 % 24 stimuli
                    path = sprintf('stimuli/exp1/%d.png', 24*i+k-24);
                    image_data{i,24*j+k-24} = imread(path);
                end
            end
        end
        for i = 1:2 % 4 block
            for j = 1:2 % lowConflict/highConflict
                for k = 1:24 % 24 stimuli
                    path = sprintf('stimuli/exp1/%d.png', 24*i+k-24);
                    image_data{i+2,24*j+k-24} = imread(path);
                end
            end
        end
    case 2 % Caucasian
        for i = 1:2 % 2 block
            for j = 1:2 % lowConflict/highConflict
                for k = 1:24 % 24 stimuli
                    path = sprintf('stimuli/exp2/%d.png', 24*i+k-24);
                    image_data{i,24*j+k-24} = imread(path);
                end
            end
        end
        for i = 1:2 % 2 block
            for j = 1:2 % lowConflict/highConflict
                for k = 1:24 % 24 stimuli
                    path = sprintf('stimuli/exp2/%d.png', 24*i+k-24);
                    image_data{i+2,24*j+k-24} = imread(path);
                end
            end
        end
    case 9
        for i = 1:5
            image_data{i} = imread(sprintf('stimuli/practice/%d.png', i));
        end
    otherwise
        Screen('CloseAll');
        fprintf('Wrong number!');
end
end