
'******** 机器人实验片头 ********

DIM I AS BYTE
DIM J AS BYTE
DIM pose AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM walk_speed AS BYTE
DIM L_R_speed AS BYTE
DIM L_R_speed2 AS BYTE
DIM walk_order AS BYTE
DIM now_volt AS BYTE
DIM mirror_check AS BYTE
DIM motorONOFF AS BYTE
DIM zyroONOFF AS BYTE
DIM tilt_F_B AS INTEGER
DIM tilt_L_R AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM grip_pose AS BYTE
DIM tilt_CNT AS BYTE

DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE

'****Action_mode ******************
CONST entertainment_mode  = 0 	'E
CONST fight_mode    	= 1 	'F
CONST game_mode       	= 2 	'G
CONST hurdle_game_mode 	= 3 	'G

'**** TILT SENSOR CHECK

CONST F_B_tilt_AD_port = 2
CONST L_R_tilt_AD_port = 3
CONST tilt_check_CNT = 10  'ms


CONST min = 95			
CONST max = 160			
CONST COUNT_MAX = 30
CONST low_volt = 106	

PTP SETON 				
PTP ALLON				

DIR G6A,1,0,0,1,0,0		'motor0~5
DIR G6B,1,1,1,1,1,1		'motor6~11
DIR G6C,0,0,0,0,0,0		'motor12~17
DIR G6D,0,1,1,0,1,0		'motor18~23

'***** First Program *********************************
motorONOFF = 0
walk_order = 0
mirror_check = 0
tilt_CNT = 0
Action_mode = 0			
grip_pose = 0

'**** Feedback *****************************

GOSUB MOTOR_ON

SPEED 5
GOSUB power_first_pose
GOSUB stand_pose


GOTO MAIN
'************************************************
'************************************************
mode1:
    TEMPO 200
    MUSIC "O18A>#CE#G#F#D#FB"
    RETURN
footballgame_music:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN


mode3:
    TEMPO 190
    MUSIC "O28#C#D#F#G#A#G#F"
    RETURN

mode4:
    TEMPO 220
    MUSIC "O33C6D3C<6$B3A"
    RETURN


hurdle_game_music:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN

    '************************************************
MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    motorONOFF = 0

    RETURN

    '************************************************
    '************************************************
MOTOR_ON:

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    motorONOFF = 0
    GOSUB start_music			
    RETURN

    '************************************************
    start_music:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
    end_music:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    motorONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB end_music	
    RETURN
    '************************************************
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,0
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN
    '************************************************
     '************************************************
power_first_pose:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    pose = 0
    RETURN
    '************************************************
stabilized_pose:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0

    RETURN
    '******************************************	
    '************************************************
stand_pose:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    pose = 0
    grip_pose = 0
    RETURN
    '******************************************	
standard_pose: 
    MOVE G6A,100,  76, 145,  93, 100, 100 
    MOVE G6D,100,  76, 145,  93, 100, 100 
    MOVE G6B,100,  30,  80, 100, 100, 100 
    MOVE G6C,100,  30,  80, 100, 100, 100 
    WAIT 
 RETURN     
 
  '******************************************	
MAIN:


    ERX 4800,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1',KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,
        GOTO MAIN	
    '*******************************************
  
    '*******************************************

KEY1:
 GOSUB ju_qi_zuo_shou 
 GOTO main         
ju_qi_zuo_shou: 
SPEED 5 
MOVE G6A, 100,  76, 145,  93, 100,  
MOVE G6D, 100,  76, 145,  93, 100,  
MOVE G6B, 100,  90,  80,  ,  ,  
MOVE G6C, 100,  30,  80,  ,  ,  
WAIT 
SPEED 5 
MOVE G6A, 100, 141,  62, 110, 100,  
MOVE G6D, 100, 141,  62, 110, 100,  
MOVE G6B, 100,  30,  80,  ,  ,  
MOVE G6C, 100,  30,  80,  ,  ,  
WAIT

SPEED 5 
MOVE G6A,100,  76, 145,  93, 100, 100 
MOVE G6D,100,  76, 145,  93, 100, 100 
MOVE G6B,100,  30,  80, 100, 100, 100 
MOVE G6C,100,  30,  80, 100, 100, 100 
WAIT 
RETURN 