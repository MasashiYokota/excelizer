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
	"sync"
	"time"
	"unsafe"

	"github.com/360EntSecGroup-Skylar/excelize/v2"
	"github.com/google/uuid"
)

type cstring *C.char

type ExcelizerFile struct {
   sync.Mutex
   data *excelize.File
}

var fileStore map[string]ExcelizerFile

// --------------------------- Workbook ---------------------------

//export ReadSheet
func ReadSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	filename := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	var output []C.ERL_NIF_TERM
	file, err := excelize.OpenFile(filename)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	rows, err := file.GetRows(sheetName)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
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
	filename := extractArgAsGoString(env, argv, 0)
	file, err := excelize.OpenFile(filename)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	fileId := registerFilePtr(file)
	erlFileId := convertGoStringToErlBinary(env, fileId)
	status := convertGoStringToErlAtom(env, "ok")

	return C.enif_make_tuple2(env, status, erlFileId)
}

//export NewFile
func NewFile(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	file := excelize.NewFile()
	fileId := registerFilePtr(file)
	erlFileId := convertGoStringToErlBinary(env, fileId)
	status := convertGoStringToErlAtom(env, "ok")

	return C.enif_make_tuple2(env, status, erlFileId)
}

//export SaveAs
func SaveAs(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	path := extractArgAsGoString(env, argv, 1)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	if err := file.data.SaveAs(path); err != nil {
		return returnErrorStatusWithMessage(env,  err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export Save
func Save(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	if err := file.data.Save(); err != nil {
		return returnErrorStatusWithMessage(env,  err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export DeleteSheet
func DeleteSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	file.data.DeleteSheet(sheetName)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export CopySheet
func CopySheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	from := extractArgAsGoInt(env, argv, 1)
	to := extractArgAsGoInt(env, argv, 2)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	if err := file.data.CopySheet(from, to) ; err != nil {
		return returnErrorStatusWithMessage(env,  err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export SetSheetBackground
func SetSheetBackground(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	picturePath := extractArgAsGoString(env, argv, 2)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	if err := file.data.SetSheetBackground(sheetName, picturePath); err != nil {
		return returnErrorStatusWithMessage(env,  err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export GetActiveSheetIndex
func GetActiveSheetIndex(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	activeSheetIndex := file.data.GetActiveSheetIndex()
	erlActiveSheetIndexTerm := convertGoIntToErlInt(env, activeSheetIndex)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, erlActiveSheetIndexTerm)
}

//export SetActiveSheetVisible
func SetActiveSheetVisible(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	value := extractArgAsGoString(env, argv, 2)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env,  "given invalid file id")
	}
	boolValue := true
	if value == "true" {
		boolValue = true
	} else if value == "false" {
		boolValue = false
	} else {
		return returnErrorStatusWithMessage(env,  "given invalid value")
	}
	file.Lock()
	defer file.Unlock()
	if err := file.data.SetSheetVisible(sheetName, boolValue); err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export CloseFile
func CloseFile(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	err := releaseFilePtr(fileId)
	if err != nil {
		return convertGoStringToErlAtom(env, "error")
	}
	return convertGoStringToErlAtom(env, "ok")
}

// --------------------------- Worksheet ---------------------------

//export SetColWidth
func SetColWidth(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	startCol := extractArgAsGoString(env, argv, 2)
	endCol := extractArgAsGoString(env, argv, 3)
	width := extractArgAsGoFloat64(env, argv, 4)

	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	err := file.data.SetColWidth(sheetName, startCol, endCol, width)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export SetRowHeight
func SetRowHeight(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	row := extractArgAsGoInt(env, argv, 2)
	height := extractArgAsGoFloat64(env, argv, 3)

	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	err := file.data.SetRowHeight(sheetName, row, height)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export SetColVisible
func SetColVisible(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	col := extractArgAsGoString(env, argv, 2)
	visible := extractArgAsGoBoolean(env, argv, 3)

	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	err := file.data.SetColVisible(sheetName, col, visible)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export SetRowVisible
func SetRowVisible(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	row := extractArgAsGoInt(env, argv, 2)
	visible := extractArgAsGoBoolean(env, argv, 3)

	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	err := file.data.SetRowVisible(sheetName, row, visible)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export NewSheet
func NewSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	index := file.data.NewSheet(sheetName)
	erlIndex := convertGoIntToErlInt(env, index)

	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, erlIndex)
}

//export SetActiveSheet
func SetActiveSheet(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetId := extractArgAsGoInt(env, argv, 1)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	file.data.SetActiveSheet(sheetId)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

// --------------------------- Cell ---------------------------

//export SetCellValue
func SetCellValue(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	column := extractArgAsGoString(env, argv, 2)
	valueType := extractArgAsGoString(env, argv, 3)
	erlValueTerm := C.get_arg(argv, 4)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}

	value, err := convertErlTermToColumnValue(env, erlValueTerm, valueType)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	file.Lock()
	defer file.Unlock()
	file.data.SetCellValue(sheetName, column, value)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

//export SetCellStyle
func SetCellStyle(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	vcell := extractArgAsGoString(env, argv, 2)
	hcell := extractArgAsGoString(env, argv, 3)
	style := extractArgAsGoString(env, argv, 4)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	styleId, err := file.data.NewStyle(style)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	file.data.SetCellStyle(sheetName, hcell, vcell, styleId)
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

// --------------------------- StreamWrite ---------------------------

//export SetRow
func SetRow(env *C.ErlNifEnv, argc C.int, argv *C.nif_arg_t) C.ERL_NIF_TERM {
	erlRowsTerm := C.get_arg(argv, 3)
	fileId := extractArgAsGoString(env, argv, 0)
	sheetName := extractArgAsGoString(env, argv, 1)
	column := extractArgAsGoString(env, argv, 2)
	file, ok := fileStore[fileId]
	if ok == false {
		return returnErrorStatusWithMessage(env, "given invalid file id")
	}
	file.Lock()
	defer file.Unlock()
	streamWriter, err := file.data.NewStreamWriter(sheetName)
	if err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	var rows []interface{}
	var styleIDStore map[string]int
	var erlHeadTerm, erlTailTerm C.ERL_NIF_TERM
	for C.enif_get_list_cell(env, erlRowsTerm, &erlHeadTerm, &erlTailTerm) != 0 {
		var erlTupleTerm *C.ERL_NIF_TERM
		var cTupleLength C.int
		if C.enif_get_tuple(env, erlTailTerm, &cTupleLength, &erlTupleTerm) == 0 {
			return returnErrorStatusWithMessage(env, "Invalid tuple error: tuple length must be 3")
		}
		var erlValueType, erlStyle C.ErlNifBinary
		erlValueTypeTerm := C.get_arg(erlTupleTerm, 0)
		erlStyleTerm := C.get_arg(erlTupleTerm, 1)
		erlValueTerm := C.get_arg(erlTupleTerm, 2)
		C.enif_inspect_binary(env, erlValueTypeTerm, &erlValueType)
		C.enif_inspect_binary(env, erlStyleTerm, &erlStyle)
		style := convertErlBinaryToGoString(erlStyle)
		var styleID int
		styleID, ok = styleIDStore[style]
		if !ok {
			styleID, err = file.data.NewStyle(style)
			if err != nil {
				return returnErrorStatusWithMessage(env, err.Error())
			}
			styleIDStore[style] = styleID
		}

		valueType := convertErlBinaryToGoString(erlValueType)
		value, err := convertErlTermToColumnValue(env, erlValueTerm, valueType)
		if err != nil {
			return returnErrorStatusWithMessage(env, err.Error())
		}
		rows = append(rows, excelize.Cell{StyleID: styleID, Value: value})
	}

	if err = streamWriter.SetRow(column, rows); err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	if err := streamWriter.Flush(); err != nil {
		return returnErrorStatusWithMessage(env, err.Error())
	}
	status := convertGoStringToErlAtom(env, "ok")
	return C.enif_make_tuple2(env, status, convertGoStringToErlBinary(env, fileId))
}

// --------------------------- PrivFunction ---------------------------

func registerFilePtr(data *excelize.File) string {
	if fileStore == nil {
		fileStore = make(map[string]ExcelizerFile)
	}
	uuidObject := uuid.New()
	uuidStr := uuidObject.String()
	fileStore[uuidStr] = ExcelizerFile{data: data}
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
	return C.GoStringN(c, C.int(term.size))
}

func convertErlTermToColumnValue(env *C.ErlNifEnv, erlValueTerm C.ERL_NIF_TERM, valueType string) (interface{}, error) {
	if valueType == "string" && C.enif_is_binary(env, erlValueTerm) == 1 {
		var erlValue C.ErlNifBinary;
		C.enif_inspect_binary(env, erlValueTerm, &erlValue)
		value := convertErlBinaryToGoString(erlValue)
		return value, nil
	} else if valueType == "float" && C.enif_is_number(env, erlValueTerm) == 1 {
		var cValue C.double;
		C.enif_get_double(env, erlValueTerm, &cValue)
		value := float64(cValue)
		return value, nil
	} else if valueType == "int" && C.enif_is_number(env, erlValueTerm) == 1 {
		var cValue C.ErlNifSInt64;
		C.enif_get_int64(env, erlValueTerm, &cValue)
		value := int(cValue)
		return value, nil
	} else if valueType == "boolean" && C.enif_is_binary(env, erlValueTerm) == 1 {
		var erlValue C.ErlNifBinary;
		C.enif_inspect_binary(env, erlValueTerm, &erlValue)
		value := convertErlBinaryToGoString(erlValue)
		if value == "true" {
			return true, nil
		} else if value == "false" {
			return false, nil
		} else {
			return nil, errors.New("invalid boolean value: boolean type value must be 'true' or 'false' string")
		}
	} else if valueType == "datetime" && C.enif_is_binary(env, erlValueTerm) == 1 {
		var erlValue C.ErlNifBinary;
		C.enif_inspect_binary(env, erlValueTerm, &erlValue)
		value := convertErlBinaryToGoString(erlValue)
		timeValue, err := time.Parse(time.RFC3339, value)
		if err != nil {
			return nil, errors.New("invalid datetime value format: datetime format must be RFC3339")
		}
		return timeValue, nil
	} else if valueType == "nil" {
		return nil, nil
	} else {
		return nil, errors.New("given invalid value type. supported types are binary or number")
	}
}

func returnErrorStatusWithMessage(env *C.ErlNifEnv, message string) C.ERL_NIF_TERM {
	status := convertGoStringToErlAtom(env, "error")
	messageBinary := convertGoStringToErlBinary(env, message)
	return C.enif_make_tuple2(env, status, messageBinary)
}

func extractArgAsGoString(env *C.ErlNifEnv, argv *C.nif_arg_t, argIndex int) string {
	var erlValue C.ErlNifBinary;
	erlValueTerm := C.get_arg(argv, C.int(argIndex))
	C.enif_inspect_binary(env, erlValueTerm, &erlValue);
	return convertErlBinaryToGoString(erlValue)
}

func extractArgAsGoBoolean(env *C.ErlNifEnv, argv *C.nif_arg_t, argIndex int) bool {
	var erlValue C.ErlNifBinary;
	erlValueTerm := C.get_arg(argv, C.int(argIndex))
	C.enif_inspect_binary(env, erlValueTerm, &erlValue);
	data := convertErlBinaryToGoString(erlValue)
	if data == "true" {
		return true
	} else {
		return false
	}
}

func extractArgAsGoInt(env *C.ErlNifEnv, argv *C.nif_arg_t, argIndex int) int {
	var erlValue C.ErlNifSInt64;
	erlValueTerm := C.get_arg(argv, C.int(argIndex))
	C.enif_get_int64(env, erlValueTerm, &erlValue);
	return int(erlValue)
}

func extractArgAsGoFloat64(env *C.ErlNifEnv, argv *C.nif_arg_t, argIndex int) float64 {
	var erlValue C.ErlNifSInt64;
	erlValueTerm := C.get_arg(argv, C.int(argIndex))
	C.enif_get_long(env, erlValueTerm, &erlValue);
	return float64(erlValue)
}

func main() {}
