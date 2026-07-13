#include <REGX52.H>
void Delay(xms)		//@12.000MHz
{
	unsigned char i, j;
while(xms--)
{i = 2;
	j = 239;
	do
	{
		while (--j);
	} while (--i);
}
	}

void main()
{ unsigned char LEDnum;
	while(1)
	{if(P3_1==0)
	{Delay(20);
	while(P3_1==0);
	Delay(20);
	LEDnum++;
	P2=~LEDnum;}
		
		}
	}
