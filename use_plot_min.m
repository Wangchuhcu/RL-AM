function use_plot_min(f,init_result,aim_alph,draw_alph,num_frequent,count,round,target_frequent)





alph_e=draw_alph-aim_alph;%当前与目标吸声系数误差
a=mean(abs(alph_e));
a_str = sprintf('%.3f ', a);
b_str = sprintf('%d ', count);
c_str = sprintf('%d ', round);

figure
hold on;
plot(f,init_result,"r",target_frequent,draw_alph,"ro")
scatter(target_frequent,aim_alph,'MarkerFaceColor', 'blue')
%plot(f,aim_result,"b",target_frequent,aim_alph,"bo")
for i = 1:num_frequent

    text( target_frequent(i), draw_alph(i), ['(', num2str(target_frequent(i), '%.2f'), ',', num2str(draw_alph(i), '%.2f'), ')']);
    text( target_frequent(i), aim_alph(i), ['(', num2str(target_frequent(i), '%.2f'), ',', num2str(aim_alph(i), '%.2f'), ')']);
end
title("回合搜寻最小误差","第"+b_str+"轮"+"第"+c_str+"回合");
legend('当前', '','', '目标');
set(gca, 'xtick', f(1):20:f(end), 'xlim', [f(1), f(end)]);
set(gca,'ytick',0:0.1:1,'ylim',[0,1]);

text(470, 0.5, ['平均误差', a_str],'FontSize', 7, 'FontWeight', 'bold', 'Color', 'red');
hold off;

end