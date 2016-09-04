
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 1.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : Off
;Automatic register allocation : Off

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
; #include <mega328P.h>
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
;  #include <delay.h>
;
;
;
; void main (void){
; 0000 0006 void main (void){

	.CSEG
_main:
; 0000 0007     DDRD=0xFF; //PB1 de salida
	LDI  R30,LOW(255)
	OUT  0xA,R30
; 0000 0008     PORTB=0xFF;
	OUT  0x5,R30
; 0000 0009     PORTC=0xFF;
	OUT  0x8,R30
; 0000 000A 
; 0000 000B     while(1)
_0x3:
; 0000 000C     {
; 0000 000D         switch(PINC&0x07){
	IN   R30,0x6
	ANDI R30,LOW(0x7)
; 0000 000E 
; 0000 000F             case 0x00:
	CPI  R30,0
	BRNE _0x9
; 0000 0010             {
; 0000 0011                  PORTD.0=!PINB.0;
	SBIS 0x3,0
	RJMP _0xA
	CBI  0xB,0
	RJMP _0xB
_0xA:
	SBI  0xB,0
_0xB:
; 0000 0012                  PORTD.1=!PINB.1;
	SBIS 0x3,1
	RJMP _0xC
	CBI  0xB,1
	RJMP _0xD
_0xC:
	SBI  0xB,1
_0xD:
; 0000 0013                  PORTD.2=!PINB.2;
	SBIS 0x3,2
	RJMP _0xE
	CBI  0xB,2
	RJMP _0xF
_0xE:
	SBI  0xB,2
_0xF:
; 0000 0014                  PORTD.3=!PINB.3;
	SBIS 0x3,3
	RJMP _0x10
	CBI  0xB,3
	RJMP _0x11
_0x10:
	SBI  0xB,3
_0x11:
; 0000 0015                  break;
	RJMP _0x8
; 0000 0016             }
; 0000 0017             case 0x01:
_0x9:
	CPI  R30,LOW(0x1)
	BRNE _0x12
; 0000 0018             {
; 0000 0019                  PORTD.0=PINB.0&&PINB.4;
	SBIS 0x3,0
	RJMP _0x13
	SBIS 0x3,4
	RJMP _0x13
	LDI  R30,1
	RJMP _0x14
_0x13:
	LDI  R30,0
_0x14:
	CPI  R30,0
	BRNE _0x15
	CBI  0xB,0
	RJMP _0x16
_0x15:
	SBI  0xB,0
_0x16:
; 0000 001A                  PORTD.1=PINB.1&&PINB.5;
	SBIS 0x3,1
	RJMP _0x17
	SBIS 0x3,5
	RJMP _0x17
	LDI  R30,1
	RJMP _0x18
_0x17:
	LDI  R30,0
_0x18:
	CPI  R30,0
	BRNE _0x19
	CBI  0xB,1
	RJMP _0x1A
_0x19:
	SBI  0xB,1
_0x1A:
; 0000 001B                  PORTD.2=PINB.2&&PINB.6;
	SBIS 0x3,2
	RJMP _0x1B
	SBIS 0x3,6
	RJMP _0x1B
	LDI  R30,1
	RJMP _0x1C
_0x1B:
	LDI  R30,0
_0x1C:
	CPI  R30,0
	BRNE _0x1D
	CBI  0xB,2
	RJMP _0x1E
_0x1D:
	SBI  0xB,2
_0x1E:
; 0000 001C                  PORTD.3=PINB.3&&PINB.7;
	SBIS 0x3,3
	RJMP _0x1F
	SBIS 0x3,7
	RJMP _0x1F
	LDI  R30,1
	RJMP _0x20
_0x1F:
	LDI  R30,0
_0x20:
	CPI  R30,0
	BRNE _0x21
	CBI  0xB,3
	RJMP _0x22
_0x21:
	SBI  0xB,3
_0x22:
; 0000 001D                  break;
	RJMP _0x8
; 0000 001E             }
; 0000 001F             case 0x02:
_0x12:
	CPI  R30,LOW(0x2)
	BRNE _0x23
; 0000 0020             {
; 0000 0021                  PORTD.0=!(PINB.0&&PINB.4);
	SBIS 0x3,0
	RJMP _0x24
	SBIS 0x3,4
	RJMP _0x24
	LDI  R30,1
	RJMP _0x25
_0x24:
	LDI  R30,0
_0x25:
	CPI  R30,0
	BREQ _0x26
	CBI  0xB,0
	RJMP _0x27
_0x26:
	SBI  0xB,0
_0x27:
; 0000 0022                  PORTD.1=!(PINB.1&&PINB.5);
	SBIS 0x3,1
	RJMP _0x28
	SBIS 0x3,5
	RJMP _0x28
	LDI  R30,1
	RJMP _0x29
_0x28:
	LDI  R30,0
_0x29:
	CPI  R30,0
	BREQ _0x2A
	CBI  0xB,1
	RJMP _0x2B
_0x2A:
	SBI  0xB,1
_0x2B:
; 0000 0023                  PORTD.2=!(PINB.2&&PINB.6);
	SBIS 0x3,2
	RJMP _0x2C
	SBIS 0x3,6
	RJMP _0x2C
	LDI  R30,1
	RJMP _0x2D
_0x2C:
	LDI  R30,0
_0x2D:
	CPI  R30,0
	BREQ _0x2E
	CBI  0xB,2
	RJMP _0x2F
_0x2E:
	SBI  0xB,2
_0x2F:
; 0000 0024                  PORTD.3=!(PINB.3&&PINB.7);
	SBIS 0x3,3
	RJMP _0x30
	SBIS 0x3,7
	RJMP _0x30
	LDI  R30,1
	RJMP _0x31
_0x30:
	LDI  R30,0
_0x31:
	CPI  R30,0
	BREQ _0x32
	CBI  0xB,3
	RJMP _0x33
_0x32:
	SBI  0xB,3
_0x33:
; 0000 0025                  break;
	RJMP _0x8
; 0000 0026             }
; 0000 0027            case 0x03:
_0x23:
	CPI  R30,LOW(0x3)
	BRNE _0x34
; 0000 0028             {
; 0000 0029                  PORTD.0=PINB.0||PINB.4;
	SBIC 0x3,0
	RJMP _0x35
	SBIC 0x3,4
	RJMP _0x35
	LDI  R30,0
	RJMP _0x36
_0x35:
	LDI  R30,1
_0x36:
	CPI  R30,0
	BRNE _0x37
	CBI  0xB,0
	RJMP _0x38
_0x37:
	SBI  0xB,0
_0x38:
; 0000 002A                  PORTD.1=PINB.1||PINB.5;
	SBIC 0x3,1
	RJMP _0x39
	SBIC 0x3,5
	RJMP _0x39
	LDI  R30,0
	RJMP _0x3A
_0x39:
	LDI  R30,1
_0x3A:
	CPI  R30,0
	BRNE _0x3B
	CBI  0xB,1
	RJMP _0x3C
_0x3B:
	SBI  0xB,1
_0x3C:
; 0000 002B                  PORTD.2=PINB.2||PINB.6;
	SBIC 0x3,2
	RJMP _0x3D
	SBIC 0x3,6
	RJMP _0x3D
	LDI  R30,0
	RJMP _0x3E
_0x3D:
	LDI  R30,1
_0x3E:
	CPI  R30,0
	BRNE _0x3F
	CBI  0xB,2
	RJMP _0x40
_0x3F:
	SBI  0xB,2
_0x40:
; 0000 002C                  PORTD.3=PINB.3||PINB.7;
	SBIC 0x3,3
	RJMP _0x41
	SBIC 0x3,7
	RJMP _0x41
	LDI  R30,0
	RJMP _0x42
_0x41:
	LDI  R30,1
_0x42:
	CPI  R30,0
	BRNE _0x43
	CBI  0xB,3
	RJMP _0x44
_0x43:
	SBI  0xB,3
_0x44:
; 0000 002D                  break;
	RJMP _0x8
; 0000 002E             }
; 0000 002F            case 0x04:
_0x34:
	CPI  R30,LOW(0x4)
	BRNE _0x45
; 0000 0030             {
; 0000 0031                  PORTD.0=!(PINB.0||PINB.4);
	SBIC 0x3,0
	RJMP _0x46
	SBIC 0x3,4
	RJMP _0x46
	LDI  R30,0
	RJMP _0x47
_0x46:
	LDI  R30,1
_0x47:
	CPI  R30,0
	BREQ _0x48
	CBI  0xB,0
	RJMP _0x49
_0x48:
	SBI  0xB,0
_0x49:
; 0000 0032                  PORTD.1=!(PINB.1||PINB.5);
	SBIC 0x3,1
	RJMP _0x4A
	SBIC 0x3,5
	RJMP _0x4A
	LDI  R30,0
	RJMP _0x4B
_0x4A:
	LDI  R30,1
_0x4B:
	CPI  R30,0
	BREQ _0x4C
	CBI  0xB,1
	RJMP _0x4D
_0x4C:
	SBI  0xB,1
_0x4D:
; 0000 0033                  PORTD.2=!(PINB.2||PINB.6);
	SBIC 0x3,2
	RJMP _0x4E
	SBIC 0x3,6
	RJMP _0x4E
	LDI  R30,0
	RJMP _0x4F
_0x4E:
	LDI  R30,1
_0x4F:
	CPI  R30,0
	BREQ _0x50
	CBI  0xB,2
	RJMP _0x51
_0x50:
	SBI  0xB,2
_0x51:
; 0000 0034                  PORTD.3=!(PINB.3||PINB.7);
	SBIC 0x3,3
	RJMP _0x52
	SBIC 0x3,7
	RJMP _0x52
	LDI  R30,0
	RJMP _0x53
_0x52:
	LDI  R30,1
_0x53:
	CPI  R30,0
	BREQ _0x54
	CBI  0xB,3
	RJMP _0x55
_0x54:
	SBI  0xB,3
_0x55:
; 0000 0035                  break;
	RJMP _0x8
; 0000 0036             }
; 0000 0037             case 0x05:
_0x45:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x56
; 0000 0038             {
; 0000 0039                  PORTD.0=((PINB.0&&(!PINB.4))||(PINB.4&&(!PINB.0)));
	SBIS 0x3,0
	RJMP _0x57
	SBIS 0x3,4
	RJMP _0x59
_0x57:
	SBIS 0x3,4
	RJMP _0x5A
	SBIS 0x3,0
	RJMP _0x59
_0x5A:
	LDI  R30,0
	RJMP _0x5C
_0x59:
	LDI  R30,1
_0x5C:
	CPI  R30,0
	BRNE _0x5D
	CBI  0xB,0
	RJMP _0x5E
_0x5D:
	SBI  0xB,0
_0x5E:
; 0000 003A                  PORTD.1=((PINB.1&&(!PINB.5))||(PINB.5&&(!PINB.1)));
	SBIS 0x3,1
	RJMP _0x5F
	SBIS 0x3,5
	RJMP _0x61
_0x5F:
	SBIS 0x3,5
	RJMP _0x62
	SBIS 0x3,1
	RJMP _0x61
_0x62:
	LDI  R30,0
	RJMP _0x64
_0x61:
	LDI  R30,1
_0x64:
	CPI  R30,0
	BRNE _0x65
	CBI  0xB,1
	RJMP _0x66
_0x65:
	SBI  0xB,1
_0x66:
; 0000 003B                  PORTD.2=((PINB.2&&(!PINB.6))||(PINB.6&&(!PINB.2)));
	SBIS 0x3,2
	RJMP _0x67
	SBIS 0x3,6
	RJMP _0x69
_0x67:
	SBIS 0x3,6
	RJMP _0x6A
	SBIS 0x3,2
	RJMP _0x69
_0x6A:
	LDI  R30,0
	RJMP _0x6C
_0x69:
	LDI  R30,1
_0x6C:
	CPI  R30,0
	BRNE _0x6D
	CBI  0xB,2
	RJMP _0x6E
_0x6D:
	SBI  0xB,2
_0x6E:
; 0000 003C                  PORTD.3=((PINB.3&&(!PINB.7))||(PINB.7&&(!PINB.3)));
	SBIS 0x3,3
	RJMP _0x6F
	SBIS 0x3,7
	RJMP _0x71
_0x6F:
	SBIS 0x3,7
	RJMP _0x72
	SBIS 0x3,3
	RJMP _0x71
_0x72:
	LDI  R30,0
	RJMP _0x74
_0x71:
	LDI  R30,1
_0x74:
	CPI  R30,0
	BRNE _0x75
	CBI  0xB,3
	RJMP _0x76
_0x75:
	SBI  0xB,3
_0x76:
; 0000 003D                  break;
	RJMP _0x8
; 0000 003E             }
; 0000 003F             case 0x06:
_0x56:
	CPI  R30,LOW(0x6)
	BREQ PC+3
	JMP _0x77
; 0000 0040             {
; 0000 0041                  PORTD.0=!((PINB.0&&(!PINB.4))||(PINB.4&&(!PINB.0)));
	SBIS 0x3,0
	RJMP _0x78
	SBIS 0x3,4
	RJMP _0x7A
_0x78:
	SBIS 0x3,4
	RJMP _0x7B
	SBIS 0x3,0
	RJMP _0x7A
_0x7B:
	LDI  R30,0
	RJMP _0x7D
_0x7A:
	LDI  R30,1
_0x7D:
	CPI  R30,0
	BREQ _0x7E
	CBI  0xB,0
	RJMP _0x7F
_0x7E:
	SBI  0xB,0
_0x7F:
; 0000 0042                  PORTD.1=!((PINB.1&&(!PINB.5))||(PINB.5&&(!PINB.1)));
	SBIS 0x3,1
	RJMP _0x80
	SBIS 0x3,5
	RJMP _0x82
_0x80:
	SBIS 0x3,5
	RJMP _0x83
	SBIS 0x3,1
	RJMP _0x82
_0x83:
	LDI  R30,0
	RJMP _0x85
_0x82:
	LDI  R30,1
_0x85:
	CPI  R30,0
	BREQ _0x86
	CBI  0xB,1
	RJMP _0x87
_0x86:
	SBI  0xB,1
_0x87:
; 0000 0043                  PORTD.2=!((PINB.2&&(!PINB.6))||(PINB.6&&(!PINB.2)));
	SBIS 0x3,2
	RJMP _0x88
	SBIS 0x3,6
	RJMP _0x8A
_0x88:
	SBIS 0x3,6
	RJMP _0x8B
	SBIS 0x3,2
	RJMP _0x8A
_0x8B:
	LDI  R30,0
	RJMP _0x8D
_0x8A:
	LDI  R30,1
_0x8D:
	CPI  R30,0
	BREQ _0x8E
	CBI  0xB,2
	RJMP _0x8F
_0x8E:
	SBI  0xB,2
_0x8F:
; 0000 0044                  PORTD.3=!((PINB.3&&(!PINB.7))||(PINB.7&&(!PINB.3)));
	SBIS 0x3,3
	RJMP _0x90
	SBIS 0x3,7
	RJMP _0x92
_0x90:
	SBIS 0x3,7
	RJMP _0x93
	SBIS 0x3,3
	RJMP _0x92
_0x93:
	LDI  R30,0
	RJMP _0x95
_0x92:
	LDI  R30,1
_0x95:
	CPI  R30,0
	BREQ _0x96
	CBI  0xB,3
	RJMP _0x97
_0x96:
	SBI  0xB,3
_0x97:
; 0000 0045                  break;
	RJMP _0x8
; 0000 0046             }
; 0000 0047             case 0x07:
_0x77:
	CPI  R30,LOW(0x7)
	BRNE _0x8
; 0000 0048             {
; 0000 0049                  PORTD=(PINB&0x0F)+((PINB&0xF0)>>4);
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	IN   R30,0x3
	ANDI R30,LOW(0xF0)
	LDI  R31,0
	CALL __ASRW4
	ADD  R30,R26
	OUT  0xB,R30
; 0000 004A                  break;
; 0000 004B             }
; 0000 004C         }
_0x8:
; 0000 004D     }
	RJMP _0x3
; 0000 004E  }
_0x99:
	RJMP _0x99

	.CSEG

	.CSEG
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

;END OF CODE MARKER
__END_OF_CODE:
