#include <REGX52.H>
#include "Delay.h"

sbit RCK=P3^5;//RCLK
sbit SCK=P3^6;//SRCLK
sbit SER=P3^4;//SER

#define MATRIX_LED_PORT  P0

/**
  *@brief  74HC595 write a word
  *@param	 need word
  *@retval	no
  */

void _74HC595_WriteByte(unsigned char Byte)
{unsigned char i;
	for(i=0;i<8;i++)
	{
	SER=Byte&(0x80>>i);
	SCK=1;
	SCK=0;	
	}
	RCK=1;
	RCK=0;
}

/**
  *@brief	LED show a date
	*@param	column range:0~7,0 is the left
	*@param	date is the datein the column 
	range:0~7,0 in the down,light is 1;
  *@retval no
  */

void MatrixLED_ShowColun(unsigned char Column,Date)
{
	_74HC595_WriteByte(Date);
	P0=~(0x80>>Column);
	Delay(1);
	P0=0xFF;
}

void main()
{		SCK=0;
	  RCK=0;
	
    while(1)
    {MatrixLED_ShowColun(0,0x70);
		 MatrixLED_ShowColun(1,0x88);
		 MatrixLED_ShowColun(2,0x84);
		 MatrixLED_ShowColun(3,0x42);
		 MatrixLED_ShowColun(4,0x42); 
		 MatrixLED_ShowColun(5,0x84);
		 MatrixLED_ShowColun(6,0x88);
			MatrixLED_ShowColun(7,0x70);
     }
}