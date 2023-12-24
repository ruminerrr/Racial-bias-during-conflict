%% init
clear;clc;
% subject&study info
prompt = {'Subject''s ID:', 'Study Number:', 'Start Run:'};
subject = input(prompt{1});
exp = input(prompt{2});
block = input(prompt{3});
% debug
debug = 0;
AssertOpenGL;
commandwindow;
if debug
    ListenChar(0);
    ShowCursor();
    PsychDebugWindowConfiguration;
else
    ListenChar(2);
    HideCursor();
end
% global veriable
global x
% screen settings
x.ins_color = [255 255 255];
x.bg_color = [122 122 122];
Screen('Preference', 'SkipSyncTests', 0);
PsychDefaultSetup(2);
x.screenNumber = max(Screen('Screens'));
[x.window, x.windowRect] = Screen('OpenWindow', x.screenNumber, x.bg_color);
[x.x_center, x.y_center] = RectCenter(x.windowRect);
Screen('TextFont', x.window, 'Simsun');
Screen('Preference','TextEncodingLocale','UTF-8');
% keyboard defination
KbName('UnifyKeyNames');
continue_key = KbName('space');
quit_key = KbName('ESCAPE');
launch_key = KbName('leftarrow');
cancel_key = KbName('rightarrow');
% port setting
port_address = hex2dec('037F');
config_io;
outp(port_address, 0);
%{
Stimulus Markers
    Low=1 High=2 / Netural=1 Pain=2 / Woman=1 Man=2 Tree=3
    NeutralWoman-LowSoldier=11 NeutralMan-LowSoldier=12 Tree-LowSoldier=13
    NeutralWoman-HighSoldier=21 NeutralMan-HighSoldier=22 Tree-HighSoldier=23
Choice Markers
    ChoiceStart=99 Launch=100 Non-launch=200 Non-response=199
SolderNumber Markers
    low=1 High=2
Others
    RunStart=88 Rest=66
%}
% experiment settings
n_block = 4;
n_trial = 48;
trial_duration = 6;
% create result data
mkdir(sprintf('result/sub_%d', subject));
result = table();
result = addvars(result, string.empty(), 'NewVariableNames', "stimulus");
%% Practice Block
if block == 1
    % introduction
    IntroImage = imread('stimuli/introduction.png');
    PracticeImage = imread('stimuli/practice.png');
    IntroChoiceOnset = imread('stimuli/practice/choice_onset.png');
    IntroChoiceLaunch = imread('stimuli/practice/choice_launch.png');
    IntroChoiceCancel = imread('stimuli/practice/choice_cancel.png');
    %load('stimuli/practice/intro_text.mat');
    %load('stimuli/practice/prac_text.mat');
    %prac_image = image_read(9);
    ShowPicWaitKey(IntroImage);
    %FlipText('Set123距离：', x.x_center, 250);
    %FlipText(intro_text{1,1}, x.x_center, x.y_center);% 杀死x个士兵
    %Screen('Flip', x.window);
    %while KbCheck(), end
    %KbStrokeWait;
    ShowPicWaitKey(imread('stimuli/introduction/intro_SN1.png'));
    ShowPicWaitKey(imread(sprintf('stimuli/introduction/choice%d_1.png',exp)));
    ShowPicWaitKey(imread('stimuli/introduction/intro_SN2.png'));
    ShowPicWaitKey(imread(sprintf('stimuli/introduction/choice%d_2.png',exp)));
    %DrawPic(prac_image{1}, x.y_center-50);
    %FlipText(intro_text{2,1}, x.x_center, 200);% 但会误杀附近的平民/树
    %FlipText(intro_text{3,1}, x.x_center, 260);% 平民/树的照片如下图所示
    %FlipText(intro_text{4,1}, x.x_center, 740);% 你是否选择发射武器
    %FlipText(intro_text{5,1}, x.x_center, 800);% 左箭头发射，右箭头不发射
    %Screen('Flip', x.window);
    %while KbCheck(), end
    % KbStrokeWait;
    % FlipText('再举个例子：',x.x_center, 250);
    % FlipText(intro_text{1,2}, x.x_center, x.y_center);% 杀死x个士兵
    % Screen('Flip', x.window);
    %     while KbCheck(), end
    %     KbStrokeWait;
    %     DrawPic(prac_image{5}, x.y_center-50);
    %     FlipText(intro_text{2,2}, x.x_center, 200);% 但会误杀附近的平民/树
    %     FlipText(intro_text{3,2}, x.x_center, 250);% 平民/树的照片如下图所示
    %     FlipText(intro_text{4,2}, x.x_center, 750);% 你是否选择发射武器
    %     FlipText(intro_text{5,2}, x.x_center, 800);% 左箭头发射，右箭头不发射
    %     Screen('Flip', x.window);
    %     while KbCheck(), end
    %     KbStrokeWait;
    ShowPicWaitKey(PracticeImage);
    % 5 practice trials
    for i = 1:5
        IntroSoldNumPic = imread(sprintf('stimuli/practice/SNP%d.png',i));
        IntroStimPic = imread(sprintf('stimuli/practice/stim%d_%d.png',exp, i));
        % Scree 1
        FlipFix();
        % FlipText(prac_text{i,1}, x.x_center, x.y_center-50);% 杀死士兵
        % FlipText(prac_text{i,2}, x.x_center, x.y_center);% x名
        % Screen('Flip', x.window);
        % WaitSecs(1);
        ShowPicWaitSec(IntroSoldNumPic);
        % Screen 2
        FlipFix();
        ShowPicWaitSec(IntroStimPic);
        FlipFix();
        ShowPic(IntroChoiceOnset);
        t_start = Screen('Flip', x.window);
        while KbCheck(), end
        while GetSecs - t_start < trial_duration
            [keyIsDown, t_end, keyCode] = KbCheck();
            if keyIsDown
                if keyCode(quit_key)
                    ListenChar(0);
                    ShowCursor();
                    Screen('CloseAll');
                    return;
                elseif keyCode(launch_key)
                    ShowPic(IntroChoiceLaunch);
                    Screen('Flip', x.window);
                    WaitSecs(1);
                    break
                elseif keyCode(cancel_key)
                    ShowPic(IntroChoiceCancel);
                    Screen('Flip', x.window);
                    WaitSecs(1);
                    break
                else
                    continue;
                end
            end
        end
    end
end
%% formal exp
% introduction
expintro_image = imread('stimuli/exp.png');
ShowPicWaitKey(expintro_image);
load(sprintf("order/%d.mat",subject));
text_data = text_read;
exp_image = image_read(exp);
soldier_text = '杀死士兵';
ChoiceOnset = imread('stimuli/choice/choice_onset.png');
ChoiceLaunch = imread('stimuli/choice/choice_launch.png');
ChoiceCancel = imread('stimuli/choice/choice_cancel.png');
BreakPic = imread('stimuli/break.png');
%choice_text = {'发射导弹','放弃发射'};
%fix_duration = 0.1*(randi([8,14]));
for i = block:n_block
    outp(port_address, 88);
    WaitSecs(0.004);
    outp(port_address, 0);
    exp_text = text_data(block,:);
    for j = 1:n_trial
        index = stimuli_order(1,48*i+j-48);
        [stim_marker, sold_marker] = MarkerSet(index);
        % Fixation
        t = FlipFix();
        warning off
        result.stimulus(6*j-5) = "fixation";
        result.response(6*j-5) = 99;
        result.rt(6*j-5) = t;
        warning on
        % Soldier number
        %FlipText(soldier_text, x.x_center, x.y_center-50);
        %FlipText(exp_text{index}, x.x_center, x.y_center);% x名士兵
        SoldNumPic = imread(sprintf('stimuli/soilder-number/SN%d.png',exp_text(index)));
        outp(port_address, sold_marker);
        WaitSecs(0.004);
        outp(port_address, 0);
        ShowPicWaitSec(SoldNumPic);
        warning off
        result.stimulus(6*j-4) = sprintf("杀死%d士兵",exp_text(index));
        result.response(6*j-4) = 99;
        result.rt(6*j-4) = 1;
        warning on
        % Fixation
        %outp(port_address, 99);
        %WaitSecs(0.004);
        %outp(port_address, 0);
        t = FlipFix();
        warning off
        result.stimulus(6*j-3) = "fixation";
        result.response(6*j-3) = 99;
        result.rt(6*j-3) = t;
        warning on
        % Decision-making
        outp(port_address, stim_marker);
        WaitSecs(0.004);
        outp(port_address, 0);
        DrawPic(exp_image{block,index}, x.y_center-30);% 人/树照片
        Screen('Flip', x.window);
        WaitSecs(1);
        warning off
        result.stimulus(6*j-2) = index;
        result.response(6*j-2) = 99;
        result.rt(6*j-2) = 1;
        warning on
        t = FlipFix();
        warning off
        result.stimulus(6*j-1) = "fixation";
        result.response(6*j-1) = 99;
        result.rt(6*j-1) = t;
        warning on
        %FlipText('发射', 550, x.y_center-25);% 发射导弹
        %FlipText('放弃', 730, x.y_center-25);% 放弃发射导弹
        %FlipText(choice_text{1}, 400, 850);% 发射导弹
        %FlipText(choice_text{2}, 880, 850);% 放弃发射导弹
        outp(port_address, 99);
        WaitSecs(0.004);
        outp(port_address, 0);
        ShowPic(ChoiceOnset);
        t_start = Screen('Flip', x.window);
        warning off
        while KbCheck(), end
        while GetSecs - t_start < trial_duration
            [keyIsDown, t_end, keyCode] = KbCheck();
            if keyIsDown
                if keyCode(quit_key)
                    ListenChar(0);
                    ShowCursor();
                    Screen('CloseAll');
                    return;
                elseif keyCode(launch_key)
                    result.rt(6*j) = GetSecs - t_start;
                    outp(port_address, 100);
                    WaitSecs(0.004);
                    outp(port_address, 0);
                    response = 1;
                    % FlipText('发射', 550, x.y_center-25);% 发射导弹
                    % FlipText('放弃', 730, x.y_center-25);% 放弃发射导弹
                    % FlipText('——', 550, x.y_center);
                    ShowPicWaitSec(ChoiceLaunch);
                    % Screen('Flip', x.window);
                    % WaitSecs(1);
                    %outp(port_address, 9);
                    %WaitSecs(0.004);
                    %outp(port_address, 0);
                    break
                elseif keyCode(cancel_key)
                    result.rt(6*j) = GetSecs - t_start;
                    outp(port_address, 200);
                    WaitSecs(0.004);
                    outp(port_address, 0);
                    response = 0;
                    % FlipText('发射', 550, x.y_center-25);% 发射导弹
                    % FlipText('放弃', 730, x.y_center-25);% 放弃发射导弹
                    % FlipText('——', 730, x.y_center);
                    % Screen('Flip', x.window);
                    % WaitSecs(1);
                    ShowPicWaitSec(ChoiceCancel);
                    %outp(port_address, 9);
                    %WaitSecs(0.004);
                    %outp(port_address, 0);
                    break
                else
                    continue;
                end
            end
        end
        if GetSecs - t_start >= trial_duration % don't response
            outp(port_address, 199);
            WaitSecs(0.004);
            outp(port_address, 0);
            response = 99;
        end
        result.stimulus(6*j) = index;
        result.response(6*j) = response;
        warning on
    end
    % save data
    writetable(result, sprintf('result/sub_%d/block_%d.csv', subject, i));
    % rest
    if i <= 3
        %rest_text1 = '请休息一下，休息过程中请不要操作电脑';
        %rest_text2 = '休息结束后，请呼叫主试帮你开启下一轮实验';
        %FlipText(rest_text1, x.x_center, x.y_center-25);
        %FlipText(rest_text2, x.x_center, x.y_center+25);
        %Screen('Flip', x.window);
        outp(port_address, 66);
        outp(port_address, 0);
        ShowPicWaitKey(BreakPic);
        %while KbCheck(), end
        %KbStrokeWait;
    end
end
%% finish
finish_image = imread('stimuli/finish.png');
ShowPicWaitKey(finish_image);
Screen('CloseAll');
ListenChar(0);
ShowCursor();
final_data = readtable(sprintf('result/sub_%d/block_1.csv', subject));
for i = 2:4
    final_data = vertcat(final_data, readtable(sprintf('result/sub_%d/block_%d.csv', subject, i)));
end
writetable(final_data, sprintf('result/sub_%d/result.csv', subject));
%% Functions
% Setting Markers
function [stim_marker, sold_marker] = MarkerSet(index)
if index<=4
    stim_marker = 111;
    sold_marker = 1;
elseif index<=8&&index>4
    stim_marker = 112;
    sold_marker = 1;
elseif index<=12&&index>8
    stim_marker = 121;
    sold_marker = 1;
elseif index<=16&&index>12
    stim_marker = 122;
    sold_marker = 1;
elseif index<=24&&index>16
    stim_marker = 113;
    sold_marker = 1;
elseif index<=28&&index>24
    stim_marker = 211;
    sold_marker = 2;
elseif index<=32&&index>28
    stim_marker = 212;
    sold_marker = 2;
elseif index<=36&&index>32
    stim_marker = 221;
    sold_marker = 2;
elseif index<=40&&index>36
    stim_marker = 222;
    sold_marker = 2;
elseif index<=48&&index>40
    stim_marker = 213;
    sold_marker = 2;
end
end
% Show picture untill key is press down
function ShowPicWaitKey(image)
global x
texture = Screen('MakeTexture', x.window, image);
Screen('DrawTexture', x.window, texture);
Screen('Flip', x.window);
while KbCheck(), end
KbStrokeWait;
Screen('Flip', x.window);
end
% Draw text on screen
% function FlipText(text, t_x, y)
% global x
% text = double(native2unicode(text));
% ins_size = 30;
% Screen('TextSize', x.window, ins_size);
% rect = Screen('TextBounds', x.window, text);
% width = rect(3) - rect(1);
% text_x = (2*t_x-width)/2;
% DrawFormattedText(x.window, text, text_x, y, x.ins_color);
% end
% Draw fixation
function fixation_duration = FlipFix(~)
global x %#ok<*GVMIS> 
fixation_duration = 0.1*(randi([8,14]));
fixation = '+';
fixation_size = 100;
Screen('TextSize', x.window, fixation_size);
rect = Screen('TextBounds', x.window, fixation);
width = rect(3) - rect(1);
highth = rect(2) - rect(1);
fix_x = (2*x.x_center-width)/2;
%fix_y = (2*x.y_center-highth)/2;
DrawFormattedText(x.window, fixation, fix_x, x.y_center+50, x.ins_color);
% Screen('DrawText', x.window, fixation, x.x_center-0.5*fixation_size, x.y_center-0.5*fixation_size, x.ins_color);
Screen('Flip', x.window);
WaitSecs(fixation_duration);
end
% Draw picture on screen
function DrawPic(image,y)
global x
texture = Screen('MakeTexture', x.window, image);
width = 0.20 * x.windowRect(3);
height = width*(5/4);
rect = [x.x_center-0.5*width, y-0.5*height, x.x_center+0.5*width, y+0.5*height];
Screen('DrawTexture', x.window, texture, [], rect);
end
% Show picture untill key is press down
function ShowPicWaitSec(image)
global x
texture = Screen('MakeTexture', x.window, image);
Screen('DrawTexture', x.window, texture);
Screen('Flip', x.window);
WaitSecs(1);
end
function ShowPic(image)
global x
texture = Screen('MakeTexture', x.window, image);
Screen('DrawTexture', x.window, texture);
% Screen('Flip', x.window);
end