// #include "libexcelizir.h"
#include <stdio.h>
#include "erl_nif.h"
#include "libgo_excelizer.h"

// --------------------------- Workbook ---------------------------

ERL_NIF_TERM read_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return ReadSheet(env, argc, argv);
}

ERL_NIF_TERM open_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return OpenFile(env, argc, argv);
}

ERL_NIF_TERM new_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewFile(env, argc, argv);
}

ERL_NIF_TERM save_as(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SaveAs(env, argc, argv);
}

ERL_NIF_TERM save(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return Save(env, argc, argv);
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

ERL_NIF_TERM set_sheet_visible(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetSheetVisible(env, argc, argv);
}

ERL_NIF_TERM get_sheet_visible(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetSheetVisible(env, argc, argv);
}

ERL_NIF_TERM close_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return CloseFile(env, argc, argv);
}

// --------------------------- Worksheet ---------------------------
ERL_NIF_TERM set_col_width(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetColWidth(env, argc, argv);
}

ERL_NIF_TERM set_row_height(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetRowHeight(env, argc, argv);
}

ERL_NIF_TERM set_col_visible(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetColVisible(env, argc, argv);
}

ERL_NIF_TERM set_row_visible(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetRowVisible(env, argc, argv);
}

ERL_NIF_TERM new_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewSheet(env, argc, argv);
}

ERL_NIF_TERM set_active_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetActiveSheet(env, argc, argv);
}

ERL_NIF_TERM get_sheet_name(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetSheetName(env, argc, argv);
}

ERL_NIF_TERM get_col_visible(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetColVisible(env, argc, argv);
}

ERL_NIF_TERM get_col_width(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetColWidth(env, argc, argv);
}

ERL_NIF_TERM get_row_height(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetRowHeight(env, argc, argv);
}

ERL_NIF_TERM get_row_visible(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetRowVisible(env, argc, argv);
}

ERL_NIF_TERM get_sheet_index(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetSheetIndex(env, argc, argv);
}

ERL_NIF_TERM set_sheet_name(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetSheetName(env, argc, argv);
}

ERL_NIF_TERM insert_col(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return InsertCol(env, argc, argv);
}

ERL_NIF_TERM insert_row(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return InsertRow(env, argc, argv);
}

ERL_NIF_TERM remove_col(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return RemoveCol(env, argc, argv);
}

ERL_NIF_TERM remove_row(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return RemoveRow(env, argc, argv);
}

// --------------------------- Cell ---------------------------
ERL_NIF_TERM set_cell_value(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellValue(env, argc, argv);
}

ERL_NIF_TERM set_cell_style(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellStyle(env, argc, argv);
}

ERL_NIF_TERM merge_cell(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return MergeCell(env, argc, argv);
}

ERL_NIF_TERM unmerge_cell(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return UnmergeCell(env, argc, argv);
}

ERL_NIF_TERM set_cell_formula(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellFormula(env, argc, argv);
}

ERL_NIF_TERM get_cell_formula(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return GetCellFormula(env, argc, argv);
}

// --------------------------- Image ---------------------------
ERL_NIF_TERM add_picture(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return AddPicture(env, argc, argv);
}

ERL_NIF_TERM add_picture_from_bytes(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return AddPictureFromBytes(env, argc, argv);
}

// --------------------------- StreamWrite ---------------------------
ERL_NIF_TERM set_row(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetRow(env, argc, argv);
}

static ErlNifFunc excelixir_nif_funcs[] = {
  {"read_sheet", 2, read_sheet},
  {"open_file", 1, open_file, ERL_NIF_DIRTY_JOB_IO_BOUND},
  {"new_file", 0, new_file},
  {"new_sheet", 2, new_sheet},
  {"set_col_visible", 4, set_col_visible},
  {"set_row_visible", 4, set_row_visible},
  {"set_col_width", 5, set_col_width},
  {"set_row_height", 4, set_row_height},
  {"set_active_sheet", 2, set_active_sheet},
  {"get_sheet_name", 2, get_sheet_name},
  {"get_col_visible", 3, get_col_visible},
  {"get_col_width", 3, get_col_width},
  {"get_row_height", 3, get_row_height},
  {"get_row_visible", 3, get_row_visible},
  {"get_sheet_index", 2, get_sheet_index},
  {"set_sheet_name", 3, set_sheet_name},
  {"insert_col", 3, insert_col},
  {"insert_row", 3, insert_row},
  {"remove_col", 3, remove_col},
  {"remove_row", 3, remove_row},
  {"save_as", 2, save_as, ERL_NIF_DIRTY_JOB_IO_BOUND},
  {"save", 1, save, ERL_NIF_DIRTY_JOB_IO_BOUND},
  {"delete_sheet", 2, delete_sheet},
  {"copy_sheet", 3, copy_sheet},
  {"set_sheet_background", 3, set_sheet_background},
  {"get_active_sheet_index", 1, get_active_sheet_index},
  {"set_sheet_visible", 3, set_sheet_visible},
  {"get_sheet_visible", 2, get_sheet_visible},
  {"close_file", 1, close_file},
  {"set_cell_value", 5, set_cell_value},
  {"set_cell_style", 5, set_cell_style},
  {"merge_cell", 4, merge_cell},
  {"unmerge_cell", 4, unmerge_cell},
  {"set_cell_formula", 4, set_cell_formula},
  {"get_cell_formula", 3, get_cell_formula},
  {"add_picture", 5, add_picture},
  {"add_picture_from_bytes", 7, add_picture_from_bytes},
  {"set_row", 4, set_row, ERL_NIF_DIRTY_JOB_CPU_BOUND},
};

ERL_NIF_INIT(Elixir.Excelizer.Native.Base, excelixir_nif_funcs, NULL, NULL, NULL, NULL)
