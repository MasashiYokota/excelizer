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
	"errors"
	"fmt"
	"unsafe"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/google/uuid"
)

type cstring *C.char

var fileStore map[string]*excelize.File

//export ReadSheet
func ReadSheet(env *C.ErlNifEnv, enifFilename, enifSheetName C.ErlNifBinary) C.ERL_NIF_TERM {
	filename := convertErlBinaryToGoString(enifFilename)
	sheetName := convertErlBinaryToGoString(enifSheetName)
	var output []C.ERL_NIF_TERM
	file, err := excelize.OpenFile(filename)
	if err != nil {
		fmt.Println(err.Error())
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "load error")
		return C.enif_make_tuple2(env, status, message)
	}
	rows := file.GetRows(sheetName)
	for _, row := range rows {
		var outputRow []C.ERL_NIF_TERM;
		for _, col := range row {
			outputRow = append(outputRow, convertGoStringToErlBinary(env, col))
		}
		erlRow := ConvertErlTermArrayToErlList(env, outputRow)
		output = append(output, erlRow)
	}
	status := convertGoStringToErlAtom(env, "ok")
	result := ConvertErlTermArrayToErlList(env, output)
	return C.enif_make_tuple2(env, status, result)
}

//export OpenFile
func OpenFile(env *C.ErlNifEnv, enifFilename C.ErlNifBinary) C.ERL_NIF_TERM {
	filename := convertErlBinaryToGoString(enifFilename)
	file, err := excelize.OpenFile(filename)
	if err != nil {
		fmt.Println(err.Error())
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "failed to open file")
		return C.enif_make_tuple2(env, status, message)
	}
	fileId := registerFilePtr(file)
	erlFileId := convertGoStringToErlBinary(env, fileId)
	status := convertGoStringToErlAtom(env, "ok")

	return C.enif_make_tuple2(env, status, erlFileId)
}

//export NewSheet
func NewSheet(env *C.ErlNifEnv, enifFileId, enifSheetName C.ErlNifBinary) C.ERL_NIF_TERM {
	sheetName := convertErlBinaryToGoString(enifSheetName)
	fileId := convertErlBinaryToGoString(enifFileId)
	file, ok := fileStore[fileId]
	if ok == false {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid file id")
		return C.enif_make_tuple2(env, status, message)
	}
	index := file.NewSheet(sheetName)
	erlIndex := convertGoIntToErlInt(env, index)

	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, erlIndex)
}

//export CloseFile
func CloseFile(env *C.ErlNifEnv, erlFileId C.ErlNifBinary) C.ERL_NIF_TERM {
	fileId := convertErlBinaryToGoString(erlFileId)
	err := releaseFilePtr(fileId)
	if err != nil {
		return convertGoStringToErlAtom(env, "error")
	}
	return convertGoStringToErlAtom(env, "ok")
}

func registerFilePtr(file *excelize.File) string {
	if fileStore == nil {
		fileStore = make(map[string]*excelize.File)
	}
	uuidObject := uuid.New()
	uuidStr := uuidObject.String()
	fileStore[uuidStr] = file
	return uuidStr
}

func releaseFilePtr(fileId string) (error) {
	_, ok := fileStore[fileId]
	if ok == false {
		return errors.New("fileId not found")
	}
	delete(fileStore, fileId)
	return nil
}

func convertGoStringToErlBinary(env *C.ErlNifEnv, message string) C.ERL_NIF_TERM {
	bin := []byte(message)
	binSize := C.size_t(len(bin))
	var nifBin C.ErlNifBinary;
	if binSize > 0 && C.enif_alloc_binary(binSize, &nifBin) == 1 {
		C.update_binary(&nifBin, unsafe.Pointer(&bin[0]), binSize)
	}
	return C.enif_make_binary(env, &nifBin)
}

func ConvertErlTermArrayToErlList(env *C.ErlNifEnv, array []C.ERL_NIF_TERM) C.ERL_NIF_TERM {
	arraySize := C.unsigned(len(array))
	return C.enif_make_list_from_array(env, (*C.ERL_NIF_TERM)(&array[0]), arraySize)
}

func convertGoStringToErlAtom(env *C.ErlNifEnv, message string) C.ERL_NIF_TERM {
	cmessage := C.CString(message)
	defer C.free(unsafe.Pointer(cmessage))
	return C.enif_make_atom(env, cmessage)
}

func convertGoIntToErlInt(env *C.ErlNifEnv, value int) C.ERL_NIF_TERM {
	return C.enif_make_int64(env, C.ErlNifSInt64(value))
}

// ref: https://stackoverflow.com/questions/59827026/cgo-convert-go-string-to-c-uchar
func convertErlBinaryToGoString(term C.ErlNifBinary) string {
	c := (*C.char)(unsafe.Pointer(term.data))
	return C.GoString(c)
}

func main() {}
