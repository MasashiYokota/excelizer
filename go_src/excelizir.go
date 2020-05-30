package main

/*
#include "erl_nif.h"
#include <string.h>

static void update_binary(ErlNifBinary* bin, void* str, size_t size) {
	memcpy(bin->data, str, size);
}

*/
import "C"
import (
	"fmt"
	"unsafe"

	"github.com/360EntSecGroup-Skylar/excelize"
)

type cstring *C.char

// ref https://stackoverflow.com/questions/39794721/how-to-convert-go-struct-to-c-struct

// for keeping data from GC
var fileInstances map[uintptr]*excelize.File

//export ReadSheet
func ReadSheet(env *C.ErlNifEnv, enifFilename, enifSheetName C.ErlNifBinary) C.ERL_NIF_TERM {
	filename := convertEnifBinaryToGoString(enifFilename)
	sheetName := convertEnifBinaryToGoString(enifSheetName)
	var output []C.ERL_NIF_TERM
	file, err := excelize.OpenFile(filename)
	if err != nil {
		fmt.Println(err.Error())
		enif_status := createEnifAtom(env, "error")
		message := createEnifBinary(env, "load error")
		return C.enif_make_tuple2(env, enif_status, message)
	}
	// Sheet1 のすべてのセルを取得
	rows := file.GetRows(sheetName)
	for _, row := range rows {
		var outputRow []C.ERL_NIF_TERM;
		for _, col := range row {
			outputRow = append(outputRow, createEnifBinary(env, col))
		}
		erlRow := C.enif_make_list_from_array(env, (*C.ERL_NIF_TERM)(&outputRow[0]), C.unsigned(len(outputRow)))
		output = append(output, erlRow)
	}
	enif_status := createEnifAtom(env, "ok")
	result := C.enif_make_list_from_array(env, (*C.ERL_NIF_TERM)(&output[0]), C.unsigned(len(output)))
	return C.enif_make_tuple2(env, enif_status, result)
}

// export OpenFile
func OpenFile(cFilename cstring) (cstring, uintptr) {
	filename := C.GoString(cFilename)
	file, err := excelize.OpenFile(filename)
	var cFilePtr uintptr
	if err != nil {
		fmt.Println(err.Error())
		status := C.CString("error")
		defer C.free(unsafe.Pointer(status))
		return status, cFilePtr
	}
	status := C.CString("ok")
	defer C.free(unsafe.Pointer(status))
	return status, storeFileObjectToGlobalHeap(file)
}

// export CloseFile
func CloseFile(filePtr uintptr) {
	delete(fileInstances, filePtr)
}

func convertFilePtrToUintPtr(file *excelize.File) uintptr {
	return uintptr(unsafe.Pointer(file))
}

func storeFileObjectToGlobalHeap(file *excelize.File) uintptr {
	if fileInstances == nil {
		fileInstances = make(map[uintptr]*excelize.File)
	}
	ptr := convertFilePtrToUintPtr(file)
	fileInstances[ptr] = file
	return ptr
}

func convertUintPtrToFilePtr(p uintptr) *excelize.File {
	return (*excelize.File)(unsafe.Pointer(p))
}

func createEnifBinary(env *C.ErlNifEnv, message string) C.ERL_NIF_TERM {
	bin := []byte(message)
	binSize := C.size_t(len(bin))
	var nifBin C.ErlNifBinary;
	if binSize > 0 && C.enif_alloc_binary(binSize, &nifBin) == 1 {
		// ref: https://taiyoh.hatenablog.com/entry/2013/12/25/230905
		C.update_binary(&nifBin, unsafe.Pointer(&bin[0]), binSize)
	}
	return C.enif_make_binary(env, &nifBin)
}

func createEnifAtom(env *C.ErlNifEnv, message string) C.ERL_NIF_TERM {
	cmessage := C.CString(message)
	defer C.free(unsafe.Pointer(cmessage))
	return C.enif_make_atom(env, cmessage)
}

// ref: https://stackoverflow.com/questions/59827026/cgo-convert-go-string-to-c-uchar
func convertEnifBinaryToGoString(term C.ErlNifBinary) string {
	c := (*C.char)(unsafe.Pointer(term.data))
	return C.GoString(c)
}

func main() {}
