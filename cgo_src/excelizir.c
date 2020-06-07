// #include "libexcelizir.h"
#include <stdio.h>
#include "erl_nif.h"
#include "libgo_excelizir.h"

// --------------------------- Workbook ---------------------------

ERL_NIF_TERM read_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return ReadSheet(env, argc, argv);
}

ERL_NIF_TERM open_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_schedule_nif(env, "OpenFile", ERL_NIF_DIRTY_JOB_IO_BOUND, OpenFile, argc, argv);
}

ERL_NIF_TERM new_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewFile(env, argc, argv);
}

ERL_NIF_TERM new_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewSheet(env, argc, argv);
}

ERL_NIF_TERM set_active_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetActiveSheet(env, argc, argv);
}

ERL_NIF_TERM save_as(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_schedule_nif(env, "SaveAs", ERL_NIF_DIRTY_JOB_IO_BOUND, SaveAs, argc, argv);
}

ERL_NIF_TERM save(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_schedule_nif(env, "Save", ERL_NIF_DIRTY_JOB_IO_BOUND, Save, argc, argv);
}

ERL_NIF_TERM delete_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
	return DeleteSheet(env, argc, argv);
}

ERL_NIF_TERM copy_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
	return CopySheet(env, argc, argv);
}

ERL_NIF_TERM set_sheet_background(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
	return SetSheetBackground(env, argc, argv);
}

ERL_NIF_TERM get_active_sheet_index(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
	return GetActiveSheetIndex(env, argc, argv);
}

ERL_NIF_TERM close_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return CloseFile(env, argc, argv);
}

// --------------------------- Cell ---------------------------
ERL_NIF_TERM set_cell_value(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellValue(env, argc, argv);
}

ERL_NIF_TERM set_cell_style(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellStyle(env, argc, argv);
}

// --------------------------- StreamWrite ---------------------------
ERL_NIF_TERM set_row(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_schedule_nif(env, "SetRow", ERL_NIF_DIRTY_JOB_CPU_BOUND, SetRow, argc, argv);
}

static ErlNifFunc excelixir_nif_funcs[] = {
  {"read_sheet", 2, read_sheet},
  {"open_file", 1, open_file},
  {"new_file", 0, new_file},
  {"new_sheet", 2, new_sheet},
  {"set_active_sheet", 2, set_active_sheet},
  {"save_as", 2, save_as},
  {"save", 1, save},
  {"delete_sheet", 2, delete_sheet},
  {"copy_sheet", 3, copy_sheet},
  {"set_sheet_background", 3, set_sheet_background},
  {"get_active_sheet_index", 1, get_active_sheet_index},
  {"close_file", 1, close_file},
  {"set_cell_value", 5, set_cell_value},
  {"set_cell_style", 5, set_cell_style},
  {"set_row", 4, set_row},
};

ERL_NIF_INIT(Elixir.Excelizir.Base, excelixir_nif_funcs, NULL, NULL, NULL, NULL)
