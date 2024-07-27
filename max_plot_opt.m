function max_plot_opt(f,max_result_plot,aim_alph,target_frequent,num_frequent)
    figure
    hold on;
    plot(f,max_result_plot(2,:),"r")
    scatter(target_frequent,aim_alph,'MarkerFaceColor', 'blue')
    for i = 1:num_frequent

        %text( target_frequent(i), draw_alph(i), ['(', num2str(target_frequent(i), '%.2f'), ',', num2str(draw_alph(i), '%.2f'), ')']);
        text( target_frequent(i), aim_alph(i), ['(', num2str(target_frequent(i), '%.2f'), ',', num2str(aim_alph(i), '%.2f'), ')']);
    end

end
