# Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials  
# 强化学习驱动的声学超材料逆向设计
## 简介
这个程序构建了一个多智能体强化学习模型，可以实现可定制任意吸声系数的声学超材料逆向设计。为了更方便用户操作，我们设计了一个matlab小程序。希望这个程序能够帮助声学超材料设计者和研究者更方便的进行设计和研究。  

作者：王寅初 华中科技大学智能制造装备与技术全国重点实验室，运筹与优化团队2023级博士生。  

## 使用条件：  
本程序用matlab编写，使用matlab版本为R2023b。   

## 使用说明：  
1.代码文件中***main_interface_english.mlapp***是程序的运行文件；  
2.打开并运行程序可以看到如**图1**所示的程序界面；  
3.可以点击坐标内任何位置，设置设计目标；也可以在右边手动输入设计目标的频率和吸声系数，如**图2**所示；  
4.左边是一些可设置的参数，比如模型运行的回合数、厚度和状态误差的权重因子等；  
5.当然也可以保持默认状态，设定好之后可以点击***run model***；  
6.最后模型将评分最高的逆向设计结果参数展示在界面的下方，其吸声系数曲线会展示在坐标轴上，如**图3**所示。    
7.需要注意的是：本程序是可以展示逆向设计的超材料的图片如**图4**所示，但是，需要与comsol程序进行联合。这需要在代码文件中放入.mph文件，由于此类文件超过了25m，无法上传到github，所以此程序无法展示声学超材料的结构图片。
如果需要该功能，可以根据合理的需求从作者处获得具有此功能的代码。
![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/program%20interface.png)  
**figure1 program interface**

![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/design%20objective.png)
**figure2 Design results**  
![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/Design%20results.png)
**Design result**  



