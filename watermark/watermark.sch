EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74xx:74HCT4051 U?
U 1 1 608AFB59
P 5500 3400
F 0 "U?" V 5596 3944 50  0000 L CNN
F 1 "74HCT4051" V 5505 3944 50  0000 L CNN
F 2 "" H 5500 3000 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/cd74hct4051.pdf" H 5500 3000 50  0001 C CNN
	1    5500 3400
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74HCT4051 U?
U 1 1 608B37CA
P 3250 3400
F 0 "U?" V 3346 3944 50  0000 L CNN
F 1 "74HCT4051" V 3255 3944 50  0000 L CNN
F 2 "" H 3250 3000 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/cd74hct4051.pdf" H 3250 3000 50  0001 C CNN
	1    3250 3400
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Variable R?
U 1 1 608B5481
P 2950 2250
F 0 "R?" H 3078 2296 50  0000 L CNN
F 1 "R" H 3078 2205 50  0000 L CNN
F 2 "" V 2880 2250 50  0001 C CNN
F 3 "~" H 2950 2250 50  0001 C CNN
	1    2950 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:R 10K
U 1 1 608B5D06
P 2950 1600
F 0 "10K" H 3020 1646 50  0000 L CNN
F 1 "R" H 3020 1555 50  0000 L CNN
F 2 "" V 2880 1600 50  0001 C CNN
F 3 "~" H 2950 1600 50  0001 C CNN
	1    2950 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 3000 2950 2750
Wire Wire Line
	2950 2100 2950 2000
Wire Wire Line
	2950 1450 5900 1450
Wire Wire Line
	5900 1450 5900 3000
Wire Wire Line
	5200 3000 5200 2750
Wire Wire Line
	5200 2750 2950 2750
Connection ~ 2950 2750
$Comp
L MCU_Module:Arduino_UNO_R2 A?
U 1 1 608BD114
P 4300 5250
F 0 "A?" H 4300 3969 50  0000 C CNN
F 1 "Arduino_UNO_R2" H 4300 4060 50  0000 C CNN
F 2 "Module:Arduino_UNO_R2" H 4300 5250 50  0001 C CIN
F 3 "https://www.arduino.cc/en/Main/arduinoBoardUno" H 4300 5250 50  0001 C CNN
	1    4300 5250
	-1   0    0    1   
$EndComp
Wire Wire Line
	1850 5250 3800 5250
Wire Wire Line
	2950 2000 2550 2000
Wire Wire Line
	1600 5150 3800 5150
Connection ~ 2950 2000
Wire Wire Line
	2950 2000 2950 1750
$Comp
L Device:C 10nF
U 1 1 608C2E1E
P 2550 2500
F 0 "10nF" H 2665 2546 50  0000 L CNN
F 1 "C" H 2665 2455 50  0000 L CNN
F 2 "" H 2588 2350 50  0001 C CNN
F 3 "~" H 2550 2500 50  0001 C CNN
	1    2550 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 2400 2950 2650
Wire Wire Line
	2950 2650 2550 2650
Connection ~ 2950 2650
Wire Wire Line
	2950 2650 2950 2750
Wire Wire Line
	2550 2350 1850 2350
Wire Wire Line
	1850 2350 1850 5250
$Comp
L Device:C 10nF
U 1 1 608C5621
P 2550 1850
F 0 "10nF" H 2665 1896 50  0000 L CNN
F 1 "C" H 2665 1805 50  0000 L CNN
F 2 "" H 2588 1700 50  0001 C CNN
F 3 "~" H 2550 1850 50  0001 C CNN
	1    2550 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 1700 1600 1700
Wire Wire Line
	1600 1700 1600 5150
Wire Wire Line
	5050 3900 2950 3900
Wire Wire Line
	2950 3900 2950 3700
Wire Wire Line
	4800 4850 5050 4850
Wire Wire Line
	5050 4850 5050 3900
Wire Wire Line
	4800 4750 5200 4750
Wire Wire Line
	5200 4750 5200 3700
$EndSCHEMATC
