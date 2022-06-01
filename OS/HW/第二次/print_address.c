#include <stdio.h>
#include <stdlib.h>
int a=0;
int b;

int main()
{
	int c;
	int e;
	int *d = (int*)malloc(sizeof(int));
	int *f = (int*)malloc(sizeof(int));
	printf(".data:%x\n",&a);
	printf(".bss:%x\n",&b);
	printf(".text:%x\n",&main);
	printf("stack:%x\n",&c);
	printf("stack_orientation:%x\n",&e - &c);
	
	printf("heap:%x\n",d);
	printf("heap_orientation:%x\n",f-d);
	
	
	return 0;
}

