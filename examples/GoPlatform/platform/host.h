#include <stdlib.h>

struct RocStr {
    char* bytes;
    size_t len;
    size_t capacity;
};

extern void roc__main_for_host_1_exposed_generic(const struct RocStr *data);
