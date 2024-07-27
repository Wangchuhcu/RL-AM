function [alpha_result]=comsol_matlab(adjust_cell,result_sore)
%%该脚本用于MATLAB和COMSOL的联合仿真/This script is used for the co-simulation of MATLAB and COMSOL

[ad_line,ad_row]=size(adjust_cell);%ad_row表示一共有几个组件
[res_line,res_row]=size(adjust_cell{1,1});%res_line表示几个谐振器耦合
%% 导入对应mph文件/Import the corresponding mph file
if res_line ==4
   
    model = mphopen('comsol_matlab/helmholtz_four.mph');
elseif res_line ==1
    model = mphopen('comsol_matlab/helmholtz_one.mph');
elseif res_line ==2
    model = mphopen('comsol_matlab/helmholtz_two.mph');
elseif res_line ==3
    model = mphopen('comsol_matlab/helmholtz_three.mph');
elseif res_line ==5
    model = mphopen('comsol_matlab/helmholtz_five.mph');
elseif res_line ==6
    model = mphopen('comsol_matlab/helmholtz_six.mph');
elseif res_line ==7
    model = mphopen('comsol_matlab/helmholtz_seven.mph');
elseif res_line ==8
    model = mphopen('comsol_matlab/helmholtz_eight.mph');
elseif res_line ==9
    model = mphopen('comsol_matlab/helmholtz_nine.mph');
elseif res_line ==10
    model = mphopen('comsol_matlab/helmholtz_ten.mph');
elseif res_line ==11
    model = mphopen('comsol_matlab/helmholtz_eleven.mph');
elseif res_line ==12
    model = mphopen('comsol_matlab/helmholtz_twelve.mph');

end


%%


%figure();
%mphgeom(model, 'geom1', 'FaceAlpha', 0.5);%画出初始图，透明
par_all=mphgetexpressions(model.param);%得到所有参数
%分别得到各结构参数/Each structural parameter is obtained separately
par_bh=mphgetexpressions(model.param('default'));
par_qc=mphgetexpressions(model.param('par2'));
par_qk=mphgetexpressions(model.param('par3'));
par_jr=mphgetexpressions(model.param('par4'));
par_qg=mphgetexpressions(model.param('par5'));
par_jg_x=mphgetexpressions(model.param('par6'));
par_jg_s=mphgetexpressions(model.param('par7'));





% 创建一个新的图形窗口

%% 将最好的评分单独画出来/Draw the best ratings separately
[num_best_line,num_best_row]=max(result_sore);%获取最优组件的索引
best_comp=adjust_cell{ad_line,num_best_row};%提取最优组件的结构参数
%将其结构参数转化为字符串/Convert its structural parameters to strings
str_best_comp = string(0);
str_best_comp = arrayfun(@(x) sprintf('%.3f[mm]', x), best_comp, 'UniformOutput', false);

best_figure=figure('Visible', "on");

for num_part_best=1:res_line
    
    model.param.set(par_qc(num_part_best,1), str_best_comp(num_part_best,2));%设置qc参数值
    model.param.set(par_qk(num_part_best,1), str_best_comp(num_part_best,3));%设置qk参数值
    model.param.set(par_jr(num_part_best,1), str_best_comp(num_part_best,4));%设置jr参数值
    model.param.set(par_qg(num_part_best,1), str_best_comp(num_part_best,5));%设置jr参数值
    model.param.set(par_jg_x(num_part_best,1), str_best_comp(num_part_best,6));%设置jr参数值
    model.param.set(par_jg_s(num_part_best,1), str_best_comp(num_part_best,7));%设置jr参数值
end
mphgeom(model, 'geom1', 'FaceAlpha', 0.5);%画出初始图，透明
text(0, 0, 0, ['结果评分:', num2str(num_best_line)],'FontSize', 13, 'FontWeight', 'bold','Color', 'red');
%将获得的结构参数图片存储到文件中/Store the obtained picture of the structure parameters in a file.
exportgraphics(gcf, 'structure_picture/best_structure.png', 'Resolution', 300);
% 关闭图形窗口
%close(best_figure);
model.study('std1').feature('freq').set('plist', 'range(250,2,600)');%更改频率范围
model.study("std1").run%运行研究1
alpha=mphglobal(model,"alpha");%获取输出的吸声系数
plistValue = mphglobal(model, 'freq'); % 获取参数frequent的值

plot(plistValue,alpha)%画出吸声系数曲线/Draw the sound absorption coefficient curve

mphgetexpressions(model.param);

alpha_result{1}=[alpha,plistValue]%将吸声系数曲线结果返回/Return the results of the sound absorption coefficient curve
end
