#include <REGX52.H>
void Timer0Init(void)		//1??@12.000MHz
{

	TMOD &= 0xF0;		//
	TMOD |= 0x01;		//???????
	TL0 = 0x18;		//?
	TH0 = 0xFC;		//??????
	TF0 = 0;		//
	TR0 = 1;
ET0=1;
	EA=1;
	PT0=0;	//???0????
}
/*void Timer0Init(void)		//1毫秒@12.000MHz
{
	TMOD &= 0xF0;		//设置定时器模式
	TMOD |= 0x01;		//设置定时器模式
	TL0 = 0x18;		//设置定时初值
	TH0 = 0xFC;		//设置定时初值
	TF0 = 0;		//清除TF0标志
	TR0 = 1;
ET0=1;
	EA=1;
	PT0=0;	//定时器0开始计时
}*/
