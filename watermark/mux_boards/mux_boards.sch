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
L 74xx:74HC4051 U?
U 1 1 6177A1B4
P 3250 3500
F 0 "U?" H 3300 4089 50  0000 C CNN
F 1 "74HC4051" H 3300 4180 50  0000 C CNN
F 2 "" H 3250 3100 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/cd74hc4051.pdf" H 3250 3100 50  0001 C CNN
	1    3250 3500
	-1   0    0    1   
$EndComp
Wire Wire Line
	5350 3000 3900 3000
Wire Wire Line
	3900 3000 3900 3400
Wire Wire Line
	3900 3400 3550 3400
Wire Wire Line
	5350 3100 4000 3100
Wire Wire Line
	4000 3100 4000 3500
Wire Wire Line
	4000 3500 3550 3500
Wire Wire Line
	5350 3200 4100 3200
Wire Wire Line
	4100 3200 4100 3600
Wire Wire Line
	4100 3600 3550 3600
Wire Wire Line
	5350 3300 4200 3300
Wire Wire Line
	4200 3300 4200 3800
Wire Wire Line
	4200 3800 3550 3800
$Comp
L Device:LED L1
U 1 1 6177CB55
P 4500 4850
F 0 "L1" H 4493 4595 50  0000 C CNN
F 1 "LED" H 4493 4686 50  0000 C CNN
F 2 "" H 4500 4850 50  0001 C CNN
F 3 "~" H 4500 4850 50  0001 C CNN
	1    4500 4850
	-1   0    0    1   
$EndComp
$Comp
L MCU_Module:Arduino_UNO_R2 A?
U 1 1 6177B137
P 5800 3250
F 0 "A?" H 5800 4431 50  0000 C CNN
F 1 "Arduino_UNO_R2" H 5800 4340 50  0000 C CNN
F 2 "Module:Arduino_UNO_R2" H 5800 3250 50  0001 C CIN
F 3 "https://www.arduino.cc/en/Main/arduinoBoardUno" H 5800 3250 50  0001 C CNN
	1    5800 3250
	1    0    0    -1  
$EndComp
$Comp
L Device:R_US R
U 1 1 61780AA8
P 3850 4850
F 0 "R" V 3645 4850 50  0000 C CNN
F 1 "220" V 3736 4850 50  0000 C CNN
F 2 "" V 3890 4840 50  0001 C CNN
F 3 "~" H 3850 4850 50  0001 C CNN
	1    3850 4850
	0    1    1    0   
$EndComp
Wire Wire Line
	2850 3800 2850 4850
Wire Wire Line
	2850 4850 3700 4850
Wire Wire Line
	4000 4850 4350 4850
Connection ~ 4350 4850
Wire Wire Line
	4350 4850 4400 4850
$Comp
L Device:LED L2
U 1 1 61788484
P 4550 5300
F 0 "L2" H 4543 5045 50  0000 C CNN
F 1 "LED" H 4543 5136 50  0000 C CNN
F 2 "" H 4550 5300 50  0001 C CNN
F 3 "~" H 4550 5300 50  0001 C CNN
	1    4550 5300
	-1   0    0    1   
$EndComp
$Comp
L Device:LED L3
U 1 1 61788A2E
P 4550 5750
F 0 "L3" H 4543 5495 50  0000 C CNN
F 1 "LED" H 4543 5586 50  0000 C CNN
F 2 "" H 4550 5750 50  0001 C CNN
F 3 "~" H 4550 5750 50  0001 C CNN
	1    4550 5750
	-1   0    0    1   
$EndComp
$Comp
L Device:LED L4
U 1 1 61788EBB
P 4550 6150
F 0 "L4" H 4543 5895 50  0000 C CNN
F 1 "LED" H 4543 5986 50  0000 C CNN
F 2 "" H 4550 6150 50  0001 C CNN
F 3 "~" H 4550 6150 50  0001 C CNN
	1    4550 6150
	-1   0    0    1   
$EndComp
$Comp
L Device:LED L5
U 1 1 617891B7
P 4600 6600
F 0 "L5" H 4593 6345 50  0000 C CNN
F 1 "LED" H 4593 6436 50  0000 C CNN
F 2 "" H 4600 6600 50  0001 C CNN
F 3 "~" H 4600 6600 50  0001 C CNN
	1    4600 6600
	-1   0    0    1   
$EndComp
Wire Wire Line
	2850 3700 2750 3700
Wire Wire Line
	2750 3700 2750 5300
Wire Wire Line
	2750 5300 3700 5300
Wire Wire Line
	2850 3600 2550 3600
Wire Wire Line
	2550 3600 2550 5750
Wire Wire Line
	2550 5750 3750 5750
Wire Wire Line
	2850 3500 2400 3500
Wire Wire Line
	2400 3500 2400 6150
Wire Wire Line
	2400 6150 3750 6150
Wire Wire Line
	2850 3400 2250 3400
Wire Wire Line
	2250 3400 2250 6600
Wire Wire Line
	2250 6600 3750 6600
$Comp
L Device:LED L6
U 1 1 6178EDEA
P 4600 6950
F 0 "L6" H 4593 6695 50  0000 C CNN
F 1 "LED" H 4593 6786 50  0000 C CNN
F 2 "" H 4600 6950 50  0001 C CNN
F 3 "~" H 4600 6950 50  0001 C CNN
	1    4600 6950
	-1   0    0    1   
$EndComp
$Comp
L Device:LED L7
U 1 1 6178F650
P 4650 7300
F 0 "L7" H 4643 7045 50  0000 C CNN
F 1 "LED" H 4643 7136 50  0000 C CNN
F 2 "" H 4650 7300 50  0001 C CNN
F 3 "~" H 4650 7300 50  0001 C CNN
	1    4650 7300
	-1   0    0    1   
$EndComp
Wire Wire Line
	2850 3300 2150 3300
Wire Wire Line
	2150 3300 2150 6950
Wire Wire Line
	2150 6950 3800 6950
Wire Wire Line
	2850 3200 1950 3200
Wire Wire Line
	1950 3200 1950 7300
Wire Wire Line
	1950 7300 3850 7300
$Comp
L Device:LED L?
U 1 1 6179149D
P 4650 7600
F 0 "L?" H 4643 7345 50  0000 C CNN
F 1 "LED" H 4643 7436 50  0000 C CNN
F 2 "" H 4650 7600 50  0001 C CNN
F 3 "~" H 4650 7600 50  0001 C CNN
	1    4650 7600
	-1   0    0    1   
$EndComp
Wire Wire Line
	2850 3100 1800 3100
Wire Wire Line
	1800 3100 1800 7600
$Comp
L Device:R_US R
U 1 1 617958E1
P 3850 5300
F 0 "R" V 3645 5300 50  0000 C CNN
F 1 "220" V 3736 5300 50  0000 C CNN
F 2 "" V 3890 5290 50  0001 C CNN
F 3 "~" H 3850 5300 50  0001 C CNN
	1    3850 5300
	0    1    1    0   
$EndComp
Wire Wire Line
	4000 5300 4400 5300
$Comp
L Device:R_US R
U 1 1 61795FC8
P 3900 5750
F 0 "R" V 3695 5750 50  0000 C CNN
F 1 "220" V 3786 5750 50  0000 C CNN
F 2 "" V 3940 5740 50  0001 C CNN
F 3 "~" H 3900 5750 50  0001 C CNN
	1    3900 5750
	0    1    1    0   
$EndComp
Wire Wire Line
	4050 5750 4400 5750
$Comp
L Device:R_US R
U 1 1 617965B4
P 3900 6150
F 0 "R" V 3695 6150 50  0000 C CNN
F 1 "220" V 3786 6150 50  0000 C CNN
F 2 "" V 3940 6140 50  0001 C CNN
F 3 "~" H 3900 6150 50  0001 C CNN
	1    3900 6150
	0    1    1    0   
$EndComp
Wire Wire Line
	4050 6150 4400 6150
$Comp
L Device:R_US R
U 1 1 61796AE5
P 3900 6600
F 0 "R" V 3695 6600 50  0000 C CNN
F 1 "220" V 3786 6600 50  0000 C CNN
F 2 "" V 3940 6590 50  0001 C CNN
F 3 "~" H 3900 6600 50  0001 C CNN
	1    3900 6600
	0    1    1    0   
$EndComp
Wire Wire Line
	4050 6600 4450 6600
$Comp
L Device:R_US R
U 1 1 61796FDD
P 3950 6950
F 0 "R" V 3745 6950 50  0000 C CNN
F 1 "220" V 3836 6950 50  0000 C CNN
F 2 "" V 3990 6940 50  0001 C CNN
F 3 "~" H 3950 6950 50  0001 C CNN
	1    3950 6950
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 6950 4450 6950
$Comp
L Device:R_US R
U 1 1 617973D8
P 4000 7300
F 0 "R" V 3795 7300 50  0000 C CNN
F 1 "220" V 3886 7300 50  0000 C CNN
F 2 "" V 4040 7290 50  0001 C CNN
F 3 "~" H 4000 7300 50  0001 C CNN
	1    4000 7300
	0    1    1    0   
$EndComp
Wire Wire Line
	4150 7300 4500 7300
$Comp
L Device:R_US R
U 1 1 617979AD
P 4050 7600
F 0 "R" V 3845 7600 50  0000 C CNN
F 1 "220" V 3936 7600 50  0000 C CNN
F 2 "" V 4090 7590 50  0001 C CNN
F 3 "~" H 4050 7600 50  0001 C CNN
	1    4050 7600
	0    1    1    0   
$EndComp
Wire Wire Line
	4650 4850 4800 4850
Wire Wire Line
	4800 4850 4800 5300
Wire Wire Line
	4800 5300 4700 5300
Wire Wire Line
	4800 5300 4800 5750
Wire Wire Line
	4800 5750 4700 5750
Connection ~ 4800 5300
Wire Wire Line
	4800 5750 4800 6150
Wire Wire Line
	4800 6150 4700 6150
Connection ~ 4800 5750
Wire Wire Line
	4800 6150 4800 6600
Wire Wire Line
	4800 6600 4750 6600
Connection ~ 4800 6150
Wire Wire Line
	4800 6600 4800 6950
Wire Wire Line
	4800 6950 4750 6950
Connection ~ 4800 6600
Wire Wire Line
	4800 6950 4800 7300
Connection ~ 4800 6950
Wire Wire Line
	4800 7300 4800 7600
Connection ~ 4800 7300
Wire Wire Line
	4800 4850 4800 2800
Wire Wire Line
	4800 2800 3250 2800
Wire Wire Line
	3250 2800 3250 2900
Connection ~ 4800 4850
Wire Wire Line
	4800 2800 5100 2800
Wire Wire Line
	5100 2800 5100 4350
Wire Wire Line
	5100 4350 5700 4350
Connection ~ 4800 2800
Wire Wire Line
	1800 7600 3900 7600
Wire Wire Line
	4200 7600 4500 7600
$EndSCHEMATC