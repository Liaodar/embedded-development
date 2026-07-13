#include <REGX52.H>
#include "Delay.h"
#include "juzheng.h"
#include "LCD1602.h"


void main()
{unsigned char num;
unsigned int ni;
unsigned char n=0;
LCD_Init();
LCD_ShowString(1,1,"It is what?");
while(1)
{num=MatrixKey();
		if(num)
		{		
		    if(num<=10)
				{ if(n==0)
				{ni=num%10;
				 LCD_ShowNum(2,1,ni,4);
				 n++;
				}
				else if(n>0&&n<4)
				{ni=ni*10+num%10;
				 LCD_ShowNum(2,1,ni,4);
				 n++;
					}}
		
		    
					
				if(n==4)
				{if(num==11)
				{if(ni==1234)
				{LCD_ShowString(1,1,"           ");
				LCD_ShowString(1,1,"OK");
				LCD_ShowNum(2,1,0,4);
				 }
				 else
				 {LCD_ShowString(1,1,"           ");
				 LCD_ShowString(1,1,"FUCK YOU");
				 LCD_ShowNum(2,1,0,4);}
				 }
				 else if(num==12)
				 {n=0,ni=0;
				 LCD_ShowString(1,1,"It is what?");
				 LCD_ShowNum(2,1,ni,4);}}				
				
				
				
				
				 
				



		}


}


}
//num=MatrixKey();
//if(num)
//{LCD_ShowNum(2,1,num,2);