
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
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

_tipoCafe:
	.DB  0x43,0x61,0x66,0x65,0x3A,0x20,0x20,0x52
	.DB  0x69,0x73,0x74,0x72,0x65,0x74,0x74,0x6F
	.DB  0x20,0x20,0x20,0x20,0x0,0x43,0x61,0x66
	.DB  0x65,0x3A,0x20,0x20,0x49,0x6E,0x64,0x72
	.DB  0x69,0x79,0x61,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x43,0x61,0x66,0x65,0x3A,0x20
	.DB  0x20,0x52,0x6F,0x6D,0x61,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x43
	.DB  0x61,0x66,0x65,0x3A,0x20,0x20,0x43,0x69
	.DB  0x6F,0x63,0x61,0x74,0x74,0x69,0x6E,0x6F
	.DB  0x20,0x20,0x20,0x0,0x43,0x61,0x66,0x65
	.DB  0x3A,0x20,0x20,0x52,0x69,0x73,0x74,0x72
	.DB  0x65,0x74,0x74,0x6F,0x20,0x33,0x78,0x20
	.DB  0x0,0x43,0x61,0x66,0x65,0x3A,0x20,0x20
	.DB  0x49,0x6E,0x64,0x72,0x69,0x79,0x61,0x20
	.DB  0x32,0x78,0x20,0x20,0x20,0x0,0x43,0x61
	.DB  0x66,0x65,0x3A,0x20,0x20,0x52,0x6F,0x6D
	.DB  0x61,0x20,0x20,0x20,0x32,0x78,0x20,0x20
	.DB  0x20,0x20,0x0,0x43,0x61,0x66,0x65,0x3A
	.DB  0x20,0x20,0x43,0x69,0x6F,0x63,0x61,0x74
	.DB  0x74,0x69,0x6E,0x6F,0x20,0x32,0x78,0x0
_terminado:
	.DB  0x6,0x1,0x26,0x1,0x6,0x1,0x26,0x1
	.DB  0x4A,0x1,0x4A,0x1,0x4A,0x1
_peligro:
	.DB  0x26,0x1,0x6,0x1,0x26,0x1,0x6,0x1

_0x3:
	.DB  0x3,0x3,0x3,0x2,0x2,0xC,0x0,0x8
	.DB  0x0,0x1,0x0,0x6
_0x40:
	.DB  0x2,0x4,0xE,0x11,0x1F,0x10,0xE
_0x41:
	.DB  0x9,0x12,0x9,0x0,0x1F,0x1F,0xE,0xE
_0x42:
	.DB  0x2D,0x0,0x28,0x0,0x28,0x0,0x14,0x0
	.DB  0x78,0x0,0x4B,0x0,0x4B,0x0,0x28
_0x43:
	.DB  0x46,0x0,0x50,0x0,0x50,0x0,0x4B,0x0
	.DB  0xAA,0x0,0x96,0x0,0xA0,0x0,0x96
_0x0:
	.DB  0x48,0x61,0x63,0x69,0x65,0x6E,0x64,0x6F
	.DB  0x20,0x63,0x61,0x66,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x46,0x61,0x6C
	.DB  0x74,0x61,0x6E,0x20,0x25,0x69,0x20,0x73
	.DB  0x65,0x67,0x75,0x6E,0x64,0x6F,0x73,0xA
	.DB  0x0,0x2E,0x20,0x20,0x0,0x46,0x61,0x6C
	.DB  0x74,0x61,0x6E,0x20,0x25,0x69,0x20,0x73
	.DB  0x65,0x67,0x75,0x6E,0x64,0x6F,0x73,0x20
	.DB  0x0,0x2E,0x2E,0x20,0x0,0x2E,0x2E,0x2E
	.DB  0x0,0x46,0x61,0x6C,0x74,0x61,0x6E,0x20
	.DB  0x25,0x69,0x20,0x73,0x65,0x67,0x75,0x6E
	.DB  0x64,0x6F,0x73,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x4C,0x69,0x73,0x74,0x6F
	.DB  0x21,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x4E,0x69,0x76,0x65,0x6C,0x20,0x62
	.DB  0x61,0x6A,0x6F,0x20,0x64,0x65,0x20,0x61
	.DB  0x67,0x75,0x61,0x21,0x20,0x0,0x20,0x20
	.DB  0x20,0x52,0x65,0x63,0x61,0x72,0x67,0x75
	.DB  0x65,0x20,0x61,0x67,0x75,0x61,0x20,0x20
	.DB  0x20,0x20,0x0,0x4D,0x69,0x63,0x72,0x6F
	.DB  0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x61
	.DB  0x64,0x6F,0x72,0x65,0x73,0x0,0x41,0x67
	.DB  0x6F,0x73,0x74,0x6F,0x2D,0x44,0x69,0x63
	.DB  0x69,0x65,0x6D,0x62,0x72,0x65,0x0,0x32
	.DB  0x30,0x31,0x34,0x0,0x50,0x72,0x6F,0x79
	.DB  0x65,0x63,0x74,0x6F,0x20,0x46,0x69,0x6E
	.DB  0x61,0x6C,0x0,0x4A,0x61,0x76,0x69,0x65
	.DB  0x72,0x20,0x64,0x65,0x20,0x56,0x65,0x6C
	.DB  0x61,0x73,0x63,0x6F,0x0,0x52,0x69,0x63
	.DB  0x61,0x72,0x64,0x6F,0x20,0x4D,0x65,0x64
	.DB  0x69,0x6E,0x61,0x0,0x46,0x65,0x72,0x6E
	.DB  0x61,0x6E,0x64,0x6F,0x20,0x56,0x69,0x6C
	.DB  0x6C,0x65,0x72,0x73,0x0,0x41,0x78,0x65
	.DB  0x6C,0x20,0x53,0x61,0x6C,0x61,0x7A,0x61
	.DB  0x72,0x0,0x42,0x69,0x65,0x6E,0x76,0x65
	.DB  0x6E,0x69,0x64,0x6F,0x20,0x61,0x20,0x6C
	.DB  0x61,0x20,0x0,0x43,0x61,0x66,0x65,0x74
	.DB  0x65,0x72,0x61,0x20,0x49,0x6E,0x74,0x65
	.DB  0x6C,0x69,0x67,0x65,0x6E,0x74,0x65,0x0
	.DB  0x20,0x49,0x6E,0x64,0x69,0x71,0x75,0x65
	.DB  0x20,0x75,0x6E,0x61,0x20,0x6F,0x70,0x63
	.DB  0x69,0x6F,0x6E,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x43,0x61,0x66,0x65
	.DB  0x74,0x65,0x72,0x61,0x20,0x41,0x70,0x61
	.DB  0x67,0x61,0x64,0x61,0x20,0x20,0x0,0x44
	.DB  0x41,0x4D,0x45,0x20,0x4C,0x41,0x20,0x4D
	.DB  0x4F,0x54,0x48,0x45,0x52,0x46,0x55,0x43
	.DB  0x4B,0x49,0x4E,0x47,0x20,0x4F,0x50,0x43
	.DB  0x49,0x4F,0x4E,0x20,0x52,0x49,0x47,0x48
	.DB  0x54,0x20,0x4E,0x4F,0x57,0x20,0xA,0x0
	.DB  0x25,0x63,0x0,0x25,0x63,0x20,0x6C,0x65
	.DB  0x6C,0xA,0x0,0x43,0x61,0x73,0x6F,0x20
	.DB  0x31,0x20,0xA,0x0,0x20,0x20,0x46,0x61
	.DB  0x76,0x6F,0x72,0x20,0x64,0x65,0x20,0x65
	.DB  0x6E,0x63,0x65,0x6E,0x64,0x65,0x72,0x20
	.DB  0x0,0x43,0x61,0x73,0x6F,0x20,0x32,0x20
	.DB  0xA,0x0,0x43,0x61,0x73,0x6F,0x20,0x33
	.DB  0x20,0xA,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x41,0x70,0x61,0x67,0x61,0x6E,0x64,0x6F
	.DB  0x2E,0x2E,0x2E,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x45,0x6E,0x63,0x65,0x6E
	.DB  0x64,0x69,0x65,0x6E,0x64,0x6F,0x2E,0x2E
	.DB  0x2E,0x20,0x20,0x20,0x0,0x20,0x53,0x65
	.DB  0x6C,0x65,0x63,0x63,0x69,0x6F,0x6E,0x20
	.DB  0x65,0x72,0x72,0x6F,0x6E,0x65,0x61,0x2C
	.DB  0x20,0x0,0x20,0x69,0x6E,0x74,0x65,0x6E
	.DB  0x74,0x65,0x20,0x6E,0x75,0x65,0x76,0x61
	.DB  0x6D,0x65,0x6E,0x74,0x65,0x20,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _car0
	.DW  _0x40*2

	.DW  0x08
	.DW  _car1
	.DW  _0x41*2

	.DW  0x0F
	.DW  _segundosCafe
	.DW  _0x42*2

	.DW  0x0F
	.DW  _aguaCafe
	.DW  _0x43*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

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
	ST   -Y,R16
;	TablaInicializacion -> Y+1
;	i -> R16
	IN   R30,0x7
	ORI  R30,LOW(0xF)
	OUT  0x7,R30
	IN   R30,0xA
	ORI  R30,LOW(0x84)
	OUT  0xA,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x0
	LDI  R16,LOW(0)
_0x5:
	CPI  R16,12
	BRSH _0x6
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x3
	SUBI R16,-1
	RJMP _0x5
_0x6:
	LDI  R30,LOW(12)
	STS  _cursor,R30
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDD  R16,Y+0
	ADIW R28,13
	RET
_PulsoEn:
	SBI  0xB,2
	CBI  0xB,2
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
	RJMP _0x20A000A
_EscribeComLCD:
	ST   -Y,R16
;	Comando -> Y+1
;	tempComando -> R16
	CBI  0xB,7
	CALL SUBOPT_0x1
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	RCALL _PulsoEn
	LDD  R16,Y+0
	RJMP _0x20A000B
_LetraDatoLCD:
	ST   -Y,R16
;	dato -> Y+1
;	tempdato -> R16
	SBI  0xB,7
	CALL SUBOPT_0x1
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	RCALL _PulsoEn
	LDD  R16,Y+0
	RJMP _0x20A000B
_LetraLCD:
	ST   -Y,R16
;	dato -> Y+1
;	tempdato -> R16
	SBI  0xB,7
	CALL SUBOPT_0x1
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	RCALL _PulsoEn
	LDD  R16,Y+0
	RJMP _0x20A000B
_StringLCD:
	ST   -Y,R16
;	i -> R16
	LDI  R16,LOW(0)
_0x2E:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	MOV  R30,R16
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x9
	BRNE _0x2E
	LDD  R16,Y+0
	RJMP _0x20A0009
_StringLCD2:
	ST   -Y,R16
;	tiempo -> Y+1
;	i -> R16
	LDI  R16,LOW(0)
_0x31:
	MOV  R30,R16
	SUBI R16,-1
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	CALL SUBOPT_0x8
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CALL SUBOPT_0x0
	MOV  R30,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL SUBOPT_0x9
	BRNE _0x31
	LDD  R16,Y+0
	ADIW R28,5
	RET
_StringLCDVar:
	ST   -Y,R16
;	Mensaje -> Y+1
;	i -> R16
	LDI  R16,LOW(0)
_0x34:
	CALL SUBOPT_0x7
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _LetraLCD
	CALL SUBOPT_0xA
	CPI  R30,0
	BRNE _0x34
	LDD  R16,Y+0
	RJMP _0x20A0009
_BorrarLCD:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _EscribeComLCD
	RET
_MoverCursor:
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBIW R30,0
	BRNE _0x39
	LDD  R30,Y+1
	SUBI R30,-LOW(128)
	RJMP _0x8C
_0x39:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3A
	LDD  R30,Y+1
	SUBI R30,-LOW(192)
	RJMP _0x8C
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
	LDD  R30,Y+1
	SUBI R30,-LOW(148)
	RJMP _0x8C
_0x3B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x38
	LDD  R30,Y+1
	SUBI R30,-LOW(212)
_0x8C:
	ST   -Y,R30
	RCALL _EscribeComLCD
_0x38:
	RJMP _0x20A000B
_CreaCaracter:
	ST   -Y,R16
;	NoCaracter -> Y+3
;	datos -> Y+1
;	i -> R16
	LDD  R30,Y+3
	LSL  R30
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(64)
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDI  R16,LOW(0)
_0x3E:
	CPI  R16,8
	BRSH _0x3F
	CALL SUBOPT_0xA
	ST   -Y,R30
	RCALL _LetraDatoLCD
	SUBI R16,-1
	RJMP _0x3E
_0x3F:
	LDI  R30,LOW(128)
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    #include <stdio.h>
;
;char car0[8]={0x02,0x04,0x0E,0x11,0x1F,0x10,0x0E,0x00};

	.DSEG
;char car1[8]={0x09,0x12,0x09,0x00,0x1F,0x1F,0x0E,0x0E};
;
;int segundosCafe[8]={45,40,40,20,120,75,75,40};
;int encendido;
;char entrada;
;int aguaCafe[8]={70,80,80,75,170,150,160,150};
;flash char tipoCafe[8][21]={"Cafe:  Ristretto    ","Cafe:  Indriya      ","Cafe:  Roma         ","Cafe:  Ciocattino   ","Cafe:  Ristretto 3x ","Cafe:  Indriya 2x   ","Cafe:  Roma   2x    ","Cafe:  Ciocattino 2x"};
;
;
;flash int du=262,re= 294,mi =330;
;
;flash int terminado[7]={du,re,du,re,mi,mi,mi};
;
;flash int peligro[4]={re,du,re,du};
;
;
;
;
;#define HacerCafe PIND.0
;#define Listo PORTC.4
;#define AlertaAgua PORTC.5
;#define Trabajando PORTB.3
;
;int seg,agua,i,cuentas;
;char Cadenaentra[10];
;
;void noTono()
; 0000 0022 {

	.CSEG
_noTono:
; 0000 0023     TCCR0B=0x00;        //Apagar Timer
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0024 }
	RET
;
;
;void giraMotor(){
; 0000 0027 void giraMotor(){
_giraMotor:
; 0000 0028     OCR2B=0xFF;
	LDI  R30,LOW(255)
	STS  180,R30
; 0000 0029     delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x0
; 0000 002A     OCR2B=0x00;
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 002B }
	RET
;void tono(int m)
; 0000 002D {
_tono:
; 0000 002E     cuentas =(62500/m);
;	m -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(62500)
	LDI  R27,HIGH(62500)
	CALL __DIVW21U
	STS  _cuentas,R30
	STS  _cuentas+1,R31
; 0000 002F     TCCR0A=0x42;    //Toggle y CTC
	LDI  R30,LOW(66)
	OUT  0x24,R30
; 0000 0030     TCCR0B=0x03;    //Prende Timer 0 en CK/8
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 0031     OCR0A=cuentas-1;       //78 cuentas 256 - 1 = 255    decimal se pone asi natural
	LDS  R30,_cuentas
	LDS  R31,_cuentas+1
	SBIW R30,1
	OUT  0x27,R30
; 0000 0032 }
_0x20A000B:
	ADIW R28,2
	RET
;
;
;void pushCafe(){
; 0000 0035 void pushCafe(){
_pushCafe:
; 0000 0036     giraMotor();
	RCALL _giraMotor
; 0000 0037     OCR1AH = 0x05;
	LDI  R30,LOW(5)
	STS  137,R30
; 0000 0038     OCR1AL = 0x14;
	LDI  R30,LOW(20)
	CALL SUBOPT_0xB
; 0000 0039     delay_ms(250);
; 0000 003A     OCR1AH = 0x06;
	LDI  R30,LOW(6)
	STS  137,R30
; 0000 003B     OCR1AL = 0xA4;
	LDI  R30,LOW(164)
	CALL SUBOPT_0xB
; 0000 003C     delay_ms(250);
; 0000 003D     OCR1AH = 0x05;
	CALL SUBOPT_0xC
; 0000 003E     OCR1AL = 0xDC;
; 0000 003F     delay_ms(500);
	CALL SUBOPT_0xD
; 0000 0040 
; 0000 0041 }
	RET
;void pushEncendido(){
; 0000 0042 void pushEncendido(){
_pushEncendido:
; 0000 0043     OCR1BH = 0x06;
	LDI  R30,LOW(6)
	STS  139,R30
; 0000 0044     OCR1BL = 0xA4;
	LDI  R30,LOW(164)
	CALL SUBOPT_0xE
; 0000 0045     delay_ms(250);
; 0000 0046     OCR1BH = 0x05;
	LDI  R30,LOW(5)
	STS  139,R30
; 0000 0047     OCR1BL = 0x14;
	LDI  R30,LOW(20)
	CALL SUBOPT_0xE
; 0000 0048     delay_ms(250);
; 0000 0049     OCR1BH = 0x05;
	CALL SUBOPT_0xF
; 0000 004A     OCR1BL = 0xDC;
; 0000 004B     //delay_ms(30000);
; 0000 004C     encendido=!encendido;
	LDS  R30,_encendido
	LDS  R31,_encendido+1
	CALL __LNEGW1
	LDI  R31,0
	STS  _encendido,R30
	STS  _encendido+1,R31
; 0000 004D 
; 0000 004E }
	RET
;void HaciendoCafe()
; 0000 0050 {
_HaciendoCafe:
; 0000 0051     pushCafe();
	RCALL _pushCafe
; 0000 0052     while(seg>0)
_0x44:
	LDS  R26,_seg
	LDS  R27,_seg+1
	CALL __CPW02
	BRLT PC+3
	JMP _0x46
; 0000 0053     {
; 0000 0054         MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0055         StringLCD("Haciendo cafe       ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x11
; 0000 0056         printf("Faltan %i segundos\n",seg+1);
	CALL SUBOPT_0x12
	ADIW R30,1
	CALL SUBOPT_0x13
	CALL _printf
	ADIW R28,6
; 0000 0057         if(seg<10)
	LDS  R26,_seg
	LDS  R27,_seg+1
	SBIW R26,10
	BRGE _0x47
; 0000 0058         {
; 0000 0059             delay_ms(200);
	CALL SUBOPT_0x14
; 0000 005A             MoverCursor(14,2);
	CALL SUBOPT_0x15
; 0000 005B             StringLCD(".  ");
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x11
; 0000 005C             sprintf(Cadenaentra,"Faltan %i segundos ",seg);
	CALL SUBOPT_0x16
	__POINTW1FN _0x0,45
	CALL SUBOPT_0x17
	CALL _sprintf
	ADIW R28,8
; 0000 005D             printf("Faltan %i segundos\n",seg);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL _printf
	ADIW R28,6
; 0000 005E             delay_ms(200);
	CALL SUBOPT_0x14
; 0000 005F             MoverCursor(14,2);
	CALL SUBOPT_0x15
; 0000 0060             StringLCD(".. ");
	__POINTW1FN _0x0,65
	CALL SUBOPT_0x11
; 0000 0061             delay_ms(200);
	CALL SUBOPT_0x14
; 0000 0062             MoverCursor(0,3);
	CALL SUBOPT_0x18
; 0000 0063             StringLCDVar(Cadenaentra);
	CALL SUBOPT_0x19
; 0000 0064             seg--;
; 0000 0065             MoverCursor(14,2);
	CALL SUBOPT_0x15
; 0000 0066             StringLCD("...");
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x11
; 0000 0067             delay_ms(200);
	CALL SUBOPT_0x14
; 0000 0068         }
; 0000 0069         sprintf(Cadenaentra,"Faltan %i segundos",seg);
_0x47:
	CALL SUBOPT_0x16
	__POINTW1FN _0x0,73
	CALL SUBOPT_0x17
	CALL _sprintf
	ADIW R28,8
; 0000 006A         delay_ms(835);
	LDI  R30,LOW(835)
	LDI  R31,HIGH(835)
	CALL SUBOPT_0x0
; 0000 006B         MoverCursor(0,3);
	CALL SUBOPT_0x18
; 0000 006C         StringLCDVar(Cadenaentra);
	CALL SUBOPT_0x19
; 0000 006D         seg--;
; 0000 006E     }
	RJMP _0x44
_0x46:
; 0000 006F     MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0070     StringLCD("       Listo!       ");
	__POINTW1FN _0x0,92
	CALL SUBOPT_0x11
; 0000 0071     MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 0072     StringLCD(tipoCafe[entrada-48]);
	CALL SUBOPT_0x1B
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL __MULW12U
	SUBI R30,LOW(-_tipoCafe*2)
	SBCI R31,HIGH(-_tipoCafe*2)
	CALL SUBOPT_0x11
; 0000 0073     pushCafe();
	RCALL _pushCafe
; 0000 0074 }
	RET
;
;void NivelBajo()
; 0000 0077 {
_NivelBajo:
; 0000 0078     MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0079     StringLCD("Nivel bajo de agua! ");
	__POINTW1FN _0x0,113
	CALL SUBOPT_0x11
; 0000 007A     MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 007B     StringLCD("   Recargue agua    ");
	__POINTW1FN _0x0,134
	CALL SUBOPT_0x11
; 0000 007C     for(i=0;i<2;i++)
	CALL SUBOPT_0x1C
_0x49:
	CALL SUBOPT_0x1D
	SBIW R26,2
	BRGE _0x4A
; 0000 007D     {
; 0000 007E         AlertaAgua=1;
	SBI  0x8,5
; 0000 007F         delay_ms(1000);
	CALL SUBOPT_0x1E
; 0000 0080         AlertaAgua=0;
	CBI  0x8,5
; 0000 0081         delay_ms(1000);
	CALL SUBOPT_0x1E
; 0000 0082     }
	CALL SUBOPT_0x1F
	RJMP _0x49
_0x4A:
; 0000 0083 }
	RET
;
;void main()
; 0000 0086 {
_main:
; 0000 0087 
; 0000 0088     ConfiguraLCD();
	RCALL _ConfiguraLCD
; 0000 0089     CreaCaracter(0,car0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_car0)
	LDI  R31,HIGH(_car0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 008A     CreaCaracter(1,car1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_car1)
	LDI  R31,HIGH(_car1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 008B     DDRB.1=1;
	SBI  0x4,1
; 0000 008C     TCCR2A=0x23;
	LDI  R30,LOW(35)
	STS  176,R30
; 0000 008D     TCCR2B=0x07;
	LDI  R30,LOW(7)
	STS  177,R30
; 0000 008E     TCCR1A=0xA2;
	LDI  R30,LOW(162)
	STS  128,R30
; 0000 008F     TCCR1B=0x1A;
	LDI  R30,LOW(26)
	STS  129,R30
; 0000 0090     ICR1H=0x4E;
	LDI  R30,LOW(78)
	STS  135,R30
; 0000 0091     ICR1L=0x20;
	LDI  R30,LOW(32)
	STS  134,R30
; 0000 0092 
; 0000 0093     UCSR0A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 0094     UCSR0B=0x18;
	LDI  R30,LOW(24)
	STS  193,R30
; 0000 0095     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0096     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 0097     UBRR0L=0x33;
	LDI  R30,LOW(51)
	STS  196,R30
; 0000 0098 
; 0000 0099 
; 0000 009A     OCR1AH = 0x05;
	CALL SUBOPT_0xC
; 0000 009B     OCR1AL = 0xDC;
; 0000 009C     OCR1BH = 0x05;
	CALL SUBOPT_0xF
; 0000 009D     OCR1BL = 0xDC;
; 0000 009E 
; 0000 009F 
; 0000 00A0     PORTD.0=1;
	SBI  0xB,0
; 0000 00A1     PORTD.3=0;
	CBI  0xB,3
; 0000 00A2     seg=0;
	LDI  R30,LOW(0)
	STS  _seg,R30
	STS  _seg+1,R30
; 0000 00A3     agua=900;
	CALL SUBOPT_0x20
; 0000 00A4     DDRD.3=1;
	SBI  0xA,3
; 0000 00A5     DDRB.2=1;
	SBI  0x4,2
; 0000 00A6     PORTB.5=1;
	SBI  0x5,5
; 0000 00A7     DDRB.4=1;
	SBI  0x4,4
; 0000 00A8     DDRD.6=1;
	SBI  0xA,6
; 0000 00A9     DDRC.4=1;
	SBI  0x7,4
; 0000 00AA     DDRC.5=1;
	SBI  0x7,5
; 0000 00AB     DDRB.3=1;
	SBI  0x4,3
; 0000 00AC 
; 0000 00AD     OCR2B=0x00;
	LDI  R30,LOW(0)
	STS  180,R30
; 0000 00AE     MoverCursor(1,0);
	CALL SUBOPT_0x21
; 0000 00AF     StringLCD("Microcontroladores");
	__POINTW1FN _0x0,155
	CALL SUBOPT_0x11
; 0000 00B0     MoverCursor(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x22
; 0000 00B1     StringLCD2("Agosto-Diciembre",150);
	__POINTW1FN _0x0,174
	CALL SUBOPT_0x23
; 0000 00B2     MoverCursor(8,2);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 00B3     StringLCD2("2014",150);
	__POINTW1FN _0x0,191
	CALL SUBOPT_0x23
; 0000 00B4     MoverCursor(3,3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 00B5     StringLCD("Proyecto Final");
	__POINTW1FN _0x0,196
	CALL SUBOPT_0x11
; 0000 00B6     delay_ms(2000);
	CALL SUBOPT_0x24
; 0000 00B7     BorrarLCD();
	RCALL _BorrarLCD
; 0000 00B8     MoverCursor(1,0);
	CALL SUBOPT_0x21
; 0000 00B9     StringLCD("Javier de Velasco");
	__POINTW1FN _0x0,211
	CALL SUBOPT_0x11
; 0000 00BA     MoverCursor(3,1);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x22
; 0000 00BB     StringLCD("Ricardo Medina");
	__POINTW1FN _0x0,229
	CALL SUBOPT_0x11
; 0000 00BC     MoverCursor(2,2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 00BD     StringLCD("Fernando Villers");
	__POINTW1FN _0x0,244
	CALL SUBOPT_0x11
; 0000 00BE     MoverCursor(4,3);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 00BF     StringLCD("Axel Salazar");
	__POINTW1FN _0x0,261
	CALL SUBOPT_0x11
; 0000 00C0     delay_ms(2000);
	CALL SUBOPT_0x24
; 0000 00C1     BorrarLCD();
	RCALL _BorrarLCD
; 0000 00C2     Listo=1;
	SBI  0x8,4
; 0000 00C3     delay_ms(2000);
	CALL SUBOPT_0x24
; 0000 00C4     encendido=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _encendido,R30
	STS  _encendido+1,R31
; 0000 00C5 
; 0000 00C6     while(1)
_0x67:
; 0000 00C7     {
; 0000 00C8 
; 0000 00C9         Listo=0;
	CBI  0x8,4
; 0000 00CA         AlertaAgua=0;
	CBI  0x8,5
; 0000 00CB         Trabajando=0;
	CBI  0x5,3
; 0000 00CC         i=0;
	CALL SUBOPT_0x1C
; 0000 00CD         MoverCursor(1,0);
	CALL SUBOPT_0x21
; 0000 00CE         StringLCD("Bienvenido a la ");
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x11
; 0000 00CF         LetraLCD(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 00D0         MoverCursor(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x22
; 0000 00D1         StringLCD("Cafetera Inteligente");
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x11
; 0000 00D2         MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 00D3         if(agua <150 )
	LDS  R26,_agua
	LDS  R27,_agua+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	BRGE _0x70
; 0000 00D4         {
; 0000 00D5             NivelBajo();
	RCALL _NivelBajo
; 0000 00D6             while(i<4)
_0x71:
	CALL SUBOPT_0x1D
	SBIW R26,4
	BRGE _0x73
; 0000 00D7             {
; 0000 00D8                 tono(peligro[i++]);
	CALL SUBOPT_0x1F
	SBIW R30,1
	LDI  R26,LOW(_peligro*2)
	LDI  R27,HIGH(_peligro*2)
	CALL SUBOPT_0x25
; 0000 00D9                 delay_ms(500);
; 0000 00DA                 noTono();
	RCALL _noTono
; 0000 00DB             }
	RJMP _0x71
_0x73:
; 0000 00DC             delay_ms(500);
	CALL SUBOPT_0xD
; 0000 00DD             while(PINB.5==1)
_0x74:
	SBIS 0x3,5
	RJMP _0x76
; 0000 00DE             agua=900;
	CALL SUBOPT_0x20
	RJMP _0x74
_0x76:
; 0000 00DF i=0;
	CALL SUBOPT_0x1C
; 0000 00E0         }
; 0000 00E1         else{
	RJMP _0x77
_0x70:
; 0000 00E2             if(encendido==1){
	CALL SUBOPT_0x26
	BRNE _0x78
; 0000 00E3              MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 00E4             StringLCD(" Indique una opcion ");
	__POINTW1FN _0x0,312
	RJMP _0x8D
; 0000 00E5             MoverCursor(0,3);
; 0000 00E6             StringLCD("                    ");  }
; 0000 00E7             else{
_0x78:
; 0000 00E8              MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 00E9             StringLCD("  Cafetera Apagada  ");
	__POINTW1FN _0x0,354
_0x8D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 00EA             MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 00EB             StringLCD("                    ");  }
	CALL SUBOPT_0x27
; 0000 00EC             printf("DAME LA MOTHERFUCKING OPCION RIGHT NOW \n");
	__POINTW1FN _0x0,375
	CALL SUBOPT_0x28
; 0000 00ED             scanf("%c",&entrada);
	__POINTW1FN _0x0,416
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_entrada)
	LDI  R31,HIGH(_entrada)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _scanf
	ADIW R28,6
; 0000 00EE             printf("%c lel\n",entrada);
	__POINTW1FN _0x0,419
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_entrada
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 00EF             if((entrada-48) < 8)
	CALL SUBOPT_0x1B
	SBIW R30,8
	BRLT PC+3
	JMP _0x7A
; 0000 00F0             {
; 0000 00F1                 printf("Caso 1 \n");
	__POINTW1FN _0x0,427
	CALL SUBOPT_0x28
; 0000 00F2                 if(encendido==1){
	CALL SUBOPT_0x26
	BRNE _0x7B
; 0000 00F3                     seg=segundosCafe[entrada-48];
	CALL SUBOPT_0x1B
	LDI  R26,LOW(_segundosCafe)
	LDI  R27,HIGH(_segundosCafe)
	CALL SUBOPT_0x29
	STS  _seg,R30
	STS  _seg+1,R31
; 0000 00F4                     Trabajando=1;
	SBI  0x5,3
; 0000 00F5                     HaciendoCafe();
	RCALL _HaciendoCafe
; 0000 00F6                     agua=agua-aguaCafe[entrada-48];
	CALL SUBOPT_0x1B
	LDI  R26,LOW(_aguaCafe)
	LDI  R27,HIGH(_aguaCafe)
	CALL SUBOPT_0x29
	LDS  R26,_agua
	LDS  R27,_agua+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _agua,R26
	STS  _agua+1,R27
; 0000 00F7                     Trabajando=0;
	CBI  0x5,3
; 0000 00F8                     Listo=1;
	SBI  0x8,4
; 0000 00F9                     delay_ms(1000);
	CALL SUBOPT_0x1E
; 0000 00FA                     while(i<7)
_0x82:
	CALL SUBOPT_0x1D
	SBIW R26,7
	BRGE _0x84
; 0000 00FB                     {
; 0000 00FC                         tono(terminado[i++]);
	CALL SUBOPT_0x1F
	SBIW R30,1
	LDI  R26,LOW(_terminado*2)
	LDI  R27,HIGH(_terminado*2)
	CALL SUBOPT_0x25
; 0000 00FD                         delay_ms(500);
; 0000 00FE                         noTono();
	RCALL _noTono
; 0000 00FF                     }
	RJMP _0x82
_0x84:
; 0000 0100                     delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x0
; 0000 0101                     MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0102                     StringLCD("                    ");
	CALL SUBOPT_0x27
; 0000 0103                     MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 0104                     StringLCD("                    ");
	CALL SUBOPT_0x27
; 0000 0105                 }
; 0000 0106                 else{
	RJMP _0x85
_0x7B:
; 0000 0107                     MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0108                     StringLCD("  Cafetera Apagada  ");
	__POINTW1FN _0x0,354
	CALL SUBOPT_0x11
; 0000 0109                     MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 010A                     StringLCD("  Favor de encender ");
	__POINTW1FN _0x0,436
	CALL SUBOPT_0x11
; 0000 010B                     delay_ms(2000);
	CALL SUBOPT_0x24
; 0000 010C                 }
_0x85:
; 0000 010D             }
; 0000 010E             else
	RJMP _0x86
_0x7A:
; 0000 010F             {
; 0000 0110                 printf("Caso 2 \n");
	__POINTW1FN _0x0,457
	CALL SUBOPT_0x28
; 0000 0111                 if((entrada-48)==8){
	CALL SUBOPT_0x1B
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x87
; 0000 0112                 printf("Caso 3 \n");
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x28
; 0000 0113                   if(encendido==1){
	CALL SUBOPT_0x26
	BRNE _0x88
; 0000 0114                     MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0115                     StringLCD("     Apagando...    ");
	__POINTW1FN _0x0,475
	RJMP _0x8E
; 0000 0116                     MoverCursor(0,3);
; 0000 0117                     StringLCD("                    ");
; 0000 0118                     pushEncendido();
; 0000 0119                     delay_ms(3000);
; 0000 011A 
; 0000 011B                   }
; 0000 011C                   else{
_0x88:
; 0000 011D                    MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 011E                     StringLCD("   Encendiendo...   ");
	__POINTW1FN _0x0,496
_0x8E:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 011F                     MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 0120                     StringLCD("                    ");
	CALL SUBOPT_0x27
; 0000 0121                     pushEncendido();
	RCALL _pushEncendido
; 0000 0122                     delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x0
; 0000 0123                   }
; 0000 0124                 }
; 0000 0125                 else{
	RJMP _0x8A
_0x87:
; 0000 0126                 printf("Caso 1 \n");
	__POINTW1FN _0x0,427
	CALL SUBOPT_0x28
; 0000 0127                     MoverCursor(0,2);
	CALL SUBOPT_0x10
; 0000 0128                     StringLCD(" Seleccion erronea, ");
	__POINTW1FN _0x0,517
	CALL SUBOPT_0x11
; 0000 0129                     MoverCursor(0,3);
	CALL SUBOPT_0x1A
; 0000 012A                     StringLCD(" intente nuevamente ");
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x11
; 0000 012B                     delay_ms(2000);
	CALL SUBOPT_0x24
; 0000 012C                 }
_0x8A:
; 0000 012D             }
_0x86:
; 0000 012E         }
_0x77:
; 0000 012F 
; 0000 0130     }
	RJMP _0x67
; 0000 0131 }
_0x8B:
	RJMP _0x8B
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
_getchar:
_0x2000003:
	LDS  R30,192
	ANDI R30,LOW(0x80)
	BREQ _0x2000003
	LDS  R30,198
	RET
_putchar:
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
_0x20A000A:
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x2A
_0x20A0009:
	ADIW R28,3
	RET
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000018
	__CPWRN 16,17,2
	BRLO _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2A
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x200001A
	CALL SUBOPT_0x2A
_0x200001A:
_0x2000019:
	RJMP _0x200001B
_0x2000016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	LDD  R17,Y+1
	RJMP _0x20A0006
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR3
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200001F
	CALL SUBOPT_0x2B
	__POINTW1FN _0x2000000,0
	CALL SUBOPT_0x2C
	RJMP _0x20A0008
_0x200001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200001E
	CALL SUBOPT_0x2B
	__POINTW1FN _0x2000000,1
	CALL SUBOPT_0x2C
	RJMP _0x20A0008
_0x200001E:
	LDD  R26,Y+10
	CPI  R26,LOW(0x7)
	BRLO _0x2000021
	LDI  R30,LOW(6)
	STD  Y+10,R30
_0x2000021:
	LDD  R16,Y+10
_0x2000022:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x2000024
	CALL SUBOPT_0x2D
	RJMP _0x2000022
_0x2000024:
	__GETD1S 11
	CALL __CPD10
	BRNE _0x2000025
	LDI  R18,LOW(0)
	CALL SUBOPT_0x2D
	RJMP _0x2000026
_0x2000025:
	LDD  R18,Y+10
	CALL SUBOPT_0x2E
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000027
	CALL SUBOPT_0x2D
_0x2000028:
	CALL SUBOPT_0x2E
	BRLO _0x200002A
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0x2E
	BRSH _0x200002E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	SUBI R18,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0x2D
_0x200002B:
	__GETD1S 11
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2E
	BRLO _0x200002F
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
_0x200002F:
_0x2000026:
	LDI  R16,LOW(0)
_0x2000030:
	LDD  R30,Y+10
	CP   R30,R16
	BRLO _0x2000032
	__GETD2S 3
	CALL SUBOPT_0x34
	CALL SUBOPT_0x33
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 3
	CALL SUBOPT_0x2F
	CALL __DIVF21
	CALL __CFD1U
	MOV  R17,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 3
	CALL __MULF12
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x37
	CALL SUBOPT_0x32
	MOV  R30,R16
	SUBI R16,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0x35
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0x38
	SBIW R30,1
	LDD  R26,Y+9
	STD  Z+0,R26
	CPI  R18,0
	BRGE _0x2000034
	NEG  R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R30,LOW(45)
	RJMP _0x2000114
_0x2000034:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R30,LOW(43)
_0x2000114:
	ST   X,R30
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x38
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0008:
	CALL __LOADLOCR3
	ADIW R28,15
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R16,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x2A
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000038
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x200003C
	CPI  R19,37
	BRNE _0x200003D
	LDI  R16,LOW(1)
	RJMP _0x200003E
_0x200003D:
	ST   -Y,R19
	CALL SUBOPT_0x2B
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R19,37
	BRNE _0x2000040
	ST   -Y,R19
	CALL SUBOPT_0x2B
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2000115
_0x2000040:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x2000041
	LDI  R17,LOW(1)
	RJMP _0x200003B
_0x2000041:
	CPI  R19,43
	BRNE _0x2000042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000042:
	CPI  R19,32
	BRNE _0x2000043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000043:
	RJMP _0x2000044
_0x200003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000045
_0x2000044:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x2000046
	ORI  R17,LOW(128)
	RJMP _0x200003B
_0x2000046:
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x3)
	BRNE _0x2000048
_0x2000047:
	CPI  R19,48
	BRLO _0x200004A
	CPI  R19,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200003B
_0x2000049:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x200004C
	LDI  R16,LOW(4)
	RJMP _0x200003B
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x4)
	BRNE _0x200004F
	CPI  R19,48
	BRLO _0x2000051
	CPI  R19,58
	BRLO _0x2000052
_0x2000051:
	RJMP _0x2000050
_0x2000052:
	ORI  R17,LOW(32)
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200003B
_0x2000050:
_0x200004D:
	CPI  R19,108
	BRNE _0x2000053
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x200003B
_0x2000053:
	RJMP _0x2000054
_0x200004F:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x200003B
_0x2000054:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2B
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0x45)
	BREQ _0x200005D
	CPI  R30,LOW(0x65)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3B
	CALL __GETD1P
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	RJMP _0x2000064
_0x2000061:
	CALL SUBOPT_0x3E
	CALL __ANEGF1
	CALL SUBOPT_0x3C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R17,7
	RJMP _0x2000065
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x2B
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2000066
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000066:
_0x2000064:
	SBRS R17,5
	LDI  R21,LOW(6)
	CPI  R19,102
	BRNE _0x2000068
	CALL SUBOPT_0x3E
	CALL __PUTPARD1
	ST   -Y,R21
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000069
_0x2000068:
	CALL SUBOPT_0x3E
	CALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R19
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000069:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x3F
	RJMP _0x200006A
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006C
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
	RJMP _0x200006D
_0x200006C:
	CPI  R30,LOW(0x70)
	BRNE _0x200006F
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x200006D:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x2000071
	CP   R21,R16
	BRLO _0x2000072
_0x2000071:
	RJMP _0x2000070
_0x2000072:
	MOV  R16,R21
_0x2000070:
_0x200006A:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R18,LOW(0)
	RJMP _0x2000073
_0x200006F:
	CPI  R30,LOW(0x64)
	BREQ _0x2000076
	CPI  R30,LOW(0x69)
	BRNE _0x2000077
_0x2000076:
	ORI  R17,LOW(4)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x75)
	BRNE _0x2000079
_0x2000078:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R17,1
	RJMP _0x200007A
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x41
	LDI  R16,LOW(10)
	RJMP _0x200007B
_0x200007A:
	__GETD1N 0x2710
	CALL SUBOPT_0x41
	LDI  R16,LOW(5)
	RJMP _0x200007B
_0x2000079:
	CPI  R30,LOW(0x58)
	BRNE _0x200007D
	ORI  R17,LOW(8)
	RJMP _0x200007E
_0x200007D:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000BC
_0x200007E:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R17,1
	RJMP _0x2000080
	__GETD1N 0x10000000
	CALL SUBOPT_0x41
	LDI  R16,LOW(8)
	RJMP _0x200007B
_0x2000080:
	__GETD1N 0x1000
	CALL SUBOPT_0x41
	LDI  R16,LOW(4)
_0x200007B:
	CPI  R21,0
	BREQ _0x2000081
	ANDI R17,LOW(127)
	RJMP _0x2000082
_0x2000081:
	LDI  R21,LOW(1)
_0x2000082:
	SBRS R17,1
	RJMP _0x2000083
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3B
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000116
_0x2000083:
	SBRS R17,2
	RJMP _0x2000085
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	CALL __CWD1
	RJMP _0x2000116
_0x2000085:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	CLR  R22
	CLR  R23
_0x2000116:
	__PUTD1S 10
	SBRS R17,2
	RJMP _0x2000087
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000088
	CALL SUBOPT_0x3E
	CALL __ANEGD1
	CALL SUBOPT_0x3C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000088:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000089
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0x200008A
_0x2000089:
	ANDI R17,LOW(251)
_0x200008A:
_0x2000087:
	MOV  R18,R21
_0x2000073:
	SBRC R17,0
	RJMP _0x200008B
_0x200008C:
	CP   R16,R20
	BRSH _0x200008F
	CP   R18,R20
	BRLO _0x2000090
_0x200008F:
	RJMP _0x200008E
_0x2000090:
	SBRS R17,7
	RJMP _0x2000091
	SBRS R17,2
	RJMP _0x2000092
	ANDI R17,LOW(251)
	LDD  R19,Y+21
	SUBI R16,LOW(1)
	RJMP _0x2000093
_0x2000092:
	LDI  R19,LOW(48)
_0x2000093:
	RJMP _0x2000094
_0x2000091:
	LDI  R19,LOW(32)
_0x2000094:
	ST   -Y,R19
	CALL SUBOPT_0x2B
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	SUBI R20,LOW(1)
	RJMP _0x200008C
_0x200008E:
_0x200008B:
_0x2000095:
	CP   R16,R21
	BRSH _0x2000097
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x2000098
	CALL SUBOPT_0x42
	BREQ _0x2000099
	SUBI R20,LOW(1)
_0x2000099:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0x2000098:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x43
	BREQ _0x200009A
	SUBI R20,LOW(1)
_0x200009A:
	SUBI R21,LOW(1)
	RJMP _0x2000095
_0x2000097:
	MOV  R18,R16
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009B
_0x200009C:
	CPI  R18,0
	BREQ _0x200009E
	SBRS R17,3
	RJMP _0x200009F
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R19,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A0
_0x200009F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R19,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A0:
	ST   -Y,R19
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x43
	BREQ _0x20000A1
	SUBI R20,LOW(1)
_0x20000A1:
	SUBI R18,LOW(1)
	RJMP _0x200009C
_0x200009E:
	RJMP _0x20000A2
_0x200009B:
_0x20000A4:
	CALL SUBOPT_0x44
	CALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0x20000A6
	SBRS R17,3
	RJMP _0x20000A7
	SUBI R19,-LOW(55)
	RJMP _0x20000A8
_0x20000A7:
	SUBI R19,-LOW(87)
_0x20000A8:
	RJMP _0x20000A9
_0x20000A6:
	SUBI R19,-LOW(48)
_0x20000A9:
	SBRC R17,4
	RJMP _0x20000AB
	CPI  R19,49
	BRSH _0x20000AD
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AC
_0x20000AD:
	RJMP _0x20000AF
_0x20000AC:
	CP   R21,R18
	BRSH _0x2000117
	CP   R20,R18
	BRLO _0x20000B2
	SBRS R17,0
	RJMP _0x20000B3
_0x20000B2:
	RJMP _0x20000B1
_0x20000B3:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x20000B4
_0x2000117:
	LDI  R19,LOW(48)
_0x20000AF:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x20000B5
	CALL SUBOPT_0x42
	BREQ _0x20000B6
	SUBI R20,LOW(1)
_0x20000B6:
_0x20000B5:
_0x20000B4:
_0x20000AB:
	ST   -Y,R19
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x43
	BREQ _0x20000B7
	SUBI R20,LOW(1)
_0x20000B7:
_0x20000B1:
	SUBI R18,LOW(1)
	CALL SUBOPT_0x44
	CALL __MODD21U
	CALL SUBOPT_0x3C
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x41
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A5
	RJMP _0x20000A4
_0x20000A5:
_0x20000A2:
	SBRS R17,0
	RJMP _0x20000B8
_0x20000B9:
	CPI  R20,0
	BREQ _0x20000BB
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2B
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x20000B9
_0x20000BB:
_0x20000B8:
_0x20000BC:
_0x200005A:
_0x2000115:
	LDI  R16,LOW(0)
_0x200003B:
	RJMP _0x2000036
_0x2000038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x45
	SBIW R30,0
	BRNE _0x20000BD
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0007
_0x20000BD:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x45
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x46
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x46
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	CALL SUBOPT_0x47
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
_get_usart_G100:
	ST   -Y,R16
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x20000C3
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20000C4
_0x20000C3:
	RCALL _getchar
	MOV  R16,R30
_0x20000C4:
	MOV  R30,R16
_0x20A0006:
	LDD  R16,Y+0
	ADIW R28,5
	RET
__scanf_G100:
	SBIW R28,5
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R21,R30
_0x20000CA:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,1
	STD  Y+17,R30
	STD  Y+17+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x20000CC
	CALL SUBOPT_0x48
	BREQ _0x20000CD
_0x20000CE:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x49
	POP  R21
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x20000D1
	CALL SUBOPT_0x48
	BRNE _0x20000D2
_0x20000D1:
	RJMP _0x20000D0
_0x20000D2:
	CALL SUBOPT_0x4A
	BRGE _0x20000D3
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000D3:
	RJMP _0x20000CE
_0x20000D0:
	MOV  R21,R18
	RJMP _0x20000D4
_0x20000CD:
	CPI  R18,37
	BREQ PC+3
	JMP _0x20000D5
	LDI  R20,LOW(0)
_0x20000D6:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
	CPI  R18,48
	BRLO _0x20000DA
	CPI  R18,58
	BRLO _0x20000D9
_0x20000DA:
	RJMP _0x20000D8
_0x20000D9:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x20000D6
_0x20000D8:
	CPI  R18,0
	BRNE _0x20000DC
	RJMP _0x20000CC
_0x20000DC:
_0x20000DD:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x49
	POP  R21
	MOV  R19,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x20000DF
	CALL SUBOPT_0x4A
	BRGE _0x20000E0
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000E0:
	RJMP _0x20000DD
_0x20000DF:
	CPI  R19,0
	BRNE _0x20000E1
	RJMP _0x20000E2
_0x20000E1:
	MOV  R21,R19
	CPI  R20,0
	BRNE _0x20000E3
	LDI  R20,LOW(255)
_0x20000E3:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x20000E7
	CALL SUBOPT_0x4B
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x49
	POP  R21
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x4A
	BRGE _0x20000E8
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000E8:
	RJMP _0x20000E6
_0x20000E7:
	CPI  R30,LOW(0x73)
	BRNE _0x20000F1
	CALL SUBOPT_0x4B
_0x20000EA:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x20000EC
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x49
	POP  R21
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x20000EE
	CALL SUBOPT_0x48
	BREQ _0x20000ED
_0x20000EE:
	CALL SUBOPT_0x4A
	BRGE _0x20000F0
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000F0:
	RJMP _0x20000EC
_0x20000ED:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R18
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x20000EA
_0x20000EC:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20000E6
_0x20000F1:
	LDI  R30,LOW(1)
	STD  Y+10,R30
	MOV  R30,R18
	CPI  R30,LOW(0x64)
	BREQ _0x20000F6
	CPI  R30,LOW(0x69)
	BRNE _0x20000F7
_0x20000F6:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	RJMP _0x20000F8
_0x20000F7:
	CPI  R30,LOW(0x75)
	BRNE _0x20000F9
_0x20000F8:
	LDI  R19,LOW(10)
	RJMP _0x20000F4
_0x20000F9:
	CPI  R30,LOW(0x78)
	BRNE _0x20000FA
	LDI  R19,LOW(16)
	RJMP _0x20000F4
_0x20000FA:
	CPI  R30,LOW(0x25)
	BRNE _0x20000FD
	RJMP _0x20000FC
_0x20000FD:
	RJMP _0x20A0005
_0x20000F4:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x20000FE:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000100
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x49
	POP  R21
	MOV  R18,R30
	CPI  R30,LOW(0x21)
	BRSH _0x2000101
	CALL SUBOPT_0x4A
	BRGE _0x2000102
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x2000102:
	RJMP _0x2000103
_0x2000101:
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0x2000104
	CPI  R18,45
	BRNE _0x2000105
	LDI  R30,LOW(255)
	STD  Y+10,R30
	RJMP _0x20000FE
_0x2000105:
	LDI  R30,LOW(1)
	STD  Y+10,R30
_0x2000104:
	CPI  R19,16
	BRNE _0x2000107
	ST   -Y,R18
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x2000103
	RJMP _0x2000109
_0x2000107:
	ST   -Y,R18
	CALL _isdigit
	CPI  R30,0
	BRNE _0x200010A
_0x2000103:
	MOV  R21,R18
	RJMP _0x2000100
_0x200010A:
_0x2000109:
	CPI  R18,97
	BRLO _0x200010B
	SUBI R18,LOW(87)
	RJMP _0x200010C
_0x200010B:
	CPI  R18,65
	BRLO _0x200010D
	SUBI R18,LOW(55)
	RJMP _0x200010E
_0x200010D:
	SUBI R18,LOW(48)
_0x200010E:
_0x200010C:
	MOV  R30,R19
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x20000FE
_0x2000100:
	CALL SUBOPT_0x4B
	LDD  R30,Y+10
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __MULW12U
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x20000E6:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x200010F
_0x20000D5:
_0x20000FC:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x49
	POP  R21
	CP   R30,R18
	BREQ _0x2000110
	CALL SUBOPT_0x4A
	BRGE _0x2000111
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x2000111:
_0x20000E2:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x2000112
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x2000112:
	RJMP _0x20000CC
_0x2000110:
_0x200010F:
_0x20000D4:
	RJMP _0x20000CA
_0x20000CC:
_0x20A0005:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20A0004:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
_scanf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+3,R30
	STD  Y+3+1,R30
	MOVW R26,R28
	ADIW R26,5
	CALL SUBOPT_0x46
	LDI  R30,LOW(_get_usart_G100)
	LDI  R31,HIGH(_get_usart_G100)
	CALL SUBOPT_0x47
	RCALL __scanf_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET

	.CSEG
_isdigit:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
_isxdigit:
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x4C
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x4C
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x4C
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	RCALL SUBOPT_0x4D
	__POINTW1FN _0x2080000,0
	RCALL SUBOPT_0x2C
	RJMP _0x20A0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	RCALL SUBOPT_0x4D
	__POINTW1FN _0x2080000,1
	RCALL SUBOPT_0x2C
	RJMP _0x20A0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x4F
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R16,Y+8
_0x2080011:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x2080013
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x51
	RJMP _0x2080011
_0x2080013:
	RCALL SUBOPT_0x52
	CALL __ADDF12
	RCALL SUBOPT_0x4E
	LDI  R16,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x51
_0x2080014:
	RCALL SUBOPT_0x52
	CALL __CMPF12
	BRLO _0x2080016
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x51
	SUBI R16,-LOW(1)
	CPI  R16,39
	BRLO _0x2080017
	RCALL SUBOPT_0x4D
	__POINTW1FN _0x2080000,5
	RCALL SUBOPT_0x2C
	RJMP _0x20A0002
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R16,0
	BRNE _0x2080018
	RCALL SUBOPT_0x4F
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x208001C
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x33
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
	CALL __DIVF21
	CALL __CFD1U
	MOV  R17,R30
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x36
	LDI  R31,0
	RCALL SUBOPT_0x50
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x4E
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0001
	RCALL SUBOPT_0x4F
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x4E
	__GETD1S 9
	CALL __CFD1U
	MOV  R17,R30
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x36
	LDI  R31,0
	RCALL SUBOPT_0x53
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x4E
	RJMP _0x208001E
_0x2080020:
_0x20A0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
_cursor:
	.BYTE 0x1
_car0:
	.BYTE 0x8
_car1:
	.BYTE 0x8
_segundosCafe:
	.BYTE 0x10
_encendido:
	.BYTE 0x2
_entrada:
	.BYTE 0x1
_aguaCafe:
	.BYTE 0x10
_seg:
	.BYTE 0x2
_agua:
	.BYTE 0x2
_i:
	.BYTE 0x2
_cuentas:
	.BYTE 0x2
_Cadenaentra:
	.BYTE 0xA
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CALL _MandaLineasDatosLCD
	JMP  _PulsoEn

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R16,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL __ASRW4
	MOV  R16,R30
	ST   -Y,R16
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	ST   -Y,R16
	CALL _MandaLineasDatosLCD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	MOV  R30,R16
	SUBI R16,-1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	JMP  _LetraLCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	STS  136,R30
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(5)
	STS  137,R30
	LDI  R30,LOW(220)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	STS  138,R30
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(5)
	STS  139,R30
	LDI  R30,LOW(220)
	STS  138,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _MoverCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _StringLCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	__POINTW1FN _0x0,21
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_seg
	LDS  R31,_seg+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _MoverCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(_Cadenaentra)
	LDI  R31,HIGH(_Cadenaentra)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_seg
	LDS  R31,_seg+1
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _MoverCursor
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	CALL _StringLCDVar
	LDI  R26,LOW(_seg)
	LDI  R27,HIGH(_seg)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _MoverCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	LDS  R30,_entrada
	LDI  R31,0
	SBIW R30,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	STS  _agua,R30
	STS  _agua+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _MoverCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _MoverCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _StringLCD2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	CALL _tono
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDS  R26,_encendido
	LDS  R27,_encendido+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	__POINTW1FN _0x0,333
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2D:
	__GETD2S 3
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	__GETD1S 3
	__GETD2S 11
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 11
	SUBI R18,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	STD  Y+7,R26
	STD  Y+7+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x38:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x39:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3A:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3B:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0x39
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x3B
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x42:
	ANDI R17,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R20,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R20,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	ST   -Y,R18
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x49:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4A:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4B:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	SBIW R30,4
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x52:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGW1:
	OR   R30,R31
	LDI  R30,1
	BREQ __LNEGW1F
	LDI  R30,0
__LNEGW1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
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
