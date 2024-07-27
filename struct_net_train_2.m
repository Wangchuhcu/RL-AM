clc
clear all
%初始的神经网络
layers = [
    featureInputLayer(4, 'Normalization', 'none', 'Name', 'input')
    %%%%%%%%第一层隐藏层
    fullyConnectedLayer(120, 'Name', 'fc1_test')
    reluLayer('Name', 'relu1')
    % %dropoutLayer(0.5, 'Name', 'dropout1') % 添加Dropout层
    %%%%%%%%第二层隐藏层
    fullyConnectedLayer(240, 'Name', 'fc2_test')
    reluLayer('Name', 'relu2')

    %%%%%%%%第三层隐藏层
    fullyConnectedLayer(120, 'Name', 'fc3_test')
    reluLayer('Name', 'relu3')

    % fullyConnectedLayer(30, 'Name', 'fc3')
    % reluLayer('Name', 'relu3')
    % %dropoutLayer(0.5, 'Name', 'dropout2') % 添加Dropout层
    fullyConnectedLayer(1, 'Name', 'fc4_test')
    ];
train_net_2 = dlnetwork(layers);%构建网络饼命名为net
save('train_net_2.mat', 'train_net_2');

