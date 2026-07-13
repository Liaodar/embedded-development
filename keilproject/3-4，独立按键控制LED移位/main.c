#include <REGX52.H>

void Delay(unsigned int xms)		//@12.000MHz
{
	unsigned char i, j;
while(xms--)
{
	i = 2;
	j = 239;
	do
	{
		while (--j);
	} while (--i);
}
}
char LEDnum;
void main()
{

while(1)
{if(P3_1==0)
{Delay(20);//20
while(P3_1==0);
Delay(20);

LEDnum++;

if(LEDnum>=8)
	LEDnum=0;
P2=~(0x01<<LEDnum);

}
//30

if(P3_0==0)
{Delay(20);
while(P3_0==0);
Delay(20);
LEDnum--;
if(LEDnum<0)
	LEDnum=7;
P2=~(0x01<<LEDnum);





}}
}
