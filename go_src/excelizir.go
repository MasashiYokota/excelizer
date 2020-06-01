package main

/*
#include "erl_nif.h"
#include <string.h>

typedef const ERL_NIF_TERM nif_arg_t;

static void update_binary(ErlNifBinary* bin, void* str, size_t size) {
	memcpy(bin->data, str, size);
}

static ERL_NIF_TERM get_arg(ERL_NIF_TERM* arg, int index) {
	return arg[index];
}

*/
import "C"
import (
	"errors"
	"fmt"
	"time"
	"unsafe"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/google/uuid"
)

type cstring *C.char

var fileStore map[string]*excelize.File

//export ReadSheet
func ReadSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFilename, erlSheetName C.ErlNifBinary;
	erlFilenameTerm := C.get_arg(argv, 0)
	erlSheetNameTerm := C.get_arg(argv, 1)
	C.enif_inspect_binary(env, erlFilenameTerm, &erlFilename);
	C.enif_inspect_binary(env, erlSheetNameTerm, &erlSheetName);

	filename := convertErlBinaryToGoString(erlFilename)
	sheetName := convertErlBinaryToGoString(erlSheetName)
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
func OpenFile(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFilename C.ErlNifBinary;
	erlFilenameTerm := C.get_arg(argv, 0)
	C.enif_inspect_binary(env,erlFilenameTerm, &erlFilename);

	filename := convertErlBinaryToGoString(erlFilename)
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
func NewSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFileId, erlSheetName C.ErlNifBinary;
	erlFileIdTerm := C.get_arg(argv, 0)
	erlSheetNameTerm := C.get_arg(argv, 1)
	C.enif_inspect_binary(env, erlFileIdTerm, &erlFileId);
	C.enif_inspect_binary(env, erlSheetNameTerm, &erlSheetName);

	sheetName := convertErlBinaryToGoString(erlSheetName)
	fileId := convertErlBinaryToGoString(erlFileId)
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

//export SetCellValue
func SetCellValue(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFileId, erlSheetName, erlColumn, erlValueType C.ErlNifBinary;
	erlFileIdTerm := C.get_arg(argv, 0)
	erlSheetNameTerm := C.get_arg(argv, 1)
	erlColumnTerm := C.get_arg(argv, 2)
	erlValueTypeTerm := C.get_arg(argv, 3)
	erlValueTerm := C.get_arg(argv, 4)
	C.enif_inspect_binary(env, erlFileIdTerm, &erlFileId);
	C.enif_inspect_binary(env, erlSheetNameTerm, &erlSheetName);
	C.enif_inspect_binary(env, erlColumnTerm, &erlColumn);
	C.enif_inspect_binary(env, erlValueTypeTerm, &erlValueType);

	fileId := convertErlBinaryToGoString(erlFileId)
	sheetName := convertErlBinaryToGoString(erlSheetName)
	column := convertErlBinaryToGoString(erlColumn)
	valueType := convertErlBinaryToGoString(erlValueType)
	file, ok := fileStore[fileId]
	if ok == false {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid file id")
		return C.enif_make_tuple2(env, status, message)
	}

	if valueType == "string" && C.enif_is_binary(env, erlValueTerm) == 1 {
		var erlValue C.ErlNifBinary;
		C.enif_inspect_binary(env, erlValueTerm, &erlValue)
		value := convertErlBinaryToGoString(erlValue)
		file.SetCellStr(sheetName, column, value)
		status := convertGoStringToErlAtom(env, "ok")
		return C.enif_make_tuple2(env, status, erlFileIdTerm)
	} else if valueType == "float" && C.enif_is_number(env, erlValueTerm) == 1 {
		var cValue C.double;
		C.enif_get_double(env, erlValueTerm, &cValue)
		value := float64(cValue)
		file.SetCellValue(sheetName, column, value)
		status := convertGoStringToErlAtom(env, "ok")
		return C.enif_make_tuple2(env, status, erlFileIdTerm)
	} else if valueType == "int" && C.enif_is_number(env, erlValueTerm) == 1 {
		var cValue C.ErlNifSInt64;
		C.enif_get_int64(env, erlValueTerm, &cValue)
		value := int(cValue)
		file.SetCellInt(sheetName, column, value)
		status := convertGoStringToErlAtom(env, "ok")
		return C.enif_make_tuple2(env, status, erlFileIdTerm)
	} else if valueType == "boolean" && C.enif_is_binary(env, erlValueTerm) == 1 {
		var erlValue C.ErlNifBinary;
		C.enif_inspect_binary(env, erlValueTerm, &erlValue)
		value := convertErlBinaryToGoString(erlValue)
		if value == "true" {
			file.SetCellBool(sheetName, column, true)
		} else if value == "false" {
			file.SetCellBool(sheetName, column, false)
		} else {
			status := convertGoStringToErlAtom(env, "error")
			message := convertGoStringToErlBinary(env, "invalid boolean value: boolean type value must be 'true' or 'false' string")
			return C.enif_make_tuple2(env, status, message)
		}
		status := convertGoStringToErlAtom(env, "ok")
		return C.enif_make_tuple2(env, status, erlFileIdTerm)
	} else if valueType == "datetime" && C.enif_is_binary(env, erlValueTerm) == 1 {
		var erlValue C.ErlNifBinary;
		C.enif_inspect_binary(env, erlValueTerm, &erlValue)
		value := convertErlBinaryToGoString(erlValue)
		timeValue, err := time.Parse(time.RFC3339, value)
		if err != nil {
			status := convertGoStringToErlAtom(env, "error")
			message := convertGoStringToErlBinary(env, "invalid datetime value format: datetime format must be RFC3339")
			return C.enif_make_tuple2(env, status, message)
		}
		file.SetCellValue(sheetName, column, timeValue)
		status := convertGoStringToErlAtom(env, "ok")
		return C.enif_make_tuple2(env, status, erlFileIdTerm)
	} else {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid value type. supported types are binary or number")
		return C.enif_make_tuple2(env, status, message)
	}
}

//export SetCellStyle
func SetCellStyle(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFileId, erlSheetName, erlVCell, erlHCell, erlStyle C.ErlNifBinary;
	erlFileIdTerm := C.get_arg(argv, 0)
	erlSheetNameTerm := C.get_arg(argv, 1)
	erlHCellTerm := C.get_arg(argv, 2)
	erlVCellTerm := C.get_arg(argv, 3)
	erlStyleTerm := C.get_arg(argv, 4)
	C.enif_inspect_binary(env, erlFileIdTerm, &erlFileId);
	C.enif_inspect_binary(env, erlSheetNameTerm, &erlSheetName);
	C.enif_inspect_binary(env, erlVCellTerm, &erlVCell);
	C.enif_inspect_binary(env, erlHCellTerm, &erlHCell);
	C.enif_inspect_binary(env, erlStyleTerm, &erlStyle);
	fileId := convertErlBinaryToGoString(erlFileId)
	sheetName := convertErlBinaryToGoString(erlSheetName)
	vcell := convertErlBinaryToGoString(erlVCell)
	hcell := convertErlBinaryToGoString(erlHCell)
	style := convertErlBinaryToGoString(erlStyle)
	file, ok := fileStore[fileId]
	if ok == false {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid file id")
		return C.enif_make_tuple2(env, status, message)
	}
	styleId, err := file.NewStyle(style)
	if err != nil {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid style")
		return C.enif_make_tuple2(env, status, message)
	}
	file.SetCellStyle(sheetName, hcell, vcell, styleId)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, erlFileIdTerm)
}

//export SetActiveSheet
func SetActiveSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFileId C.ErlNifBinary;
	var erlSheetId C.ErlNifSInt64;
	erlFileIdTerm := C.get_arg(argv, 0)
	erlSheetIdTerm := C.get_arg(argv, 1)
	C.enif_inspect_binary(env, erlFileIdTerm, &erlFileId);
	C.enif_get_int64(env, erlSheetIdTerm, &erlSheetId);

	fileId := convertErlBinaryToGoString(erlFileId)
	sheetId := int(erlSheetId)
	file, ok := fileStore[fileId]
	if ok == false {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid file id")
		return C.enif_make_tuple2(env, status, message)
	}
	file.SetActiveSheet(sheetId)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, erlFileIdTerm)
}

//export SaveAs
func SaveAs(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFileId, erlPath C.ErlNifBinary;
	erlFileIdTerm := C.get_arg(argv, 0)
	erlPathTerm := C.get_arg(argv, 1)
	C.enif_inspect_binary(env, erlFileIdTerm, &erlFileId);
	C.enif_inspect_binary(env, erlPathTerm, &erlPath);

	fileId := convertErlBinaryToGoString(erlFileId)
	path := convertErlBinaryToGoString(erlPath)
	file, ok := fileStore[fileId]
	if ok == false {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "given invalid file id")
		return C.enif_make_tuple2(env, status, message)
	}
	if err := file.SaveAs(path); err != nil {
		status := convertGoStringToErlAtom(env, "error")
		message := convertGoStringToErlBinary(env, "failed to save")
		return C.enif_make_tuple2(env, status, message)
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, erlFileIdTerm)
}

//export CloseFile
func CloseFile(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	var erlFileId C.ErlNifBinary;
	erlFileIdTerm := C.get_arg(argv, 0)
	C.enif_inspect_binary(env, erlFileIdTerm, &erlFileId);
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

func convertErlNumberToGoFloat64(env *C.ErlNifEnv, erlValue C.ERL_NIF_TERM) (float64, error) {
	var cValue C.double
	if C.enif_get_double(env, erlValue, &cValue) == 0 {
		return 0, errors.New("invalid erlang type")
	}
	return float64(cValue), nil
}

// ref: https://stackoverflow.com/questions/59827026/cgo-convert-go-string-to-c-uchar
func convertErlBinaryToGoString(term C.ErlNifBinary) string {
	c := (*C.char)(unsafe.Pointer(term.data))
	return C.GoString(c)
}

func main() {}
