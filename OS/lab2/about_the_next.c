#include <stdio.h>

#define LIST_HEAD(name, type)                                           	\
        struct name {                                                           \
                struct type *lh_first;  /* first element */                     \
        }

/*
 * Set a list head variable to LIST_HEAD_INITIALIZER(head)
 * to reset it to the empty list.
 */
#define LIST_HEAD_INITIALIZER(head)                                     \
        { NULL }

/*
 * Use this inside a structure "LIST_ENTRY(type) field" to use
 * x as the list piece.
 *
 * The le_prev points at the pointer to the structure containing
 * this very LIST_ENTRY, so that if we want to remove this list entry,
 * we can do *le_prev = le_next to update the structure pointing at us.
 */
#define LIST_ENTRY(type)                                                	\
        struct {                                                                \
                struct type *le_next;   /* next element */                      \
                struct type **le_prev;  /* address of previous next element */  \
        }

/*
 * List functions.
 */

/*
 * Detect the list named "head" is empty.
 */
#define LIST_EMPTY(head)        ((head)->lh_first == NULL)

/*
 * Return the first element in the list named "head".
 */
#define LIST_FIRST(head)        ((head)->lh_first)

/*
 * Iterate over the elements in the list named "head".
 * During the loop, assign the list elements to the variable "var"
 * and use the LIST_ENTRY structure member "field" as the link field.
 */
#define LIST_FOREACH(var, head, field)                                  \
        for ((var) = LIST_FIRST((head));                                \
                 (var);                                                 \
                 (var) = LIST_NEXT((var), field))

/*
 * Reset the list named "head" to the empty list.
 */
#define LIST_INIT(head) do {                                            \
                LIST_FIRST((head)) = NULL;                              \
        } while (0)

/* Exercise 2.2 */
/*
 * Insert the element "elm" *after* the element "listelm" which is
 * already in the list.  The "field" name is the link element
 * as above.
 */
#define LIST_INSERT_AFTER(listelm, elm, field) do {		                \
                (elm)->field.le_next = (listelm)->field.le_next;                \
                if (LIST_NEXT((listelm), field) != NULL)    	      \
                        LIST_NEXT((listelm), field)->field.le_prev = &(elm)->field.le_next; \
                LIST_NEXT((listelm), field) = (elm);                            \
                (elm)->field.le_prev = &LIST_NEXT((listelm), field);                              \
        } while (0)
        // Note: assign a to b <==> a = b
        //Step 1, assign elm.next to listelm.next.
        //Step 2: Judge whether listelm.next is NULL, if not, then assign listelm.next.pre to a proper value.
        //step 3: Assign listelm.next to a proper value.
        //step 4: Assign elm.pre to a proper value.


/*
 * Insert the element "elm" *before* the element "listelm" which is
 * already in the list.  The "field" name is the link element
 * as above.
 */
#define LIST_INSERT_BEFORE(listelm, elm, field) do {		                \
                (elm)->field.le_prev = (listelm)->field.le_prev;                \
                LIST_NEXT((elm), field) = (listelm);                            \
                *(listelm)->field.le_prev = (elm);                              \
                (listelm)->field.le_prev = &LIST_NEXT((elm), field);            \
        } while (0)

/*
 * Insert the element "elm" at the head of the list named "head".
 * The "field" name is the link element as above.
 */
#define LIST_INSERT_HEAD(head, elm, field) do {                   		      \
                if ((LIST_NEXT((elm), field) = LIST_FIRST((head))) != NULL)    	      \
                        LIST_FIRST((head))->field.le_prev = &LIST_NEXT((elm), field); \
                LIST_FIRST((head)) = (elm);                                           \
                (elm)->field.le_prev = &LIST_FIRST((head));                           \
        } while (0)

/* Exercise 2.2 */
/*
 * Insert the element "elm" at the tail of the list named "head".
 * The "field" name is the link element as above. You can refer to LIST_INSERT_HEAD.
 * Note: this function has big differences with LIST_INSERT_HEAD !
 */
#define LIST_INSERT_TAIL(head, elm, field) do {                   		      \
                if(LIST_FIRST((head))!=NULL){                                           \
                        for ((LIST_NEXT((elm), field)) = LIST_FIRST((head));       \
                                (LIST_NEXT((elm), field));           \
                                (LIST_NEXT((elm), field)) = LIST_NEXT((LIST_NEXT((elm), field)), field));             \
                        LIST_NEXT((elm), field)->field.le_next = (elm);                         \
                        ((elm)->field.le_prev) = &(LIST_NEXT((elm), field));                 \
                        LIST_NEXT((elm), field) = NULL;                                    \
                }                                                       \
                else{                                                                        \
                        LIST_FIRST((head)) = (elm);             \
                        (elm)->field.le_prev = &LIST_FIRST((head));                           \
                }                                                                        \
        } while (0)
/* finish your code here. */


#define LIST_NEXT(elm, field)   ((elm)->field.le_next)

/*
 * Remove the element "elm" from the list.
 * The "field" name is the link element as above.
 */
#define LIST_REMOVE(elm, field) do {                                    	\
                if (LIST_NEXT((elm), field) != NULL)                            \
                        LIST_NEXT((elm), field)->field.le_prev =                \
                                        (elm)->field.le_prev;                   \
                *(elm)->field.le_prev = LIST_NEXT((elm), field);                \
        } while (0)

LIST_HEAD(Page_list, Page);
typedef LIST_ENTRY(Page) Page_LIST_entry_t;

struct Page {
	Page_LIST_entry_t pp_link;	/* free list link */

	// Ref is the count of pointers (usually in page table entries)
	// to this page.  This only holds for pages allocated using
	// page_alloc.  Pages allocated at boot time using pmap.c's "alloc"
	// do not have valid reference count fields.

	unsigned short pp_ref;
};

int main()
{
	
	return 0;
}

