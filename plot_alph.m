function plot_alph(f,init_result,aim_result,aim_alph,init_alph,num_frequent,round,target_frequent)





alph_e=init_alph-aim_alph;%当前与目标吸声系数误差
a=mean(abs(alph_e));
a_str = sprintf('%d ', a);
b_str = sprintf('%d ', round);

figure
hold on;
plot(f,init_result,"r",target_frequent,init_alph,"ro")
plot(f,aim_result,"b",target_frequent,aim_alph,"bo")
for i = 1:num_frequent

    text( target_frequent(i), init_alph(i), ['(', num2str(target_frequent(i), '%.2f'), ',', num2str(init_alph(i), '%.2f'), ')']);
    text( target_frequent(i), aim_alph(i), ['(', num2str(target_frequent(i), '%.2f'), ',', num2str(aim_alph(i), '%.2f'), ')']);
end
title(["回合",b_str]);
legend('当前', '','', '目标');
set(gca, 'xtick', f(1):20:f(end), 'xlim', [f(1), f(end)]);
set(gca,'ytick',0:0.1:1,'ylim',[0,1]);

text(470, 0.5, ['平均误差', a_str],'FontSize', 7, 'FontWeight', 'bold', 'Color', 'red');
hold off;

end