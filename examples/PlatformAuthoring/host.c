#include <inttypes.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* The platform's `provides` entry exposes this C ABI function. */
extern int64_t roc_transform(int64_t value);

/* Runtime callbacks belong to the host. this example accepts alignment up to 8 bytes. */
void *roc_alloc(size_t size, size_t alignment) {
    if (alignment > 8) abort();
    void *ptr = malloc(size == 0 ? 1 : size);
    if (ptr == NULL) abort();
    return ptr;
}

void *roc_realloc(void *ptr, size_t size, size_t alignment) {
    if (alignment > 8) abort();
    void *next = realloc(ptr, size == 0 ? 1 : size);
    if (next == NULL) abort();
    return next;
}

void roc_dealloc(void *ptr, size_t alignment) {
    (void)alignment;
    free(ptr);
}

void roc_dbg(const uint8_t *bytes, size_t len) {
    fwrite(bytes, 1, len, stderr);
    fputc('\n', stderr);
}

void roc_crashed(const uint8_t *bytes, size_t len) {
    roc_dbg(bytes, len);
    exit(1);
}

void roc_expect_failed(const uint8_t *bytes, size_t len) {
    roc_crashed(bytes, len);
}

int main(void) {
    int64_t answer = roc_transform(41);
    printf("%" PRId64 "\n", answer);
    return answer == 42 ? 0 : 1;
}
