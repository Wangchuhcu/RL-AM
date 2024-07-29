# 强化学习驱动的声学超材料逆向设计
# Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials  

## 简介/Introduction:
这个程序构建了一个多智能体深度强化学习模型，可以实现可定制任意吸声系数的声学超材料逆向设计。为了更方便用户操作，我们设计了一个MATLAB小程序。希望这个程序能够帮助声学超材料设计者和研究者更方便的进行设计和研究。  

This program constructs a multi-agent deep reinforcement learning model that enables the reverse design of acoustic metamaterials with customizable absorption coefficients.To facilitate user operation, we designed a MATLAB-APP program.It is hoped that this program can assist acoustic metamaterial designers and researchers in conducting their design and research more conveniently.  

## 作者/Author：
王寅初 华中科技大学智能制造装备与技术全国重点实验室，运筹与优化团队2023级博士生。  
Yinchu Wang State Key Lab of Intelligent Manufacturing Equipment and Technology, Huazhong University of Science and Technology, PhD students of the Operations Research and Optimization team, Class of 2023.


## 使用条件/Usage Conditions：  
本程序基于matlab编写，使用版本为R2023b。  
This program is written in MATLAB, using version R2023b.

## 使用说明/Program Usage Instructions：  
1.代码文件中***main_interface_english.mlapp***是程序的运行文件；  
2.打开并运行程序可以看到如**图1**所示的程序界面；  
3.可以点击坐标内任何位置，设置设计目标；也可以在右边手动输入设计目标的频率和吸声系数，如**图2**所示；  
4.左边是一些可设置的参数，比如模型运行的回合数、厚度和状态误差的权重因子等；  
5.当然也可以保持默认状态，设定好之后可以点击***run model***；  
6.最后模型将评分最高的逆向设计结果参数展示在界面的下方，其吸声系数曲线会展示在坐标轴界面上，如**图3**所示。    
7.需要注意的是：本程序是可以展示逆向设计的超材料的图片,如**图4**所示。然而，实现这个功能要求**MATLAB**与**COMSOL**进行联合，这需要在代码文件中放入 **.mph** 文件，由于此类文件超过了25M，无法上传到github，所以此程序无法展示声学超材料的结构图片。
如果需要该功能，可以根据合理的需求从作者处获得具有此功能的代码。  

1.The ***code file main_interface_english.mlapp*** is the executable file of the program；   
2.Opening and running the program will display the interface shown in **Figure 1**;    
3.You can click anywhere within the coordinates to set the design target; you can also manually enter the frequency and absorption coefficient of the design target on the right side, as shown in **Figure 2**;  
4.The left side contains several configurable parameters, such as the number of episodes for the model, thickness, and the weight factors for state error, etc;  
5.Of course, you can also keep the default settings, and after configuring, you can click ***run model***;  
6.Finally, the model displays the parameters of the highest-scoring inverse design results at the bottom of the interface, and its absorption coefficient curve will be shown on the coordinate axes, as illustrated in ***Figure 3***；   
7.It is important to note that this program can display images of the inverse design of metamaterials, as shown in ***Figure 4***.However, achieving this functionality requires a collaboration between **MATLAB** and **COMSOL**, which necessitates placing the **.mph** files in the code files. Since such files exceed 25 MB, they cannot be uploaded to GitHub, thus this program is unable to display images of the acoustic metamaterial structures.If this functionality is needed, you can obtain the code with this feature from the author based on reasonable requests.

![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/program%20interface.png)  
**figure1 program interface**

![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/design%20objective.png)
**figure2 Design results**  
![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/Design%20results.png)
**figure3 Design result**  
![image text](https://github.com/Wangchuhcu/Reinforcement-Learning-Driven-Inverse-Design-of-Acoustic-Metamaterials/blob/main/App_figure/Pictures%20of%20acoustic%20metamaterial%20structures.png)
**figure4 Pictures of acoustic metamaterial structures**  




