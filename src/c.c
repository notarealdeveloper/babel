#include <stdio.h>

int c_function(int x) {
    printf("%s: got value %d\n", __func__, x);
    return 2*x;
}
