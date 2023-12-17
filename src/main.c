#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int c_function(int x);
extern int rust_function(int x);
extern int asm_function(int x);
extern int cython_function(int x);

int main(int argc, char **argv) {

    printf("And the whole world was of one language, and of one speech...\n");

    int x = 1;
    x = c_function(x);
    printf("c_function: returned %d\n", x);

    x = rust_function(x);
    printf("rust_function: returned %d\n", x);

    x = asm_function(x);
    printf("asm_function: returned %d\n", x);

    x = cython_function(x);
    printf("cython_function: returned %d\n", x);

    return x;
}
