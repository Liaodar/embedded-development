#include <REGX52.H>
#include "Delay.h"
#include "LCD1602.h"
#include "juzheng.h"

void main()
{unsigned char num;
LCD_Init();
LCD_ShowString(1,1,"FUCK YOU");
while(1)
{num=MatrixKey();
if(num)
{LCD_ShowNum(2,1,num,2);}}

}

