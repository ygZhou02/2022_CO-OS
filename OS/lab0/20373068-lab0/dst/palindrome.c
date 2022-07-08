#include<stdio.h>
int main()
{
	int n;
	scanf("%d",&n);
	int i=0;
	int flag = 0;
	while(n>0){
		int a = n % 10;
		int c = n;
		int d;
		int b=1;
		while(c>0){
			d = c % 10;
			c /=10;
			b *= 10;
		}
		b *= d;
		if(a != d){
			flag = 1;	
			break;
		}
		b /= 10;
		n -= b;
		n /= 10;

	}

	if(!flag){
		printf("Y");
	}else{
		printf("N");
	}
	return 0;
}
