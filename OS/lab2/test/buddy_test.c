static void buddy_test(){
	u_int pa_1, pa_2;
	u_char pi_1, pi_2;
	buddy_alloc(1572864, &pa_1, &pi_1);
	buddy_alloc(1048576, &pa_2, &pi_2);
	printf("%x\n%d\n%x\n%d\n", pa_1, (int)pi_1, pa_2, (int)pi_2);
	buddy_free(pa_1);
	buddy_free(pa_2);
}

void mips_init(){
	mips_detect_memory();
	mips_vm_init();
	page_init();

	buddy_init();
	buddy_test();

	*((volatile char*)(0xB0000010)) = 0;
}
