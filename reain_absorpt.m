function result=reain_absorpt(f, d, j, w, p0, Cp, K, u, k0, v, c0, jg, dc, qg, z0)
%% 嵌入管的阻抗
for a=1:length(f)
    for t=1:length(d)
        kh(a)=sqrt(-j.*w(a).*p0.*Cp./K) ;%sign的主要作用是当被开方的数是正的时候它取正，里面是负数的时候它取负
        kv(a)=sqrt(-j.*w(a).*p0./u);%.*sign(-j.*w.*p0./u)sqrt sqrt
        Qht(a,t)=besselj(2,kh(a).*d(t)/2)./besselj(0,kh(a).*d(t)/2);
        Qhv(a,t)=besselj(2,kv(a).*d(t)/2)./besselj(0,kv(a).*d(t)/2);
        kct(a,t)=sqrt(k0(a).^2.*(v-(v-1).*Qht(a,t))./Qhv(a,t)); %sign的主要作用是当被开方的数是正的时候它取正，里面是负数的时候它取负
        Zt(a,t)=-p0*c0*2*j.*sin(kct(a,t).*jg(t)./2)./sqrt((v-(v-1).*Qht(a,t)).*Qhv(a,t));
        %% 不规则空腔阻抗
        St(a,t)=pi*(d(t)/2)^2;%嵌入管横截面积
        Sc0=pi*(dc/2)^2;
        Vc(a,t)=Sc0*qg(t);
        Zc(a,t)=-j.*St(a,t).*p0.*c0^2./(w(a).*Vc(a,t));
        %% 辐射矫正公式
        ss(t)=d(t)/(dc);
        S0(t)=(1+(1-1.25*ss(t)))*4/(3*pi)*d(t);
        %% 周期性元素表面阻抗axax(a,t)*
        Zw0(a,t)=Sc0./St(a,t).*(Zt(a,t)+Zc(a,t)+2*sqrt(2.*w(a).*p0.*u)+j.*w(a).*p0.*S0(t));
    end
%% 并联吸收体阻抗
ZW(a,:)=1./Zw0(a,:);
Zs(a,:)=length(d)/(sum(ZW(a,:),2));
%Zs(a,:)=1/(sum(ZW(a,:),2));
R0(a,:)=abs((Zs(a,:)-z0)./(Zs(a,:)+z0));% 反射系数(jet)
R(a)=1-R0(a,:).^2;
end
%% 反射系数

% 
% [pks, locs] = findpeaks(R, 'MinPeakDistance',1);%该函数找到吸声曲线的峰值pks表示峰值纵坐标，loc表示峰值的横坐标索引
% 
% hold on
% plot(f,R,f(locs),pks,"ro")
% for i = 1:length(locs)
%     text(f(locs(i)), pks(i), ['(', num2str(f(locs(i)), '%.2f'), ',', num2str(pks(i), '%.2f'), ')']);
% end
% pks;
% title('亥姆霍兹谐振器耦合吸声曲线');
% legend('吸声曲线', '共振频率坐标');
% % 找到y轴上的最大值及其索引
% [maxY, maxYIndex] = max(R)
% % 标记出曲线在y轴上的最大值所对应的坐标
% plot(f(maxYIndex), maxY, 'ro', 'MarkerSize', 10);
% % 添加最大值坐标的数值标签
% text(f(maxYIndex), maxY, ['(' num2str(f(maxYIndex)) ',' num2str(maxY) ')']);
% set(gca, 'xtick', f(1):20:f(end), 'xlim', [f(1), f(end)]);
% set(gca,'ytick',0:0.1:1,'ylim',[0,1]);


% result.max_alph=pks;%返回最大吸声系数
% result.f_alph=R;%返回吸声系数整体值
% result.loc_alph=f(locs);%返回最大吸声系数对应的坐标值
result=[f;R];


end
