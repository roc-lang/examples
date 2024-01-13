package main

/*
#cgo LDFLAGS: ./main.o -ldl
#include "./host.h"
*/
import "C"

import (
	"fmt"
	"unsafe"
)

func main() {
	var str C.struct_RocStr
	C.roc__mainForHost_1_exposed_generic(&str)
	fmt.Print(readRocStr(str))
}

const is64Bit = uint64(^uintptr(0)) == ^uint64(0)

func readRocStr(str C.struct_RocStr) string {
	if int(str.capacity) < 0 {
		// Small string
		ptr := (*byte)(unsafe.Pointer(&str))

		byteLen := 12
		if is64Bit {
			byteLen = 24
		}

		shortStr := unsafe.String(ptr, byteLen)
		len := shortStr[byteLen-1] ^ 128
		return shortStr[:len]
	}

	ptr := (*byte)(unsafe.Pointer(str.bytes))
	return unsafe.String(ptr, str.len)
}

//export roc_alloc
func roc_alloc(size C.ulong, alignment int) unsafe.Pointer {
	return C.malloc(size)
}

//export roc_realloc
func roc_realloc(ptr unsafe.Pointer, newSize, _ C.ulong, alignment int) unsafe.Pointer {
	return C.realloc(ptr, newSize)
}

//export roc_dealloc
func roc_dealloc(ptr unsafe.Pointer, alignment int) {
	C.free(ptr)
}
