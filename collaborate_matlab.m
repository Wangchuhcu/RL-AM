function collaborate_matlab(adjust_cell,result_sore)
%该脚本将MATLAB得到的结构参数导入到comsol软件中，然后画出结构图片并导回到APP中/
%The script imports the structural parameters obtained from MATLAB into the comsol software, then draws a picture of the structure and imports it back into the app
[ad_line,ad_row]=size(adjust_cell);%ad_row表示一共有几个组件
[res_line,res_row]=size(adjust_cell{1,1});%res_line表示几个谐振器耦合
%% 导入对应mph文件
if res_line ==4
   
    model = mphopen('helmholtz_collection/helmholtz_four.mph');
elseif res_line ==1
    model = mphopen('helmholtz_collection/helmholtz_one.mph');
elseif res_line ==2
    model = mphopen('helmholtz_collection/helmholtz_two.mph');
elseif res_line ==3
    model = mphopen('helmholtz_collection/helmholtz_three.mph');
elseif res_line ==5
    model = mphopen('helmholtz_collection/helmholtz_five.mph');
elseif res_line ==6
    model = mphopen('helmholtz_collection/helmholtz_six.mph');
elseif res_line ==7
    model = mphopen('helmholtz_collection/helmholtz_seven.mph');
elseif res_line ==8
    model = mphopen('helmholtz_collection/helmholtz_eight.mph');
elseif res_line ==9
    model = mphopen('helmholtz_collection/helmholtz_nine.mph');
elseif res_line ==10
    model = mphopen('helmholtz_collection/helmholtz_ten.mph');
elseif res_line ==11
    model = mphopen('helmholtz_collection/helmholtz_eleven.mph');
elseif res_line ==12
    model = mphopen('helmholtz_collection/helmholtz_twelve.mph');

end


%%


%figure();
%mphgeom(model, 'geom1', 'FaceAlpha', 0.5);%画出初始图，透明
par_all=mphgetexpressions(model.param);%得到所有参数
%分别得到各结构参数
par_bh=mphgetexpressions(model.param('default'));
par_qc=mphgetexpressions(model.param('par2'));
par_qk=mphgetexpressions(model.param('par3'));
par_jr=mphgetexpressions(model.param('par4'));
par_qg=mphgetexpressions(model.param('par5'));
par_jg_x=mphgetexpressions(model.param('par6'));
par_jg_s=mphgetexpressions(model.param('par7'));




rows = 3;%总图的行数
cols = 3;%总图列数
% 创建一个新的图形窗口
all_figure=figure('Visible', 'off');
%% 第一个for循环用来遍历几个结果的结构
for num_cell = 1:ad_row
    comp=adjust_cell{ad_line,num_cell};%提取一个组件的结构参数
    %求出组件中最高的谐振器高度
    high_all=comp(:,8);
    max_high=max(high_all);%最大高度
    current_result_sore=result_sore(num_cell);
    %将其结构参数转化为字符串
    str_comp = string(0);
    str_comp = arrayfun(@(x) sprintf('%.3f[mm]', x), comp, 'UniformOutput', false);
    %第二个for循环用来依次改变结构参数，par_line表示一个组件里有几个谐振器
    for num_part=1:res_line
        model.param.set(par_qc(num_part,1), str_comp(num_part,2));%设置qc参数值
        model.param.set(par_qk(num_part,1), str_comp(num_part,3));%设置qk参数值
        model.param.set(par_jr(num_part,1), str_comp(num_part,4));%设置jr参数值
        model.param.set(par_qg(num_part,1), str_comp(num_part,5));%设置jr参数值
        model.param.set(par_jg_x(num_part,1), str_comp(num_part,6));%设置jr参数值
        model.param.set(par_jg_s(num_part,1), str_comp(num_part,7));%设置jr参数值
    end
    subplot(rows, cols, num_cell);
    mphgeom(model, 'geom1', 'FaceAlpha', 0.5);%画出初始图，透明
    %text(-15, 0, 0, ['结果评分:', num2str(current_result_sore)]);
    text(0, 0, 0, ['Sore:', num2str(current_result_sore)],'FontSize', 13, 'FontWeight', 'bold','Color', 'red');
    %text(-15, 0, -30, ['最大高度', num2str(max_high), '[mm]']);

end
%将获得的结构参数图片存储到文件中/Store the obtained picture of the structure parameters in a file
exportgraphics(gcf, 'structure_picture/all_structure.png', 'Resolution', 300);
close(all_figure);

%% 将最好的评分单独画出来/Draw the best ratings separately
[num_best_line,num_best_row]=max(result_sore);%获取最优组件的索引
best_comp=adjust_cell{ad_line,num_best_row};%提取最优组件的结构参数
%将其结构参数转化为字符串/Convert its structural parameters to strings
str_best_comp = string(0);
str_best_comp = arrayfun(@(x) sprintf('%.3f[mm]', x), best_comp, 'UniformOutput', false);

best_figure=figure('Visible', "off");%是否弹出窗口

for num_part_best=1:res_line
    
    model.param.set(par_qc(num_part_best,1), str_best_comp(num_part_best,2));%设置qc参数值
    model.param.set(par_qk(num_part_best,1), str_best_comp(num_part_best,3));%设置qk参数值
    model.param.set(par_jr(num_part_best,1), str_best_comp(num_part_best,4));%设置jr参数值
    model.param.set(par_qg(num_part_best,1), str_best_comp(num_part_best,5));%设置jr参数值
    model.param.set(par_jg_x(num_part_best,1), str_best_comp(num_part_best,6));%设置jr参数值
    model.param.set(par_jg_s(num_part_best,1), str_best_comp(num_part_best,7));%设置jr参数值
end
mphgeom(model, 'geom1', 'FaceAlpha', 0.5);%画出初始图，透明
text(0, 0, 0, ['Sore:', num2str(num_best_line)],'FontSize', 17, 'FontWeight', 'bold','Color', 'red');
%将获得的结构参数图片存储到文件中/Store the obtained structural parameter images in a file
exportgraphics(gcf, 'structure_picture/best_structure.png', 'Resolution', 300);
% 关闭图形窗口
%close(best_figure);




mphgetexpressions(model.param);

end
