#include <REGX52.H>
#include "Delay.h"

unsigned char MatrixKey()
{
unsigned char MatrixKey=0;
P1=0xFF;
P1_3=0;
if(P1_7==0){Delay(20);while(P1_7==0);Delay(20);MatrixKey=1;}
if(P1_6==0){Delay(20);while(P1_6==0);Delay(20);MatrixKey=5;}
if(P1_5==0){Delay(20);while(P1_5==0);Delay(20);MatrixKey=9;}
if(P1_4==0){Delay(20);while(P1_4==0);Delay(20);MatrixKey=13;}

P1=0xFF;
P1_2=0;
if(P1_7==0){Delay(20);while(P1_7==0);Delay(20);MatrixKey=2;}
if(P1_6==0){Delay(20);while(P1_6==0);Delay(20);MatrixKey=6;}
if(P1_5==0){Delay(20);while(P1_5==0);Delay(20);MatrixKey=10;}
if(P1_4==0){Delay(20);while(P1_4==0);Delay(20);MatrixKey=14;}

P1=0xFF;
P1_1=0;
if(P1_7==0){Delay(20);while(P1_7==0);Delay(20);MatrixKey=3;}
if(P1_6==0){Delay(20);while(P1_6==0);Delay(20);MatrixKey=7;}
if(P1_5==0){Delay(20);while(P1_5==0);Delay(20);MatrixKey=11;}
if(P1_4==0){Delay(20);while(P1_4==0);Delay(20);MatrixKey=15;}

P1=0xFF;
P1_0=0;
if(P1_7==0){Delay(20);while(P1_7==0);Delay(20);MatrixKey=4;}
if(P1_6==0){Delay(20);while(P1_6==0);Delay(20);MatrixKey=8;}
if(P1_5==0){Delay(20);while(P1_5==0);Delay(20);MatrixKey=12;}
if(P1_4==0){Delay(20);while(P1_4==0);Delay(20);MatrixKey=16;}


return MatrixKey;
}




