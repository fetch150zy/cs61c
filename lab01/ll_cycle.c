#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    node* p1 = head;
    node* p2 = head;
    while (p1 != NULL && p2 != NULL) {
        p2 = p2->next;
        if (p1 == p2)
            return 1;
        p1 = p1->next;
        if (p1 == NULL || p2 == NULL)
            break;
        p2 = p2->next;
    }
    return 0;
}