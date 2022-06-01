static void page_protect_test(){
	extern struct Page *pages;
	struct Page *pp;
	printf("%d\n", page_protect(pages + 16383));
	printf("%d\n", page_protect(pages + 16383));
	page_alloc(&pp), pp->pp_ref++;
	printf("%d\n", page2ppn(pp));
	printf("%d\n", page_protect(pp));
	printf("%d\n", page_status_query(pp));
	printf("%d\n", page_status_query(pages + 16383));
	printf("%d\n", page_status_query(pages + 16381));
	page_decref(pp);
	printf("%d\n", page_status_query(pp));
}

void mips_init(){
	mips_detect_memory();
	mips_vm_init();
	page_init();

	page_protect_test();

	*((volatile char*)(0xB0000010)) = 0;
}
