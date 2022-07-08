OUTPUT_ARCH(mips)
/*
指定输出可执行文件的平台为mips
*/
ENTRY(_start)
/*
指定输出可执行文件的起始代码段为_start
*/
SECTIONS
{
	. = 0x80010000;

	.text : { *(.text) }

	.data : { *(.data) }
	.bss : { *(.bss) }

end = . ;
}
