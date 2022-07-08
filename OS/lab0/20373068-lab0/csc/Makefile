fibomake: code/fibo.c code/main.c
	gcc -c code/fibo.c -I./include/ -o ./code/fibo.o
	gcc -c code/main.c -I./include/ -o ./code/main.o
	gcc code/fibo.o code/main.o -o fibo
clean:
	rm code/fibo.o code/main.o
