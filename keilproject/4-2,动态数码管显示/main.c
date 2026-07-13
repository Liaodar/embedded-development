#include <REGX52.H>
void Delay(xms)		//@12.000MHz
{
	unsigned char i, j;

	
	while(xms--)
{	i = 2;
	j = 239;
	do
	{
		while (--j);
		} while (--i);}
}

sum[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
void show(int LED,int num)
{switch(LED)
{case 1:P2_4=1;P2_3=1;P2_2=1;break;
 case 2:P2_4=1;P2_3=1;P2_2=0;break;
 case 3:P2_4=1;P2_3=0;P2_2=1;break;
 case 4:P2_4=1;P2_3=0;P2_2=0;break;
 case 5:P2_4=0;P2_3=1;P2_2=1;break;
 case 6:P2_4=0;P2_3=1;P2_2=0;break;
 case 7:P2_4=0;P2_3=0;P2_2=1;break;
 case 8:P2_4=0;P2_3=0;P2_2=0;break;
}P0=sum[num];
Delay(1);
P0=0x00;
}
void main()
{

#include <REGX52.H>
void Delay(xms)		//@12.000MHz
{
	unsigned char i, j;

	
	while(xms--)
{	i = 2;
	j = 239;
	do
	{
		while (--j);
		} while (--i);}
}

sum[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
void show(int LED,int num)
{switch(LED)
{case 1:P2_4=1;P2_3=1;P2_2=1;break;
 case 2:P2_4=1;P2_3=1;P2_2=0;break;
 case 3:P2_4=1;P2_3=0;P2_2=1;break;
 case 4:P2_4=1;P2_3=0;P2_2=0;break;
 case 5:P2_4=0;P2_3=1;P2_2=1;break;
 case 6:P2_4=0;P2_3=1;P2_2=0;break;
 case 7:P2_4=0;P2_3=0;P2_2=1;break;
 case 8:P2_4=0;P2_3=0;P2_2=0;break;
}P0=sum[num];
Delay(1);
P0=0x00;
}
void main()
{


while(1)
   {show(1,9);
	 show(2,1);
	 show(5,2);
	 show(6,7);
	 show(7,7);
	 show(8,8) ;
	 
	 
	 
	 
	 }



}
while(1)
   {show(1,9);
	 show(2,1);
	 show(5,2);
	 show(6,7);
	 show(7,7);
	 show(8,8) ;
	 
	 
	 
	 
	 }



}