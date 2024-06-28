%初始化
clear
clc
close all
%%读取数据
load('peak.mat')
M=mapminmax(peak,0,1);
train_data=M(:,1:90);%训练集
test_data=M(:,91:100);%测试集
b=train_data
rowrank1 = randperm(size(b,2));     % size获得b的列数，randperm打乱各列的顺序
ptrain = b(:,rowrank1);             % 按照rowrank重新排列各列，注意rowrank的位置
test= test_data;%测试集

input_train=ptrain(1:2,:);
output_train=ptrain(3,:);
input_test=test(1:2,:);
output_test=test(3,:);

%% 构建BP神经网络

net=newff(input_train,output_train,[8,15,9]);
%网络参数
%net.trainFcn = 'trainbr'; % 贝叶斯正则化算法;
net.trainParam.epochs=10000;        %训练次数
net.trainParam.lr=0.001;            %学习速率
net.trainParam.goal=0.000001;      %训练目标最小误差
% net.trainParam.mc=0.95;          % 附加动量因子
% net.trainParam.min_grad=0.00001;% 最小性能梯度

%% BP神经网络训练
net=train(net,input_train,output_train);
% 保存模型
save bestnet net;
load('bestnet');
%% BP神经网络测试
an=sim(net,input_test);            %用训练好的模型进行仿真
                                   % test_simu=mapminmax('reverse',an,outputps);  %预测结果反归一化
error=an-output_test;              %预测值和真实值的误差
%% 真实值与预测值误差比较
figure(1)
plot(output_test,'bo-')
hold on
plot(an,'r*-')
hold on
legend('期望值','预测值')
xlabel('数据组数'),ylabel('值'),title('BP神经网络测试集预测值和期望值的误差对比')
%% 计算误差
[~,len]=size(output_test);
MAE1=sum(abs(error./output_test))/len;
MSE1=error*error'/len;
RMSE1=MSE1^(1/2);
R = corrcoef(output_test,an);
r = R(1,2);
disp(['........BP神经网络误差计算................'])
disp(['平均绝对误差MAE为:',num2str(MAE1)])
disp(['均方误差为MSE:',num2str(MSE1)])
disp(['均方根误差RMSE为:',num2str(RMSE1)])
disp(['决定系数 R^2为:',num2str(r)])

