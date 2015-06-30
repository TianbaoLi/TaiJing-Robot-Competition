

'******** ROBONOVA-2 Standard Program ********

DIM I AS BYTE'把I定义成字节型
DIM J AS BYTE'把J定义成字节型
DIM pose AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM walk_speed AS BYTE
DIM LR_speed AS BYTE
DIM LR_speed2 AS BYTE
DIM walk_order AS BYTE
DIM now_voltage AS BYTE
DIM reverse_check AS BYTE
DIM motor_ONOFF AS BYTE
DIM gyro_ONOFF AS BYTE
DIM tilt_FB AS INTEGER'定义整形前后
DIM tilt_LR AS INTEGER'定义左右
DIM DELAY_TIME AS BYTE '延时
DIM DELAY_TIME2 AS BYTE'延时2
DIM TEMP AS BYTE'临时做工
DIM thing_chach_pose AS BYTE'获取事物站立姿势
DIM tilt_check_count AS BYTE'倾斜检查
DIM fall_check AS BYTE'倒的检查

DIM repeat_order AS BYTE'重复命令
DIM tilt_check_failure AS BYTE'倾斜检查是否失败
DIM promote_dir_failure AS BYTE'提升失败

DIM info_index AS BYTE'信息编辑

DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S11 AS BYTE
DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE


'**** tilt_port *****

CONST FB_tilt_AD_port = 2'前后倾斜地址 点
CONST LR_tilt_AD_port = 3'左右倾斜地址 点

'**** OLD tilt Sensors *****
'CONST tilt_time_check = 10  
'CONST min = 100			
'CONST max = 160			
'CONST COUNT_MAX = 30

'**** 2012 NEW tilt Sensors *****‘2012新的倾斜传感器
CONST tilt_time_check = 5  '倾斜时间检查
CONST min = 61			'最小值
CONST max = 107			'最大值
CONST COUNT_MAX = 20'计算 
'*******************

CONST low_volt = 103	'最低 伏特

PTP SETON '				 
PTP ALLON'				

DIR G6A,1,0,0,1,0,0		'设定马达动作方向
DIR G6B,1,1,1,1,1,1		
DIR G6C,0,0,0,0,0,0		
DIR G6D,0,1,1,0,1,0		


'***** first_declaration *********************************
motor_ONOFF = 0'打开电机
walk_order = 0'行走命令
reverse_check = 0'复查
tilt_check_count = 0'倾斜检查
fall_check = 0'倒的检查
tilt_check_failure = 1
promote_dir_failure = 0
thing_chach_pose = 0
'****Action_mode()******************
Action_mode = 0		'D(CODE 27):dancemode
Action_mode = 1	'F(CODE 32):fightmode
Action_mode = 2	'G(CODE 23):gamemode
Action_mode = 3	'B(CODE 20):footballmode
Action_mode = 4	'E(CODE 18):steeplechase_racesmode
Action_mode = 5	'C(CODE 17):cameramode
Action_mode = 6	'A(CODE 15):promotemode



'*********************************
OUT 52,0	'把信号输出到端口
DELAY 1000
GOSUB MOTOR_ON '转到第131行执行MOTOR_ON



SPEED 5'速度5
GOSUB first_power_pose'第一个位置姿势，执行241行
GOSUB standard_pose'站立姿势，执行260行

PRINT "VOLUME 200 !"'输出音量200


GOSUB SOUND_MODE_SELECT'音乐模式选择，执行372行





GOTO MAIN'执行主函数，11036
'************************************************
'************************************************

MOTOR_FAST_ON:'电机快速启动

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    motor_ONOFF = 0'电机开关
    RETURN

    '************************************************
    '************************************************
MOTOR_ON:'电机开

    GOSUB MOTOR_GET  '转到第161行执行MOTOR_GET

    MOTOR G6B '以下为使用四组电机
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    motor_ONOFF = 0
    GOSUB start_buzzer'	启动电池 执行545行		
    RETURN'返回102行

    '************************************************
    
MOTOR_OFF:  '电机关闭

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    motor_ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB end_buzzer	'结束电池
    RETURN '返回
    '************************************************
    
MOTOR_GET:'读入A，B，C，D四组电机的值
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN  '返回到第三135行

    '************************************************
All_motor_Reset: '所有电机重启

    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:'所有电机模式2

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:'所有电机模式3

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:'腿部电机模式1
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN '返回原程序（1.613)
    '************************************************
Leg_motor_mode2:'腿部电机模式2
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:'腿部电机模式3
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:'腿部电机模式4
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:'腿部电机模式5
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:'手臂电机模式1
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN '返回原程序（1.612)
    '************************************************
Arm_motor_mode2:'手臂电机模式2
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:'手臂电机模式3
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN

    '************************************************
    '*******standard_pose*****************************
    '************************************************
first_power_pose:'开腿开手站立
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    pose = 0
    RETURN '返回到104行
    '************************************************
stabilizing_pose:'开腿站立
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0

    RETURN
    '************************************************
standard_pose:'标准站立姿势
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0
    thing_chach_pose = 0
    RETURN '返回到105行
    '************************************************	
attention_pose:'笔直站立姿势
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    pose = 2
    RETURN
    '************************************************
sit_pose:'蹲姿

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    pose = 1

    RETURN

    '************************************************
RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 4800, A, MAIN'蓝牙主发射频率

    GOTO RX_EXIT
    '************************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2'蓝牙发射频率2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN '返回原程序（1.4651行)
    '************************************************
    '******* sound_module *************************
    '************************************************
 MR_SOUND_OPEN:'启动声音文件
 	PRINT "OPEN MRSOUND.MRS !" '打开声音文件
RETURN '返回375行
    '************************************************
SOUND_promote1:'发出声音1
    PRINT "SOUND 48!" '输出声音48
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote2:'发出声音2
    PRINT "SOUND 49!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote3:
    PRINT "SOUND 50!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote4:
    PRINT "SOUND 51!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote5:
    PRINT "SOUND 52!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote6:
    PRINT "SOUND 53!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote7:
    PRINT "SOUND 54!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote8:
    PRINT "SOUND 55!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
SOUND_promote9:
    PRINT "SOUND 56!"
    DELAY 500
    GOSUB GOSUB_RX_EXIT
    RETURN
    '************************************************
SOUND_people_dance: '类人型舞蹈歌曲
    PRINT "SOUND 47!"
    RETURN
SOUND_robo_link: '机器人连接
    PRINT "SOUND 46!"
    RETURN
SOUND_HELLO: '发出声音’HELLO‘
    PRINT "SOUND 12!"
    RETURN
SOUND_HELLO_miniROBOT_ROBONOVA_2: '再次发出声音’HELLO
    PRINT "SOUND 0!"
    RETURN

    '************************************************
SOUND_MODE_SELECT:'音乐模式选择
GOSUB MR_SOUND_OPEN '声音打开，执行308行
	
    IF Action_mode = 0 THEN		'如果动作模式为0，那么执行舞蹈模式声音	
        GOSUB  SOUND_dancemode  '执行393行
    ELSEIF Action_mode = 1 THEN	'如果动作模式为1，那么执行摔跤模式声音	
        GOSUB SOUND_拜捧mode     '执行396行
    ELSEIF Action_mode = 2 THEN	'如果动作模式为2，那么执行对抗模式声音	
        GOSUB SOUND_gamemode     '执行399行
    ELSEIF Action_mode = 3 THEN	'如果动作模式为3，那么执行足球模式声音	
        GOSUB SOUND_footballmode   '执行402行
    ELSEIF Action_mode = 4 THEN		'如果动作模式为4，那么执行阶梯模式声音
        GOSUB SOUND_steeplechase_racesmode   '执行405行
    ELSEIF Action_mode = 5 THEN		'如果动作模式为5，那么执行视觉模式
        GOSUB SOUND_cameramode       '执行408行
    ELSEIF Action_mode = 6 THEN		'如果动作模式为6，那么执行投篮模式
        GOSUB SOUND_promotemode
    ENDIF

    RETURN '返回115行执行
    '************************************************
SOUND_dancemode:'舞蹈模式声音
    PRINT "SOUND 1!"
    RETURN   '返回389行执行
SOUND_拜捧mode:'摔跤模式声音
    PRINT "SOUND 2!"
    RETURN '返回389行执行
SOUND_gamemode:'对抗模式声音
    PRINT "SOUND 3!"
    RETURN '返回389行执行
SOUND_footballmode:'足球模式声音
    PRINT "SOUND 4!"
    RETURN '返回389行执行
SOUND_steeplechase_racesmode:'阶梯模式声音
    PRINT "SOUND 5!"
    RETURN '返回389行执行
SOUND_promotemode:'投篮模式声音
    PRINT "SOUND 6!"
    RETURN '返回389行执行
SOUND_cameramode:'视觉模式声音
    PRINT "SOUND 7!"
    RETURN
SOUND_blue_UP:
    PRINT "SOUND 26!"
    RETURN
SOUND_blue_DOWN:
    PRINT "SOUND 27!"
    RETURN
SOUND_white_UP:
    PRINT "SOUND 28!"
    RETURN
SOUND_white_DOWN:
    PRINT "SOUND 29!"
    RETURN


SOUND_BGM1:'背景音乐1
    PRINT "AUTO 31!"
    RETURN
SOUND_BGM2:
    PRINT "AUTO 32!"
    RETURN
SOUND_BGM3:
    PRINT "AUTO 33!"
    RETURN
SOUND_BGM4:
    PRINT "AUTO 34!"
    RETURN
SOUND_BGM5:
    PRINT "AUTO 35!"
    RETURN
SOUND_BGM6:
    PRINT "AUTO 36!"
    RETURN
SOUND_BGM7:
    PRINT "AUTO 37!"
    RETURN
SOUND_BGM8:
    PRINT "AUTO 38!"
    RETURN
SOUND_BGM9:
    PRINT "AUTO 39!"
    RETURN
SOUND_BGM10:
    PRINT "AUTO 40!"
    RETURN
SOUND_BGM11:
    PRINT "AUTO 41!"
    RETURN
SOUND_BGM12:
    PRINT "AUTO 42!"
    RETURN

SOUND_ALL_OFF_MSG:'关闭所有背景音乐
    PRINT "SOUND 20!"'输出声音20
    DELAY 1500 '延迟1500s
    GOSUB SOUND_VOLUME_0 '执行音量0
    RETURN

SOUND_ALL_ON_MSG:'打开所有背景音乐
    GOSUB SOUND_VOLUME_30 '执行音量30
    PRINT "SOUND 21!"'输出声音21

    RETURN

SOUND_ON_OK_MSG: '确认已经打开所有背景音乐
    PRINT "SOUND 22!"
    RETURN

SOUND_scissors: '剪刀声音
    PRINT "SOUND 23!"
    RETURN
SOUND_rock:'石头声音
    PRINT "SOUND 24 !"
    RETURN
SOUND_paper:'布声音
    PRINT "SOUND 25 !"
    RETURN
SOUND_Walk_Move: '行走移动声音
    PRINT "SOUND 45 !"
    RETURN
SOUND_Walk_Ready:'行走准备声音
    PRINT "PLAYNUM 43 !"
    RETURN
SOUND_walk:'行走声音
    PRINT "SOUND 43 !"
    RETURN
SOUND_REPLAY:'重放声音
    PRINT "!"
    RETURN

SOUND_VOLUME_50:'声音音量50
    PRINT "VOLUME 50 !"
    RETURN

SOUND_VOLUME_40:
    PRINT "VOLUME 40 !"
    RETURN

SOUND_VOLUME_30:
    PRINT "VOLUME 30 !"
    RETURN
SOUND_VOLUME_20:
    PRINT "VOLUME 20 !"
    RETURN
SOUND_VOLUME_10:
    PRINT "VOLUME 10 !"
    RETURN

SOUND_VOLUME_0:
    PRINT "VOLUME 0 !"
    RETURN



SOUND_STOP: '声音停止
    PRINT "STOP !"
    RETURN

SOUND_UP: '加大声音
    PRINT "UP 5 !"
    RETURN

SOUND_DOWN:'降低声音
    PRINT "DOWN 5 !"
    RETURN


    '************************************************
    '******* buzzer ***********************
    '************************************************


start_buzzer: '开始信号
    TEMPO 220 '速度/节奏
    MUSIC "O23EAB7EA>3#C"
    RETURN '返回到145行
    '************************************************
end_buzzer:'结束信号
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
entertainment_sound:'娱乐音乐
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
game_sound:'游戏音乐
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
fight_sound:'对抗音乐
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
warning_sound:'警告声
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
buzzer_sound:'信号声
    TEMPO 180
    MUSIC "A"
    DELAY 300

    RETURN
    '************************************************
siren_sound:'警报声
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************

footballgame_sound:'足球比赛音乐
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN
    '************************************************

steeplechase_racesmode_sound:'障碍赛音乐
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN
    '************************************************
    '************************************************
    '************************************************

back_standup:'后倒后自动站立

    HIGHSPEED SETOFF '快速关闭当前模式
    PTP SETON 	'设置马达同时控制功能开			
    PTP ALLON		'设置马达全开		

    GOSUB Arm_motor_mode1 '执行223行
    GOSUB Leg_motor_mode1 '执行196行


    SPEED 15
    MOVE G6A,100, 150, 170,  40, 100
    MOVE G6D,100, 150, 170,  40, 100
    MOVE G6B, 150, 150,  45
    MOVE G6C, 150, 150,  45
    WAIT

    SPEED 15
    MOVE G6A,  100, 155,  110, 120, 100
    MOVE G6D,  100, 155,  110, 120, 100
    MOVE G6B, 190, 80,  15
    MOVE G6C, 190, 80,  15
    WAIT

    GOSUB Leg_motor_mode2 '执行201行
    SPEED 15	
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    DELAY 50
    SPEED 12	
    MOVE G6A,  100, 150,  25, 162, 100
    MOVE G6D,  100, 150,  25, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT


    SPEED 8
    MOVE G6A,  100, 138,  25, 155, 100
    MOVE G6D,  100, 138,  25, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 10
    GOSUB standard_pose
    GOSUB Leg_motor_mode1
    fall_check = 1
    RETURN '返回4658行

    '**********************************************
front_standup:'前倒后自动站立

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode1


    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 10
    GOSUB standard_pose
    fall_check = 1
    RETURN            

    '******************************************
    '************************************************
    '****** walk ********************************
    '************************************************

front_walk_50:'向前走
    GOSUB SOUND_Walk_Ready
    walk_speed = 10'5
    LR_speed = 5'8'3
    LR_speed2 = 4'5'2
    fall_check = 0
    GOSUB Leg_motor_mode3

    IF walk_order = 0 THEN
        walk_order = 1

        SPEED 4
        '
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 146,  93,  94
        MOVE G6B,100,35
        MOVE G6C,100,35
        WAIT

        SPEED 10'walk_speed
        '
        MOVE G6A, 90, 100, 115, 105, 114
        MOVE G6D,113,  78, 146,  93,  94
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO front_walk_50_1	
    ELSE
        walk_order = 0

        SPEED 4
        '
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 146,  93,  94
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 10'walk_speed
        '
        MOVE G6D, 90, 100, 115, 105, 114
        MOVE G6A,113,  78, 146,  93,  94
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO front_walk_50_2	

    ENDIF


    '*******************************


front_walk_50_1:'向前走1

    SPEED walk_speed
    '
    MOVE G6A, 85,  44, 163, 113, 114
    MOVE G6D,110,  77, 146,  93,  94
    WAIT

    GOSUB SOUND_REPLAY

    SPEED LR_speed
    'GOSUB Leg_motor_mode3
    '
    MOVE G6A,110,  76, 144, 100,  93
    MOVE G6D,85, 93, 155,  71, 112
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF


    SPEED walk_speed
    'GOSUB Leg_motor_mode2
    '
    MOVE G6A,111,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, front_walk_50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        'GOSUB Leg_motor_mode3
        SPEED 5

        '
        MOVE G6A, 106,  76, 146,  93,  96		
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	


        SPEED 3
        GOSUB standard_pose
        GOSUB Leg_motor_mode1
        ' 
        GOTO RX_EXIT
    ENDIF
    '**********


front_walk_50_2:'向前走


    SPEED walk_speed
    '
    MOVE G6D,85,  44, 163, 113, 114
    MOVE G6A,110,  77, 146,  93,  94
    WAIT

    GOSUB SOUND_REPLAY

    SPEED LR_speed
    'GOSUB Leg_motor_mode3
    '
    MOVE G6D,110,  76, 144, 100,  93
    MOVE G6A, 85, 93, 155,  71, 112
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    SPEED walk_speed
    'GOSUB Leg_motor_mode2
    '
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,111,  77, 146,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ERX 4800,A, front_walk_50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        'GOSUB Leg_motor_mode3
        SPEED 5

        '
        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 3
        GOSUB standard_pose
        GOSUB Leg_motor_mode1
        '
        GOTO RX_EXIT
    ENDIF


    GOTO front_walk_50_1
    '************************************************
    '************************************************
    '************************************************
back_walk_50:'向后走
    GOSUB SOUND_Walk_Ready
    walk_speed = 12'6
    LR_speed = 6'3
    LR_speed2 = 4'2
    fall_check = 0
    GOSUB Leg_motor_mode3



    IF walk_order = 0 THEN
        walk_order = 1

        SPEED 4
        '
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 146,  93,  94
        MOVE G6B,100,35
        MOVE G6C,100,35
        WAIT

        'HIGHSPEED SETON
        SPEED 10'walk_speed
        '
        MOVE G6A, 90, 95, 115, 105, 114
        MOVE G6D,113,  78, 146,  93,  94
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO back_walk_50_1	
    ELSE
        walk_order = 0

        SPEED 4
        '
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 146,  93,  94
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        'HIGHSPEED SETON
        SPEED 10'walk_speed
        '
        MOVE G6D, 90, 95, 115, 105, 114
        MOVE G6A,113,  78, 146,  93,  94
        MOVE G6C,90
        MOVE G6B,110
        WAIT

        GOTO back_walk_50_2

    ENDIF


back_walk_50_1:'向后走1
    SPEED walk_speed
    GOSUB Leg_motor_mode2
    '
    MOVE G6D,110,  76, 144, 100,  93
    MOVE G6A, 90, 93, 155,  71, 112
    WAIT
    GOSUB SOUND_REPLAY

    SPEED LR_speed2
    GOSUB Leg_motor_mode3
    '
    MOVE G6D,90,  46, 163, 110, 114
    MOVE G6A,110,  77, 147,  90,  94
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    SPEED walk_speed
    '
    MOVE G6A,112,  77, 147,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, back_walk_50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '
        MOVE G6A, 106,  76, 146,  93,  96		
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB standard_pose
        'GOSUB Leg_motor_mode1
        '  
        GOTO RX_EXIT
    ENDIF
    '**********

back_walk_50_2:
    SPEED walk_speed
    GOSUB Leg_motor_mode2
    '
    MOVE G6A,110,  76, 144, 100,  93
    MOVE G6D,90, 93, 155,  71, 112
    WAIT
    GOSUB SOUND_REPLAY

    SPEED LR_speed2
    GOSUB Leg_motor_mode3
    '
    MOVE G6A, 90,  46, 163, 110, 114
    MOVE G6D,110,  77, 147,  90,  94
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    SPEED walk_speed
    '
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,112,  76, 147,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ERX 4800,A, back_walk_50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '
        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT	

        SPEED 3
        GOSUB standard_pose
        'GOSUB Leg_motor_mode1
        '  
        GOTO RX_EXIT
    ENDIF  	

    GOTO back_walk_50_1
    '**********************************************
    '******************************************
front_run_50:'向前跑
    fall_check = 0
    GOSUB SOUND_Walk_Ready
    SPEED 12
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    IF walk_order = 0 THEN
        walk_order = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO front_run_50_1
    ELSE
        walk_order = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO front_run_50_4
    ENDIF


    '**********************

front_run_50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  78, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


front_run_50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  89,  100
    WAIT

    GOSUB SOUND_REPLAY

front_run_50_3:
    MOVE G6A,103,  70, 145, 103,  100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, front_run_50_4
    IF A <> A_old THEN  GOTO front_run_50_stop

    '*********************************

front_run_50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  78, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


front_run_50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  89,  100
    WAIT

    GOSUB SOUND_REPLAY

front_run_50_6:
    MOVE G6D,103,  70, 145, 103,  100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, front_run_50_1
    IF A <> A_old THEN  GOTO front_run_50_stop


    GOTO front_run_50_1


front_run_50_stop:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB stabilizing_pose
    SPEED 5
    GOSUB standard_pose

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************

    '******************************************
back_run_40:'向后跑
    fall_check = 0
    SPEED 10
    GOSUB SOUND_Walk_Ready
    HIGHSPEED SETON
    GOSUB Leg_motor_mode5

    IF walk_order = 0 THEN
        walk_order = 1
        MOVE G6A,88,  73, 145,  96, 102
        MOVE G6D,104,  73, 145,  96, 100
        WAIT

        GOTO back_run_40_1
    ELSE
        walk_order = 0
        MOVE G6D,88,  73, 145,  96, 102
        MOVE G6A,104,  73, 145,  96, 100
        WAIT


        GOTO back_run_40_4
    ENDIF


    '**********************

back_run_40_1:
    'SPEED 10
    MOVE G6A,92,  92, 100, 115, 104
    MOVE G6D,103,  74, 145,  96,  100
    MOVE G6B, 120
    MOVE G6C,80
    'WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

back_run_40_2:
    'SPEED 10
    MOVE G6A,95,  100, 122, 95, 104
    MOVE G6D,103,  70, 145,  102,  100
    'WAIT

back_run_40_3:
    'SPEED 10
    MOVE G6A,103,  90, 145, 80, 100
    MOVE G6D,92,  64, 145,  108,  102
    'WAIT
    GOSUB SOUND_REPLAY



    ERX 4800,A, back_run_40_4
    IF A <> A_old THEN  GOTO back_run_40_stop
    '*********************************

back_run_40_4:
    'SPEED 10
    MOVE G6D,92,  92, 100, 115, 104
    MOVE G6A,103,  74, 145,  96,  100
    MOVE G6C, 120
    MOVE G6B,80
    'WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

back_run_40_5:

    MOVE G6D,95,  100, 122, 95, 104
    MOVE G6A,103,  70, 145,  102,  100


back_run_40_6:

    MOVE G6D,103,  90, 145, 80, 100
    MOVE G6A,92,  64, 145,  108,  102
    ' WAIT
    GOSUB SOUND_REPLAY

    ERX 4800,A, back_run_40_1
    IF A <> A_old THEN  GOTO back_run_40_stop

    GOTO  back_run_40_1 	

back_run_40_stop:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB stabilizing_pose
    SPEED 5
    GOSUB standard_pose

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************

    '******************************************
stabilizing_stop:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB stabilizing_pose
    SPEED 15
    GOSUB standard_pose
    GOSUB Leg_motor_mode1
    RETURN

    '******************************************
    '**********************************************

    '******************************************
front_short_step:
    fall_check = 0
    GOSUB SOUND_Walk_Ready
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF walk_order = 0 THEN
        walk_order = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO front_short_step_1
    ELSE
        walk_order = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO front_short_step_4
    ENDIF


    '**********************

front_short_step_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


front_short_step_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

front_short_step_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, front_short_step_4
    IF A <> A_old THEN  GOTO front_short_step_stop

    '*********************************

front_short_step_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


front_short_step_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

front_short_step_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, front_short_step_1
    IF A <> A_old THEN  GOTO front_short_step_stop


    GOTO front_short_step_1


front_short_step_stop:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB stabilizing_pose
    SPEED 10
    GOSUB standard_pose

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '******************************************
back_short_step:
    fall_check = 0
    GOSUB SOUND_Walk_Ready
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF walk_order = 0 THEN
        walk_order = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO back_short_step_1
    ELSE
        walk_order = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO back_short_step_4
    ENDIF


    '**********************

back_short_step_1:
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT


back_short_step_2:
    MOVE G6A,95,  90, 135, 90, 104
    MOVE G6D,104,  77, 146,  91,  100
    WAIT

back_short_step_3:
    MOVE G6A, 103,  79, 146,  89, 100
    MOVE G6D,95,   65, 146, 103,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, back_short_step_4
    IF A <> A_old THEN  GOTO back_short_step_stop

    '*********************************

back_short_step_4:
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


back_short_step_5:
    MOVE G6A,104,  77, 146,  91,  100
    MOVE G6D,95,  90, 135, 90, 104
    WAIT

back_short_step_6:
    MOVE G6D, 103,  79, 146,  89, 100
    MOVE G6A,95,   65, 146, 103,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, back_short_step_1
    IF A <> A_old THEN  GOTO back_short_step_stop


    GOTO back_short_step_1


back_short_step_stop:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB stabilizing_pose
    SPEED 10
    GOSUB standard_pose

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '**********************************************

front_run_30: '
    fall_check = 0
    GOSUB SOUND_Walk_Ready
    SPEED 12
    HIGHSPEED SETON

    IF walk_order = 0 THEN
        MOVE G6A,100,  80, 119, 118, 103
        MOVE G6D,102,  75, 149,  93,  100
        MOVE G6B, 80,  30,  80
        MOVE G6C,120,  30,  80

        walk_order = 1
        GOTO front_run_30_2
    ELSE
        MOVE G6D,100,  80, 119, 118, 103
        MOVE G6A,102,  75, 149,  93,  100
        MOVE G6C, 80,  30,  80
        MOVE G6B,120,  30,  80

        walk_order = 0
        GOTO front_run_30_4

    ENDIF



    '********************************************
front_run_30_1:

    ':
    MOVE G6A,100,  80, 119, 118, 103
    MOVE G6D,102,  75, 147,  93,  100
    MOVE G6B, 80,  30,  80
    MOVE G6C,120,  30,  80
    GOSUB SOUND_REPLAY

    ERX 4800, A, front_run_30_2
    GOSUB standard_pose
    HIGHSPEED SETOFF
    GOTO RX_EXIT

front_run_30_2:

    ':
    MOVE G6A,102,  74, 140, 106,  100
    MOVE G6D, 95, 105, 124,  93, 103
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80

   ' GOSUB FB_tilt_check
'    IF fall_check = 1 THEN
'        fall_check = 0
'        GOTO MAIN
'    ENDIF

front_run_30_3:
    ':
    MOVE G6D,100,  80, 119, 118, 103
    MOVE G6A,102,  75, 147,  93,  100
    MOVE G6C, 80,  30,  80
    MOVE G6B,120,  30,  80
    GOSUB SOUND_REPLAY



    ERX 4800, A, front_run_30_4
    GOSUB standard_pose
    HIGHSPEED SETOFF
    GOTO RX_EXIT

front_run_30_4:
    ':
    MOVE G6D,102,  74, 140, 106,  100
    MOVE G6A, 95, 105, 124,  93, 103
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80

   ' GOSUB FB_tilt_check
'    IF fall_check = 1 THEN
'        fall_check = 0
'        GOTO MAIN
'    ENDIF

    '************************************************


    GOTO front_run_30_1


    GOTO RX_EXIT

    '*********************************************
    '******************************************
chach_run:
    fall_check = 0
    GOSUB SOUND_Walk_Ready
    SPEED 15
    GOSUB All_motor_mode3

    IF walk_order = 0 THEN
        walk_order = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO chach_run_1
    ELSE
        walk_order = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO chach_run_4
    ENDIF


    '**********************

chach_run_1:
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6D,104,  77, 145,  87,  102
    WAIT
    DELAY 5

chach_run_2:
    MOVE G6D,104,  79, 145,  82,  100
    MOVE G6A,95,  85, 130, 95, 104
    WAIT
    DELAY 5
chach_run_3:
    MOVE G6A,103,   85, 130, 95,  100
    MOVE G6D, 97,  79, 145,  82, 102
    WAIT
    DELAY 5
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, chach_run_4
    IF A <> A_old THEN  GOTO chach_run_stop

    '*********************************

chach_run_4:
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6A,104,  77, 145,  87,  102
    WAIT


chach_run_5:
    MOVE G6D,95,  85, 130, 95, 104
    MOVE G6A,104,  79, 145,  82,  100
    WAIT

chach_run_6:
    MOVE G6D,103,   85, 130, 95,  100
    MOVE G6A, 97,  79, 145,  82, 102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, chach_run_1
    IF A <> A_old THEN  GOTO chach_run_stop


    GOTO chach_run_1


chach_run_stop:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '******************************************
chach_back_walk:
    fall_check = 0
    GOSUB SOUND_Walk_Ready
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF walk_order = 0 THEN
        walk_order = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO chach_back_walk_1
    ELSE
        walk_order = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO chach_back_walk_4
    ENDIF


    '**********************

chach_back_walk_1:
    MOVE G6D,104,  77, 146,  83,  102
    MOVE G6A,95,  95, 120, 92, 104
    WAIT


chach_back_walk_2:
    MOVE G6A,95,  90, 135, 82, 104
    MOVE G6D,104,  77, 146,  83,  100
    WAIT

chach_back_walk_3:
    MOVE G6A, 103,  79, 146,  81, 100
    MOVE G6D,95,   65, 146, 95,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, chach_back_walk_4
    IF A <> A_old THEN  GOTO chach_back_walk_stop

    '*********************************

chach_back_walk_4:
    MOVE G6D,95,  95, 120, 92, 104
    MOVE G6A,104,  77, 146,  83,  102
    WAIT


chach_back_walk_5:
    MOVE G6A,104,  77, 146,  83,  100
    MOVE G6D,95,  90, 135, 82, 104
    WAIT

chach_back_walk_6:
    MOVE G6D, 103,  79, 146,  81, 100
    MOVE G6A,95,   65, 146, 95,  102
    WAIT
    GOSUB SOUND_REPLAY
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, chach_back_walk_1
    IF A <> A_old THEN  GOTO chach_back_walk_stop


    GOTO chach_back_walk_1


chach_back_walk_stop:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400


    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '*********************************************	
front_sit_walk:
    GOSUB All_motor_mode3
    SPEED 9

front_sit_walk_1:

    MOVE G6A,114, 143,  28, 142,  96, 100
    MOVE G6D, 87, 135,  28, 155, 110, 100
    WAIT


    MOVE G6D,98, 126,  28, 160, 102, 100
    MOVE G6A,98, 160,  28, 125, 102, 100
    WAIT

    ERX 4800, A, front_sit_walk_2
    SPEED 6
    IF  thing_chach_pose = 0 THEN
        GOSUB sit_pose
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        pose = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT

front_sit_walk_2:
    MOVE G6D,113, 143,  28, 142,  96, 100
    MOVE G6A, 87, 135,  28, 155, 110, 100
    WAIT

    MOVE G6A,98, 126,  28, 160, 102, 100
    MOVE G6D,98, 160,  28, 125, 102, 100
    WAIT

    ERX 4800, A, front_sit_walk_1
    SPEED 6
    IF  thing_chach_pose = 0 THEN
        GOSUB sit_pose
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        pose = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT


    GOTO front_sit_walk_1
    '*****************************
back_sit_walk:
    GOSUB All_motor_mode3
    SPEED 8

back_sit_walk_1:

    MOVE G6D,113, 140,  28, 142,  96, 100
    MOVE G6A, 87, 140,  28, 140, 110, 100
    WAIT

    MOVE G6A,98, 155,  28, 125, 102, 100
    MOVE G6D,98, 121,  28, 160, 102, 100
    WAIT

    ERX 4800, A, back_sit_walk_2
    SPEED 6
    IF  thing_chach_pose = 0 THEN
        GOSUB sit_pose
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        pose = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT

back_sit_walk_2:
    MOVE G6A,113, 140,  28, 142,  96, 100
    MOVE G6D, 87, 140,  28, 140, 110, 100
    WAIT


    MOVE G6D,98, 155,  28, 125, 102, 100
    MOVE G6A,98, 121,  28, 160, 102, 100
    WAIT

    ERX 4800, A, back_sit_walk_1
    SPEED 6
    IF  thing_chach_pose = 0 THEN
        GOSUB sit_pose
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        pose = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT


    GOTO back_sit_walk_1
    '*****************************		

sit_right_walk:
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6A,110, 145,  28, 140, 100, 100
    MOVE G6D, 86, 145,  28, 140, 105, 100
    WAIT

    SPEED 5
    MOVE G6A, 90, 145,  28, 140, 110, 100
    MOVE G6D, 90, 145,  28, 140, 110, 100
    WAIT

    SPEED 6 	
    MOVE G6A, 80, 135,  45, 135, 105, 100
    MOVE G6D,108, 145,  28, 140, 100, 100
    WAIT

    SPEED 4 		
    MOVE G6A, 90, 145,  28, 140, 100, 100
    MOVE G6D,106, 145,  28, 140, 100, 100
    WAIT

    SPEED 3
    IF  thing_chach_pose = 0 THEN
        GOSUB sit_pose
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        pose = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT
    '*****************************	
sit_left_walk:
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6D,110, 145,  28, 140, 100, 100
    MOVE G6A, 86, 145,  28, 140, 105, 100
    WAIT

    SPEED 5
    MOVE G6D, 90, 145,  28, 140, 110, 100
    MOVE G6A, 90, 145,  28, 140, 110, 100
    WAIT

    SPEED 6 	
    MOVE G6D, 80, 135,  45, 135, 105, 100
    MOVE G6A,108, 145,  28, 140, 100, 100
    WAIT

    SPEED 4 		
    MOVE G6D, 90, 145,  28, 140, 100, 100
    MOVE G6A,106, 145,  28, 140, 100, 100
    WAIT

    SPEED 3
    IF  thing_chach_pose = 0 THEN
        GOSUB sit_pose
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        pose = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT
    '**********************************************
    '************************************************
paper_delivery:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6B,188,  15,  80
    MOVE G6C,188,  15,  80
    WAIT


    GOSUB All_motor_Reset
    thing_chach_pose = 3
    RETURN
    '************************************************
    '************************************************
paper_lift:
    GOSUB All_motor_mode3
    SPEED 3
    MOVE G6A,100,  73, 145,  85, 100
    MOVE G6D,100,  73, 145,  85, 100
    MOVE G6B,165,  30,  80
    MOVE G6C,165,  30,  80
    WAIT


    DELAY 2000
    '****  ************
    MOVE G6B,165,  15,  80
    MOVE G6C,165,  15,  80
    WAIT

    GOSUB All_motor_Reset
    thing_chach_pose = 2
    RETURN
    '************************************************
    '**********************************************

paper_lift_front_walk_50:
    fall_check = 0
    walk_speed = 10
    LR_speed = 3
    LR_speed2 = 4

    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    IF walk_order = 0 THEN
        walk_order = 1

        SPEED 3
        '
        MOVE G6A, 88,  68, 152,  83, 110
        MOVE G6D,108,  73, 146,  85,  94
        WAIT

        SPEED 10'walk_speed
        '
        MOVE G6A, 90, 97, 115, 98, 114
        MOVE G6D,112,  75, 146,  85,  94
        WAIT


        GOTO paper_lift_front_walk_50_1	
    ELSE
        walk_order = 0

        SPEED 3
        '
        MOVE G6D,  88,  68, 152,  83, 110
        MOVE G6A, 108,  73, 146,  85,  94
        WAIT

        SPEED 10'walk_speed
        '
        MOVE G6D, 90, 97, 115, 98, 114
        MOVE G6A,112,  75, 146,  85,  94
        WAIT


        GOTO paper_lift_front_walk_50_2	

    ENDIF


    '*******************************


paper_lift_front_walk_50_1:

    SPEED walk_speed
    '
    MOVE G6A, 90,  41, 163, 105, 114
    MOVE G6D,110,  74, 146,  85,  94
    WAIT

    SPEED LR_speed
    GOSUB Leg_motor_mode3
    '
    MOVE G6A,110,  73, 144, 92,  93
    MOVE G6D,90, 90, 155,  63, 112
    WAIT


    SPEED walk_speed
    GOSUB Leg_motor_mode2
    '
    MOVE G6A,111,  74, 146,  85, 94
    MOVE G6D,90, 97, 105, 102, 114
    WAIT
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF
    ERX 4800,A, paper_lift_front_walk_50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '
        MOVE G6A, 106,  73, 146,  85,  96		
        MOVE G6D,  88,  68, 152,  82, 106
        WAIT	


        SPEED 3
        MOVE G6A,100,  73, 145,  85, 100, 100
        MOVE G6D,100,  73, 145,  85, 100, 100
        WAIT
        GOSUB Leg_motor_mode1
        '  
        GOTO RX_EXIT
    ENDIF
    '**********


paper_lift_front_walk_50_2:


    SPEED walk_speed
    '
    MOVE G6D,90,  41, 163, 105, 114
    MOVE G6A,110,  74, 146,  85,  94
    WAIT

    SPEED LR_speed
    GOSUB Leg_motor_mode3
    '
    MOVE G6D,110,  73, 144, 92,  93
    MOVE G6A, 90, 90, 155,  63, 112
    WAIT

    SPEED walk_speed
    GOSUB Leg_motor_mode2
    '
    MOVE G6A, 90, 97, 105, 102, 114
    MOVE G6D,111,  74, 146,  85,  94
    WAIT
    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        GOTO MAIN
    ENDIF
    ERX 4800,A, paper_lift_front_walk_50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '
        MOVE G6D, 106,  73, 146,  85,  96		
        MOVE G6A,  88,  68, 152,  82, 106
        WAIT

        SPEED 3
        MOVE G6A,100,  73, 145,  85, 100, 100
        MOVE G6D,100,  73, 145,  85, 100, 100
        WAIT
        GOSUB Leg_motor_mode1
        '  
        GOTO RX_EXIT
    ENDIF


    GOTO paper_lift_front_walk_50_1
    '************************************************
    '******************************************
standstill:
    fall_check = 0
    GOSUB Arm_motor_mode3
    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,2,3,3,3,2
    MOTORMODE G6D,2,3,3,3,2

    MOVE G6B,,35
    MOVE G6C,,35
    WAIT

standstill_1:

    SPEED 4
    MOVE G6A,105,  76, 146,  93, 98, 100
    MOVE G6D,85,  73, 151,  90, 108, 100
    WAIT

    SPEED 12
    MOVE G6A,113,  76, 146,  93, 96, 100
    MOVE G6D,90,  100, 95,  120, 115, 100
    MOVE G6B,120
    MOVE G6C,80
    WAIT

    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6A,109,  76, 146,  93, 97, 100
    MOVE G6D,90,  76, 148,  92, 110, 100
    WAIT



    SPEED 4	
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100	
    WAIT

    ERX 4800,A, standstill_2
    IF A <> A_old THEN
        SPEED 5
        GOSUB standard_pose
        GOSUB Leg_motor_mode1
        RETURN
    ENDIF

standstill_2:
    '***********************************
    SPEED 4
    MOVE G6D,105,  76, 146,  93, 98, 100
    MOVE G6A,85,  73, 151,  90, 108, 100
    WAIT	

    SPEED 12
    MOVE G6D,113,  76, 146,  93, 96, 100
    MOVE G6A,90,  100, 95,  120, 115, 100
    MOVE G6C,120
    MOVE G6B,80
    WAIT	



    GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6D,109,  76, 146,  93, 97, 100
    MOVE G6A,90,  76, 148,  92, 110, 100
    WAIT	

    SPEED 4		
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100	
    WAIT	

    ERX 4800,A, standstill_1
    IF A <> A_old THEN
        SPEED 5
        GOSUB standard_pose
        GOSUB Leg_motor_mode1
        RETURN
    ENDIF

    GOTO standstill_1


    RETURN
    '**********************************************	
    '**********************************************	
    '**********************************************	
    '************************************************
right_walk_20:

    GOSUB SOUND_Walk_Move
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 104, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB standard_pose

    GOTO RX_EXIT
    '**********************************************

left_walk_20:

    GOSUB SOUND_Walk_Move
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB standard_pose
    GOTO RX_EXIT

    '**********************************************

right_walk_70:
    GOSUB SOUND_Walk_Move
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB standard_pose

    GOTO RX_EXIT
    '*************

left_walk_70:
    GOSUB SOUND_Walk_Move

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15	
    GOSUB standard_pose

    GOTO RX_EXIT
    '************************************************

chack_right_walk_20:


    SPEED 12
    MOVE G6D, 93,  90, 120, 97, 104, 100
    MOVE G6A,103,  76, 145,  85, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 85, 100, 100
    MOVE G6A,90,  80, 140,  87, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  85, 100, 100
    MOVE G6A,98,  76, 145,  85, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '**********************************************

chack_left_walk_20:


    SPEED 12
    MOVE G6A, 93,  90, 120, 97, 104, 100
    MOVE G6D,103,  76, 145,  85, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 85, 100, 100
    MOVE G6D,90,  80, 140,  87, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  85, 100, 100
    MOVE G6D,98,  76, 145,  85, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '**********************************************

chack_right_walk_70:
    GOSUB SOUND_Walk_Move
    SPEED 10
    MOVE G6D, 90,  90, 120, 92, 110, 100
    MOVE G6A,100,  76, 146,  85, 107, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 85, 100, 100
    MOVE G6A,83,  76, 140,  92, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  85, 100, 100
    MOVE G6A,98,  76, 146,  85, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '*************

chack_left_walk_70:
    GOSUB SOUND_Walk_Move

    SPEED 10
    MOVE G6A, 90,  90, 120, 97, 110, 100	
    MOVE G6D,100,  76, 146,  85, 107, 100	
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 85, 100, 100
    MOVE G6D,83,  76, 140,  92, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  85, 100, 100
    MOVE G6D,98,  76, 146,  85, 100, 100
    WAIT

    SPEED 15	
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '************************************************
slow_left_walk_50:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 76,  72, 160,  82, 128,  100
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT

    SPEED 5
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 76,  72, 160,  82, 120,  100
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT

    SPEED 6
    MOVE G6D, 85,  80, 140, 95, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 2
    GOSUB standard_pose
    GOSUB All_motor_Reset	
    RETURN

    '**********************************************
    '************************************************
slow_right_walk_50:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6D, 85,  80, 140, 95, 114, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 76,  72, 160,  82, 128,  100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT

    SPEED 5
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 76,  72, 160,  82, 120,  100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT

    SPEED 6
    MOVE G6A, 85,  80, 140, 95, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT

    SPEED 2
    GOSUB standard_pose
    GOSUB All_motor_Reset	
    RETURN

    '**********************************************

    '**********************************************
left_turn_10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB standard_pose
    GOTO RX_EXIT
    '**********************************************
right_turn_10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB standard_pose

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
left_turn_20:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB standard_pose
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
right_turn_20:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB standard_pose
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
left_turn_45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB standard_pose
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '**********************************************
right_turn_45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB standard_pose
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
left_turn_60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB standard_pose
    GOTO RX_EXIT

    '**********************************************
right_turn_60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB standard_pose
    GOTO RX_EXIT

    '************************************************
    '**********************************************
chack_left_turn_10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  86, 145,  75, 103, 100
    MOVE G6D,97,  66, 145,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  75, 101, 100
    MOVE G6D,94,  66, 145,  95, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
chack_right_turn_10:
    GOSUB SOUND_Walk_Move
    SPEED 5
    MOVE G6A,97,  66, 145,  95, 103, 100
    MOVE G6D,97,  86, 145,  75, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  95, 101, 100
    MOVE G6D,94,  86, 145,  75, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
    '**********************************************
chack_left_turn_20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  65, 105, 100
    MOVE G6D,95,  56, 145,  105, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  65, 105, 100
    MOVE G6D,93,  56, 145,  105, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
chack_right_turn_20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  56, 145,  105, 105, 100
    MOVE G6D,95,  96, 145,  65, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  105, 105, 100
    MOVE G6D,93,  96, 145,  65, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
chack_left_turn_45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  55, 105, 100
    MOVE G6D,95,  46, 145,  115, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  55, 105, 100
    MOVE G6D,93,  46, 145,  115, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '**********************************************
chack_right_turn_45:
    GOSUB SOUND_Walk_Move
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  115, 105, 100
    MOVE G6D,95,  106, 145,  55, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  115, 105, 100
    MOVE G6D,93,  106, 145,  55, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
chack_left_turn_60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  116, 145,  45, 105, 100
    MOVE G6D,95,  36, 145,  125, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  45, 105, 100
    MOVE G6D,90,  36, 145,  125, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '**********************************************
chack_right_turn_60:
    GOSUB SOUND_Walk_Move
    SPEED 15
    MOVE G6A,95,  36, 145,  125, 105, 100
    MOVE G6D,95,  116, 145,  45, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  125, 105, 100
    MOVE G6D,90,  116, 145,  45, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '************************************************
    '***********************************
    '************************************************

bow_1:
    GOSUB SOUND_HELLO_miniROBOT_ROBONOVA_2
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6A,100,  70, 125, 150, 100
    MOVE G6D,100,  70, 125, 150, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    DELAY 1000
    SPEED 6
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '************************************************
bow_2:
    GOSUB All_motor_mode3
    SPEED 4
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6B,110,  30,  80
    MOVE G6C,90,  30,  80
    WAIT

    SPEED 8
    MOVE G6D, 90, 95, 115, 105, 112
    MOVE G6A,113,  76, 146,  93,  94
    MOVE G6B,130,  30,  80
    MOVE G6C,75,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,112,  86, 120, 120,  94
    MOVE G6D,90, 100, 155,  71, 112
    MOVE G6B,140,  30,  80
    MOVE G6C,70,  30,  80
    WAIT


    SPEED 10
    MOVE G6A,108,  85, 110, 140,  94
    MOVE G6D,85, 97, 145,  91, 112
    MOVE G6B,150,  20,  40
    MOVE G6C,60,  30,  80
    WAIT

    DELAY 1000
    '*******************
    GOSUB leg_motor_mode2
    SPEED 6
    MOVE G6D, 90, 95, 115, 105, 110
    MOVE G6A,114,  76, 146,  93,  96
    MOVE G6B,130,  30,  80
    MOVE G6C,75,  30,  80
    WAIT

    SPEED 8
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6B,110,  30,  80
    MOVE G6C,90,  30,  80
    WAIT

    SPEED 3
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '************************************************


bow_3:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  70,  80
    MOVE G6B,160,  35,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    '
    SPEED 8
    MOVE G6A,100,  55, 145,  145, 100, 100
    MOVE G6D,100,  55, 145,  145, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    DELAY 1000
    '
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  70,  80
    MOVE G6B,160,  40,  80
    WAIT

    SPEED 10
    GOSUB standard_pose
    GOSUB All_motor_Reset


    RETURN
    '************************************************


cheer:
    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  80, 145,  75, 100
    MOVE G6D,100,  80, 145,  75, 100
    MOVE G6B,100,  180,  120
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 2

        MOVE G6B,100,  145,  100
        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6B,100,  180,  130
        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    ''************************************************
win_ceremony_1:
    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  180,  120
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 3

        MOVE G6B,100,  145,  100
        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6B,100,  180,  130
        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    ''************************************************
win_ceremony_2:
    SPEED 10
    GOSUB standard_pose
    GOSUB All_motor_mode3

    SPEED 8

    MOVE G6A, 100, 163,  75,  15, 100
    MOVE G6D, 100, 163,  75,  15, 100
    MOVE G6B,185, 100, 90
    MOVE G6C,185, 100, 90
    WAIT

    SPEED 2

    MOVE G6A, 100, 165,  70,  10, 100, 100
    MOVE G6D, 100, 165,  70,  10, 100, 100
    MOVE G6B,185, 100, 90
    MOVE G6C,185, 100, 90
    WAIT

    DELAY 400
    SPEED 15
    FOR I = 1 TO 5

        MOVE G6B,185, 20, 50
        MOVE G6C,185, 20, 50
        WAIT

        MOVE G6B,185, 70, 80
        MOVE G6C,185, 70, 80
        WAIT

    NEXT I

    MOVE G6B,100, 70, 80
    MOVE G6C,100, 70, 80
    WAIT

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A, 100, 145,  70,  80, 100, 100
    MOVE G6D, 100, 145,  70,  80, 100, 100
    MOVE G6B,100, 40, 90
    MOVE G6C,100, 40, 90
    WAIT

    SPEED 8
    MOVE G6A,100, 121,  80, 110, 101, 100
    MOVE G6D,100, 121,  80, 110, 101, 100
    MOVE G6B,100,  40,  80, , ,
    MOVE G6C,100,  40,  80, , ,
    WAIT

    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    ''************************************************
    ''************************************************
win_ceremony_3:
    GOSUB All_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  180,  120
    WAIT	

    SPEED 10
    FOR i = 1 TO 4

        MOVE G6C,100,  145,  100
        WAIT

        MOVE G6C,100,  180,  130
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN
    ''************************************************

lose_action_1:
    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 140,  37, 140, 100, 100
    MOVE G6D,100, 140,  37, 140, 100, 100
    WAIT

    SPEED 3
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6B,140
    MOVE G6C,140
    WAIT
    SPEED 4
    MOVE G6A,95, 163,  28, 160, 105
    MOVE G6D,95, 163,  28, 160, 105
    MOVE G6B,160,  15,  90
    MOVE G6C,185,  20,  85
    WAIT

    DELAY 400
    SPEED 10
    FOR i = 1 TO 8
        MOVE G6C,165,  20,  85
        WAIT
        MOVE G6C,188,  20,  85
        WAIT  	
    NEXT i
    DELAY 500

    GOSUB Leg_motor_mode3

    SPEED 10	
    MOVE G6A,  100, 165,  28, 162, 100
    MOVE G6D,  100, 165,  28, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 150,  27, 162, 100
    MOVE G6D,  100, 150,  27, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT

    SPEED 6
    MOVE G6A,  100, 138,  28, 155, 100
    MOVE G6D,  100, 138,  28, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    GOSUB Leg_motor_mode2
    SPEED 8
    GOSUB standard_pose

    RETURN

    ''************************************************
lose_action_2:
    GOSUB Arm_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  185,  170
    WAIT	

    SPEED 4
    FOR i = 1 TO 8
        MOVE G6C,100,  170,  185
        WAIT

        MOVE G6C,100,  185,  170
        WAIT	
    NEXT i
    DELAY 200
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN
    ''************************************************
    ''************************************************
hug_action:
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6B,100,  60,  80
    MOVE G6C,160,  50,  80
    WAIT

    SPEED 15
    MOVE G6A, 85,  76, 145, 94, 110
    MOVE G6D,108,  81, 135,  98, 98
    MOVE G6B,100,  60,  80
    MOVE G6C,160,  50,  80
    WAIT

    SPEED 6
    MOVE G6A, 90,  92, 115, 109, 125, 100
    MOVE G6D,103,  76, 141,  98,  82, 100
    MOVE G6B,160,  50,  80
    MOVE G6C,188,  50,  80
    WAIT	

    SPEED 5
    FOR i = 1 TO 6

        MOVE G6B,160,  50,  50
        MOVE G6C,188,  50,  50
        WAIT

        MOVE G6B,160,  55,  80
        MOVE G6C,188,  55,  80
        WAIT
    NEXT i


    SPEED 10
    MOVE G6A, 85,  76, 145, 94, 110
    MOVE G6D,108,  81, 135,  98, 98
    MOVE G6B,100,  40,  80
    MOVE G6C,160,  60,  80
    WAIT

    SPEED 10
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6B,100,  40,  80
    MOVE G6C,140,  60,  90
    WAIT

    SPEED 6
    MOVE G6A, 95,  75, 146,  93, 105
    MOVE G6D,109,  76, 146,  93,  92
    WAIT

    SPEED 3
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN


    ''************************************************
breathing_exercises:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6B, 150,  35, 70,
    MOVE G6C, 150,  35, 70,
    MOVE G6A,100,  63, 135, 140, 100,
    MOVE G6D,100,  63, 135, 140, 100,
    WAIT

    FOR I = 1 TO 4
        SPEED 7
        MOVE G6B, 155,  40, 90,
        MOVE G6C, 155,  40, 90,
        WAIT

        SPEED 5
        MOVE G6A,100,  58, 135, 155, 100,
        MOVE G6D,100,  58, 135, 155, 100,
        WAIT

        SPEED 7
        MOVE G6B, 155,  20, 70,
        MOVE G6C, 155,  20, 70,
        WAIT

        SPEED 5
        MOVE G6A,100,  48, 160, 135, 100,
        MOVE G6D,100,  48, 160, 135, 100,
        WAIT
    NEXT I


    SPEED 6
    MOVE G6A,100,  65, 135, 140, 100,
    MOVE G6D,100,  65, 135, 140, 100,
    MOVE G6B, 155,  40, 80,
    MOVE G6C, 155,  40, 80,
    WAIT

    SPEED 6
    GOSUB standard_pose
    GOSUB All_motor_Reset 	
    RETURN
    '************************************************







    '************************************************
    '************************************************
crawl:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    'GOTO crawlleft_turn__LOOP

crawl_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    ERX 4800, A, crawl_1
    IF A = 8 THEN GOTO crawl_1
    IF A = 9 THEN GOTO crawlright_turn__LOOP
    IF A = 7 THEN GOTO crawlleft_turn__LOOP

    GOTO crawl_standup

crawl_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    ERX 4800, A, crawl_2
    IF A = 8 THEN GOTO crawl_2
    IF A = 9 THEN GOTO crawlright_turn__LOOP
    IF A = 7 THEN GOTO crawlleft_turn__LOOP

    GOTO crawl_standup

crawl_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 160,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO crawl_LOOP


    '**********************************
crawlleft_turn_:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    SPEED 10
    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  20, 80
    MOVE G6B,175,  20, 80
    WAIT

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

crawlleft_turn__LOOP:

    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6B,175,  70, 20
    MOVE G6C,175,  10, 75
    WAIT	


    ERX 4800, A, crawlleft_turn__1
    IF A = 8 THEN GOTO crawl_LOOP
    IF A = 9 THEN GOTO crawlright_turn__LOOP
    IF A = 7 THEN GOTO crawlleft_turn__1
    GOTO crawl_standup

crawlleft_turn__1:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6B,175,  80, 30
    MOVE G6C,175,  30, 95
    WAIT		


    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6B,175,  15, 75
    MOVE G6C,175,  60, 20
    WAIT		

    ERX 4800, A, crawlleft_turn__2
    IF A = 8 THEN GOTO crawl_LOOP
    IF A = 9 THEN GOTO crawlright_turn__LOOP
    IF A = 7 THEN GOTO crawlleft_turn__2
    GOTO crawl_standup

crawlleft_turn__2:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6B,175,  10, 75
    MOVE G6C,175,  10, 75
    WAIT	

    GOTO crawlleft_turn__LOOP



    '**********************************

    '**********************************
crawlright_turn_:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    SPEED 10
    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  20, 80
    MOVE G6B,175,  20, 80
    WAIT

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

crawlright_turn__LOOP:

    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  70, 20
    MOVE G6B,175,  10, 75
    WAIT	


    ERX 4800, A, crawlright_turn__1
    IF A = 8 THEN GOTO crawl_LOOP
    IF A = 9 THEN GOTO crawlright_turn__1
    IF A = 7 THEN GOTO crawlleft_turn__LOOP
    GOTO crawl_standup

crawlright_turn__1:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6C,175,  80, 30
    MOVE G6B,175,  30, 95
    WAIT		


    MOVE G6A, 100, 160,  110, 100, 110
    MOVE G6D, 100, 160,  110, 100, 110
    MOVE G6C,175,  15, 75
    MOVE G6B,175,  60, 20
    WAIT		

    ERX 4800, A, crawlright_turn__2
    IF A = 8 THEN GOTO crawl_LOOP
    IF A = 9 THEN GOTO crawlright_turn__2
    IF A = 7 THEN GOTO crawlleft_turn__LOOP
    GOTO crawl_standup

crawlright_turn__2:
    MOVE G6A, 100, 155,  110, 100, 110
    MOVE G6D, 100, 155,  110, 100, 110
    MOVE G6C,175,  10, 75
    MOVE G6B,175,  10, 75
    WAIT	

    GOTO crawlright_turn__LOOP



    '**********************************

    GOTO RX_EXIT
    '**********************************	
crawl_standup:
    PTP SETON		
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3
    DELAY 300

    SPEED 10	
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 150,  25, 162, 100
    MOVE G6D,  100, 150,  25, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT

    SPEED 6
    MOVE G6A,  100, 138,  25, 155, 100
    MOVE G6D,  100, 138,  25, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 8
    GOSUB Leg_motor_mode2

    SPEED 6
    MOVE G6A,100, 140,  37, 140, 100, 100
    MOVE G6D,100, 140,  37, 140, 100, 100
    WAIT

    GOSUB standard_pose

    GOTO RX_EXIT

    '******************************************************
front_tumbling:

    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85
    WAIT

    SPEED 10	
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 15
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20
    WAIT

    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 162, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  70, 120, 30, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70
    WAIT
    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 70,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB sit_pose

    SPEED 10
    GOSUB standard_pose

    RETURN

    '**********************************************
    '**********************************************
back_tumbling:

    SPEED 15
    MOVE G6A,100, 170,  71,  23, 100, 100
    MOVE G6D,100, 170,  71,  23, 100, 100
    MOVE G6B, 80,  50,  70
    MOVE G6C, 80,  50,  70
    WAIT	

    MOVE G6A,100, 133,  49,  23, 100, 100
    MOVE G6D,100, 133,  49,  23, 100, 100
    MOVE G6B, 45, 116,  15
    MOVE G6C, 45, 116,  15
    WAIT

    SPEED 15
    MOVE G6A,100, 133,  49,  23, 100, 100
    MOVE G6D,100,  70, 180, 160, 100, 100
    MOVE G6B, 45,  50,  70
    MOVE G6C, 45,  50,  70
    WAIT


    SPEED 15
    MOVE G6A,100, 133, 180, 160, 100, 100
    MOVE G6D,100,  133, 180, 160, 100, 100
    MOVE G6B, 10,  50,  70
    MOVE G6C, 10,  50,  70
    WAIT

    HIGHSPEED SETON

    MOVE G6A,100, 95, 180, 160, 100, 100
    MOVE G6D,100, 95, 180, 160, 100, 100
    MOVE G6B,160,  50,  70
    MOVE G6C,160,  50,  70
    WAIT

    HIGHSPEED SETOFF '

    SPEED 15
    MOVE G6A,100, 130, 120,  80, 100, 100
    MOVE G6D, 100, 130, 120,  80, 100, 100
    MOVE G6B,160, 160,  10
    MOVE G6C,160, 160,  10
    WAIT
    '
    SPEED 15
    MOVE G6A,100, 145, 150,  90, 100, 100
    MOVE G6D, 100, 145, 150,  90, 100, 100
    MOVE G6B,180, 90,  10
    MOVE G6C,180, 90,  10
    WAIT

    SPEED 10
    MOVE G6A, 100, 145,  85, 150, 100, 100
    MOVE G6D, 100, 145,  85, 150, 100, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    SPEED 15
    MOVE G6A, 100, 165,  55, 155, 100, 100
    MOVE G6D, 100, 165,  55, 155, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT	

    GOSUB Leg_motor_mode2
    SPEED 15	
    MOVE G6A,  100, 165,  27, 162, 100
    MOVE G6D,  100, 165,  27, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 150,  27, 162, 100
    MOVE G6D,  100, 150,  27, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT

    SPEED 6
    MOVE G6A,  100, 138,  27, 155, 100
    MOVE G6D,  100, 138,  27, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 10
    GOSUB standard_pose
    RETURN
    '************************************************
front_lie:

    SPEED 10
    MOVE G6A,100, 155,  25, 140, 100,
    MOVE G6D,100, 155,  25, 140, 100,
    MOVE G6B,130,  50,  85
    MOVE G6C,130,  50,  85
    WAIT

    SPEED 3
    MOVE G6A, 100, 165,  50, 160, 100,
    MOVE G6D, 100, 165,  50, 160, 100,
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 10
    MOVE G6A,100, 130, 120,  80, 100,
    MOVE G6D,100, 130, 120,  80, 100,
    MOVE G6B,125, 160,  10
    MOVE G6C,125, 160,  10
    WAIT	

    SPEED 12
    GOSUB standard_pose

    RETURN
    '**********************************************
    '******************************************
back_lie:

    SPEED 10
    MOVE G6A,100, 165,  40, 100, 100,
    MOVE G6D,100, 165,  40, 100, 100,
    MOVE G6B,110,  70,  50
    MOVE G6C,110,  70,  50
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  70, 15, 100,
    MOVE G6D,100, 165,  70, 15, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    SPEED 15
    MOVE G6A,100, 126,  60, 50, 100,
    MOVE G6D,100, 126,  60, 50, 100,
    MOVE G6B,20,  30,  90
    MOVE G6C,20,  30,  90
    WAIT

    SPEED 10
    MOVE G6A,100, 10,  83, 140, 100,
    MOVE G6D,100, 10,  83, 140, 100,
    MOVE G6B,20,  130,  15
    MOVE G6C,20,  130,  15
    WAIT

    SPEED 10
    MOVE G6A,100, 10,  100, 115, 100,
    MOVE G6D,100, 10,  100, 115, 100,
    MOVE G6B,100,  130,  15
    MOVE G6C,100,  130,  15
    WAIT

    SPEED 10
    GOSUB standard_pose

    RETURN
    '******************************************


    '**********************************************
    '**********************************************
left_tumbling:
    GOSUB Leg_motor_mode1
    SPEED 15
    GOSUB standard_pose


    SPEED 15
    MOVE G6D,100, 125,  62, 132, 100, 100
    MOVE G6A,100, 125,  62, 132, 100, 100
    MOVE G6B,105, 150, 140
    MOVE G6C,105, 150, 140
    WAIT

    SPEED 7
    MOVE G6D,83 , 108,  85, 125, 105, 100
    MOVE G6A,108, 125,  62, 132, 110, 100
    MOVE G6B,105, 155, 145
    MOVE G6C,105, 155, 145
    WAIT


    SPEED 10
    MOVE G6D,89,  125,  62, 130, 110, 100
    MOVE G6A,110, 125,  62, 130, 122, 100
    WAIT
    SPEED 8
    MOVE G6D, 89, 125,  62, 130, 150, 100
    MOVE G6A,106, 125,  62, 130, 150, 100
    MOVE G6B,105, 167, 190
    MOVE G6C,105, 167, 190
    WAIT

    SPEED 6
    MOVE G6D,120, 125,  62, 130, 170, 100
    MOVE G6A,104, 125,  62, 130, 170, 100
    WAIT

    SPEED 12
    MOVE G6D,120, 125,  62, 130, 183, 100
    MOVE G6A,110, 125,  62, 130, 185, 100
    WAIT

    DELAY 400

    SPEED 14
    MOVE G6D,120, 125,  62, 130, 168, 100
    MOVE G6A,120, 125  62, 130, 185, 100
    MOVE G6B,105, 120, 145
    MOVE G6C,105, 120, 145
    WAIT

    SPEED 12
    MOVE G6D,105, 125,  62, 130, 183, 100
    MOVE G6A, 86, 112,  73, 127, 100, 100
    MOVE G6B,105, 120, 135
    MOVE G6C,105, 120, 135
    WAIT

    SPEED 8
    MOVE G6D,107, 125,  62, 132, 113, 100
    MOVE G6A, 82, 110,  90, 120,  100, 100
    MOVE G6B,105, 50, 80
    MOVE G6C,105, 50, 80
    WAIT

    SPEED 6
    MOVE G6A,97, 125,  62, 132, 102, 100
    MOVE G6D,97, 125,  62, 132, 102, 100
    MOVE G6B,100, 50, 80
    MOVE G6C,100, 50, 80
    WAIT

    SPEED 10
    GOSUB standard_pose
    RETURN
    '**********************************************
    '**********************************************
right_tumbling:
    GOSUB Leg_motor_mode1
    SPEED 15
    GOSUB standard_pose


    SPEED 15
    MOVE G6A,100, 125,  62, 132, 100, 100
    MOVE G6D,100, 125,  62, 132, 100, 100
    MOVE G6B,105, 150, 140
    MOVE G6C,105, 150, 140
    WAIT

    SPEED 7
    MOVE G6A,83 , 108,  85, 125, 105, 100
    MOVE G6D,108, 125,  62, 132, 110, 100
    MOVE G6B,105, 155, 145
    MOVE G6C,105, 155, 145
    WAIT


    SPEED 10
    MOVE G6A,89,  125,  62, 130, 110, 100
    MOVE G6D,110, 125,  62, 130, 122, 100
    WAIT
    SPEED 8
    MOVE G6A, 89, 125,  62, 130, 150, 100
    MOVE G6D,106, 125,  62, 130, 150, 100
    MOVE G6B,105, 167, 190
    MOVE G6C,105, 167, 190
    WAIT

    SPEED 6
    MOVE G6A,120, 125,  62, 130, 170, 100
    MOVE G6D,104, 125,  62, 130, 170, 100
    WAIT

    SPEED 12
    MOVE G6A,120, 125,  62, 130, 183, 100
    MOVE G6D,110, 125,  62, 130, 185, 100
    WAIT

    DELAY 400

    SPEED 14
    MOVE G6A,120, 125,  60, 130, 168, 100
    MOVE G6D,120, 125  60, 130, 185, 100
    MOVE G6B,105, 120, 145
    MOVE G6C,105, 120, 145
    WAIT

    SPEED 12
    MOVE G6A,105, 125,  62, 130, 183, 100
    MOVE G6D, 86, 112,  73, 127, 100, 100
    MOVE G6B,105, 120, 135
    MOVE G6C,105, 120, 135
    WAIT

    SPEED 8
    MOVE G6A,107, 125,  62, 132, 113, 100
    MOVE G6D, 82, 110,  90, 120,  100, 100
    MOVE G6B,105, 50, 80
    MOVE G6C,105, 50, 80
    WAIT

    SPEED 6
    MOVE G6A,97, 125,  62, 132, 102, 100
    MOVE G6D,97, 125,  62, 132, 102, 100
    MOVE G6B,100, 50, 80
    MOVE G6C,100, 50, 80
    WAIT

    SPEED 10
    GOSUB standard_pose
    RETURN
    '**********************************************
    '**********************************************
left_foot_sit_standup:

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,112,  77, 146,  93,  92' 60	
    MOVE G6D, 80,  71, 152,  91, 112', 60
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT


    SPEED 8
    MOVE G6A,113,  77, 146,  93,  92, 100	
    MOVE G6D,80,  150,  27, 143, 114, 100
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT

    DELAY 500


    SPEED 8
    MOVE G6A,113, 152,  27, 140, 92, 100
    MOVE G6D,85, 154,  27, 143, 114, 100,
    MOVE G6C,100,  100,  100
    MOVE G6B,100,  100,  100
    WAIT

    GOSUB Leg_motor_mode1
    DELAY 1000

    SPEED 3
    MOVE G6A,115, 152,  35, 140, 92, 100
    WAIT

    SPEED 8
    MOVE G6A,113,  77, 146,  93, 92, 100
    WAIT

    GOSUB Leg_motor_mode2
    DELAY 500

    MOVE G6A,112,  77, 146,  93,  92, 100		
    MOVE G6D, 80, 88, 125, 100, 115, 100
    MOVE G6B,100,  100,  100, , , ,
    MOVE G6C,100,  100,  100, , , ,
    WAIT


    SPEED 4
    GOSUB standard_pose
    GOSUB Leg_motor_mode1

    RETURN
    '******************************************	
right_foot_sit_standup:

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D,112,  77, 146,  93,  92, '60	
    MOVE G6A, 80,  71, 152,  91, 112,' 60
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT


    SPEED 8
    MOVE G6D,113,  77, 146,  93,  92, 100	
    MOVE G6A,80,  150,  27, 140, 114, 100
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT

    DELAY 500

    SPEED 8
    MOVE G6D,113, 152,  27, 140, 92, 100
    MOVE G6A,85, 154,  27, 140, 114, 100,
    MOVE G6C,100,  100,  100
    MOVE G6B,100,  100,  100
    WAIT

    GOSUB Leg_motor_mode1
    DELAY 1000

    SPEED 3
    MOVE G6D,115, 152,  35, 140, 92, 100
    WAIT

    SPEED 8
    MOVE G6D,113,  77, 146,  93, 92, 100
    WAIT

    GOSUB Leg_motor_mode2
    DELAY 500


    MOVE G6D,112,  77, 146,  93,  92, 100		
    MOVE G6A, 80, 88, 125, 100, 115, 100
    MOVE G6B,100,  100,  100, , , ,
    MOVE G6C,100,  100,  100, , , ,
    WAIT


    SPEED 4
    GOSUB standard_pose
    GOSUB Leg_motor_mode1

    RETURN
    '**********************************************
    '********************************************	
hand_standing:
    GOSUB front_lie
    GOSUB Arm_motor_mode1
    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6B, 115,  45,  70,  ,  ,  ,
    MOVE G6C,115,  45,  70,  ,  ,  ,
    WAIT

    MOVE G6A,100, 125,  65,  10, 100
    MOVE G6D,100, 125,  65,  10, 100
    MOVE G6B, 130,  45,  70,  ,  ,  ,
    MOVE G6C,130,  45,  70,  ,  ,  ,
    WAIT

    SPEED 6
    MOVE G6A,100,  89, 129,  57, 100,
    MOVE G6D, 100,  89, 129,  57, 100
    MOVE G6B, 180,  45,  70,  ,  ,  ,
    MOVE G6C, 180,  45,  70,  ,  ,  ,
    WAIT

    MOVE G6A,100,  64, 169,  60, 100,
    MOVE G6D, 100,  64, 169,  60, 100
    MOVE G6B, 190,  45,  70,  ,  ,  ,
    MOVE G6C, 190,  45,  70,  ,  ,  ,
    WAIT
    DELAY 500

    SPEED 12

    FOR i = 1 TO 4

        MOVE G6A,100, 141,  30, 120, 100
        MOVE G6D, 100,  64, 169,  60, 100
        WAIT

        MOVE G6D,100, 141,  30, 120, 100
        MOVE G6A, 100,  64, 169,  60, 100
        WAIT

    NEXT i

    MOVE G6A,100,  64, 169,  60, 100,
    MOVE G6D, 100,  64, 169,  60, 100
    MOVE G6B, 190,  45,  70,  ,  ,  ,
    MOVE G6C, 190,  45,  70,  ,  ,  ,
    WAIT

    DELAY 300

    SPEED 4
    FOR i = 1 TO 3


        MOVE G6A,70,  64, 169,  60, 130,
        MOVE G6D, 70,  64, 169,  60, 130
        WAIT

        MOVE G6A,100,  64, 169,  60, 100,
        MOVE G6D, 100,  64, 169,  60, 100
        WAIT
    NEXT i

    DELAY 300	
    SPEED 10
    MOVE G6A,100,  89, 129,  65, 100,
    MOVE G6D,100,  89, 129,  65, 100
    MOVE G6B, 180,  45,  70,  ,  ,  ,
    MOVE G6C, 180,  45,  70,  ,  ,  ,
    WAIT

    SPEED 10
    MOVE G6A,100, 125,  65,  10, 100,
    MOVE G6D, 100, 125,  65,  10, 100
    MOVE G6B, 160,  45,  70,  ,  ,  ,
    MOVE G6C, 160,  45,  70,  ,  ,  ,
    WAIT

    SPEED 10
    MOVE G6A,100, 125,  65,  10, 100,
    MOVE G6D, 100, 125,  65,  10, 100
    MOVE G6B, 110,  45,  70,  ,  ,  ,
    MOVE G6C, 110,  45,  70,  ,  ,  ,
    WAIT
    SPEED 10
    GOSUB standard_pose

    GOSUB back_standup

    RETURN
    '**********************************************	
old_dance:

    DIM w1 AS BYTE
    GOSUB Leg_motor_mode2
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT


    SPEED 5
    MOVE G6A, 80,  74, 146, 94, 116, 100
    MOVE G6D,108,  81, 137,  98, 98, 100
    MOVE G6B,100,  70,  90
    MOVE G6C,100,  70,  90	
    WAIT

    SPEED 5
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT	



    SPEED 4
    MOVE G6A,94,  94, 145,  45, 106
    MOVE G6D,94,  94, 145,  45, 106
    WAIT	

    HIGHSPEED SETON


    FOR I= 1 TO 3
        SPEED 6
        FOR w1= 0 TO 2

            MOVE G6B,100,  150,  140,
            MOVE G6C,100,  100,  190,
            MOVE G6A, 95,  94, 145,  45, 107,
            MOVE G6D, 89,  94, 145,  45, 113,
            WAIT

            MOVE G6C,100,  150,  140,
            MOVE G6B,100,  100,  190,
            MOVE G6D, 95,  94, 145,  45, 107,
            MOVE G6A, 89,  94, 145,  45, 113,
            WAIT

        NEXT w1

        SPEED 12
        MOVE G6C,100,  100,  190,
        MOVE G6B,100,  75,  100,
        MOVE G6A, 95,  94, 145,  45, 107,
        MOVE G6D, 89,  94, 145,  45, 113,
        WAIT

        SPEED 12
        MOVE G6C,100,  150,  140,
        MOVE G6B,100,  100,  100,
        MOVE G6D, 95,  94, 145,  45, 107,
        MOVE G6A, 89,  94, 145,  45, 113,
        WAIT

        DELAY 200
        SPEED 6
        FOR w1= 0 TO 2


            MOVE G6B,100,  150,  140,
            MOVE G6C,100,  100,  190,
            MOVE G6A, 95,  94, 145,  45, 107,
            MOVE G6D, 89,  94, 145,  45, 113,
            WAIT

            MOVE G6C,100,  150,  140,
            MOVE G6B,100,  100,  190,
            MOVE G6D, 95,  94, 145,  45, 107,
            MOVE G6A, 89,  94, 145,  45, 113,
            WAIT

        NEXT w1

        SPEED 15
        MOVE G6B,100,  100,  190,
        MOVE G6C,100,  75,  100,
        MOVE G6D, 89,  94, 145,  45, 113,
        MOVE G6A, 95,  94, 145,  45, 107,
        WAIT

        SPEED 12
        MOVE G6B,100,  150,  140,
        MOVE G6C,100,  100,  100,
        MOVE G6D, 95,  94, 145,  45, 107,
        MOVE G6A, 89,  94, 145,  45, 113,
        WAIT

        DELAY 100
    NEXT I
    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3	
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 98, 100
    MOVE G6D,100,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    SPEED 5
    DELAY 50
    GOSUB standard_pose


    RETURN

    '************************************************

    '******************************************	


flying:

    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110, 100
    MOVE G6D,112,  76, 146,  93,  92, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT


    SPEED 10
    MOVE G6A, 90,  98, 105,  115, 115, 100
    MOVE G6D,114,  74, 145,  98,  93, 100
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 6
    MOVE G6A, 90, 121,  36, 105, 115,  100
    MOVE G6D,114,  60, 146, 138,  93,  100
    WAIT

    SPEED 6
    GOSUB Leg_motor_mode2
    MOVE G6A, 90,  98, 105,  64, 115,  100
    MOVE G6D,114,  42, 170, 160,  93,  100
    MOVE G6B,100, 160, 180
    MOVE G6C,100, 160, 180
    WAIT

    SPEED 10
    MOVE G6A, 90, 117,  41, 113, 115,  60
    MOVE G6D,114,  33, 176, 160,  93,  60
    MOVE G6B,100, 160, 180
    MOVE G6C,100, 160, 180
    WAIT


    FOR i = 0 TO 2
        SPEED 7
        MOVE G6A, 90, 117,  41, 113, 115,  100
        MOVE G6D,114,  33, 176, 160,  93,  100
        MOVE G6B,100, 180, 130, , ,  70
        MOVE G6C,100, 180, 130, , ,
        WAIT
        SPEED 15
        MOVE G6A, 90,  63, 165,  47, 115,  100
        MOVE G6D,114,  43, 176, 160,  93,  100
        MOVE G6B,100,  70,  50, , ,
        MOVE G6C,100,  70,  50, , ,
        WAIT
    NEXT i

    FOR i = 0 TO 3
        SPEED 6
        MOVE G6A, 90,  74, 176,  32, 115,  100
        MOVE G6D,114,  39, 176, 160,  93,  100
        MOVE G6B,170, 169, 117, , , 130
        MOVE G6C,170, 169, 117, , ,
        WAIT

        SPEED 15
        HIGHSPEED SETON
        MOVE G6A, 90,  36, 154,  32, 115,  100
        MOVE G6D,114,  39, 176, 160,  93,  100
        MOVE G6B,170,  40,  70, , ,
        MOVE G6C,170,  40,  70, , ,
        WAIT
        DELAY 100
        HIGHSPEED SETOFF
    NEXT i
    '****************

    SPEED 1
    HIGHSPEED SETON
    FOR i = 1 TO 15
        SPEED i
        MOVE G6B,170,  80,  80
        MOVE G6C,170,  80,  80
        WAIT

        MOVE G6B,170,  120,  120
        MOVE G6C,170,  120,  120
        WAIT
    NEXT i
    DELAY 100
    HIGHSPEED SETOFF
    DELAY 500
    '****************
    SPEED 6
    MOVE G6A, 90,  98, 105,  64, 115,  100
    MOVE G6D,114,  39, 170, 160,  93,  100
    MOVE G6B,100, 160, 180
    MOVE G6C,100, 160, 180
    WAIT


    MOVE G6A, 90, 121,  36, 105, 115,  100
    MOVE G6D,114,  60, 146, 138,  93,  100
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 4
    MOVE G6A, 85,  98, 105,  115, 115, 100
    MOVE G6D,115,  74, 145,  98,  93, 100
    WAIT

    SPEED 8
    MOVE G6A, 85,  71, 152,  91, 110, 100
    MOVE G6D,108,  76, 146,  93,  92, 100
    MOVE G6B,100,  70,  80
    MOVE G6C,100,  70,  80
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  80
    MOVE G6C,100,  35,  80
    WAIT

    SPEED 2
    GOSUB standard_pose	
    GOSUB All_motor_Reset
    RETURN
    '******************************************
    '******************************************
fly:

    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6D, 88,  71, 152,  91, 110, 100
    MOVE G6A,112,  76, 146,  93,  92, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT


    SPEED 10
    MOVE G6D, 90,  98, 105,  115, 115, 100
    MOVE G6A,114,  74, 145,  98,  93, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT

    SPEED 6
    MOVE G6D, 90, 121,  36, 105, 115,  100
    MOVE G6A,114,  60, 146, 138,  93,  100
    MOVE G6B,130,  100,  100
    MOVE G6C,130,  100,  100
    WAIT

    SPEED 6
    GOSUB Leg_motor_mode2
    MOVE G6D, 90,  98, 145,  54, 115,  100
    MOVE G6A,114,  45, 170, 160,  93,  100
    MOVE G6B,170, 100, 100
    MOVE G6C,170, 100, 100
    WAIT

    GOSUB Leg_motor_mode4
    '****************
    FOR I = 0 TO 3
        SPEED 6
        MOVE G6D, 90,  98, 145,  54, 115,  100
        MOVE G6A,114,  45, 170, 160,  93,  100
        MOVE G6B,170, 150, 140
        MOVE G6C,170, 50, 70
        WAIT

        SPEED 6
        MOVE G6D, 90,  98, 145,  54, 115,  100
        MOVE G6A,114,  45, 170, 160,  93,  100
        MOVE G6C,170, 150, 140
        MOVE G6B,170, 50, 70
        WAIT

    NEXT I
    DELAY 300

    SPEED 10
    MOVE G6D, 90,  98, 145,  54, 115,  100
    MOVE G6A,114,  45, 170, 160,  93,  100
    MOVE G6B,170, 100, 100
    MOVE G6C,170, 100, 100
    WAIT

    '****************
    SPEED 5
    MOVE G6D, 90,  98, 105,  64, 115,  100
    MOVE G6A,114,  45, 170, 160,  93,  100
    MOVE G6B,170, 100, 100
    MOVE G6C,170, 100, 100
    WAIT
    GOSUB Leg_motor_mode2

    SPEED 5
    MOVE G6D, 90, 121,  36, 105, 115,  100
    MOVE G6A,113,  64, 146, 138,  93,  100
    MOVE G6B,140,  100,  100
    MOVE G6C,140,  100,  100
    WAIT

    SPEED 4
    MOVE G6D, 85,  98, 105,  115, 115, 100
    MOVE G6A,113,  74, 145,  98,  93, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT

    SPEED 8
    MOVE G6D, 85,  71, 152,  91, 110, 100
    MOVE G6A,108,  76, 146,  93,  92, 100
    MOVE G6B,100,  70,  80
    MOVE G6C,100,  70,  80
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  80
    MOVE G6C,100,  35,  80
    WAIT

    SPEED 2
    GOSUB standard_pose	
    GOSUB All_motor_Reset
    RETURN
    '******************************************
    '************************************************
FB_tilt_check:
    '  IF tilt_check_failure = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        A = AD(FB_tilt_AD_port)	'将AD端口的模拟信号赋给A 
        IF A > 250 OR A < 5 THEN RETURN '返回11041行
        IF A > MIN AND A < MAX THEN RETURN '返回11041行
        DELAY tilt_time_check
    NEXT i

    IF A < MIN THEN GOSUB tilt_front '执行4654行
    IF A > MAX THEN GOSUB tilt_back '执行4660行

    GOSUB GOSUB_RX_EXIT '执行291行

    RETURN '返回11041行
    '**************************************************
tilt_front:
    A = AD(FB_tilt_AD_port)  '将AD端口的模拟信号赋给A
    'IF A < MIN THEN GOSUB front_standup
    IF A < MIN THEN  GOSUB back_standup '执行605行
    RETURN '返回4648行

tilt_back:
    A = AD(FB_tilt_AD_port)
    'IF A > MAX THEN GOSUB back_standup
    IF A > MAX THEN GOSUB front_standup '执行661行
    RETURN '返回4650行
    '**************************************************
LR_tilt_check:
    '  IF tilt_check_failure = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        B = AD(LR_tilt_AD_port)	' 
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY tilt_time_check
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB standard_pose	
        RETURN

    ENDIF
    RETURN '返回11042行
    '**************************************************
    '**************************************************
right_ball_kick:
    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6A,113,  75, 145,  100,  95	
    MOVE G6D, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 15
    MOVE G6A,113,  73, 145,  85,  95	
    MOVE G6D, 83,  20, 172,  155, 114
    MOVE G6C,50
    MOVE G6B,150
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB standard_pose	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN


    '******************************************
left_ball_kick:

    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6D,113,  75, 145,  100,  95	
    MOVE G6A, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 15
    MOVE G6D,113,  73, 145,  85,  95	
    MOVE G6A, 83,  20, 172,  155, 114
    MOVE G6B,50
    MOVE G6C,150
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6D,112,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6D,113,  77, 145,  95,  95	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6D,110,  77, 145,  93,  93, 100	
    MOVE G6A, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB standard_pose	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN

    '******************************************
    '**************************************
LED_ON_OFF2:

    OUT 52,1
    DELAY 150

    OUT 52,0
    DELAY 150
    RETURN
    '**************************************
LED_ON_OFF:

    OUT 52,1
    DELAY 150
    OUT 52,0
    DELAY 150

    OUT 52,1
    DELAY 150
    OUT 52,0
    DELAY 150
    RETURN
    '**************************************
    '**************************************
back_dancer2:

    GOSUB All_motor_mode3

    GOSUB LED_ON_OFF2

    ':
    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80, 100, 100, 100
    MOVE G6C,100,  40,  80, 100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90, 100, 100, 100
    MOVE G6C,100,  40,  90, 100, 100, 100
    WAIT


    SPEED 5
    MOVE G6A, 80,  74, 146, 94, 116, 100
    MOVE G6D,108,  81, 137,  98, 98, 100
    MOVE G6B,100,  70,  90, 100, 100, 100
    MOVE G6C,100,  70,  90, 100, 100, 100 	
    WAIT

    SPEED 4
    MOVE G6A,98,  76, 145,  93, 103, 100
    MOVE G6D,98,  76, 145,  93, 103, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT	


    GOSUB LED_ON_OFF2
    '**** ******
    SPEED 3
    MOVE G6A,98,  76, 145,  93, 103, 100
    MOVE G6D,98,  76, 145,  93, 103, 100
    WAIT

    '**********************************
    FOR i = 0 TO 3
        SPEED 4
        MOVE G6A,108,  92, 119,  106, 99
        MOVE G6D,86,  76, 145,  94, 107
        WAIT

        SPEED 4
        MOVE G6A,102,  78, 139,  98, 84
        MOVE G6D,92,  90, 115,  110, 122
        WAIT

        SPEED 4
        MOVE G6D,108,  92, 119,  106, 99
        MOVE G6A,86,  76, 145,  94, 107
        WAIT

        SPEED 4
        MOVE G6D,102,  78, 139,  98, 84
        MOVE G6A,92,  90, 115,  110, 122
        WAIT

    NEXT i

    SPEED 3
    MOVE G6A,108,  92, 119,  106, 99
    MOVE G6D,86,  76, 145,  94, 107
    MOVE G6B,, , , , ,80
    WAIT

    GOSUB Leg_motor_mode1
    SPEED 4
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT



    SPEED 6
    GOSUB standard_pose

    GOSUB All_motor_Reset


    RETURN
    '******************************************
LR_twist_dance:

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6A,88,  76, 145,  93, 110
    MOVE G6D,88,  76, 145,  93, 110
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT

    DELAY 500
    HIGHSPEED SETON

    SPEED 8	
    MOVE G6B,100,  100,  120
    MOVE G6C,100,  50,  90
    WAIT

    SPEED 15
    MOVE G6B,100,  150,  180
    MOVE G6C,100,  60,  100
    WAIT
    DELAY 400

    HIGHSPEED SETOFF
    GOSUB Arm_motor_mode3
    SPEED 6
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    HIGHSPEED SETON
    GOSUB Arm_motor_mode1
    SPEED 8
    MOVE G6C,100,  150,  100
    MOVE G6B,100,  100,  100
    WAIT
    DELAY 300

    SPEED 15
    MOVE G6C,100,  150,  150
    MOVE G6B,100,  50,  100
    WAIT
    DELAY 300
    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode4

    FOR I = 2 TO 5
        TEMP = I * 3
        SPEED TEMP
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B, 170,  70,  50,  ,  ,
        MOVE G6C,  100, 140, 150,  ,  ,
        WAIT

        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C, 170,  70,  50,  ,  ,
        MOVE G6B,  100, 140, 150,  ,  ,
        WAIT
    NEXT I

    HIGHSPEED SETON
    FOR I = 2 TO 4
        TEMP = I * 3
        SPEED TEMP
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B, 170,  70,  50,  ,  ,
        MOVE G6C,  100, 140, 150,  ,  ,
        WAIT

        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C, 170,  70,  50,  ,  ,
        MOVE G6B,  100, 140, 150,  ,  ,
        WAIT
    NEXT I

    HIGHSPEED SETOFF

    DELAY 300
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    GOSUB standard_pose


    RETURN
    '**********************************************
    '******************************************
arirang_dance:

    GOSUB All_motor_Reset

    HIGHSPEED SETON
    SPEED 8
    MOVE G6A,88,  76, 145,  93, 110
    MOVE G6D,88,  76, 145,  93, 110
    MOVE G6B,100,  100, 100
    MOVE G6C,100,  100,  100
    WAIT

    DELAY 300



    HIGHSPEED SETOFF

    GOSUB Arm_motor_mode3
    GOSUB Leg_motor_mode4

    FOR I = 1 TO 8
        SPEED 10
        MOVE G6A,  99,  96, 111, 107,  82,
        MOVE G6D,  72,  89, 120, 103, 142,
        MOVE G6B,100,  170, 150
        MOVE G6C,100,  70,  70
        WAIT

        SPEED 10
        MOVE G6A,  87,  92, 115, 105,  112,
        MOVE G6D,  87,  92, 115, 105, 112,
        MOVE G6B,100,  80, 180
        MOVE G6C,100,  120,  20
        WAIT

        '***************************
        SPEED 10
        MOVE G6D,  99,  96, 111, 107,  82,
        MOVE G6A,  72,  89, 120, 103, 142,
        MOVE G6C,100,  170, 150
        MOVE G6B,100,  70,  70
        WAIT

        SPEED 10
        MOVE G6A,  87,  92, 115, 105,  112,
        MOVE G6D,  87,  92, 115, 105, 112,
        MOVE G6C,100,  80, 180
        MOVE G6B,100,  120,  20
        WAIT
    NEXT I

    SPEED 15
    MOVE G6A,  87,  92, 115, 105,  112,
    MOVE G6D,  87,  92, 115, 105, 112,
    MOVE G6C,100,  80, 90
    MOVE G6B,100,  80,  90
    WAIT

    DELAY 300
    GOSUB Leg_motor_mode1
    SPEED 15
    MOVE G6A,98,  76, 145,  93, 98, 100
    MOVE G6D,98,  76, 145,  93, 98, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    GOSUB standard_pose


    RETURN
    '**********************************************
fly_standup:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6A,100, 140,  37, 140, 100, 100
    MOVE G6D,100, 140,  37, 140, 100, 100
    WAIT

    SPEED 3
    GOSUB sit_pose

    HIGHSPEED SETON
    FOR i = 1 TO 2
        SPEED 6
        MOVE G6B,100,  150,  115
        MOVE G6C,100,  150,  115
        WAIT   	

        SPEED 8
        MOVE G6B,100,  40,  80
        MOVE G6C,100,  40,  80
        WAIT
    NEXT i
    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT

    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 133,  50, 132, 100, 100
    MOVE G6D,100, 133,  50, 132, 100, 100
    WAIT

    SPEED 10
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT


    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 120,  80, 112, 100, 100
    MOVE G6D,100, 120,  80, 112, 100, 100
    WAIT

    SPEED 10
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT

    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 88,  125, 100, 100, 100
    MOVE G6D,100, 88,  125, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6B,100,  150,  115
    MOVE G6C,100,  150,  115
    WAIT

    SPEED 6
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    MOVE G6A,100, 76,  145, 93, 100, 100
    MOVE G6D,100, 76,  145, 93, 100, 100
    WAIT

    FOR i = 1 TO 3
        SPEED 10
        MOVE G6B,100,  150,  115
        MOVE G6C,100,  150,  115
        WAIT

        SPEED 10
        MOVE G6B,100,  40,  80
        MOVE G6C,100,  40,  80
        WAIT
    NEXT i

    HIGHSPEED SETOFF
    SPEED 5
    GOSUB standard_pose
    GOSUB All_motor_Reset       	
    RETURN


    '**********************************************

chanson_dance:

    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80, 100, 100, 100
    MOVE G6C,160,  30,  80, 100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,110,  76, 145,  93, 98, 100
    MOVE G6B,100,  40,  90, , , 55
    MOVE G6C,185,  15,  15	
    WAIT


    SPEED 4
    MOVE G6A, 80,  74, 145, 94, 116, 100
    MOVE G6D,108,  81, 135,  98, 98, 100
    MOVE G6B,100,  40,  90, , , 55
    MOVE G6C,185,  15,  15	
    WAIT

    SPEED 6
    MOVE G6A,98,  76, 145,  93, 103, 100
    MOVE G6D,98,  76, 145,  93, 103, 100
    MOVE G6B,100,  40,  90, , , 100
    MOVE G6C,185,  30,  10	
    WAIT	

    '****  ******
    SPEED 5
    MOVE G6A,98,  79, 145,  83, 103, 100
    MOVE G6D,98,  79, 145,  83, 103, 100
    MOVE G6B,100, 50, 90, , , 100
    MOVE G6C,185,  30,  10	
    WAIT
    '****  ******

    SPEED 4
    FOR I = 0 TO 1

        MOVE G6B,100,  80,  90, , , 80
        MOVE G6C,180,  30,  10	
        WAIT	

        MOVE G6B,100,  60,  90, , , 120
        MOVE G6C,185,  35,  10	
        WAIT	

    NEXT I


    SPEED 4
    MOVE G6A,95, 100, 145,  53, 105, 100
    MOVE G6D,95,  60, 145,  93, 105, 100
    MOVE G6B,100, 40, 90, , , 145
    WAIT

    SPEED 5
    FOR I = 0 TO 1

        MOVE G6B,100,  120,  120, , , 80
        MOVE G6C,180,  30,  10	
        WAIT	

        MOVE G6B,100,  80,  90, , , 120
        MOVE G6C,185,  35,  10	
        WAIT	

    NEXT I

    SPEED 4
    MOVE G6A,98,  79, 145,  83, 103, 100
    MOVE G6D,98,  79, 145,  83, 103, 100
    MOVE G6B,100, 40, 90, , ,100
    WAIT


    SPEED 4
    MOVE G6D,95, 100, 145,  53, 105, 100
    MOVE G6A,95,  60, 145,  93, 105, 100
    MOVE G6B,, , , , , 55
    WAIT


    SPEED 4
    FOR I = 0 TO 1

        MOVE G6B,120, 60, 90, , ,80
        WAIT
        MOVE G6B,80, 40, 90, , , 120
        WAIT

    NEXT I

    SPEED 4
    MOVE G6A,98,  79, 145,  83, 103, 100
    MOVE G6D,98,  79, 145,  83, 103, 100
    MOVE G6B,100, 50, 70, , , 100
    MOVE G6C,185,  40,  10	
    WAIT

    '******************************************

    '*** *****
    SPEED 3
    MOVE G6A,108,  95, 119,  96, 99
    MOVE G6D,86,  82, 145,  83, 107
    MOVE G6B,80, 50, 80, , , 70
    MOVE G6C,185,  20,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,100, 120, 110, , , 60
    MOVE G6C,175,  40,  10	
    WAIT


    SPEED 3
    MOVE G6D,108,  95, 119,  96, 99
    MOVE G6A,86,  82, 145,  83, 107
    MOVE G6B,100, 130, 120, , , 70
    MOVE G6C,185,  40,  10	
    WAIT

    SPEED 4
    MOVE G6D,112,  82, 139,  86, 84
    MOVE G6A,80,  79, 145,  83, 122
    MOVE G6B,120, 50, 70, , , 100
    MOVE G6C,185,  30,  10	
    WAIT


    '*** -1*****
    SPEED 4
    MOVE G6A,108,  78, 119,  136, 99
    MOVE G6D,86,  65, 145,  123, 107
    MOVE G6B,120, 40, 80, , , 110
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,120, 20, 80, , , 120
    MOVE G6C,175,  40,  10	
    WAIT

    SPEED 4
    MOVE G6A,108,  78, 119,  136, 99
    MOVE G6D,86,  65, 145,  123, 107
    MOVE G6B,120, 40, 80, , , 90
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,120, 20, 80, , , 70
    MOVE G6C,190,  20,  10	
    WAIT

    '*** *****
    SPEED 4
    MOVE G6A,108,  95, 119,  96, 99
    MOVE G6D,86,  82, 145,  83, 107
    MOVE G6B,100, 40, 90, , , 80
    MOVE G6C,185,  20,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,100, 80, 95, , , 70
    MOVE G6C,175,  40,  10	
    WAIT

    SPEED 3
    MOVE G6D,108,  95, 119,  96, 99
    MOVE G6A,86,  82, 145,  83, 107
    MOVE G6B,70, 130, 120, , , 110
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6D,108,  86, 139,  76, 90
    MOVE G6A,85,  83, 145,  73, 122
    MOVE G6B,150, 40, 70, , , 120
    MOVE G6C,190,  30,  10	
    WAIT


    SPEED 5
    FOR I = 0 TO 2
        MOVE G6B,150, 40, 70, , , 110
        MOVE G6C,190,  20,  10	
        WAIT
        MOVE G6B,150, 40, 70, , , 90
        MOVE G6C,185,  30,  10	
        WAIT
    NEXT I

    '*** *****
    SPEED 4
    MOVE G6A,108,  78, 119,  136, 99
    MOVE G6D,86,  65, 145,  123, 107
    MOVE G6B,120, 40, 80, , , 110
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,112,  83, 139,  86, 84
    MOVE G6D,80,  80, 145,  83, 122
    MOVE G6B,190, 20, 80, , , 120
    MOVE G6C,175,  40,  10	
    WAIT

    SPEED 4
    MOVE G6D,105,  102, 119,  76, 99
    MOVE G6A,87,  89, 145,  63, 107
    MOVE G6B,80, 150, 120, , , 50
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6D,100,  82, 139,  91, 84
    MOVE G6A,95,  104, 105,  102, 122
    MOVE G6B,150, 100, 90, , , 60
    MOVE G6C,185,  20,  10	
    WAIT

    SPEED 4
    FOR I = 0 TO 2
        MOVE G6B,150, 100, 90, , ,70
        MOVE G6C,190,  20,  10	
        WAIT
        MOVE G6B,190, 100, 90, , ,90
        MOVE G6C,185,  30,  10	
        WAIT
    NEXT I

    '************
    SPEED 3
    MOVE G6D,100,  72, 139,  101, 84
    MOVE G6A,95,  114, 105,  92, 122
    MOVE G6B,150, 100, 90, , , 120
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,100,  72, 139,  101, 84
    MOVE G6D,95,  114, 105,  92, 122
    MOVE G6B,150, 100, 90, , , 60
    MOVE G6C,185,  30,  10	
    WAIT
    '****************
    SPEED 3
    MOVE G6D,100,  72, 139,  101, 84
    MOVE G6A,95,  114, 105,  92, 122
    MOVE G6B,150, 70, 80, , , 90
    MOVE G6C,185,  30,  10	
    WAIT

    SPEED 4
    MOVE G6A,100,  72, 139,  101, 84
    MOVE G6D,95,  114, 105,  92, 122
    MOVE G6B,120, 130, 120, , , 60
    MOVE G6C,185,  30,  10	
    WAIT
    '************
    SPEED 3
    MOVE G6A,98,  87, 145,  63, 103, 100
    MOVE G6D,98,  87, 145,  63, 103, 100
    MOVE G6B,60, 180, 110, , , 100
    MOVE G6C,190,  30,  10	
    WAIT
    GOSUB LED_ON_OFF2
    SPEED 5
    FOR I = 0 TO 3
        MOVE G6B,, , , , , 95
        MOVE G6C,190,  40,  10	
        WAIT
        MOVE G6B,, , , , , 105
        MOVE G6C,190,  30,  10	
        WAIT    	

    NEXT I	

    '*************************

    DELAY 1000

    SPEED 8
    MOVE G6A,98,  87, 145,  63, 103, 100
    MOVE G6D,98,  87, 145,  63, 103, 100
    MOVE G6B,120,  80,  80
    MOVE G6C,120,  80,  80
    WAIT

    GOSUB Leg_motor_mode1
    SPEED 7
    MOVE G6A,102,  76, 145,  93, 98, 100
    MOVE G6D,102,  76, 145,  93, 98, 100
    WAIT

    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    GOSUB bow_3

    RETURN

    '************************************************

bbong_song_dance:

    GOSUB All_motor_mode3


    '****  ******

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6B,130,  60,  90
    MOVE G6C,160,  30,  80
    WAIT

    SPEED 12
    MOVE G6A, 85,  80, 140, 95, 114
    MOVE G6D,110,  76, 145,  93, 98
    MOVE G6B,150,  80,  90
    MOVE G6C,185,  15,  15	
    WAIT


    SPEED 12
    MOVE G6A, 80,  74, 145, 94, 116
    MOVE G6D,108,  81, 135,  98, 98
    MOVE G6B,180,  90, 90
    MOVE G6C,185,  15,  15	
    WAIT

    SPEED 6
    MOVE G6A,100,  96, 105,  113, 110
    MOVE G6D,85,  76, 145,  93, 105
    MOVE G6B,180,  90, 90
    MOVE G6C,185,  15,  15	
    WAIT	

    DELAY 300

    FOR i = 1 TO 2

        SPEED 4
        MOVE G6D,100,  96, 105,  113, 110
        MOVE G6A,85,  76, 145,  93, 105
        MOVE G6B,180,  90, 90
        MOVE G6C,185,  15,  15	
        WAIT	


        SPEED 4
        MOVE G6A,100,  96, 105,  113, 110
        MOVE G6D,85,  76, 145,  93, 105
        MOVE G6B,180,  90, 90
        MOVE G6C,185,  15,  15	
        WAIT

    NEXT i

    ' SPEED 6
    '    FOR i = 1 TO 4
    '        MOVE G6B,180,  90, 90
    '        MOVE G6C,175,  20,  13	
    '        WAIT
    '
    '        MOVE G6B,180,  90, 90
    '        MOVE G6C,188,  20,  18	
    '        WAIT   	
    '    NEXT i
    DELAY 300

    SPEED 8
    MOVE G6D,100,  96, 105,  113, 110
    MOVE G6A,85,  76, 145,  93, 105
    MOVE G6C,180,  90, 90
    MOVE G6B,185,  15,  15	
    WAIT	

    FOR i = 1 TO 2

        SPEED 4
        MOVE G6A,100,  96, 105,  113, 110
        MOVE G6D,85,  76, 145,  93, 105
        MOVE G6C,180,  90, 90
        MOVE G6B,185,  15,  15	
        WAIT

        SPEED 4
        MOVE G6D,100,  96, 105,  113, 110
        MOVE G6A,85,  76, 145,  93, 105
        MOVE G6C,180,  90, 90
        MOVE G6B,185,  15,  15	
        WAIT	

    NEXT i

    DELAY 300

    SPEED 10
    MOVE G6D,95,  80, 130,  110, 105
    MOVE G6A,95,  80, 130,  110, 105
    MOVE G6C,100,  70, 80
    MOVE G6B,100,  70,  80	
    WAIT		

    GOSUB Leg_motor_mode1
    SPEED 7
    MOVE G6A,102,  76, 145,  93, 98, 100
    MOVE G6D,102,  76, 145,  93, 98, 100
    WAIT

    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN
    '************************************************
comeon_action:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6B,100,  40,  80
    MOVE G6C,180,  30,  80
    WAIT


    SPEED 15
    FOR i = 1 TO 3
        MOVE G6B,80,  40,  90
        MOVE G6C,185,  15,  80	
        WAIT

        MOVE G6B,80,  40,  90
        MOVE G6C,185,  15,  20	
        WAIT
    NEXT i

    SPEED 10
    MOVE G6B,80,  40,  90
    MOVE G6C,185,  25,  90	
    WAIT
    DELAY 400

    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN

    '************************************************

    '************************************************
    '************************************************
    '************************************************
    '************************************************

arm_copy:
    GOSUB Arm_motor_mode3
    SPEED 10
    MOVE G6C,100,  70,  100
    WAIT

    MOTOROFF G6C	'     
    SPEED 15

    TEMPO 230
    MUSIC "cde"	

    DELAY 1000

arm_copy_1:

    '
    S12 = MOTORIN(12)
    S13 = MOTORIN(13)
    S14 = MOTORIN(14)

    ' 
    SERVO 6,S12
    SERVO 7,S13
    SERVO 8,S14

    ' 
    ERX 4800,A,arm_copy_1
    IF A = 26 THEN
        TEMPO 230
        MUSIC "cdefgab"

        GOSUB MOTOR_ON
        SPEED 5
        GOSUB standard_pose

        GOTO RX_EXIT
    ENDIF	


    GOTO arm_copy_1
    '******************************************
matrix:
    SPEED 10
    GOSUB standard_pose
    GOSUB All_motor_mode3

    SPEED 8

    MOVE G6A, 100, 163,  75,  15, 100, 100
    MOVE G6D, 100, 163,  75,  15, 100, 100
    MOVE G6B,185, 120, 130, 100, 100, 100
    MOVE G6C,185, 120, 130, 100, 100, 100
    WAIT

    SPEED 2

    MOVE G6A, 100, 168,  70,  10, 100, 100
    MOVE G6D, 100, 168,  70,  10, 100, 100
    MOVE G6B,185, 120, 130
    MOVE G6C,185, 120, 130
    WAIT

    DELAY 1000
    SPEED 10
    FOR I = 1 TO 5

        MOVE G6B,185, 20, 50
        MOVE G6C,185, 20, 50
        WAIT

        MOVE G6B,185, 70, 80
        MOVE G6C,185, 70, 80
        WAIT

    NEXT I

    MOVE G6B,100, 70, 80
    MOVE G6C,100, 70, 80
    WAIT

    SPEED 10
    FOR I = 1 TO 5

        MOVE G6B,100, 90, 90
        MOVE G6C,100, 90, 90
        WAIT

        MOVE G6B,100, 40, 70
        MOVE G6C,100, 40, 70
        WAIT

    NEXT I

    DELAY 500
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A, 100, 145,  70,  80, 100, 100
    MOVE G6D, 100, 145,  70,  80, 100, 100
    MOVE G6B,100, 40, 90, 100, 100, 100
    MOVE G6C,100, 40, 90, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100, 121,  80, 110, 101, 100
    MOVE G6D,100, 121,  80, 110, 101, 100
    MOVE G6B,100,  40,  80, , ,
    MOVE G6C,100,  40,  80, , ,
    WAIT

    SPEED 8
    GOSUB standard_pose
    RETURN
    '******************************************
continuous_dance_1: '48 sec
    GOSUB SOUND_BGM10
    GOSUB cheer
    DELAY 500

    GOSUB right_foot_sit_standup
    DELAY 500

    GOSUB left_foot_sit_standup
    DELAY 500

    GOSUB back_dancer2
    DELAY 500

    GOSUB old_dance
    DELAY 500

    GOSUB bow_3
    GOSUB SOUND_STOP
    RETURN


    '******************************************
continuous_dance_2: '80 sec
    GOSUB SOUND_BGM7
    GOSUB matrix
    DELAY 500

    GOSUB breathing_exercises
    DELAY 500

    GOSUB bbong_song_dance
    DELAY 500

    GOSUB fly_standup
    DELAY 500

    GOSUB flying
    DELAY 500

    GOSUB LR_twist_dance
    DELAY 500

    GOSUB bow_2
    GOSUB SOUND_STOP
    RETURN
    '******************************************
total_dance_1: ' sec
    GOSUB SOUND_robo_link

    GOSUB bow_3	

    GOSUB lose_action_2
    DELAY 200

    GOSUB back_dancer2
    DELAY 200

    GOSUB old_dance
    DELAY 500

    '*********************
    GOSUB breathing_exercises
    DELAY 200

    GOSUB fly
    DELAY 200

    GOSUB bbong_song_dance
    DELAY 200

    GOSUB right_foot_sit_standup
    DELAY 200

    GOSUB arirang_dance
    DELAY 200

    GOSUB fly_standup
    DELAY 200

    GOSUB matrix
    DELAY 200

    GOSUB flying
    DELAY 200

    GOSUB LR_twist_dance
    DELAY 300

    '  GOSUB chanson_dance
    '    DELAY 500

    GOSUB hand_standing
    DELAY 200

    GOSUB bow_2

    GOSUB SOUND_STOP
    RETURN
    '******************************************
total_dance_2: '46 sec
    GOSUB SOUND_BGM2

    GOSUB arirang_dance
    GOSUB chanson_dance
    GOSUB fly
    GOSUB SOUND_STOP
    RETURN
    '******************************************
total_dance_3: '
    GOSUB SOUND_BGM5
    GOSUB chanson_dance
    GOSUB SOUND_STOP

    RETURN
    '******************************************
cup_catch:
    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100, 143,  28, 135, 190, 100
    MOVE G6D,100, 143,  28, 135, 190, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT


    DELAY 1000
    SPEED 8
    MOVE G6A,100, 143,  28, 90, 190, 100
    MOVE G6D,100, 143,  28, 90, 190, 100
    MOVE G6B,180,  30,  80
    MOVE G6C,180,  30,  80
    WAIT

    SPEED 8
    MOVE G6B,170,  20,  40
    MOVE G6C,170,  20,  40
    WAIT
    DELAY 500


    SPEED 8
    MOVE G6A,100, 143,  28, 135, 190, 100
    MOVE G6D,100, 143,  28, 135, 190, 100
    MOVE G6B,190,  20,  40
    MOVE G6C,190,  20,  40
    WAIT

    SPEED 6
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    WAIT


    RETURN

    '************************************************
thing_catch:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  33, 188,  155, 100
    MOVE G6D,100,  33, 188,  155, 100
    MOVE G6B,185,  35,  80
    MOVE G6C,185,  35,  80
    WAIT

    '****   ************
    MOVE G6B,185,  15,  60
    MOVE G6C,185,  15,  60
    WAIT

    SPEED 4
    MOVE G6A,100,  33, 170,  155, 100
    MOVE G6D,100,  33, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  60, 150,  115, 100
    MOVE G6D,100,  60, 150,  115, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB All_motor_Reset
    thing_chach_pose = 1
    RETURN
    '************************************************
    '************************************************
thing_drop:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  35, 170,  155, 100
    MOVE G6D,100,  35, 170,  155, 100
    WAIT

    DELAY 300

    MOVE G6B,185,  40,  80
    MOVE G6C,185,  40,  80
    WAIT

    SPEED 5
    MOVE G6A,100,  65, 150,  105, 100
    MOVE G6D,100,  65, 150,  105, 100
    MOVE G6B,140,  40,  80
    MOVE G6C,140,  40,  80
    WAIT


    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    thing_chach_pose = 0
    RETURN
    '************************************************
    '******************************************
front_LR_punch:
    HIGHSPEED SETON
    SPEED 7
    MOVE G6A, 92, 100, 110, 100, 107
    MOVE G6D, 92, 100, 110, 100, 107
    MOVE G6B,185, 130,  15
    MOVE G6C,185, 130,  15
    WAIT

    SPEED 10
    MOVE G6B,185, 50,  15
    MOVE G6C,185, 50,  15
    WAIT

    SPEED 13
    FOR I = 0 TO 1
        MOVE G6B,185,  10, 80
        MOVE G6C,185, 80,  10
        WAIT
        DELAY 200
        MOVE G6B,185, 80,  10
        MOVE G6C,185,  10, 80
        WAIT
        DELAY 200

    NEXT I

    MOVE G6A, 92, 100, 113, 100, 107
    MOVE G6D, 92, 100, 113, 100, 107
    MOVE G6B,185, 130,  10
    MOVE G6C,185, 130,  10
    WAIT

    HIGHSPEED SETOFF
    SPEED 12
    MOVE G6A, 102, 100, 113, 100, 98
    MOVE G6D, 102, 100, 113, 100, 98
    MOVE G6B,100,  80,  60
    MOVE G6C,100,  80,  60
    WAIT

    GOSUB standard_pose

    GOTO RX_EXIT
    ''**********************************************

    '******************************************
front_lift_attack:
    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,98,  70, 146,  103, 100
    MOVE G6D,98,  70, 146,  103, 100
    MOVE G6B,133, 30,  80
    MOVE G6C,133, 30,  80
    WAIT

    SPEED 10
    MOVE G6B,133, 15,  70
    MOVE G6C,133, 15,  70
    WAIT

    SPEED 13
    MOVE G6A,98,  77, 146,  73, 100
    MOVE G6D,98,  77, 146,  73, 100
    MOVE G6B,185, 15,  70
    MOVE G6C,185, 15,  70
    WAIT

    HIGHSPEED SETOFF
    DELAY 1000

    SPEED 12
    MOVE G6A,98,  70, 146,  103, 100
    MOVE G6D,98,  70, 146,  103, 100
    MOVE G6B,133, 30,  80
    MOVE G6C,133, 30,  80
    WAIT

    SPEED 10
    GOSUB standard_pose

    GOTO RX_EXIT
    ''**********************************************
    '******************************************
back_lift_attack:
    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,98,  79, 146,  83, 100
    MOVE G6D,98,  79, 146,  83, 100
    MOVE G6B,80, 30,  80
    MOVE G6C,80, 30,  80
    WAIT

    SPEED 10
    MOVE G6B,80, 20,  70
    MOVE G6C,80, 20,  70
    WAIT

    SPEED 13
    MOVE G6A,98,  68, 146,  118, 100
    MOVE G6D,98,  68, 146,  118, 100
    MOVE G6B,15, 10,  70
    MOVE G6C,15, 10,  70
    WAIT

    HIGHSPEED SETOFF
    DELAY 1000

    SPEED 12
    MOVE G6A,98,  68, 146,  103, 100
    MOVE G6D,98,  68, 146,  103, 100
    MOVE G6B,80, 30,  80
    MOVE G6C,80, 30,  80
    WAIT

    SPEED 8
    GOSUB standard_pose

    GOTO RX_EXIT
    ''**********************************************
left_front_attack:
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,185,  80,  20
    MOVE G6C,50,  40,  80
    WAIT

    SPEED 10
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,185,  80,  20
    MOVE G6C,50,  40,  80
    WAIT
    GOSUB All_motor_Reset
    SPEED 12
    HIGHSPEED SETON

    MOVE G6A,95,  84, 105, 126,  105,
    MOVE G6D, 86, 110, 136,  69, 114,
    MOVE G6B, 189,  30,  80
    MOVE G6C,  50,  40,  80
    WAIT

    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 12
    MOVE G6A,93,  80, 130, 110,  105,
    MOVE G6D, 93, 80, 130,  110, 105,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT

    SPEED 6
    MOVE G6A,101,  80, 130, 110,  98,
    MOVE G6D, 101, 80, 130,  110, 98,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT

    SPEED 10
    GOSUB standard_pose
    GOTO RX_EXIT
    ''**********************************************
right_front_attack:
    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,108,  76, 146,  93,  92
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6B,50,  40,  80
    MOVE G6C,185,  80,  20
    WAIT

    SPEED 10
    MOVE G6A,112,  76, 146,  93, 98
    MOVE G6D, 85,  80, 140, 95, 114
    MOVE G6B,50,  40,  80
    MOVE G6C,185,  80,  20
    WAIT
    GOSUB All_motor_Reset
    SPEED 12
    HIGHSPEED SETON

    MOVE G6A, 86, 110, 136,  69, 114,
    MOVE G6D,95,  84, 105, 126,  105,
    MOVE G6B,  50,  40,  80
    MOVE G6C, 189,  30,  80
    WAIT

    DELAY 1000
    HIGHSPEED SETOFF
    SPEED 12
    MOVE G6A, 93, 80, 130,  110, 105,
    MOVE G6D,93,  80, 130, 110,  105,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT

    SPEED 6
    MOVE G6A, 101, 80, 130,  110, 98,
    MOVE G6D,101,  80, 130, 110,  98,
    MOVE G6B, 100,  40,  80
    MOVE G6C, 100,  40,  80
    WAIT
    SPEED 10
    GOSUB standard_pose
    GOTO RX_EXIT
    ''**********************************************
left_side_attack:
    HIGHSPEED SETON
    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6D,108,  76, 146,  93,  92
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6C,100,  60,  90, , ,
    MOVE G6B,100,  170,  15, , ,
    WAIT

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6D,110,  76, 146,  93,  92
    MOVE G6A, 88,  85, 130,  100, 110
    MOVE G6C,100,  60,  90, , ,
    MOVE G6B,100,  170,  45, , ,
    WAIT

    SPEED 13
    MOVE G6D, 63, 76,  160, 85, 130	
    MOVE G6A, 88, 125,  70, 120, 115
    MOVE G6C,100,  70,  100
    MOVE G6B,100, 125, 108
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF
    SPEED 15

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 10
    GOSUB standard_pose
    GOTO RX_EXIT
    ''**********************************************
right_side_attack:
    HIGHSPEED SETON
    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,108,  76, 146,  93,  92
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6B,100,  60,  90, , ,
    MOVE G6C,100,  170,  15, , ,
    WAIT

    GOSUB All_motor_Reset

    SPEED 8
    MOVE G6A,110,  76, 146,  93,  92
    MOVE G6D, 88,  85, 130,  100, 110
    MOVE G6B,100,  60,  90, , ,
    MOVE G6C,100,  170,  45, , ,
    WAIT

    SPEED 13
    MOVE G6A, 63, 76,  160, 85, 130	
    MOVE G6D, 88, 125,  70, 120, 115
    MOVE G6B,100,  70,  100
    MOVE G6C,100, 125, 108
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF
    SPEED 15

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 10
    GOSUB standard_pose
    GOTO RX_EXIT
    ''**********************************************
    '**********************************************
left_side_back_attack:

    HIGHSPEED SETON
    SPEED 12
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,15,  40,  80
    MOVE G6C,115,  40,  80
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT

    SPEED 12
    GOSUB standard_pose

    GOTO RX_EXIT

    '**********************************************
right_side_back_attack:


    HIGHSPEED SETON
    SPEED 12
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,115,  40,  80
    MOVE G6C,15,  40,  80
    WAIT


    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 12
    GOSUB standard_pose
    GOTO RX_EXIT


    '************************************************
    '************************************************
scissors:
    GOSUB SOUND_scissors
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,100,  96, 145,  73, 100, 100
    MOVE G6D,100,  56, 145,  113, 100, 100
    MOVE G6B,100,  40,  80
    MOVE G6C,100,  40,  80
    WAIT

    DELAY 1000

    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    RETURN

    '************************************************
rock:
    GOSUB SOUND_rock
    GOSUB Leg_motor_mode2
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  60,  50
    MOVE G6C,100,  60,  50
    WAIT

    DELAY 1000

    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset

    RETURN

    '************************************************
paper:
    GOSUB SOUND_paper
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,91,  76, 145,  93, 108
    MOVE G6D,91,  76, 145,  93, 108
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT

    DELAY 1000

    SPEED 5
    MOVE G6A,101,  76, 145,  93, 98
    MOVE G6D,101,  76, 145,  93, 98
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    RETURN


    '************************************************
cham3game:
    B = RND
    B = B MOD 3

    IF B = 0 THEN
        GOSUB cham3_left
    ELSEIF B = 1 THEN
        GOSUB cham3_right
    ELSEIF B = 2 THEN
        GOSUB cham3_front
    ENDIF
    RETURN
    '***************************************
cham3_left:
    HIGHSPEED SETON
    SPEED 10
    MOVE G6B, , , , , , 150
    WAIT
    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15
    GOSUB standard_pose
    RETURN
    '***************************************
cham3_right:
    HIGHSPEED SETON
    SPEED 10
    MOVE G6B, , , , , , 50
    WAIT
    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15 	
    GOSUB standard_pose
    RETURN
    '***************************************
cham3_front:
    HIGHSPEED SETON
    SPEED 10
    MOVE G6B, , , , , , 110
    WAIT
    MOVE G6B, , , , , , 90
    WAIT	
    MOVE G6B, , , , , , 100
    WAIT	
    DELAY 1000
    HIGHSPEED SETOFF

    SPEED 15 	
    GOSUB standard_pose
    RETURN
    '***************************************

blue_white_pose:
    GOSUB All_motor_mode3
    SPEED 6
    MOVE G6A,100,  76, 145,  88, 100
    MOVE G6D,100,  76, 145,  88, 100
    MOVE G6B,135,  35,  80
    MOVE G6C,135,  35,  80
    WAIT

    RETURN
    '************************************************

blue_left_up:
    GOSUB SOUND_blue_UP
    SPEED 15
    MOVE G6B,165
    WAIT
    MOVE G6B,135
    WAIT
    RETURN
    '************************************************
blue_left_down:
    GOSUB SOUND_blue_DOWN
    SPEED 15
    MOVE G6B,105
    WAIT
    MOVE G6B,135
    WAIT
    RETURN
    '************************************************
white_right_up:
    GOSUB SOUND_white_UP
    SPEED 15
    MOVE G6C,165
    WAIT
    MOVE G6C,135
    WAIT
    RETURN
    '************************************************
white_right_down:
    GOSUB SOUND_white_DOWN
    SPEED 15
    MOVE G6C,105
    WAIT
    MOVE G6C,135
    WAIT

    RETURN
    '************************************************
dice_game:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  30, 188,  155, 100
    MOVE G6D,100,  30, 188,  155, 100
    MOVE G6B,185,  30,  80
    MOVE G6C,185,  30,  80
    WAIT

    MOVE G6B,185,  15,  65
    MOVE G6C,185,  15,  65
    WAIT

    SPEED 4
    MOVE G6A,100,  30, 170,  155, 100
    MOVE G6D,100,  30, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  60, 150,  115, 100
    MOVE G6D,100,  60, 150,  115, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  74, 145,  85, 100
    MOVE G6D,100,  74, 145,  85, 100
    WAIT


    TEMP = RND
    TEMP = TEMP MOD 3

    IF TEMP = 0 THEN

        SPEED 4
        MOVE G6B,135,  13,  50
        MOVE G6C,188,  13,  50
        WAIT

        SPEED 15
        MOVE G6C,188,  60,  50
        MOVE G6B,165,  13,  50
        WAIT

    ELSEIF TEMP = 1 THEN

        SPEED 4
        MOVE G6C,135,  13,  50
        MOVE G6B,188,  13,  50
        WAIT

        SPEED 15
        MOVE G6B,188,  60,  50
        MOVE G6C,165,  13,  50
        WAIT

    ELSE

        SPEED 15
        MOVE G6B,188,  50,  65
        MOVE G6C,188,  50,  65
        WAIT

    ENDIF


    DELAY 1000

    SPEED 10
    MOVE G6B,140,  70,  80
    MOVE G6C,140,  70,  80
    WAIT


    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB All_motor_Reset
    RETURN
    '************************************************
    '************************************************
cup_throw_game:
    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  30, 188,  155, 100
    MOVE G6D,100,  30, 188,  155, 100
    MOVE G6B,185,  30,  80
    MOVE G6C,185,  30,  80
    WAIT

    MOVE G6B,185,  15,  60
    MOVE G6C,185,  15,  60
    WAIT

    SPEED 4
    MOVE G6A,100,  30, 170,  155, 100
    MOVE G6D,100,  30, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  60, 150,  115, 100
    MOVE G6D,100,  60, 150,  115, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  74, 145,  85, 100
    MOVE G6D,100,  74, 145,  85, 100
    WAIT

    DELAY 500

    SPEED 10
    MOVE G6B,188,  50,  65
    MOVE G6C,188,  50,  65
    WAIT

    DELAY 1000

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT

    GOSUB All_motor_Reset
    RETURN
    '************************************************

    '************************************************
    '********************************************
    '********************************************

penalty_left:
    SPEED 10

    '*************
    MOVE G6A,90,  78, 155,  103, 100, 100
    MOVE G6D,90,  66, 140,  83, 100, 100
    WAIT

    DELAY 20	
    SPEED 15
    MOVE G6A,100,  76, 146,  93, 100, 100
    MOVE G6D,100,  76, 146,  93, 100, 100
    WAIT

    DELAY 200	
    '*************
    GOTO RX_EXIT

    '************************************************
    '************************************************

penalty_right:
    SPEED 10

    '*************
    MOVE G6D,90,  78, 155,  103, 100, 100
    MOVE G6A,90,  66, 140,  83, 100, 100
    WAIT

    DELAY 20	
    SPEED 15
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,100,  76, 146,  93, 100, 100
    WAIT

    DELAY 200	
    '*************
    GOTO RX_EXIT
    '************************************************
    '************************************************
stair_left_up_3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 40, 115, 160, 114,
    MOVE G6D,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 70, 100, 160, 100,
    MOVE G6D,80,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 113, 90, 80, 160,95,
    MOVE G6D,70,  95, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,75,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6A, 114, 90, 110, 130,95,
    MOVE G6D,90,  95, 90,  145, 108
    MOVE G6B,140,50
    MOVE G6C,140,30
    WAIT

    SPEED 10
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '****************************************

stair_right_up_3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 40, 115, 160, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 70, 100, 160, 100,
    MOVE G6A,80,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 80, 160,95,
    MOVE G6A,70,  95, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,75,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '********************************************	

    '************************************************
stair_left_down_3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '****************************************
    '************************************************
stair_right_down_3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6D,  80, 30, 155, 150, 114,
    MOVE G6A,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6D,  80, 30, 175, 150, 114,
    MOVE G6A,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 20, 150, 150, 110
    MOVE G6A,110,  155, 35,  120,94
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6D,100, 30, 150, 150, 100
    MOVE G6A,100,  155, 70,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 140,  85,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6D,114, 75, 130, 120, 94
    MOVE G6A,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6D,112, 80, 130, 110, 94
    MOVE G6A,80,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '************************************************
    '************************************************
hurdle_7cm_left_jump:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,114,  73, 155,  90,  94
    MOVE G6B,50,60,50
    MOVE G6C,100,90 ,50
    WAIT

    SPEED 6
    MOVE G6A, 90, 140, 35, 130, 165
    MOVE G6D,118,  73, 155,  90,  94
    MOVE G6B,50,60,50
    MOVE G6C,100,90 ,50
    WAIT


    SPEED 6
    MOVE G6A, 90, 80, 155, 160, 165
    MOVE G6D,118,  68, 155,  90,  94
    WAIT


    SPEED 4
    MOVE G6A, 90, 35, 155, 160, 110
    MOVE G6D,118,  65, 155,  90,  94
    MOVE G6B,50,50,80
    MOVE G6C,50,50 ,80
    WAIT

    SPEED 5
    MOVE G6A,80, 35, 145, 120, 108
    MOVE G6D,113,  105, 130,  55,  94
    WAIT

    SPEED 6
    MOVE G6A, 85, 35, 145, 145, 108
    MOVE G6D,105,  110, 130,  80,  94
    MOVE G6B,50,50,80
    MOVE G6C,50,50 ,80
    WAIT

    GOSUB All_motor_mode3

    SPEED 15
    MOVE G6A, 100, 40, 140, 145, 100
    MOVE G6D,100,  110, 150,  70,  100
    MOVE G6B,170,40,80
    MOVE G6C,170,40 ,80
    WAIT

    SPEED 15
    MOVE G6A, 114, 60, 140, 155, 100
    MOVE G6D,85,  120, 150,  70,  100
    MOVE G6B,190,40,80
    MOVE G6C,190,40 ,80
    WAIT
    '******************************
    SPEED 10
    MOVE G6A, 114, 60, 140, 155, 100
    MOVE G6D,85,  140, 30,  100,  100
    WAIT


    SPEED 10
    MOVE G6A, 116, 56, 140, 155, 100
    MOVE G6D,85, 140, 30,  100,  160
    WAIT

    'MOTORMODE G6D,3,3,3,3,3

    SPEED 10
    MOVE G6A, 116, 73, 145, 95, 100
    MOVE G6D,85, 140, 30,  150,  160
    WAIT

    SPEED 10
    MOVE G6A, 112, 73, 145, 95, 100
    MOVE G6D,85, 70, 140,  100,  110
    WAIT

    SPEED 10
    MOVE G6A, 108, 73, 145, 95, 100
    MOVE G6D,85, 70, 140,  100,  110
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT
    WAIT

    'GOSUB All_motor_mode3
    SPEED 5
    GOSUB standard_pose
    DELAY 500
    GOSUB All_motor_Reset
    RETURN
    '****************************************
    '************************************************
hurdle_7cm_right_jump:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,114,  73, 155,  90,  94
    MOVE G6C,50,60,50
    MOVE G6B,100,90 ,50
    WAIT

    SPEED 6
    MOVE G6D, 90, 140, 35, 130, 165
    MOVE G6A,118,  73, 155,  90,  94
    MOVE G6C,50,60,50
    MOVE G6B,100,90 ,50
    WAIT


    SPEED 6
    MOVE G6D, 90, 80, 155, 160, 165
    MOVE G6A,118,  68, 155,  90,  94
    WAIT


    SPEED 4
    MOVE G6D, 90, 35, 155, 160, 110
    MOVE G6A,118,  65, 155,  90,  94
    MOVE G6B,50,50,80
    MOVE G6C,50,50 ,80
    WAIT

    SPEED 5
    MOVE G6D,80, 35, 145, 120, 108
    MOVE G6A,113,  105, 130,  55,  94
    WAIT

    SPEED 6
    MOVE G6D, 85, 35, 145, 145, 108
    MOVE G6A,105,  110, 130,  80,  94
    MOVE G6B,50,50,80
    MOVE G6C,50,50 ,80
    WAIT

    GOSUB All_motor_mode3
    SPEED 15
    MOVE G6D, 100, 40, 140, 145, 100
    MOVE G6A,100,  110, 150,  70,  100
    MOVE G6B,170,40,80
    MOVE G6C,170,40 ,80
    WAIT



    SPEED 15
    MOVE G6D, 114, 60, 140, 155, 100
    MOVE G6A,85,  120, 150,  70,  100
    MOVE G6B,190,40,80
    MOVE G6C,190,40 ,80
    WAIT
    '******************************
    SPEED 10
    MOVE G6D, 114, 60, 140, 155, 100
    MOVE G6A,85,  140, 30,  100,  100
    WAIT


    SPEED 10
    MOVE G6D, 116, 56, 140, 155, 100
    MOVE G6A,85, 140, 30,  100,  160
    WAIT

    'MOTORMODE G6D,3,3,3,3,3

    SPEED 10
    MOVE G6D, 116, 73, 145, 95, 100
    MOVE G6A,85, 140, 30,  150,  160
    WAIT

    SPEED 10
    MOVE G6A, 112 , 73, 145, 95, 100
    MOVE G6A,85, 70, 140,  100,  110
    WAIT

    SPEED 10
    MOVE G6D, 108, 73, 145, 95, 100
    MOVE G6A,85, 70, 140,  100,  110
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT
    WAIT

    'GOSUB All_motor_mode3
    SPEED 5
    GOSUB standard_pose
    DELAY 500
    GOSUB All_motor_Reset
    RETURN
    '****************************************
    '**********************************************	
limbo_walk:

    GOSUB GOSUB_RX_EXIT
    GOSUB standard_pose
    GOSUB All_motor_mode3
    GOSUB GOSUB_RX_EXIT
    SPEED 8

    MOVE G6A, 100, 163,  75,  15, 100, 100
    MOVE G6D, 100, 163,  75,  15, 100, 100
    MOVE G6B,90, 30, 80, 100, 100, 100
    MOVE G6C,90, 30, 80, 100, 100, 100
    WAIT
    GOSUB GOSUB_RX_EXIT
    SPEED 3
    MOVE G6A, 100, 167,  27,  33, 100, 100
    MOVE G6D, 100, 167,  27,  33, 100, 100
    MOVE G6B,90, 20, 85, 100, 100, 100
    MOVE G6C,90, 20, 85, 100, 100, 100
    WAIT

    SPEED 5	
    MOVE G6A, 110, 167,  27,  33, 100
    MOVE G6D, 90, 167,  27,  33, 100
    WAIT
    GOSUB GOSUB_RX_EXIT

    SPEED 8
    'GOSUB Leg_motor_mode2
limbo_walk_LOOP:


    MOVE G6A, 110, 167,  27,  40, 100
    MOVE G6D, 90, 135,  27,  53, 100
    WAIT

    MOVE G6A, 90, 160,  27,  33, 100
    MOVE G6D, 110, 155,  27,  53, 100
    WAIT

    MOVE G6D, 110, 167,  27,  40, 100
    MOVE G6A, 90, 135,  27,  53, 100
    WAIT

    MOVE G6D, 90, 160,  27,  33, 100
    MOVE G6A, 110, 155,  27,  53, 100
    WAIT

    ERX 4800, A, limbo_walk_LOOP
    'GOTO  limbo_walk_LOOP

    SPEED 8	
    MOVE G6A, 100, 167,  27,  33, 100, 100
    MOVE G6D, 100, 167,  27,  33, 100, 100
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A, 100, 167,  27,  120, 100, 100
    MOVE G6D, 100, 167,  27,  120, 100, 100
    WAIT

    SPEED 6
    MOVE G6A, 100, 140,  40,  140, 100, 100
    MOVE G6D, 100, 140,  40,  140, 100, 100
    WAIT

    SPEED 10
    GOSUB standard_pose

    RETURN
    '**********************************************
    '************************************************
stair_left_up_1cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,114,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,114,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 55, 130, 140, 114,
    MOVE G6D,114,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 75, 100, 155, 100,
    MOVE G6D,95,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 114, 90, 90, 155,100,
    MOVE G6D,95,  100, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6A, 114, 90, 110, 130,95,
    MOVE G6D,90,  95, 90,  145, 108
    MOVE G6B,140,50
    MOVE G6C,140,30
    WAIT

    SPEED 10
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB All_motor_Reset
    RETURN
    '****************************************

stair_right_up_1cm:
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 155, 100,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB All_motor_Reset
    RETURN
    '********************************************	
    '************************************************
stair_left_down_1cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,114,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,114,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,112,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,108, 30, 150, 150, 105
    MOVE G6D,85,  155, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A,116, 70, 130, 150, 94
    MOVE G6D,75,  125, 140,  88,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,116, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT
    GOSUB Leg_motor_mode2	
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '****************************************
    '************************************************
stair_right_down_1cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,114,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6D,  80, 30, 155, 150, 114,
    MOVE G6A,114,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6D,  80, 30, 175, 150, 114,
    MOVE G6A,112,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 20, 150, 150, 105
    MOVE G6A,110,  155, 45,  120,94
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6D,108, 30, 150, 150, 105
    MOVE G6A,85,  155, 80,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,116, 70, 130, 150, 94
    MOVE G6A,75,  125, 140,  88,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    ' GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,116, 70, 130, 150, 94
    MOVE G6A,80,  125, 50,  150,114
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 9
    MOVE G6D,114, 75, 130, 120, 94
    MOVE G6A,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6D,112, 80, 130, 110, 94
    MOVE G6A,80,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN
    '************************************************
left_side_up:

    SPEED 15
    MOVE G6B,,100
    WAIT

    GOSUB standard_pose
    RETURN
    '**********************************************
right_side_up:
    SPEED 15
    MOVE G6C,,100
    WAIT

    GOSUB standard_pose
    RETURN
    '**********************************************
keeper_left:

    HIGHSPEED SETON
    SPEED 7
    MOVE G6D,65, 85,  120, 110, 90, 100
    MOVE G6A,110, 143,  28, 142, 130, 100
    MOVE G6B,185,  100,  80
    MOVE G6C,185,  100,  80
    WAIT

    DELAY 2000
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB sit_pose
    SPEED 8
    GOSUB standard_pose


    RETURN
    '**********************************************
keeper_right:

    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,65, 85,  120, 110, 90, 100
    MOVE G6D,110, 143,  28, 142, 130, 100
    MOVE G6B,185,  100,  80
    MOVE G6C,185,  100,  80
    WAIT

    DELAY 2000
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB sit_pose
    SPEED 8
    GOSUB standard_pose

    RETURN
    '**********************************************
keeper_front:

    HIGHSPEED SETON
    SPEED 7
    MOVE G6A,80, 143,  28, 142, 118, 100
    MOVE G6D,80, 143,  28, 142, 118, 100
    MOVE G6B,100,  60,  80, 100, 100, 100
    MOVE G6C,100,  60,  80, 100, 100, 100
    WAIT

    DELAY 2000
    HIGHSPEED SETOFF
    SPEED 8
    GOSUB standard_pose

    RETURN
    '**********************************************

    '**********************************************

throwing_right:
    GOSUB All_motor_mode3
    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100
    MOVE G6D,100,  76, 145,  95, 100
    MOVE G6B,100,  185,  110
    MOVE G6C,100,  185,  110
    WAIT

    GOSUB GOSUB_RX_EXIT
throwing_right_1:
    ERX 4800, A, throwing_right_1
    '****   ************
    SPEED 4
    MOVE G6B,,  ,  135
    MOVE G6C,,  ,  135
    WAIT

    DELAY 500
    GOSUB GOSUB_RX_EXIT	

throwing_right_2:
    ERX 4800, A, throwing_right_2
    IF A = 26 THEN
        SPEED 10
        GOSUB standard_pose
        GOSUB All_motor_Reset	
        GOTO RX_EXIT
    ELSEIF A = 4 THEN
        GOTO throwing_left_3
    ELSEIF A = 5 THEN
        GOTO throwing_front_3
    ELSEIF A = 6 THEN
        GOTO throwing_right_3
    ENDIF
throwing_right_3:
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    WAIT

    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    WAIT


    SPEED 6
    MOVE G6A,100,  96, 125,  85, 100
    MOVE G6D,100,  96, 125,  85, 100
    MOVE G6B,135,  ,
    MOVE G6C,135,  ,
    WAIT

    GOSUB All_motor_Reset
    HIGHSPEED SETON

    SPEED 12
    MOVE G6A,100,  66, 145,  115, 100
    MOVE G6D,100,  66, 145,  115, 100
    MOVE G6B,75,  , 125
    MOVE G6C,75,  , 125
    WAIT	

    DELAY 800
    HIGHSPEED SETOFF

    GOSUB All_motor_mode3
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN
    RETURN
    '**********************************************
throwing_left:
    GOSUB All_motor_mode3
    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100
    MOVE G6D,100,  76, 145,  95, 100
    MOVE G6B,100,  185,  110
    MOVE G6C,100,  185,  110
    WAIT

    GOSUB GOSUB_RX_EXIT
throwing_left_1:
    ERX 4800, A, throwing_left_1
    '****   ************
    SPEED 4
    MOVE G6B,,  ,  135
    MOVE G6C,,  ,  135
    WAIT

    DELAY 500
    GOSUB GOSUB_RX_EXIT	

throwing_left_2:
    ERX 4800, A, throwing_left_2
    IF A = 26 THEN
        SPEED 10
        GOSUB standard_pose
        GOSUB All_motor_Reset	
        GOTO RX_EXIT
    ELSEIF A = 4 THEN
        GOTO throwing_left_3
    ELSEIF A = 5 THEN
        GOTO throwing_front_3
    ELSEIF A = 6 THEN
        GOTO throwing_right_3
    ENDIF
throwing_left_3:
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6A,100,  76, 145,  93, 100
    WAIT

    SPEED 8
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6A,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 10
    MOVE G6D,93,  46, 145,  123, 105, 100
    MOVE G6A,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6A,100,  76, 145,  93, 100
    WAIT


    SPEED 6
    MOVE G6A,100,  96, 125,  85, 100
    MOVE G6D,100,  96, 125,  85, 100
    MOVE G6B,135,  ,
    MOVE G6C,135,  ,
    WAIT	
    GOSUB All_motor_Reset
    HIGHSPEED SETON

    SPEED 12
    MOVE G6A,100,  66, 145,  115, 100
    MOVE G6D,100,  66, 145,  115, 100
    MOVE G6B,75,  , 125
    MOVE G6C,75,  , 125
    WAIT	

    DELAY 800
    HIGHSPEED SETOFF

    GOSUB All_motor_mode3
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN
    RETURN
    '**********************************************
throwing_front:
    GOSUB All_motor_mode3
    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100
    MOVE G6D,100,  76, 145,  95, 100
    MOVE G6B,100,  185,  110
    MOVE G6C,100,  185,  110
    WAIT

    GOSUB GOSUB_RX_EXIT
throwing_front_1:
    ERX 4800, A, throwing_front_1
    '****   ************
    SPEED 4
    MOVE G6B,,  ,  135
    MOVE G6C,,  ,  135
    WAIT

    DELAY 500
    GOSUB GOSUB_RX_EXIT	

throwing_front_2:
    ERX 4800, A, throwing_front_2
    IF A = 26 THEN
        SPEED 10
        GOSUB standard_pose
        GOSUB All_motor_Reset	
        GOTO RX_EXIT
    ELSEIF A = 4 THEN
        GOTO throwing_left_3
    ELSEIF A = 5 THEN
        GOTO throwing_front_3
    ELSEIF A = 6 THEN
        GOTO throwing_right_3
    ENDIF
throwing_front_3:
    SPEED 5
    MOVE G6A,100,  96, 125,  85, 100
    MOVE G6D,100,  96, 125,  85, 100
    MOVE G6B,135,  ,
    MOVE G6C,135,  ,
    WAIT

    GOSUB All_motor_Reset
    HIGHSPEED SETON

    SPEED 12
    MOVE G6A,100,  66, 145,  115, 100
    MOVE G6D,100,  66, 145,  115, 100
    MOVE G6B,75,  , 125
    MOVE G6C,75,  , 125
    WAIT	

    DELAY 800
    HIGHSPEED SETOFF

    GOSUB All_motor_mode3
    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN
    '**********************************************
right_shoot:
    GOSUB Leg_motor_mode3
    SPEED 4
    ' 
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6C, 100,40
    MOVE G6B, 100,40
    WAIT

    GOSUB Leg_motor_mode1
    HIGHSPEED SETON
    SPEED 8
    ' 
    MOVE G6D, 80, 95, 115, 105, 140
    MOVE G6A,113,  78, 146,  93,  94
    MOVE G6C, 100,60
    MOVE G6B, 100,60
    WAIT

    DELAY 100
    HIGHSPEED SETOFF
    GOSUB Leg_motor_mode3
    SPEED 8
    ' 
    MOVE G6A, 106,  76, 146,  93,  96		
    MOVE G6D,  88,  71, 152,  91, 106
    MOVE G6B, 100,35
    MOVE G6C, 100,35
    WAIT	

    GOSUB Leg_motor_mode3
    SPEED 3
    GOSUB standard_pose
    GOSUB Leg_motor_mode1


    RETURN
    '**********************************************
left_shoot:
    GOSUB Leg_motor_mode3
    SPEED 4
    ' 
    MOVE G6A,  88,  71, 152,  91, 110
    MOVE G6D, 108,  76, 146,  93,  94
    MOVE G6B, 100,40
    MOVE G6C, 100,40
    WAIT

    GOSUB Leg_motor_mode1
    HIGHSPEED SETON

    SPEED 8
    MOVE G6A, 80, 95, 115, 105, 140
    MOVE G6D,113,  78, 146,  93,  94
    MOVE G6B, 100,60
    MOVE G6C, 100,60
    WAIT

    DELAY 100
    HIGHSPEED SETOFF
    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6D, 106,  76, 146,  93,  96		
    MOVE G6A,  88,  71, 152,  91, 106
    MOVE G6B, 100,35
    MOVE G6C, 100,35
    WAIT	

    GOSUB Leg_motor_mode3
    SPEED 3
    GOSUB standard_pose
    GOSUB Leg_motor_mode1

    RETURN

    '**********************************************
back_shoot:
    IF walk_order = 0 THEN
        ' 
        GOSUB Leg_motor_mode2
        SPEED 4

        MOVE G6A,110,  77, 145,  93,  92, 100	
        MOVE G6D, 85,  71, 152,  91, 114, 100
        MOVE G6C,100,  40,  80, , , ,
        MOVE G6B,100,  40,  80, , , ,	
        WAIT

        SPEED 10
        MOVE G6A,114,  78, 147,  85,  95	
        MOVE G6D, 83,  85, 122,  100, 114
        WAIT


        HIGHSPEED SETON

        SPEED 15
        MOVE G6A,114,  75, 147,  110,  95	
        MOVE G6D, 83,  110, 122,  75, 114
        MOVE G6B,80
        MOVE G6C,120
        WAIT


        DELAY 100
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3

        SPEED 10
        MOVE G6A,114,  74, 147,  97,  95
        MOVE G6D, 83,  85, 122,  105, 114
        MOVE G6C,100,  40,  80, , , ,
        MOVE G6B,100,  40,  80, , , ,	
        WAIT	

        SPEED 8
        MOVE G6A,113,  76, 147,  95,  95	
        MOVE G6D, 80,  76, 142,  95, 114
        MOVE G6C,100,  40,  80, , , ,
        MOVE G6B,100,  40,  80, , , ,
        WAIT	

        SPEED 8
        MOVE G6A,110,  77, 147,  93,  93, 100	
        MOVE G6D, 80,  71, 154,  91, 114, 100
        WAIT


        SPEED 3
        GOSUB standard_pose	
        GOSUB Leg_motor_mode1
        walk_order = 1
    ELSE
        ' 
        GOSUB Leg_motor_mode2
        SPEED 4

        MOVE G6D,110,  77, 145,  93,  92, 100	
        MOVE G6A, 85,  71, 152,  91, 114, 100
        MOVE G6B,100,  40,  80, , , ,
        MOVE G6C,100,  40,  80, , , ,	
        WAIT

        SPEED 10
        MOVE G6D,114,  78, 147,  85,  95	
        MOVE G6A, 83,  85, 122,  100, 114
        WAIT


        HIGHSPEED SETON

        SPEED 15
        MOVE G6D,114,  75, 147,  110,  95	
        MOVE G6A, 83,  110, 122,  75, 114
        MOVE G6C,80
        MOVE G6B,120
        WAIT


        DELAY 100
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3

        SPEED 10
        MOVE G6D,114,  74, 147,  97,  95
        MOVE G6A, 83,  85, 122,  105, 114
        MOVE G6B,100,  40,  80, , , ,
        MOVE G6C,100,  40,  80, , , ,	
        WAIT	

        SPEED 8
        MOVE G6D,113,  76, 147,  95,  95	
        MOVE G6A, 80,  76, 142,  95, 114
        MOVE G6B,100,  40,  80, , , ,
        MOVE G6C,100,  40,  80, , , ,
        WAIT	

        SPEED 8
        MOVE G6D,110,  77, 147,  93,  93, 100	
        MOVE G6A, 80,  71, 154,  91, 114, 100
        WAIT


        SPEED 3
        GOSUB standard_pose	
        GOSUB Leg_motor_mode1
        walk_order = 0
    ENDIF




    RETURN

    '************************************************
RND_MOTION:

    GOSUB All_motor_mode3

RND_MOTION_LOOP:
    'FOR J = 1 TO repeat_order
    promote_dir_failure = 0



    SPEED 3
    TEMP = RND
    TEMP = TEMP MOD 80

    S11= 60 + TEMP
    SERVO 11,S11

    '***********
    TEMP = RND
    TEMP = TEMP MOD 30

    SPEED 1

    S6= 90 + TEMP
    TEMP = TEMP MOD 2
    IF TEMP = 0 THEN
        SERVO 6,S6
    ENDIF

    '***********	
    TEMP = RND
    TEMP = TEMP MOD 30

    S12= 90 + TEMP

    TEMP = TEMP MOD 2
    IF TEMP = 0 THEN
        SERVO 12,S12
    ENDIF


    '*********************************	
    FOR I = 1 TO 150
        DELAY 15' 195
        ERX 4800,A ,RND_MOTION_1
        IF A = 26 THEN	' ♂
            GOSUB SOUND_STOP
            OUT 52,0
            SPEED 5
            GOSUB standard_pose
            GOSUB All_motor_Reset
            GOSUB buzzer_sound
            RETURN
        ELSEIF A = 21 THEN ' ♀:  
            SPEED 6
            MOVE G6B,160,  25,  70, , ,100
            MOVE G6C,160,  25,  70
            WAIT
            SPEED 8
            MOVE G6B,160,  25,  80, , ,100
            MOVE G6C,160,  25,  80
            WAIT		
            I = 1
            promote_dir_failure = 1

        ELSEIF A = 15 THEN  ' A:  
            SPEED 6
            MOVE G6B,160,  70,  70, , ,70
            MOVE G6C,160,  25,  70
            WAIT
            SPEED 8
            MOVE G6B,160,  50,  90, , ,55
            MOVE G6C,160,  15,  40
            WAIT
            I = 1
            promote_dir_failure = 1

        ELSEIF A = 30 THEN  ' ⒐:  
            SPEED 6
            MOVE G6C,175,  70,  70
            MOVE G6B,160,  25,  70, , ,140
            WAIT
            SPEED 10
            MOVE G6C,175,  90,  95
            MOVE G6B,175,  15,  20, , ,170
            WAIT
            I = 1
            promote_dir_failure = 1

        ELSEIF A = 28 THEN 	' ⒎:  
            SPEED 6
            MOVE G6B,175,  70,  70, , ,60
            MOVE G6C,160,  25,  70
            WAIT
            SPEED 10
            MOVE G6B,175,  90,  95
            MOVE G6C,175,  15,  20, , ,30
            WAIT
            I = 1
            promote_dir_failure = 1

        ELSEIF A = 20 THEN   ' B:  
            SPEED 6
            MOVE G6C,160,  70,  70
            MOVE G6B,160,  25,  70, , ,130
            WAIT
            SPEED 8
            MOVE G6C,160,  50,  90
            MOVE G6B,160,  15,  40, , ,145
            WAIT
            I = 1
            promote_dir_failure = 1

        ELSEIF A = 1 THEN
            GOSUB SOUND_promote1
        ELSEIF A = 2 THEN
            GOSUB SOUND_promote2
        ELSEIF A = 3 THEN
            GOSUB SOUND_promote3
        ELSEIF A = 4 THEN
            GOSUB SOUND_promote4
        ELSEIF A = 5 THEN
            GOSUB SOUND_promote5
        ELSEIF A = 6 THEN
            GOSUB SOUND_promote6
        ELSEIF A = 7 THEN
            GOSUB SOUND_promote7
        ELSEIF A = 8 THEN
            GOSUB SOUND_promote8
        ELSEIF A = 9 THEN
            GOSUB SOUND_promote9
        ENDIF

        GOSUB GOSUB_RX_EXIT


RND_MOTION_1:
        IF I < 10 THEN
            OUT 52,1
        ELSEIF I > 10 THEN
            OUT 52,0
        ENDIF
    NEXT I
    '***********

    IF promote_dir_failure = 1 THEN
        SPEED 6
        MOVE G6B,130,  40,  80, , ,100
        MOVE G6C,130,  40,  80
        WAIT

        MOVE G6B,100,  30,  80, , ,100
        MOVE G6C,100,  30,  80
        WAIT
    ENDIF


    GOTO RND_MOTION_LOOP
    '***********************************
    SPEED 3
    GOSUB standard_pose
    GOSUB All_motor_Reset
    GOSUB buzzer_sound

    RETURN

    '************************************************

    '**********************************************
people_gym_start:
    GOSUB SOUND_people_dance
    GOSUB people_gym_1	' 
    GOSUB people_gym_2	'  
    GOSUB people_gym_3	' 
    GOSUB people_gym_4	' 
    GOSUB people_gym_5 	' 
    GOSUB people_gym_6	' 
    GOSUB people_gym_7	' 
    GOSUB people_gym_8 	' 

    GOSUB people_gym_9	' 
    GOSUB people_gym_10   ' 
    GOSUB people_gym_11   ' 
    GOSUB people_gym_12	' 



    RETURN
    '**********************************************
    '**********************************************

people_gym_1: ' 
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    FOR i = 1 TO 4'7

        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6C,110,  30,  80
        MOVE G6B,110,  30,  80
        WAIT

        MOVE G6D,100,  85, 125,  105, 100, 100
        MOVE G6A,100,  85, 125,  105, 100, 100
        MOVE G6C,90,  30,  80
        MOVE G6B,90,  30,  80
        WAIT


    NEXT i

    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6C,110,  30,  80
    MOVE G6B,110,  30,  80
    WAIT

    SPEED 4
    FOR i = 1 TO 4

        MOVE G6C,120,  30,  80
        MOVE G6B,80,  30,  80
        WAIT

        MOVE G6C,80,  30,  80
        MOVE G6B,120,  30,  80
        WAIT

    NEXT i

    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    RETURN
    '**********************************************

people_gym_2: ' 
    GOSUB All_motor_mode3

    FOR i = 1 TO 4
        SPEED 7
        MOVE G6D,100,  74, 145,  90, 100, 100
        MOVE G6A,100,  74, 145,  90, 100, 100
        MOVE G6C,180,  30,  80
        MOVE G6B,180,  30,  80
        WAIT
        DELAY 100

        SPEED 11
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  185,  100
        MOVE G6B,100,  185,  100
        WAIT
        DELAY 100

        SPEED 9
        MOVE G6A,100, 60, 178, 76, 100, 100
        MOVE G6D,100, 60, 178, 76, 100, 100
        MOVE G6C,100,  100,  100
        MOVE G6B,100,  100,  100
        WAIT

        DELAY 100
        SPEED 7
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80, 100, 100, 100
        MOVE G6C,100,  30,  80, 100, 100, 100
        WAIT
        DELAY 100


    NEXT i


    SPEED 8
    MOVE G6B,130,  30,  80, 100, 100, 100
    MOVE G6C,130,  30,  80, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6B,130,  15,  60, 100, 100, 100
    MOVE G6C,130,  15,  60, 100, 100, 100
    WAIT

    SPEED 8
    MOVE G6B,130,  15,  60, 100, 100, 100
    MOVE G6C,130,  15,  60, 100, 100, 100
    WAIT

    FOR i = 1 TO 4
        SPEED 8
        MOVE G6A,100,  110, 60,  153, 100, 100
        MOVE G6D,100,  110, 60,  153, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT

        SPEED 5
        MOVE G6A,100,  122, 40,  160, 100, 100
        MOVE G6D,100,  122, 40,  160, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  110, 60,  153, 100, 100
        MOVE G6D,100,  110, 60,  153, 100, 100
        MOVE G6B,150,  15,  60, 100, 100, 100
        MOVE G6C,150,  15,  60, 100, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,100,  122, 40,  160, 100, 100
        MOVE G6D,100,  122, 40,  160, 100, 100
        MOVE G6B,150,  20,  80, 100, 100, 100
        MOVE G6C,150,  20,  80, 100, 100, 100
        WAIT
        DELAY 100

        SPEED 10
        MOVE G6A,100,  33, 170,  155, 100, 100
        MOVE G6D,100,  33, 170,  155, 100, 100
        MOVE G6B,170,  15,  60, 100, 100, 100
        MOVE G6C,170,  15,  60, 100, 100, 100
        WAIT
        DELAY 100

        SPEED 8
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  80, 100, 100, 100
        MOVE G6C,100,  40,  80, 100, 100, 100
        WAIT
        DELAY 100

    NEXT i



    RETURN

    '**********************************************

people_gym_3: ' 

    FOR i = 1 TO 3
        SPEED 9
        MOVE G6A,100, 60, 173, 76, 100, 100
        MOVE G6D,100, 60, 173, 76, 100, 100
        MOVE G6C,185,  30,  80
        MOVE G6B,185,  30,  80
        WAIT
        DELAY 100

        SPEED 8
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  30,  90
        MOVE G6B,100,  30,  90
        WAIT

        DELAY 100

    NEXT i

    FOR i = 1 TO 3
        SPEED 10
        MOVE G6A,100, 63, 173, 76, 100, 100
        MOVE G6D,100, 63, 173, 76, 100, 100
        MOVE G6C,60,  180,  130
        MOVE G6B,60,  180,  130
        WAIT
        DELAY 100

        SPEED 11
        MOVE G6A,100,  76, 145,  90, 100, 100
        MOVE G6D,100,  76, 145,  90, 100, 100
        MOVE G6C,130,  30,  90
        MOVE G6B,130,  30,  90
        WAIT

        DELAY 100

    NEXT i


    RETURN


    '**********************************************

people_gym_4: ' 
    GOSUB All_motor_mode3
    SPEED 9
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  40,  80
    MOVE G6B,70,  40,  80
    WAIT


    SPEED 9
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT

    SPEED 9
    MOVE G6A,94,  68, 125,  155, 105, 100
    MOVE G6D,94,  68, 125,  155, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT


    FOR i = 1 TO 1



        SPEED 9
        MOVE G6A,104,  78, 110,  160, 100, 100
        MOVE G6D,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 50
        WAIT

        SPEED 7
        MOVE G6A,104,  70, 130,  146, 95, 100
        MOVE G6D,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6A,100,  86, 145,  75, 95, 100
        MOVE G6D,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT


        '***************************

        SPEED 9
        MOVE G6D,100,  86, 145,  75, 95, 100
        MOVE G6A,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 150
        WAIT

        SPEED 7
        MOVE G6D,104,  70, 130,  146, 95, 100
        MOVE G6A,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6D,104,  78, 110,  160, 100, 100
        MOVE G6A,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

    NEXT i


    SPEED 9
    MOVE G6A,104,  78, 110,  160, 100, 100
    MOVE G6D,84,  68, 125,  155, 115, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 50
    WAIT

    SPEED 7
    MOVE G6A,100,  86, 145,  75, 95, 100
    MOVE G6D,84,  81, 155,  70, 115, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60
    WAIT

    SPEED 6
    MOVE G6D,94,  85, 145,  75, 105, 100
    MOVE G6A,94,  85, 145,  75, 105, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 100
    WAIT
    DELAY 100

    FOR i = 1 TO 2

        SPEED 9
        MOVE G6A,100,  86, 145,  75, 95, 100
        MOVE G6D,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60,
        MOVE G6B,70,  20,  60,, , 50
        WAIT

        SPEED 8
        MOVE G6A,104,  70, 130,  146, 95, 100
        MOVE G6D,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 8
        MOVE G6A,104,  78, 110,  160, 100, 100
        MOVE G6D,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60,
        WAIT

        SPEED 8
        MOVE G6D,104,  78, 110,  160, 100, 100
        MOVE G6A,84,  68, 125,  155, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60, , , 150
        WAIT

        SPEED 8
        MOVE G6D,104,  70, 130,  146, 95, 100
        MOVE G6A,84,  58, 145,  145, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT

        SPEED 9
        MOVE G6D,100,  86, 145,  75, 95, 100
        MOVE G6A,84,  81, 155,  70, 115, 100
        MOVE G6C,70,  20,  60
        MOVE G6B,70,  20,  60
        WAIT


        '***************************



    NEXT i

    SPEED 8
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  60
    MOVE G6B,70,  20,  60, , , 100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT



    RETURN


    '**********************************************

people_gym_5: ' 
    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  40,  80
    MOVE G6B,70,  40,  80
    WAIT


    SPEED 7
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,70,  20,  50
    MOVE G6B,70,  20,  50
    WAIT

    FOR j = 1 TO 2
        FOR i = 1 TO 2

            SPEED 4
            MOVE G6A, 100,  74, 175,  45, 100, 100
            MOVE G6D, 100,  74, 175,  45, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 4
            MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6D, 100,  80, 145,  85, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

        SPEED 6
        MOVE G6A, 100,  64, 145,  135, 100, 100
        MOVE G6D, 100,  64, 145,  135, 100, 100
        MOVE G6B,  60,  30,  30, 100, 100, 100
        MOVE G6C,  60,  30,  30, 100, 100, 100
        WAIT

        FOR i = 1 TO 2

            SPEED 3
            MOVE G6A, 100,  64, 145,  135, 100, 100
            MOVE G6D, 100,  64, 145,  135, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 3
            MOVE G6A, 100,  74, 125,  145, 100, 100
            MOVE G6D, 100,  74, 125,  145, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

    NEXT j

    SPEED 5
    MOVE G6A, 100,  64, 145,  135, 100, 100
    MOVE G6D, 100,  64, 145,  135, 100, 100
    MOVE G6B,  60,  30,  30, 100, 100, 100
    MOVE G6C,  60,  30,  30, 100, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,100,  40,  80
    WAIT



    RETURN


    '**********************************************

people_gym_6: ' 
    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 2

            SPEED 10
            MOVE G6D,96,  116, 67,  133, 130, 100
            MOVE G6A,85,  86, 125,  103, 85, 100
            MOVE G6C,100,  45,  90,
            MOVE G6B,100,  180,  140,, , 160
            WAIT

            SPEED 11
            MOVE G6D,96,  86, 125,  103, 110, 100
            MOVE G6A,91,  76, 145,  93, 100, 100
            MOVE G6C,100,  35,  80,
            MOVE G6B,100,  35,  80,, , 100
            WAIT
        NEXT i
        '***********************************
        FOR i = 1 TO 2

            SPEED 10
            MOVE G6A,96,  116, 67,  133, 130, 100
            MOVE G6D,85,  86, 125,  103, 85, 100
            MOVE G6B,100,  45,  90,, , 40
            MOVE G6C,100,  180,  140,
            WAIT

            SPEED 11
            MOVE G6A,96,  86, 125,  103, 110, 100
            MOVE G6D,91,  76, 145,  93, 100, 100
            MOVE G6B,100,  35,  80,, , 100
            MOVE G6C,100,  35,  80,
            WAIT
        NEXT i
    NEXT j

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,, , 100
    MOVE G6C,100,  30,  80,
    WAIT


    RETURN
    '**********************************************
people_gym_7: ' 

    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 2
            SPEED 5
            MOVE G6A,100,  33, 178,  155, 100
            MOVE G6D,100,  33, 178,  155, 100
            MOVE G6B,165,  15,  90
            MOVE G6C,165,  15,  90
            WAIT

            SPEED 5
            MOVE G6A,100,  76, 145,  93, 100
            MOVE G6D,100,  76, 145,  93, 100
            MOVE G6B,100,  30,  80
            MOVE G6C,100,  30,  80
            WAIT

        NEXT i


        FOR i = 1 TO 2

            SPEED 4
            MOVE G6A, 100,  74, 175,  45, 100, 100
            MOVE G6D, 100,  74, 175,  45, 100, 100
            MOVE G6B,  60,  30,  30, 100, 100, 100
            MOVE G6C,  60,  30,  30, 100, 100, 100
            WAIT

            SPEED 4
            MOVE G6A, 100,  80, 145,  85, 100, 100
            MOVE G6D, 100,  80, 145,  85, 100, 100
            MOVE G6C,70,  20,  50
            MOVE G6B,70,  20,  50
            WAIT

        NEXT i

        SPEED 10
        MOVE G6C,100,  40,  90
        MOVE G6B,100,  40,  90
        WAIT
    NEXT j


    RETURN
    '**********************************************
people_gym_8: ' 
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************
    SPEED 12
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT



    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************
    SPEED 12
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT


    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6B,185,  11,  20
    MOVE G6C,185,  130,  120
    WAIT

    SPEED 10
    MOVE G6C,185,  11,  20
    MOVE G6B,185,  130,  120
    WAIT


    SPEED 10
    MOVE G6C,185,  30,  80
    MOVE G6B,185,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  70, 145,  96, 100, 100
    MOVE G6D,100,  70, 145,  96, 100, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    DELAY 150
    '*****************


    RETURN

    '**********************************************
people_gym_9: ' 
    GOSUB All_motor_mode3

    FOR i = 1 TO 5
        SPEED 12
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6C,100,  30,  80
        MOVE G6B,100,  30,  80
        WAIT

        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        MOVE G6B,120,  30,  80
        MOVE G6C,120,  30,  80


        SPEED 6
        MOVE G6A,100, 143,  28, 142, 100, 100
        MOVE G6D,100, 143,  28, 142, 100, 100
        WAIT


        DELAY 100

        SPEED 8
        MOVE G6A,100, 137,  37, 140, 100, 100
        MOVE G6D,100, 137,  37, 140, 100, 100
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,189,  70,  80
        MOVE G6C,189,  70,  80
        WAIT

        SPEED 15
        MOVE G6C,189,  40,  15
        MOVE G6B,189,  40,  15
        WAIT

        DELAY 100

        SPEED 15
        MOVE G6C,100,  40,  80
        MOVE G6B,100,  40,  80
        WAIT

    NEXT i

    RETURN

    '**********************************************
    '**********************************************
people_gym_10: ' 
    GOSUB All_motor_mode3

    FOR j = 1 TO 2
        FOR i = 1 TO 3
            SPEED 8
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 8
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6C,80,  30,  80
            MOVE G6B,120,  30,  80
            WAIT

            '*************
            SPEED 8
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 8
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6B,80,  30,  80
            MOVE G6C,120,  30,  80
            WAIT

        NEXT i


        FOR i = 1 TO 3
            SPEED 12
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 12
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6C,80,  30,  80
            MOVE G6B,120,  30,  80
            WAIT

            '*************
            SPEED 12
            MOVE G6A,100,  96, 108,  113, 100, 100
            MOVE G6D,100,  96, 108,  113, 100, 100
            MOVE G6C,100,  30,  80
            MOVE G6B,100,  30,  80
            WAIT

            SPEED 12
            MOVE G6A,100,  76, 145,  93, 100, 100
            MOVE G6D,100,  76, 145,  93, 100, 100
            MOVE G6B,80,  30,  80
            MOVE G6C,120,  30,  80
            WAIT

        NEXT i

    NEXT j


    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    RETURN

    '**********************************************
    '**********************************************
people_gym_11: ' 


    FOR i = 1 TO 4
        SPEED 12
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  100,  100
        MOVE G6C,100,  100,  100
        WAIT


        SPEED 10
        MOVE G6A,100, 140,  37, 140, 100, 100
        MOVE G6D,100, 140,  37, 140, 100, 100
        MOVE G6B,160,  20,  40
        MOVE G6C,160,  20,  40
        WAIT


        SPEED 10
        MOVE G6A,100, 143,  28, 142, 100, 100
        MOVE G6D,100, 143,  28, 142, 100, 100
        MOVE G6B,160,  20,  40
        MOVE G6C,160,  20,  40
        WAIT


        DELAY 100

        SPEED 8
        MOVE G6A,100, 137,  37, 140, 100, 100
        MOVE G6D,100, 137,  37, 140, 100, 100
        WAIT

        SPEED 10
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  100,  100
        MOVE G6C,100,  100,  100
        WAIT

    NEXT i

    RETURN

    '**********************************************
    '**********************************************
people_gym_12: ' 


    SPEED 12
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT


    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************
    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 6
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    '******************
    SPEED 4
    MOVE G6A,100, 60, 178, 76, 100, 100
    MOVE G6D,100, 60, 178, 76, 100, 100
    MOVE G6C,100,  185,  130
    MOVE G6B,100,  185,  130
    WAIT
    '******************

    SPEED 2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT



    RETURN

    '**********************************************
    '**********************************************
    '**********************************************
    '****   ******************************
flyingpose:
    GOSUB All_motor_mode3

    SPEED 12
    MOVE G6A, 88,  71, 152,  91, 110, 100
    MOVE G6D,112,  76, 146,  93,  92, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT


    SPEED 10
    MOVE G6A, 90,  98, 105,  115, 115, 100
    MOVE G6D,114,  74, 145,  98,  93, 100
    MOVE G6B,100,  150,  150
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 6
    MOVE G6A, 90, 121,  36, 105, 115,  100
    MOVE G6D,114,  60, 146, 138,  93,  100
    WAIT

    SPEED 6
    GOSUB Leg_motor_mode2
    MOVE G6A, 90,  98, 135,  44, 115,  100
    MOVE G6D,114,  45, 170, 160,  93,  100
    MOVE G6B,170,  120,  120 , , , 60
    MOVE G6C,170,  120,  120
    WAIT

flyingpose_WAIT:
    ERX 4800,A,flyingpose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO flyingpose_WAIT
    ENDIF

    SPEED 4
    MOVE G6A, 85,  98, 105,  115, 115, 100
    MOVE G6D,115,  74, 145,  98,  93, 100
    MOVE G6B,100,  150,  150, , , 100
    MOVE G6C,100,  150,  150
    WAIT

    SPEED 8
    MOVE G6A, 85,  71, 152,  91, 110, 100
    MOVE G6D,108,  76, 146,  93,  92, 100
    MOVE G6B,100,  70,  80
    MOVE G6C,100,  70,  80
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  80
    MOVE G6C,100,  35,  80
    WAIT

    SPEED 2
    GOSUB standard_pose	
    GOSUB All_motor_Reset



    RETURN
    '**********************************************
fighter_pose:

    SPEED 6
    MOVE G6B, 120,  40,  90
    MOVE G6C, 120,  40,  90
    WAIT

    SPEED 6
    MOVE G6A,  70,  78, 141, 95, 127, 100
    MOVE G6D,  97, 107,  93, 116, 102, 100
    MOVE G6B, 145,  66,  87, , ,  50
    MOVE G6C, 170,  15,  32, , ,
    WAIT

    GOSUB All_motor_mode3
fighter_pose_WAIT:
    ERX 4800,A,fighter_pose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO fighter_pose_WAIT
    ENDIF
    GOSUB All_motor_Reset
    SPEED 6
    MOVE G6B, 120,  40,  90
    MOVE G6C, 120,  40,  90
    WAIT
    SPEED 8
    GOSUB standard_pose

    RETURN
    '**********************************************
side_attack_pose:

    SPEED 8
    MOVE G6A, 63, 76,  160, 85, 130	
    MOVE G6D, 88, 125,  70, 120, 115
    MOVE G6B,100,  70,  100, , ,  150
    MOVE G6C,100, 125, 108
    WAIT

    GOSUB All_motor_mode3
side_attack_pose_WAIT:
    ERX 4800,A,side_attack_pose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO side_attack_pose_WAIT
    ENDIF
    GOSUB All_motor_Reset
    SPEED 8
    GOSUB standard_pose


    RETURN
    '**********************************************
one_foot_up_pose:
    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D,112,  77, 146,  93,  92, '60	
    MOVE G6A, 80,  71, 152,  91, 112,' 60
    MOVE G6C,100,  100,  100, , , ,
    MOVE G6B,100,  100,  100, , , ,	
    WAIT
    SPEED 8
    MOVE G6D,113,  77, 146,  93,  92, 100	
    MOVE G6A,80,  150,  27, 140, 114, 100
    MOVE G6C,100,  100,  100, , ,
    MOVE G6B,100,  100,  100, , , 100
    WAIT
    GOSUB All_motor_mode3
one_foot_up_pose_WAIT:
    ERX 4800,A,one_foot_up_pose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO one_foot_up_pose_WAIT
    ENDIF

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D,112,  77, 146,  93,  92, 100		
    MOVE G6A, 80, 88, 125, 100, 115, 100
    MOVE G6B,100,  100,  100, , , ,
    MOVE G6C,100,  100,  100, , , ,
    WAIT

    SPEED 4
    GOSUB standard_pose
    GOSUB Leg_motor_mode1

    RETURN
    '**********************************************
ball_kick_pose:
    GOSUB Leg_motor_mode3
    SPEED 4

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 10
    MOVE G6A,113,  75, 145,  100,  95	
    MOVE G6D, 83,  85, 122,  105, 114
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A,113,  73, 145,  85,  95	
    MOVE G6D, 83,  20, 172,  155, 114
    MOVE G6C,50
    MOVE G6B,150
    WAIT
ball_kick_pose_WAIT:
    ERX 4800,A,ball_kick_pose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO ball_kick_pose_WAIT
    ENDIF

    SPEED 10
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT	

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB standard_pose	
    GOSUB Leg_motor_mode1



    RETURN
    '**********************************************
vision_pose:
    SPEED 6
    MOVE G6C, 100,  40,  90
    MOVE G6B, 150,  40,  90
    WAIT
    SPEED 10
    MOVE G6C,100,  100,  100,
    MOVE G6B,190,  15,  15, , , 100
    WAIT

    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,96,  106, 89,  123, 130, 100
    MOVE G6D,85,  76, 145,  93, 85, 100
    MOVE G6C,100,  110,  110,
    MOVE G6B,160,  15,  20, , , 160
    WAIT

vision_pose_WAIT:
    ERX 4800,A,vision_pose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO vision_pose_WAIT
    ENDIF

    SPEED 6
    MOVE G6C, 100,  40,  90
    MOVE G6B, 150,  40,  90, , , 100
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 6
    GOSUB standard_pose	
    GOSUB Leg_motor_mode1
    RETURN
    '**********************************************
old_dancepose:
    GOSUB Leg_motor_mode2
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,100,  40,  80, , ,100
    MOVE G6C,100,  40,  80
    WAIT

    SPEED 5
    MOVE G6A, 85,  80, 140, 95, 114, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,100,  40,  90
    MOVE G6C,100,  40,  90
    WAIT


    SPEED 5
    MOVE G6A, 80,  74, 146, 94, 116, 100
    MOVE G6D,108,  81, 137,  98, 98, 100
    MOVE G6B,100,  70,  90
    MOVE G6C,100,  70,  90	
    WAIT

    SPEED 5
    MOVE G6A,94,  76, 145,  93, 106, 100
    MOVE G6D,94,  76, 145,  93, 106, 100
    MOVE G6B,100,  100,  100
    MOVE G6C,100,  100,  100
    WAIT	

    SPEED 4
    MOVE G6C,100,  150,  140
    MOVE G6B,100,  100,  100, , ,70
    MOVE G6D, 95,  94, 145,  45, 107,
    MOVE G6A, 89,  94, 145,  45, 113,
    WAIT


old_dancepose_WAIT:
    ERX 4800,A,old_dancepose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO old_dancepose_WAIT
    ENDIF
    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 95, 100
    MOVE G6D,100,  76, 145,  93, 95, 100
    MOVE G6B,100,  30,  80, , ,100
    MOVE G6C,100,  30,  80
    WAIT
    SPEED 5
    GOSUB standard_pose



    RETURN
    '**********************************************
walkpose:

    GOSUB Leg_motor_mode3
    SPEED 4
    '哭率扁匡扁
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6A, 108,  76, 146,  93,  94
    MOVE G6C, 100,35
    MOVE G6B, 100,35
    WAIT

    SPEED 10'walk_speed
    '坷弗惯甸扁
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  78, 146,  93,  94
    MOVE G6C,70,35
    MOVE G6B,130,30
    WAIT

walkpose_WAIT:
    ERX 4800,A,walkpose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO walkpose_WAIT
    ENDIF

    SPEED 5

    '哭率扁匡扁2
    MOVE G6A, 106,  76, 146,  93,  96		
    MOVE G6D,  88,  71, 152,  91, 106
    MOVE G6B, 100,35
    MOVE G6C, 100,35
    WAIT	


    SPEED 3
    GOSUB standard_pose
    GOSUB All_motor_Reset
    RETURN

    '******************************************
Imsorry_pose:
    GOSUB Arm_motor_mode3
    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  185,  170
    WAIT	
    SPEED 4
    MOVE G6B,100,  30,  80, , ,130
    MOVE G6C,90,  170,  185
    WAIT

Imsorry_pose_WAIT:
    ERX 4800,A,Imsorry_pose_WAIT
    IF A <> 26 THEN
        GOSUB buzzer_sound
        GOTO Imsorry_pose_WAIT
    ENDIF

    SPEED 8
    GOSUB standard_pose
    GOSUB All_motor_Reset

    RETURN

    '**********************************************

    '***************************************
CODE_EVENT_ALL_STOP:
    PRINT "EVENT_ALL_STOP !"
    PRINT "STOP !"
    SPEED 8
    MOVE G6B,, 40, 90, , , 100
    MOVE G6C,, 40, 90
    WAIT
    SPEED 4
    GOSUB standard_pose
    RETURN

    '**********************************************
    '**********************************************
    '**********************************************
RBNV_info_1m9s:
    PRINT "VOLUME 200 !"

    PRINT "OPEN INFO.MRS !"
    IF info_index = 0 THEN	'KOREA
        PRINT "SOUND 0 !"
        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14  15
        PRINT "CODE_EVENT 101 1 65 105 165 215 295 370 446 519 575 589 597 606 645 689 !"

    ELSEIF info_index = 1 THEN	'CHIN
        PRINT "SOUND 1 !"
        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14
        PRINT "CODE_EVENT 101 1 65 105 146 215 310 370 446 519 575 589 597 606 670 !"

    ELSEIF info_index = 2 THEN 'JAPAN
        PRINT "SOUND 2 !"
        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14
        PRINT "CODE_EVENT 101 1 65 120 146 170 232 336 399 442 522 596 656 !"
    ELSEIF info_index = 3 OR info_index = 4 THEN 'English

        '                     1  2  3   4   5   6   7   8   9  10  11  12  13  14
        PRINT "CODE_EVENT 101 1 65 100 123 185 228 268 371 464 584 625 !" '658 !"
        PRINT "TRS !"'"TIMER_SET !"

        IF info_index = 3 THEN
            PRINT "SOUND 3 !"
        ENDIF
        IF info_index = 4 THEN
            PRINT "SOUND 4 !"
        ENDIF
    ENDIF

RBNV_info_1m9s_LOOP:

    ERX 4800,A,RBNV_info_1m9s_LOOP

    IF A >= 100 THEN
        A_OLD  = A
        A = A - 100
        ON A GOTO RBNV_info_1m9s_LOOP,RBNV_info_1m9s_1,RBNV_info_1m9s_2,RBNV_info_1m9s_3,RBNV_info_1m9s_4,RBNV_info_1m9s_5,RBNV_info_1m9s_6,RBNV_info_1m9s_7,RBNV_info_1m9s_8,RBNV_info_1m9s_9,RBNV_info_1m9s_10,RBNV_info_1m9s_11,RBNV_info_1m9s_12,RBNV_info_1m9s_13,RBNV_info_1m9s_14
        GOTO RBNV_info_1m9s_LOOP
    ELSE
        IF A = 26  THEN
            GOSUB CODE_EVENT_ALL_STOP
            GOSUB MR_SOUND_OPEN
            RETURN
        ELSEIF A = 11  THEN
            PRINT "UP 20 !"
        ELSEIF A = 12  THEN
            PRINT "DOWN 20 !"
        ENDIF
    ENDIF
    GOTO RBNV_info_1m9s_LOOP


    '***************************************
RBNV_info_1m9s_1:

    GOSUB bow_4
    GOSUB everyone
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_2:
    GOSUB info_action

    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_3:
    IF info_index = 0 THEN 'KOREA
        repeat_order = 6
    ELSEIF info_index = 1 THEN 'CHIN
        repeat_order = 4
    ELSEIF info_index = 2 THEN  'JAPAN
        repeat_order = 2
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        GOSUB drama

        GOTO RBNV_info_1m9s_LOOP
    ENDIF

    GOSUB info_stand_still
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_4:

    IF info_index = 0 THEN 'KOREA
        repeat_order = 4
    ELSEIF info_index = 1 THEN 'CHIN
        repeat_order = 4
    ELSEIF info_index = 2 THEN  'JAPAN
        repeat_order = 2
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        GOSUB usher
        DELAY 200
        GOSUB dancer
        DELAY 200
        GOSUB mascot_E
        GOTO RBNV_info_1m9s_LOOP

    ENDIF
    GOSUB vibrate_walk_stay
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_5:
    IF info_index = 0 OR info_index = 1 THEN 'KOREA,'CHIN
        GOSUB elec_program_study
    ELSEIF info_index = 2 THEN 'JAPAN
        GOSUB japan_17_motion_dance
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        repeat_order = 2
        'DELAY 200
        GOSUB standstill
        GOSUB vibrate_walk_stay

    ENDIF
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_6:
    IF info_index = 0 THEN 'KOREA
        GOSUB everyone
        GOSUB dance_action
        DELAY 250
        GOSUB olympic_hurdle
    ELSEIF info_index = 1 THEN 'CHIN
        GOSUB olympic_hurdle
        DELAY 250
        GOSUB dance_action
    ELSEIF info_index = 2 THEN  'JAPAN
        GOSUB next_my_main_board
    ELSEIF info_index = 3 OR info_index = 4   THEN  'English
        GOSUB elec_program_study_E

    ENDIF

    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_7:
    IF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB everyone
        GOSUB olympic_hurdle
        DELAY 250
        GOSUB dance_action
        GOTO RBNV_info_1m9s_LOOP
    ENDIF
    GOSUB i_info_my_self
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_8:

    IF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB i_info_my_self_E
        GOSUB children_teach

        GOTO RBNV_info_1m9s_LOOP
        'GOSUB mascot_C
    ENDIF
    GOSUB me_dance

    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_9:
    IF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB i_will_KOREAN_ENG
        GOSUB me_dance

        GOTO RBNV_info_1m9s_LOOP
    ENDIF
    GOSUB i_will_KOREAN_ENG
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_10:
    IF info_index = 0 OR info_index = 1 THEN'KOREA,'CHIN
        GOSUB drama
    ELSEIF info_index = 2 THEN 'JAPAN
        GOSUB drama
        DELAY 300
        GOSUB usher
        DELAY 300
        GOSUB dancer
        DELAY 300
        GOSUB mascot
    ELSEIF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB i_many_object_point
    ENDIF
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_11:
    IF info_index = 0 OR info_index = 1 THEN'KOREA,'CHIN
        GOSUB usher

    ELSEIF info_index = 3 OR info_index = 4 THEN 'English
        GOSUB many_move
        RETURN
    ENDIF
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_12:
    IF info_index = 0 OR info_index = 1 THEN'KOREA,'CHIN
        GOSUB dancer

    ELSEIF info_index = 2 THEN 'JAPAN
        GOSUB many_move
        GOSUB MR_SOUND_OPEN
        RETURN
    ENDIF
    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_13:
    IF info_index = 0 THEN 'KOREA
        GOSUB mascot
    ELSEIF info_index = 1 THEN 'CHIN
        GOSUB mascot_C
    ELSEIF info_index = 2 THEN  'JAPAN

    ENDIF

    GOTO RBNV_info_1m9s_LOOP
    '*********
RBNV_info_1m9s_14:
    IF info_index = 0 THEN 'KOREA
        GOSUB many_move
    ELSEIF info_index = 1 THEN 'CHIN
        GOSUB many_move_C
    ELSEIF info_index = 2 THEN  'JAPAN

    ENDIF

	GOSUB MR_SOUND_OPEN
    RETURN

    GOTO RBNV_info_1m9s_LOOP
    '*********


    '***************************************
bow_4:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  60,  80
    MOVE G6B,160,  35,  80
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    'bow_
    SPEED 8
    MOVE G6A,100,  55, 145,  145, 100, 100
    MOVE G6D,100,  55, 145,  145, 100, 100
    MOVE G6C,100,  80,  80
    MOVE G6B,175,  15,  15
    WAIT

    DELAY 1000
    ' 

    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  40,  80
    MOVE G6B,140,  40,  80
    WAIT

    SPEED 12
    GOSUB standard_pose

    RETURN
    '***************************************
everyone:
    GOSUB All_motor_mode3

    SPEED 6
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,140,  30,  80
    MOVE G6C,140,  30,  80
    WAIT
    DELAY 400

    SPEED 3
    MOVE G6B,160,  90,  90, , ,60
    MOVE G6C,160,  90,  90
    WAIT

    DELAY 600
    SPEED 8
    GOSUB standard_pose
    RETURN


    '***************************************
dance_action:
    GOSUB All_motor_mode3

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  55,  40
    MOVE G6C,100,  55,  40
    WAIT

    SPEED 6
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  60,  40
    MOVE G6C,100,  35,  50
    WAIT

    DELAY 100

    SPEED 8
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,100,  60,  40
    MOVE G6B,100,  35,  50
    WAIT
    RETURN
    '***************************************
info_action:

    GOSUB dance_action

    DELAY 800

    SPEED 8
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  80,  15, , ,150
    MOVE G6C,100,  130,  100
    WAIT

    DELAY 1000

    '***************

    SPEED 12
    GOSUB standard_pose



    RETURN
    '*******************************************
    '******************************************
info_stand_still:
    fall_check = 0
    '    GOSUB Arm_motor_mode3
    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,2,3,3,3,2
    MOTORMODE G6D,2,3,3,3,2

    MOVE G6B,,35
    MOVE G6C,,35
    WAIT
    I = 0
info_stand_still_1:

    SPEED 4
    MOVE G6A,105,  76, 146,  93, 98, 100
    MOVE G6D,90,  73, 151,  90, 108, 100
    WAIT

    SPEED 12
    MOVE G6A,113,  76, 146,  93, 98, 100
    MOVE G6D,85,  100, 95,  120, 112, 100
    MOVE G6B,120 , , , , ,90
    MOVE G6C,80
    WAIT

    'GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6A,109,  76, 146,  93, 97, 100
    MOVE G6D,90,  76, 148,  92, 110, 100
    WAIT

    SPEED 4	
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100	
    WAIT

    I = I + 1
    'ERX 4800,A, standstill_2
    IF I >= repeat_order THEN
        SPEED 5
        GOSUB standard_pose
        RETURN
    ENDIF

info_stand_still_2:
    '***********************************
    SPEED 4
    MOVE G6D,105,  76, 146,  93, 98, 100
    MOVE G6A,90,  73, 151,  90, 108, 100
    WAIT	

    SPEED 12
    MOVE G6D,113,  76, 146,  93, 98, 100
    MOVE G6A,85,  100, 95,  120, 112, 100
    MOVE G6C,120
    MOVE G6B,80 , , , , ,110
    WAIT	

    ' GOSUB FB_tilt_check
    IF fall_check = 1 THEN
        fall_check = 0
        RETURN
    ENDIF

    SPEED 10
    MOVE G6D,109,  76, 146,  93, 97, 100
    MOVE G6A,90,  76, 148,  92, 110, 100
    WAIT	

    SPEED 4		
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100	
    WAIT	
    I = I + 1
    'ERX 4800,A, standstill_1
    IF I >= repeat_order THEN
        SPEED 5
        GOSUB standard_pose
        RETURN
    ENDIF

    GOTO info_stand_still_1


    RETURN
    '**********************************************	
    '************************************************
vibrate_walk_stay:
    MOTORMODE G6A,3,2,2,2,3
    MOTORMODE G6D,3,2,2,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    SPEED 10
    GOSUB vibrate_walk_stay_first_pose

    HIGHSPEED SETON
    SPEED 15
    MOVE G6A,95,  110, 87,  120, 100, 100
    MOVE G6D,103,  110, 87,  120, 100, 100
    MOVE G6B,100,  35,  80, , ,100
    MOVE G6C,100,  35,  80
    WAIT


    SPEED 12
    FOR I = 1 TO repeat_order
        MOVE G6D,103,  110, 89,  120, 98, 100
        MOVE G6A,95,  120, 67,  125, 105, 100
        MOVE G6C,120
        MOVE G6B,80
        WAIT

        MOVE G6D,98,  110, 88,  120, 102, 100
        MOVE G6A,101,  110, 88,  120, 102, 100
        WAIT

        MOVE G6A,103,  110, 89,  120, 98, 100
        MOVE G6D,95,  120, 67,  125, 105, 100
        MOVE G6B,120
        MOVE G6C,80
        WAIT

        MOVE G6A,98,  110, 88,  120, 102, 100
        MOVE G6D,101,  110, 88,  120, 102, 100
        WAIT

    NEXT I


    SPEED 15
    GOSUB vibrate_walk_stay_first_pose
    DELAY 200
    HIGHSPEED SETOFF
    GOSUB Arm_motor_mode3
    SPEED 10
    GOSUB standard_pose
    RETURN
    '************************************************
vibrate_walk_stay_first_pose:
    MOVE G6A,100,  110, 87,  120, 100, 100
    MOVE G6D,100,  110, 87,  120, 100, 100
    MOVE G6B,100,  35,  80, , ,100
    MOVE G6C,100,  35,  80
    WAIT
    RETURN
    '************************************************
elec_program_study:
    GOSUB elec_program_study_1
    DELAY 1200

    GOSUB elec_program_study_2
    DELAY 200


    SPEED 6
    FOR I = 1 TO 2
        MOVE G6A,100,  76, 145,  88, 100, 100
        MOVE G6D,100,  76, 145,  88, 100, 100
        MOVE G6C,190,  20,  80
        MOVE G6B,170,  20,  80, , ,100
        WAIT

        MOVE G6C,170,  20,  80
        MOVE G6B,190,  20,  80
        WAIT
    NEXT I

    GOSUB elec_program_study_3

    RETURN
    '***************************************
elec_program_study_1:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB i_info_my_self_first_pose

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    RETURN
    '***************************************
elec_program_study_2:
    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,70
    WAIT
    DELAY 200

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,160,  85,  90
    MOVE G6B,160,  85,  90, , ,130
    WAIT

    RETURN
    '***************************************
elec_program_study_3:
    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  50,  80, , ,130
    MOVE G6C,80,  170,  180
    WAIT
    DELAY 100

    SPEED 3
    MOVE G6B,100,  50,  80, , ,70
    MOVE G6C,80,  150,  190
    WAIT
    DELAY 100

    SPEED 10
    GOSUB standard_pose

    RETURN
    '***************************************
elec_program_study_E:
    GOSUB elec_program_study_1
    DELAY 300
    GOSUB elec_program_study_2
    GOSUB elec_program_study_3
    RETURN
    '************************************************
japan_17_motion_dance:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB i_info_my_self_first_pose

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 50

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,70
    WAIT
    DELAY 50

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,160,  85,  90
    MOVE G6B,160,  85,  90, , ,130
    WAIT
    DELAY 50


    SPEED 10
    FOR I = 1 TO 2
        MOVE G6A,100,  76, 145,  88, 100, 100
        MOVE G6D,100,  76, 145,  88, 100, 100
        MOVE G6C,190,  20,  80
        MOVE G6B,170,  20,  80, , ,100
        WAIT

        MOVE G6C,170,  20,  80
        MOVE G6B,190,  20,  80
        WAIT
    NEXT I

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  50,  80, , ,130
    MOVE G6C,80,  170,  180
    WAIT
    DELAY 50

    SPEED 8
    MOVE G6B,100,  50,  80, , ,70
    MOVE G6C,80,  150,  190
    WAIT

    SPEED 15
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,100,  55,  40
    MOVE G6C,100,  55,  40
    WAIT

    SPEED 6
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  60,  40
    MOVE G6C,100,  35,  50
    WAIT

    DELAY 50

    SPEED 8
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,100,  60,  40
    MOVE G6B,100,  35,  50
    WAIT
    RETURN

    '***************************************
next_my_main_board:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB i_info_my_self_first_pose

    SPEED 10
    GOSUB i_info_my_self_first_pose2
    DELAY 700

    SPEED 12
    MOVE G6C,40,  150,  190
    MOVE G6B,40,  150,  190, , ,100
    WAIT
    DELAY 400

    SPEED 6
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,40,  170,  120
    MOVE G6B,40,  170,  120, , ,100
    WAIT

    DELAY 400

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 400
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 100
    SPEED 8
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  130,  120, , , 70
    WAIT

    DELAY 400
    SPEED 8
    MOVE G6C,160,  40,  25
    MOVE G6B,160,  40,  25, , ,100
    WAIT
    DELAY 200
    SPEED 4
    GOSUB i_info_my_self_first_pose2
    DELAY 200
    SPEED 6
    GOSUB standard_pose

    RETURN



    '***************************************
    '***************************************
olympic_hurdle:
    GOSUB All_motor_mode3


    SPEED 12
    MOVE G6A,100,  54, 145,  145, 100, 100
    MOVE G6D,100,  54, 145,  145, 100, 100
    MOVE G6B,50,  40,  90, , ,110
    MOVE G6C,190,  40,  90
    WAIT
    DELAY 100

    SPEED 15
    MOVE G6C,50,  40,  90
    MOVE G6B,190,  40,  90, , ,90
    WAIT
    DELAY 100

    SPEED 10
    GOSUB standard_pose
    RETURN

    '***************************************
i_info_my_self:
    GOSUB All_motor_mode3
    SPEED 12
    GOSUB i_info_my_self_first_pose

    SPEED 10
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 700

    SPEED 8
    MOVE G6C,180,  25,  80
    MOVE G6B,180,  25,  80
    WAIT
    DELAY 400

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 400
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 100
    SPEED 10
    GOSUB i_info_my_self_first_pose
    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 50
    SPEED 4
    GOSUB i_info_my_self_first_pose2
    DELAY 100
    SPEED 10
    GOSUB standard_pose

    RETURN
    '***************************************
    '***************************************
i_info_my_self_E:
    GOSUB All_motor_mode3
    SPEED 12
    GOSUB i_info_my_self_first_pose

    SPEED 10
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 300

    SPEED 8
    MOVE G6C,180,  25,  80
    MOVE G6B,180,  25,  80
    WAIT
    DELAY 300

    SPEED 10
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 200
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  160,  190, , , 130
    WAIT
    DELAY 100
    SPEED 10
    GOSUB i_info_my_self_first_pose
    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 50
    SPEED 6
    GOSUB i_info_my_self_first_pose2
    DELAY 100
    SPEED 10
    GOSUB standard_pose

    RETURN
    '***************************************
i_info_my_self_first_pose:
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,160,  30,  80
    MOVE G6B,160,  30,  80
    WAIT
    RETURN

    '***************************************
i_info_my_self_first_pose2:
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,160,  90,  90, , ,60
    MOVE G6C,160,  90,  90
    WAIT
    RETURN

    '***************************************
me_dance:
    GOSUB All_motor_mode3
    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,160,  30,  80
    MOVE G6B,100,  30,  80, , , 120
    WAIT

    SPEED 10
    MOVE G6C,170,  20,  10
    MOVE G6B,100,  30,  80
    WAIT
    DELAY 100
    SPEED 12
    MOVE G6C,130,  30,  80
    WAIT
    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  55,  40
    MOVE G6C,100,  55,  40
    WAIT

    SPEED 10

    SERVO 11,70
    GOSUB me_dance_pose1

    GOSUB me_dance_pose2

    SERVO 11,130
    GOSUB me_dance_pose1

    GOSUB me_dance_pose2


    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,100,  160,  150
    MOVE G6B,100,  160,  150, , , 120
    WAIT

    SPEED 12
    FOR I = 1 TO 2

        SERVO 11,80
        GOSUB me_dance_pose3


    NEXT I

    FOR I = 1 TO 2
        SERVO 11,120
        GOSUB me_dance_pose3

    NEXT I
    DELAY 100
    SPEED 15
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,80,  170,  180
    MOVE G6B,100,  120,  100, , ,150
    WAIT

    DELAY 600

    SPEED 10
    GOSUB standard_pose

    RETURN
    '***************************************
me_dance_pose1:
    MOVE G6A,100,  110, 87,  120, 100, 100
    MOVE G6D,100,  110, 87,  120, 100, 100
    WAIT

    RETURN
    '***************************************
me_dance_pose2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    RETURN
    '***************************************
me_dance_pose3:
    MOVE G6C,100,  130,  130
    MOVE G6B,100,  130,  130
    WAIT

    MOVE G6C,100,  160,  150
    MOVE G6B,100,  160,  150
    WAIT

    RETURN
    '***************************************
i_will_KOREAN_ENG:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB i_info_my_self_first_pose

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 800

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,130
    WAIT
    DELAY 400

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,190,  85,  90
    MOVE G6B,190,  85,  90, , ,70
    WAIT
    DELAY 400

    SPEED 4
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6C,180,  20,  10
    MOVE G6B,190,  25,  25, , ,130
    WAIT

    RETURN

    '***************************************
children_teach:
    GOSUB All_motor_mode3
    SPEED 10
    GOSUB i_info_my_self_first_pose

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  35,  20
    WAIT
    DELAY 300

    SPEED 12
    MOVE G6C,160,  35,  20
    MOVE G6B,160,  85,  90, , ,130
    WAIT
    DELAY 100

    SPEED 10
    MOVE G6A,100,  76, 160,  58, 100, 100
    MOVE G6D,100,  76, 160,  58, 100, 100
    MOVE G6C,190,  85,  90
    MOVE G6B,190,  85,  90, , ,70
    WAIT
    DELAY 100

    SPEED 8
    MOVE G6A,100,  76, 125,  125, 100, 100
    MOVE G6D,100,  76, 125,  125, 100, 100
    MOVE G6C,180,  20,  10
    MOVE G6B,190,  25,  25, , ,130
    WAIT

    RETURN

    '***************************************
drama:
    SPEED 15
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6C,60,  170,  180
    MOVE G6B,100,  60,  100, , ,150
    WAIT

    RETURN

usher:
    HIGHSPEED SETON
    SPEED 8
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,190,  95,  95, , ,70
    MOVE G6C,180,  15,  15
    WAIT
    HIGHSPEED SETOFF
    RETURN
dancer:
    SPEED 15
    MOVE G6A,98, 88, 122, 105, 117
    MOVE G6D,101, 67, 162, 86, 83
    MOVE G6B,100,  85,  20, , ,100
    MOVE G6C,100,  60,  30
    WAIT

    RETURN
    '***************************************
mascot:
    SPEED 15
    GOSUB mascot_1

    DELAY 2000

    SPEED 10
    GOSUB mascot_2
    DELAY 500

    SPEED 4
    GOSUB mascot_3

    MOVE G6B,,  ,  , , ,70
    WAIT

    SPEED 12
    GOSUB standard_pose
    RETURN
    '***************************************
mascot_1:
    MOVE G6D,98, 88, 122, 105, 117
    MOVE G6A,101, 67, 162, 86, 83
    MOVE G6B,70,  160,  190, , ,50
    MOVE G6C,70,  160,  190
    WAIT
    RETURN
    '***************************************
mascot_2:
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,180,  20,  10, , ,70
    MOVE G6C,190,  20,  20
    WAIT
    RETURN
    '***************************************
mascot_3:
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,190,  90,  90, , ,130
    MOVE G6C,190,  90,  90
    WAIT
    RETURN
    '***************************************
mascot_C:
    SPEED 15
    GOSUB mascot_1

    DELAY 1000

    SPEED 10
    GOSUB mascot_2
    DELAY 500

    SPEED 4
    GOSUB mascot_3

    DELAY 500
    MOVE G6B,,  ,  , , ,70
    WAIT
    DELAY 1000
    SPEED 12
    GOSUB standard_pose
    RETURN
    '***************************************
mascot_E:
    SPEED 15
    GOSUB mascot_1

    DELAY 150

    SPEED 10
    GOSUB mascot_2
    DELAY 1500

    SPEED 5
    GOSUB mascot_3

    DELAY 100
    SPEED 8
    MOVE G6B,,  ,  , , ,70
    WAIT
    'DELAY 500
    SPEED 14
    GOSUB standard_pose
    RETURN
    '***************************************
i_many_object_point:

    GOSUB All_motor_mode3
    SPEED 10
    GOSUB i_info_my_self_first_pose

    SPEED 12
    GOSUB i_info_my_self_first_pose2
    DELAY 100

    SPEED 12
    MOVE G6C,40,  150,  190
    MOVE G6B,40,  150,  190, , ,100
    WAIT
    DELAY 100

    SPEED 6
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,40,  170,  120
    MOVE G6B,40,  170,  120, , ,100
    WAIT

    DELAY 100

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6C,80,  160,  190
    MOVE G6B,80,  160,  190, , , 130
    WAIT

    DELAY 100
    SPEED 10
    MOVE G6A,100,  76, 145,  88, 100, 100
    MOVE G6D,100,  76, 145,  88, 100, 100
    MOVE G6C,80,  130,  120
    MOVE G6B,80,  130,  120, , , 70
    WAIT

    DELAY 100
    SPEED 8
    MOVE G6C,160,  40,  25
    MOVE G6B,160,  40,  25, , ,100
    WAIT
    SPEED 10
    GOSUB i_info_my_self_first_pose2


    RETURN

    '***************************************

many_move:					'多个机器人移动

    GOSUB many_move_1		'跳转到子程序

    DELAY 500				'延时：2000系列 500ms*10；3000系列500ms=0.5s

    SPEED 5					'设置伺服电机速度
    GOSUB many_move_2		'跳转到子程序

    DELAY 1000				'延时1s

    GOSUB many_move_3		'跳转到子程序

    RETURN					'从子程序返回
    '***************************************
many_move_1:
    GOSUB All_motor_mode3
    SPEED 12								'电机速度12
    MOVE G6A,100,  76, 145,  93, 100, 100	'操作G6A电机组
    MOVE G6D,100,  76, 145,  93, 100, 100	'操作G6D电机组
    MOVE G6C,140,  30,  80					'操作G6C电机组
    MOVE G6B,140,  30,  80, , ,100			'操作G6B电机组
    WAIT									'等待程序完成

    SPEED 10								'电机速度10
    MOVE G6A,100,  76, 145,  93, 100, 100	'操作G6A电机组
    MOVE G6D,100,  76, 145,  93, 100, 100	'操作G6D电机组
    MOVE G6C,140,  30,  30					'操作G6C电机组
    MOVE G6B,140,  30,  30, , ,130			'操作G6B电机组
    WAIT									'等待程序完成
    RETURN									'从子程序返回
    '***************************************
many_move_2:
    MOVE G6A,100,  55, 145,  145, 100, 100	'操作G6A电机组
    MOVE G6D,100,  55, 145,  145, 100, 100	'操作G6D电机组
    MOVE G6C,150,  30,  25					'操作G6C电机组
    MOVE G6B,150,  30,  25,					'操作G6B电机组
    WAIT									'等待程序完成
    RETURN									'从子程序返回
    '***************************************
many_move_3:
    SPEED 8									'电机速度8
    MOVE G6A,100,  76, 145,  93, 100, 100	'操作G6A电机组
    MOVE G6D,100,  76, 145,  93, 100, 100	'操作G6D电机组
    MOVE G6C,140,  30,  30					'操作G6C电机组
    MOVE G6B,140,  30,  30, , ,100			'操作G6B电机组
    WAIT									'等待程序完成

    SPEED 12								'电机速度12
    MOVE G6A,100,  76, 145,  93, 100, 100	'操作G6A电机组
    MOVE G6D,100,  76, 145,  93, 100, 100	'操作G6D电机组
    MOVE G6C,120,  30,  80					'操作G6C电机组
    MOVE G6B,120,  30,  80, , ,100			'操作G6B电机组
    WAIT									'等待程序完成

    SPEED 6									'电机速度6
    GOSUB standard_pose
    RETURN									'从子程序返回
    '***************************************
    '***************************************
many_move_C:
    GOSUB many_move_1

    SPEED 6					'电机速度6
    GOSUB many_move_2
    DELAY 1000				'延时1s

    GOSUB many_move_3

    RETURN					'从子程序返回



    '***************************************
    '**********************************************
    '**********************************************

motor_ONOFF_LED:
    IF motor_ONOFF = 1  THEN
        OUT 52,1				'输出数字信号到端口52(输出0时，输出0V，输出1时，输出+5V信号。)
        DELAY 200				'延时0.2s
        OUT 52,0				'输出数字信号到端口52(输出0时，输出0V，输出1时，输出+5V信号。)
        DELAY 200				'延时0.2s
    ENDIF
    RETURN						'从子程序返回
    '**********************************************
LOW_Voltage:

    B = AD(6)					'从AD6接收到模拟信号

    IF B < low_volt THEN
        GOSUB warning_sound

    ENDIF

    RETURN						'从子程序返回
    '**********************************************
SWEEP_POS1:
MOVE G6A, 100,  76, 145,  93, 100,  
MOVE G6D, 100,  76, 145,  93, 100,  
MOVE G6B,  99,  16,  87,  ,  ,  
MOVE G6C, 100,  30,  80,  ,  ,  
WAIT
RETURN

SWEEP_POS2:
MOVE G6A, 100,  76, 145,  93, 100,  
MOVE G6D, 100,  76, 145,  93, 100,  
MOVE G6B, 100,  43,  87,  ,  ,  
MOVE G6C, 100,  30,  80,  ,  ,  
WAIT
RETURN

SWEEP:
GOSUB SWEEP_POS2
GOSUB SWEEP_POS1
RETURN

ARM_1:
MOVE G6A, 100,  76, 145,  93, 100,  
MOVE G6D, 100,  76, 145,  93, 100,  
MOVE G6B, 132,  16,  91,  ,  ,  
MOVE G6C, 100,  30,  80,  ,  ,  
WAIT
RETURN

ARM_2:
MOVE G6A, 100,  76, 145,  93, 100,  
MOVE G6D, 100,  76, 145,  93, 100,  
MOVE G6B, 158,  16,  91,  ,  ,  
MOVE G6C, 100,  30,  80,  ,  ,  
WAIT
RETURN

ARM:
FOR i=1 TO 4
	GOSUB ARM_1
	GOSUB ARM_2
NEXT i
GOSUB standard_pose
WAIT
RETURN



F1:
SPPED 4
MOVE G6A, 100,  75, 144,  94, 100,  
MOVE G6D, 100,  75, 143,  93, 100,  
MOVE G6B, 187,  11,  46,  ,  ,  
MOVE G6C, 190,  14,  53,  ,  , 
WAIT
RETURN
 

F2:
MOVE G6A, 101, 145,  28, 144,  95,  
MOVE G6D, 101, 151,  24, 143, 103,  
MOVE G6B, 187,  11,  46,  ,  ,  
MOVE G6C, 190,  14,  53,  ,  ,  
WAIT
RETURN

F3:
MOVE G6A, 101, 156,  28, 144,  ,  
MOVE G6D, 101, 159,  24, 147, 102,  
MOVE G6B, 187,  ,  ,  ,  ,  
MOVE G6C, 152,  15,  53,  ,  ,  
WAIT
RETURN


F:
GOSUB F1
GOSUB F2
GOSUB F3
WAIT
RETURN

  '******************************************	
MAIN:


    ERX 4800,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9
        GOTO MAIN	
    '*******************************************
  
    '*******************************************
KEY1:
 GOSUB front_walk_50 
 GOTO main
 
KEY2:
 GOSUB back_walk_50 
 GOTO main
 
KEY3:
 GOSUB SWEEP 
 GOTO main

KEY4:
 GOSUB left_turn_45
 GOTO main
 
KEY5:
 GOSUB right_turn_45
 GOTO main

KEY6:
 GOSUB left_walk_20
 GOTO main
KEY7:
 GOSUB right_walk_20
 GOTO main
KEY8:
 GOSUB ARM
 GOTO main
KEY9:
 GOSUB F
 GOTO main