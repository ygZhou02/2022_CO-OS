#include <env.h>
#include <pmap.h>
#include <printf.h>
#include <queue.h>

/* Overview:
 *  Implement simple round-robin scheduling.
 *
 *
 * Hints:
 *  1. The variable which is for counting should be defined as 'static'.
 *  2. Use variable 'env_sched_list', which is a pointer array.
 *  3. CANNOT use `return` statement!
 */
/*** exercise 3.15 ***/
//提示1：使用静态变量来存储当前进程剩余执行次数、当前进程、当前正在遍历的队列等。

//提示 2：调度队列中并不一定只存在状态为 ENV_RUNNABLE 的进程


void sched_yield(void)
{
    static int count = 0; // remaining time slices of current env
    static int point = 0; // current env_sched_list index
    static struct Env *e = NULL;
    /*  hint:
     *  1. if (count==0), insert `e` into `env_sched_list[1-point]`
     *     using LIST_REMOVE and LIST_INSERT_TAIL.
     *  2. if (env_sched_list[point] is empty), point = 1 - point;
     *     then search through `env_sched_list[point]` for a runnable env `e`, 
     *     and set count = e->env_pri
     *  3. count--
     *  4. env_run()
     *
     *  functions or macros below may be used (not all):
     *  LIST_INSERT_TAIL, LIST_REMOVE, LIST_FIRST, LIST_EMPTY
     */
	/* 当前count为0即当前进程时间片消耗尽；e=NULL即还未开始调度第一个进程；当前进程的状态不是可运行的 */
     if (count == 0 || e == NULL || e->env_status != ENV_RUNNABLE) {
         /* e非NULL即当前有进程正在进行 */
         if (e != NULL) {
             /* 从当前的sched链表中移出 */
             LIST_REMOVE(e, env_sched_link);
             /* 当前进程的状态仍然是可运行的，则需要从sched链表中移出并将其插入另一个sched链表 */
             if (e->env_status != ENV_FREE) {
                 LIST_INSERT_HEAD(&env_sched_list[1 - point], e, env_sched_link);
             }
         }
         while (1) {
             /* 如果当前的sched链表空了，转向另外的链表 */
             while(LIST_EMPTY(&env_sched_list[point])) {
                 point = 1 - point;
             }
             /* 取出链表中的第一个进程 */
             e = LIST_FIRST(&env_sched_list[point]);
             /* 如果这个进程状态是free的，直接删除 */
             if (e->env_status == ENV_FREE) {
                 LIST_REMOVE(e, env_sched_link);
             } else if (e->env_status == ENV_NOT_RUNNABLE) {
                 /* 如果当前进程不可调度，将其转移到对面链表的末尾 */
                 LIST_REMOVE(e, env_sched_link);
                 LIST_INSERT_HEAD(&env_sched_list[1 - point], e, env_sched_link);
             } else {
                 /* 找到了合法的可调度进程，设置count为优先级即该进程要运行的时间片的数量，退出死循环 */
                 count = e->env_pri;
                 break;
             }
         }
     }
	/* 消耗一个时间片 */
     count--;
	/* 新进程被调度1次 */
     e->env_runs++;
	// printf("\n%d\n",e->env_id);
	/* 运行进程 */
     env_run(e);
}

    /*  hint:
     *  1. if (count==0), insert `e` into `env_sched_list[1-point]`
     *     using LIST_REMOVE and LIST_INSERT_TAIL.
     *  2. if (env_sched_list[point] is empty), point = 1 - point;
     *     then search through `env_sched_list[point]` for a runnable env `e`, 
     *     and set count = e->env_pri
     *  3. count--
     *  4. env_run()
     *
     *  functions or macros below may be used (not all):
     *  LIST_INSERT_TAIL, LIST_REMOVE, LIST_FIRST, LIST_EMPTY
     */
