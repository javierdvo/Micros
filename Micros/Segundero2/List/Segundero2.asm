
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 1.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : long, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cursor=R5
	.DEF _i=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x3,0x3,0x3,0x2,0x2,0xC,0x0,0x8
	.DB  0x0,0x1,0x0,0x6
_0x40:
	.DB  0x0,0xE,0x1D,0x1F,0x1E,0x1F,0x1F,0xE
_0x41:
	.DB  0x0,0xE,0x1D,0x1E,0x1C,0x1E,0x1F,0xE
_0x42:
	.DB  0x0,0xE,0x17,0x1F,0xF,0x1F,0x1F,0xE
_0x43:
	.DB  0x0,0xE,0x17,0xF,0x7,0xF,0x1F,0xE
_0x0:
	.DB  0x4D,0x69,0x63,0x72,0x6F,0x63,0x6F,0x6E
	.DB  0x74,0x72,0x6F,0x6C,0x61,0x64,0x6F,0x72
	.DB  0x65,0x73,0x0,0x41,0x67,0x6F,0x73,0x74
	.DB  0x6F,0x2D,0x44,0x69,0x63,0x69,0x65,0x6D
	.DB  0x62,0x72,0x65,0x0,0x32,0x30,0x31,0x34
	.DB  0x0,0x45,0x78,0x69,0x74,0x6F,0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _car0
	.DW  _0x40*2

	.DW  0x08
	.DW  _car1
	.DW  _0x41*2

	.DW  0x08
	.DW  _car2
	.DW  _0x42*2

	.DW  0x08
	.DW  _car3
	.DW  _0x43*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;    #include <MEGA328P.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;    #include <delay.h>
;    #include "display.h"

	.CSEG
_ConfiguraLCD:
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	CALL __INITLOCB
	ST   -Y,R17
;	TablaInicializacion -> Y+1
;	i -> R17
	IN   R30,0x7
	ORI  R30,LOW(0xF)
	OUT  0x7,R30
	IN   R30,0x4
	ORI  R30,LOW(0x7)
	OUT  0x4,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,12
	BRSH _0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	SUBI R17,-1
	RJMP _0x5
_0x6:
	LDI  R30,LOW(12)
	MOV  R5,R30
	ST   -Y,R5
	RCALL _EscribeComLCD
	LDD  R17,Y+0
	ADIW R28,13
	RET
_PulsoEn:
	SBI  0x5,1
	CBI  0x5,1
	RET
_MandaLineasDatosLCD:
;	dato -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x8)
	BREQ _0xF
	SBI  0x8,3
	RJMP _0x12
_0xF:
	CBI  0x8,3
_0x12:
	LD   R30,Y
	ANDI R30,LOW(0x4)
	BREQ _0x15
	SBI  0x8,2
	RJMP _0x18
_0x15:
	CBI  0x8,2
_0x18:
	LD   R30,Y
	ANDI R30,LOW(0x2)
	BREQ _0x1B
	SBI  0x8,1
	RJMP _0x1E
_0x1B:
	CBI  0x8,1
_0x1E:
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BREQ _0x21
	SBI  0x8,0
	RJMP _0x24
_0x21:
	CBI  0x8,0
_0x24:
	ADIW R28,1
	RET
_EscribeComLCD:
	ST   -Y,R17
;	Comando -> Y+1
;	tempComando -> R17
	CBI  0x5,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _PulsoEn
	LDD  R17,Y+0
	RJMP _0x2060001
_LetraDatoLCD:
	ST   -Y,R17
;	dato -> Y+1
;	tempdato -> R17
	SBI  0x5,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _PulsoEn
	LDD  R17,Y+0
	RJMP _0x2060001
_LetraLCD:
	ST   -Y,R17
;	dato -> Y+1
;	tempdato -> R17
	SBI  0x5,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _PulsoEn
	LDD  R17,Y+0
	RJMP _0x2060001
_StringLCD:
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x2E:
	MOV  R30,R17
	SUBI R17,-1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	RCALL _LetraLCD
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x2E
	LDD  R17,Y+0
	ADIW R28,3
	RET
;	tiempo -> Y+1
;	i -> R17
;	Mensaje -> Y+1
;	i -> R17
_MoverCursor:
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBIW R30,0
	BRNE _0x39
	LDD  R30,Y+1
	SUBI R30,-LOW(128)
	RJMP _0x54
_0x39:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3A
	LDD  R30,Y+1
	SUBI R30,-LOW(192)
	RJMP _0x54
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
	LDD  R30,Y+1
	SUBI R30,-LOW(148)
	RJMP _0x54
_0x3B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x38
	LDD  R30,Y+1
	SUBI R30,-LOW(212)
_0x54:
	ST   -Y,R30
	RCALL _EscribeComLCD
_0x38:
_0x2060001:
	ADIW R28,2
	RET
_CreaCaracter:
	ST   -Y,R17
;	NoCaracter -> Y+3
;	datos -> Y+1
;	i -> R17
	LDD  R30,Y+3
	LSL  R30
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(64)
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDI  R17,LOW(0)
_0x3E:
	CPI  R17,8
	BRSH _0x3F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RCALL _LetraDatoLCD
	SUBI R17,-1
	RJMP _0x3E
_0x3F:
	LDI  R30,LOW(128)
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDD  R17,Y+0
	ADIW R28,4
	RET
;    #include <stdio.h>
;
;
;char car0[8]={0x00,0x0E,0x1D,0x1F,0x1E,0x1F,0x1F,0x0E};

	.DSEG
;char car1[8]={0x00,0x0E,0x1D,0x1E,0x1C,0x1E,0x1F,0x0E};
;
;char car2[8]={0x00,0x0E,0x17,0x1F,0x0F,0x1F,0x1F,0x0E};
;char car3[8]={0x00,0x0E,0x17,0x0F,0x07,0x0F,0x1F,0x0E};
;int i;
;
;
;void delayPacman()
; 0000 0010 {

	.CSEG
_delayPacman:
; 0000 0011     delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0012 }
	RET
;
;void main()
; 0000 0015 {
_main:
; 0000 0016     ConfiguraLCD();
	RCALL _ConfiguraLCD
; 0000 0017     CreaCaracter(0,car0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_car0)
	LDI  R31,HIGH(_car0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 0018     CreaCaracter(1,car1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_car1)
	LDI  R31,HIGH(_car1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 0019     CreaCaracter(2,car2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(_car2)
	LDI  R31,HIGH(_car2)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 001A     CreaCaracter(3,car3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(_car3)
	LDI  R31,HIGH(_car3)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 001B     while(1)
_0x44:
; 0000 001C     {
; 0000 001D         MoverCursor(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 001E         StringLCD("Microcontroladores");
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 001F         MoverCursor(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0020         StringLCD("Agosto-Diciembre");
	__POINTW1FN _0x0,19
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0021         MoverCursor(8,2);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0022         StringLCD("2014");
	__POINTW1FN _0x0,36
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0023         MoverCursor(8,3);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0024         StringLCD("Exito");
	__POINTW1FN _0x0,41
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0025 
; 0000 0026         for(i=0;i<10;i++){
	CLR  R6
	CLR  R7
_0x48:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x49
; 0000 0027             MoverCursor(i*2,0);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0028             LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0029             delayPacman();
	RCALL _delayPacman
; 0000 002A             MoverCursor(i*2,0);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 002B             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 002C             LetraLCD(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 002D             delayPacman();
	RCALL _delayPacman
; 0000 002E             MoverCursor(i*2+1,0);
	MOV  R30,R6
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 002F             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0030 
; 0000 0031 
; 0000 0032 
; 0000 0033 
; 0000 0034 
; 0000 0035         }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x48
_0x49:
; 0000 0036          for(i=9;i>=0;i--){
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R6,R30
_0x4B:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRLT _0x4C
; 0000 0037             MoverCursor(i*2+1,1);
	MOV  R30,R6
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0038             LetraLCD(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0039             delayPacman();
	RCALL _delayPacman
; 0000 003A             MoverCursor(i*2+1,1);
	MOV  R30,R6
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 003B             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 003C             MoverCursor(i*2,1);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 003D             LetraLCD(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 003E             delayPacman();
	RCALL _delayPacman
; 0000 003F             MoverCursor(i*2,1);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0040             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0041 
; 0000 0042 
; 0000 0043 
; 0000 0044 
; 0000 0045 
; 0000 0046         }
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
	RJMP _0x4B
_0x4C:
; 0000 0047         for(i=0;i<10;i++){
	CLR  R6
	CLR  R7
_0x4E:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x4F
; 0000 0048             MoverCursor(i*2,2);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0049             LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 004A             delayPacman();
	RCALL _delayPacman
; 0000 004B             MoverCursor(i*2,2);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 004C             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 004D             LetraLCD(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 004E             delayPacman();
	RCALL _delayPacman
; 0000 004F             MoverCursor(i*2+1,2);
	MOV  R30,R6
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0050             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0051 
; 0000 0052 
; 0000 0053 
; 0000 0054 
; 0000 0055 
; 0000 0056         }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x4E
_0x4F:
; 0000 0057          for(i=9;i>=0;i--){
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R6,R30
_0x51:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRLT _0x52
; 0000 0058             MoverCursor(i*2+1,3);
	MOV  R30,R6
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0059             LetraLCD(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 005A             delayPacman();
	RCALL _delayPacman
; 0000 005B             MoverCursor(i*2+1,3);
	MOV  R30,R6
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 005C             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 005D             MoverCursor(i*2,3);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 005E             LetraLCD(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 005F             delayPacman();
	RCALL _delayPacman
; 0000 0060             MoverCursor(i*2,3);
	MOV  R30,R6
	LSL  R30
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0061             LetraLCD(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0062 
; 0000 0063 
; 0000 0064 
; 0000 0065 
; 0000 0066 
; 0000 0067         }
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
	RJMP _0x51
_0x52:
; 0000 0068 
; 0000 0069     }
	RJMP _0x44
; 0000 006A 
; 0000 006B }
_0x53:
	RJMP _0x53
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_car0:
	.BYTE 0x8
_car1:
	.BYTE 0x8
_car2:
	.BYTE 0x8
_car3:
	.BYTE 0x8

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
