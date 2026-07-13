#include <REGX52.H>
#include "Delay.h"
#include "LCD1602.h"
#include "Time0.h"
unsigned char S=50,M=59,H=24;
void main()
{ LCD_Init();
	LCD_ShowString(1,1,"Clock");
	Timer0Init();		
	while(1)
	{
		LCD_ShowNum(2,1,H,2);
		LCD_ShowNum(2,4,M,2);
		LCD_ShowNum(2,7,S,2);
		LCD_ShowString(2,1,"  :  :  ");
		
		
	}
	
	
	
}
void Timer0_Routine() interrupt 1
{ 
static unsigned int T0Count;
TL0 = 0x18;		
	TH0 = 0xFC;	
T0Count++;
if(T0Count==1000)
{T0Count=0;
	S++;
	if(S>=60)
{S=0;M++;
if(M>=60)
{M=0;H++;
if(H>=24)
{H=0;}}
}
	
	
	
}}