#include <REGX52.H>
#include "Time0.h"
#include "Key.h"
#include <INTRINS.H>

unsigned char KeyNum;
unsigned char LEDmode=0;
void Timer0_Routine() interrupt 1
{static unsigned int count=0;
	count++;
	TL0 = 0x18;		//??????
	TH0 = 0xFC;	
		if(count==300)
		{count=0;
			if(LEDmode==0){P2=_crol_(P2,1);}
			if(LEDmode==1){P2=_cror_(P2,1);}
				
		}

}	


void main()
{P2=0xFE;
Timer0Init();
    while(1)
    {KeyNum=Key();
			if(KeyNum)
			{if(KeyNum==1)
				{LEDmode++;
					if(LEDmode>=2)
					{LEDmode=0;}}
				
				
				
				
				
				
			}
      
      
    }

}
