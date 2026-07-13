#include <REGX52.H>
#include "Delay.h"
#include "LCD1602.h"
int num=0;
main()
{
LCD_Init();
LCD_ShowString(1,1,"Crazy Thursday");
LCD_ShowChar(2,1,'V');
LCD_ShowChar(2,3,'I');
LCD_ShowNum(2,5,50,2);
LCD_ShowString(2,8,"eat KFC");
    while(1)
    {

     }

}
