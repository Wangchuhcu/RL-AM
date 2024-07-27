function [result]=function_use_rein_learning(target_frequent,aim_alph,aim_alph_ero,epochs,max_round,k_h,k_e,qk,qc)
tic;  % 程序运行计时/Program runtime timing
%开始编写强化学习主程序/Start writing the main program for reinforcement learning.
%clc
%clear all
%% 读取动作选择库数据/Read action selection library data
if qk == 20 && qc == 20
    fprintf("选择腔宽=20，腔长等于20的动作库/cavity width=20,cavity length=20");
    saveVarsMat = load('action_libirary/use_data_qk_20_qg_20.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.
elseif qk == 15 && qc == 30
    fprintf("选择腔宽=15，腔长等于30的动作库/cavity width=15,cavity length=30");
    saveVarsMat = load('action_libirary/use_data_qk_15_qg_30.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.
elseif qk == 35 && qc == 20
    fprintf("选择腔宽=35，腔长等于20的动作库/cavity width=35,cavity length=20");
    saveVarsMat = load('action_libirary/use_data_qk_35_qg_20.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.

elseif qk == 32 && qc == 32
    fprintf("选择腔宽=32，腔长等于32的动作库/cavity width=32,cavity length=32");
    saveVarsMat = load('action_libirary/use_data_qk_32_qg_32.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.

elseif qk == 15 && qc == 15
    fprintf("选择腔宽=15，腔长等于15的动作库/cavity width=15,cavity length=15");
    saveVarsMat = load('action_libirary/use_data_qk_15_qg_15.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.

elseif qk == 25 && qc == 25
    fprintf("选择腔宽=25，腔长等于25的动作库/cavity width=25,cavity length=25");
    saveVarsMat = load('action_libirary/use_data_qk_25_qg_25.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.

elseif qk == 30 && qc == 30
    fprintf("选择腔宽=30，腔长等于30的动作库/cavity width=30,cavity length=30");
    saveVarsMat = load('action_libirary/use_data_qk_30_qg_30.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.

else%如果没有对应的动作库则默认选择20mm动作库/If there is no corresponding action library, the default choice is the 20mm action library.
    fprintf('选择默认的动作库/Select the default action library.');
    qk=20
    qc=20
    saveVarsMat = load('20qk_filter.mat');
    use_data = saveVarsMat.use_data_final;%将数据存储在use_data/Store the data in use_data.
end
%%

%% 数据映射-找到状态参数的最大值/Data Mapping - Finding the Maximum Value of State Parameters
data_qg = use_data(:, 4);%提取腔高数据/Extracting cavity height data
data_d0 = 2*use_data(:, 5);%提取颈部直径数据/Extract neck diameter data
data_jg = use_data(:, 6);%提取颈高数据/Extracting Neck-High Data

max_qg_error = max(data_qg)-min(data_qg);%第一个神经元的最大值/Maximum value of the first neuron

max_d0_error = max(data_d0)-min(data_d0);%第二个神经元的最大值/Maximum value of the second neuron

max_jg_error=max(data_jg)-min(data_jg);%第三个神经元的最大值/The maximum value of the third neuron

map_list = [max_qg_error,max_d0_error,max_jg_error,1];%四个神经元的映射列表/List of mappings for four neurons
%%

%% 输入求解吸声系数的参数/Input parameters for calculating the sound absorption coefficient.
target_frequent=target_frequent;
aim_alph=aim_alph;
aim_alph_ero=aim_alph_ero;
max_round=max_round;
epochs=epochs;
qk=qk*10^(-3);%腔宽/cavity width
qc=qc*10^(-3);%腔长/accent length
dc=2*sqrt(qk*qc/pi);%内壁等效直径/Equivalent Diameter of Inner Wall
K=0.0258;
u=1.814e-5;
Cp=1004;
v=1.4;
c0=343;
p0=1.2;
j=sqrt(-1);
f=30:1:700;%求解频率范围/Determine frequency range
w=2*pi*f;
k0=w./c0;
z0=p0*c0;
%%


%% 导入神经网络/Importing neural networks
load('train_net_2.mat','train_net_2');
action_probability=0.7;%概率阈值/Probability Threshold
%%

num_frequent=length(target_frequent);%设计目标的数量/Number of design objectives
result_cell={};%存储所有符合要求的结果/Store all compliant results
fale_result_cell={};%存储所有不符合要求的结果/Store all non-compliant results
result_plot_cell={};%存储所有符合要求的吸声系数曲线用于在APP中画图/Store all compliant sound absorption coefficient curves for plotting in the APP.
fale_result_plot_cell={};%存储所有不符合要求的吸声系数曲线用于在APP中画图/Store all non-compliant sound absorption coefficient curves for plotting in the APP.
result_error=[];%存储所有符合要求的误差/Store all conforming errors
fale_result_error=[];%存储所有不符合要求的误差/Store all non-conforming errors
result_sore=[];%存储所有的评分/Store all ratings
fre_cell = cell(1,num_frequent);%创建一个free_cell存储目标频率处的数据/Create a free_cell to store the data at the target frequency
qg_error_cell = cell(1,num_frequent);%创建一个qg_error_cell存储各个状态下的腔高与目前腔高的差/
d0_error_cell = cell(1,num_frequent);%创建一个d0_error_cell存储各个状态下的颈部直径与目前颈部直径的差/
jg_error_cell = cell(1,num_frequent);%创建一个jg_error_cell存储各个状态下的颈高与目前颈高/
alph_error_cell=cell(1,num_frequent);%储存不同频率下当前吸声系数与目标吸声系数的误差
deep_input_cell=cell(1,num_frequent);%储存不同频率下输入数据/
input_mapp_cell=cell(1,num_frequent);%储存不同频率下映射后的输入数据/
deep_output_cell=cell(1,num_frequent);%储存不同频率下神经网络的输出数据/
round_list=[];%存储一轮训练所需要的回合数/
fale_round_list=[];%存储不符合条件的回合数/
error_list=[];%存储一轮训练的最小误差/
row_list=[];%收集动作的总索引数/
inite_random_list=[];%储存初始曲线索引

%% 将动作库数据导入到fre_cell中/Import action library data into fre_cell
for i = 1:num_frequent
    rows_test = use_data(:,1) == target_frequent(i); %这里表示提取频率在总数据集中的索引/Here represents the index of the extraction frequency in the total dataset
    fre_cell{i}=use_data(rows_test, :);
end
%%


% 开始正式循环/Start the official cycle.
count=1;%while循环的计数器/While loop counter
while count <= epochs
    all_alph_erorr=[];%存储本回合的状态误差列表/Stores the list of state errors for the round
    all_action=[];%存储本回合所有的动作选择/Stores all action selections for the round
    no_change_action=[];

    %% 智能体随机选择动作形成初始状态/The intelligent agent randomly selects actions to form the initial state.
    
    for num_random = 1:num_frequent
        [rows_fre,cols_fre]=size(fre_cell{num_random});
        row_list(1,end+1)=rows_fre;
        random_numbers = randi([1, rows_fre], 1, 2);
        inite_random_list(1,num_random)=random_numbers(2);%随机选择的动作在动作库中的索引/Index of randomly selected actions in the action library
        action(1,num_random)=random_numbers(2);%随机选择的动作在动作库中的索引/Index of randomly selected actions in the action library
        init_state(num_random,:)=fre_cell{num_random}(random_numbers(2),:);%智能体找到初始选择的动作/Intelligent body finds the initially selected action

    end
    %% 
    
    %% 计算初始状态的吸声系数曲线/Calculate the sound absorption coefficient curve for the initial state
    for num_f = 1:num_frequent

        qg_state(1,num_f)=  init_state(num_f, 4); % 初始状态的腔高/Initial state cavity height
        d0_state(1,num_f)= 2* init_state(num_f, 5); % 初始状态的颈直径/Initial state neck diameter
        jg_state(1,num_f) =  init_state(num_f, 6); % 初始状态的径高/Initial State Trail Height

    end
    
    %计算目前状态的吸声系数/Calculation of sound absorption coefficients for the current state
    init_result=reain_absorpt(f, d0_state, j, w, p0, Cp, K, u, k0, v, c0, jg_state, dc, qg_state, z0);
    init_indices=find(ismember(init_result(1, :), target_frequent));%找到目标频率处的索引/Find the index at the target frequency
    init_alph = init_result(2, init_indices);%找到设计目标频率处的吸声系数/Find the sound absorption coefficient at the design target frequency
    %%
   
    %% 当前状态与目标吸声系数误差/Error of current state and target absorption coefficient
    all_action(:,end+1)=inite_random_list;%存储初始状态的动作选择索引/Stores the action selection index for the initial state
    alph_error=aim_alph-init_alph;%目标与当前状态的吸声系数误差/Error in absorption coefficient between target and current state
    all_alph_erorr(1,end+1)=mean(abs(alph_error));%储存所有回合的状态误差/Storing status errors for all rounds
    %%
    

    %% 开始编写强化学习/Starting to write intensive learning

    round=1;%回合数/round
    %当最大误差小于aim_alph_ero时取消循环/Cancel loop when maximum error is less than aim_alph_ero
    while mean(abs(alph_error))>aim_alph_ero
        round=round+1;
        %% 状态误差/state error
        for num_inp = 1:num_frequent
            %动作与智能体的腔高差/Cavity height difference between the action and the smart body
            qg_error_cell{num_inp}=fre_cell{num_inp}(:,4)-qg_state(1,num_inp);
            %动作与智能体的颈部直径差/Difference in neck diameter between the % action and the smart body
            d0_error_cell{num_inp}=2*fre_cell{num_inp}(:,5)-d0_state(1,num_inp);
            %动作与智能体的颈高差/Neck height difference between action and intelligence
            jg_error_cell{num_inp}=fre_cell{num_inp}(:,6)-jg_state(1,num_inp);
            [rows_fre,cols_fre]=size(fre_cell{num_inp});
            alph_error_cell{num_inp}=ones(rows_fre,1)*alph_error(num_inp);%吸声系数误差/sound absorption coefficient error
            deep_input_cell{num_inp}=vertcat(qg_error_cell{num_inp}', d0_error_cell{num_inp}', jg_error_cell{num_inp}',alph_error_cell{num_inp}');%神经网络输入的状态误差数据

        end
        %%

        %% 对输入数据进行0-10之间的映射处理/Mapping of input data between 0 and 10
        for num_cell = 1:num_frequent
           for num = 1:4
               
                input_mapp_cell{num_cell}(num,:) = deep_input_cell{num_cell}(num,:)*(10/map_list(num));

            end

        end
        %%


        %% 根据动作选择更新状态/Selection of update status based on action
        for num_action = 1:num_frequent
            dlX = dlarray(input_mapp_cell{num_action} , 'CB');%将映射后数据转换为神经网络可输入数据
            deep_output_cell{num_action} = predict(train_net_2,dlX);%得到神经网络输出的动作价值
            [max_value, max_index]=max(deep_output_cell{num_action}); %找到数组中最大的数及其索引
            action_rand = rand;%在0到1之间随机选择一个随机数
            [rows_fre,cols_fre]=size(fre_cell{num_action});
            random_numbers = randi([1, rows_fre], 1, 1);%在目标频率列表数目范围内随机选择一个数
            %如果没达到指定吸声系数
            if abs(alph_error(num_action))>=aim_alph_ero
                
                action(1,num_action)=max_index;%有action_probability的概率选择最大价值或者随机选择动作更新
                if action_rand > action_probability
        
                    action(1,num_action)=random_numbers;%有1-action_probability的概率变换动作

                end
            %如果某个智能体达到了目标，在之后的回合更新中就不再更新动作了
            else
                no_change_action(1,num_action)=target_frequent(num_action);

            end

            
            %更新状态/Update Status
            change_state(num_action,:)=fre_cell{num_action}(action(1,num_action),:);
            qg_state(1,num_action)=  change_state(num_action, 4); 
            d0_state(1,num_action)= 2* change_state(num_action, 5); 
            jg_state(1,num_action) =  change_state(num_action, 6); 


        end
        %%

        %% 更新后目标与当前吸声系数的差距/Difference between updated targets and current sound absorption coefficients
        updata_result=reain_absorpt(f, d0_state, j, w, p0, Cp, K, u, k0, v, c0, jg_state, dc, qg_state, z0);
        updata_indices=find(ismember(updata_result(1, :), target_frequent));
        updata_alph = updata_result(2, updata_indices);
        
        alph_error=aim_alph-updata_alph;%更新当前与目标吸声系数误差

        all_alph_erorr(1,end+1)=mean(abs(alph_error));%将本回合误差输入到误差列表中
        all_action(:,end+1)=action;%将更新的动作储存在all_action
        %%


        %% 如果达到目标终止条件则终止程序/Terminate the program if the target termination condition is reached
        if mean(abs(alph_error))<=aim_alph_ero
           
            break;
            
        end
        %%
        
        %% 每隔100回合输出当前最大误差/Output the current maximum error every 100 rounds
        if mod(round, 100) == 0
            fprintf('当前回合数 %d, 平均误差度: %.2f\n', round, all_alph_erorr(1,end));
            no_change_action;
            
        end
        %%

        %% 如果达到最大回合数结束一轮的循环/If the maximum number of rounds is reached, the cycle ends.
        if round >=max_round

            break;
        end

        %%

    end


    
    

    %% 找到每轮计算的误差最小的结果/Find the result that minimizes the error in each round of calculations
    error_list(1,end+1)=min(all_alph_erorr);%存储一轮训练的最小误差
    [max_value, max_index]=min(all_alph_erorr);%找到最小误差所在的索引
    min_action=all_action(:,max_index);%找到该索引对应的动作
    

    for num_action = 1:num_frequent
        draw_state(num_action,:)=fre_cell{num_action}(min_action(num_action,1),:);
        qg_min(1,num_action)=  draw_state(num_action, 4); % 第4列的数据
        d0_min(1,num_action)= 2* draw_state(num_action, 5); % 第5列的数据
        jg_min(1,num_action) =  draw_state(num_action, 6); % 第6列的数据

    end

    draw_result=reain_absorpt(f, d0_min, j, w, p0, Cp, K, u, k0, v, c0, jg_min, dc, qg_min, z0);

    min_epoch_draw_result=draw_result;%记录每回合最小的画图曲线

    draw_indices=find(ismember(draw_result(1, :), target_frequent));
    draw_alph = draw_result(2, updata_indices);
    opt_alph_error=aim_alph-draw_alph;%本轮训练最小的状态误差
   
    %%
    
    count = count + 1; % 更新计数器
    
    
    if mean(abs(opt_alph_error))<=aim_alph_ero

        result_cell(1,end+1)={change_state};%如果达到目标则将结构参数存储在result_cell/
        result_error(1,end+1)=mean(abs(alph_error));%如果达到目标则将误差信息存储在result_error/
        result_plot_cell(1,end+1)={updata_result};%如果达到目标则将画图信息存储在result_plot_cell/
        round_list(1,end+1)=round;%如果达到目标则将回合信息存储在round_list/
        fprintf('本回合：%d  达到目标值，误差值: %.3f 回合数:%d\n', count,mean(abs(alph_error)),round);
    else
        fale_result_cell(1,end+1)={change_state};
        fale_result_error(1,end+1)=mean(abs(alph_error));
        fale_result_plot_cell(1,end+1)={updata_result};
        fale_round_list(1,end+1)=round;
        fprintf('本回合：%d  没达到目标值，误差值: %.3f 回合数:%d\n', count,mean(abs(alph_error)),round);
        
    end

    
    
    

   

end


%% 获取需要显示在APP中的数据/Get the data that needs to be displayed in the app
[cell_rows, cell_cols] = size(result_cell);
if cell_cols == 0
    fprintf("呜呜，没找到结果/");
    result_cell=fale_result_cell;
    result_error=fale_result_error;
    result_plot_cell=fale_result_plot_cell;
    round_list=fale_round_list;

end
%%

[cell_rows, cell_cols] = size(result_cell);
%频率、腔宽、腔长、颈半径、改变后腔高、颈高下、颈高上、总高度/
adjust_cell={};%该数组存储声学超材料的结构参数/
for num_cell2=1:cell_cols
    cell_state=result_cell{1,num_cell2};
    state_rows = size(cell_state, 1);%获得一共几个谐振器
    jg_x=[];%收集调用结果的jg下数据
    jg_s=[];%收集调用结果的jg上数据
    high_all=[];%收集总高度
    v_change_qg=[];%收集调整后腔高的数据
    bh=1;%颈部的壁厚
    for num_action=1:state_rows
        qc_cell(1,num_action)=  1000*cell_state(num_action, 2); 
        qk_cell(1,num_action)=  1000*cell_state(num_action, 3); 
        qg_cell(1,num_action)=  1000*cell_state(num_action, 4); 
        r0_cell(1,num_action)= 1000*cell_state(num_action, 5); 
        jg_cell(1,num_action) =  1000*cell_state(num_action, 6); 
    end

    for num_exchange=1:state_rows

        if qg_cell(1,num_exchange)>=jg_cell(1,num_exchange)
            jg_x(1,end+1)=jg_cell(1,num_exchange)-2;
            jg_s(1,end+1)=2;
        else
            jg_x(1,end+1)=qg_cell(1,num_exchange)-2;
            jg_s(1,end+1)=jg_cell(1,num_exchange)-qg_cell(1,num_exchange)+2;
        end
        v_jg_x=jg_x(1,num_exchange)*pi*(r0_cell(1,num_exchange)+bh)^2;%颈高下的体积
        v_init_qt=qg_cell(1,num_exchange)*qk_cell(1,num_exchange)^2;%腔体的体积
        v_change_qg(1,end+1)=(v_init_qt+v_jg_x)/(qk_cell(1,num_exchange)^2);%调整后嵌体的高度
        high_all=v_change_qg+jg_s;
    end
    %频率、腔宽、腔长、颈半径、改变后腔高、颈高下、颈高上、总高度
    cell_change=[cell_state(:, 1),qc_cell',qk_cell',r0_cell',v_change_qg',jg_x',jg_s',high_all'];
    adjust_cell(1,end+1)={cell_change};%将转化后的数据存储在adjust_cell
    
    % 开始编写结构筛选函数
    result_sore(end+1,1)=k_h*mean(high_all)+k_e*2/result_error(1,num_cell2);

end
%%

%% 找到得分最大的结构，返回结构参数/Find the structure with the largest score and return the structure parameters
[max_value_sore, max_index_sore] = max(result_sore);

max_result=adjust_cell{max_index_sore}%得分最高的设计结果的结构参数

max_result_plot = result_plot_cell{max_index_sore};
result_plot_data=max_result_plot';%得分最高的设计结果的吸声系数曲线
result_data_write=[round_list',result_error',result_sore]%得分最高的设计结果的回合数，误差，结果评分

fprintf('最好结果的索引：%d 最好结果的误差: %.3f\n', max_index_sore,result_error(max_index_sore));
fprintf(' 最好结果的评分: %.3f\n',  max_value_sore);
%函数返回第一个值是最好的结果的参数值，第二个值是最好结果的吸声系数曲线
result{1}=max_result;%第一个返回结构参数
result{2}=max_result_plot;%第二个返回画图相关数据
result{3}=result_error(max_index_sore);%第三个返回平均误差
result{4}=max_value_sore;%第四个返回最好结果的评分
result{5}=adjust_cell;%第五个返回所有符合要求的结果
result{6}=result_sore;%第六个返回所有结构的评分

%将画图数据存储在Excel文件中/Storing drawing data in an Excel file
writematrix(result_plot_data, 'result_plot_data.xlsx');%最好结果的吸声系数曲线
writematrix(result_data_write, 'result_data_write.xlsx');%每个结果的回合数、状态误差、结果评分

        

%%

round_list;
elapsedTime = toc;  % 结束计时,获取消耗的时间/End the timer and get the elapsed time
elapsedTimeString = sprintf('%.2f s', elapsedTime);
disp(['运行时间为：' elapsedTimeString ' 秒']);


result{7}=elapsedTimeString;%第七个返回模型运行消耗的时间

end


