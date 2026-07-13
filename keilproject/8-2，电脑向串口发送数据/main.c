#include <REGX52.H>
#include "Delay.h"
#include "UART.h"

unsigned char Sec;

void main()
{
	UART_Init();			//串口初始化
	while(1)
	{
		
	}
}
void UART_Routinr() interrupt 4
{
	
	if(RI==1)
	{
		P2=SBUF;
		UART_SendByte(SBUF);
		RI=0;
	}
}