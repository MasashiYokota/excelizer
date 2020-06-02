// #include "libexcelizir.h"
#include <stdio.h>
#include "erl_nif.h"
#include "libgo_excelizir.h"

ERL_NIF_TERM read_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return ReadSheet(env, argc, argv);
}

ERL_NIF_TERM open_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return OpenFile(env, argc, argv);
}

ERL_NIF_TERM new_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewFile(env, argc, argv);
}

ERL_NIF_TERM new_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewSheet(env, argc, argv);
}

ERL_NIF_TERM set_cell_value(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellValue(env, argc, argv);
}

ERL_NIF_TERM set_cell_style(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellStyle(env, argc, argv);
}

ERL_NIF_TERM set_row(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetRow(env, argc, argv);
}

ERL_NIF_TERM set_active_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetActiveSheet(env, argc, argv);
}

ERL_NIF_TERM save_as(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SaveAs(env, argc, argv);
}

ERL_NIF_TERM close_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return CloseFile(env, argc, argv);
}

static ErlNifFunc excelixir_nif_funcs[] = {
  {"read_sheet", 2, read_sheet},
  {"open_file", 1, open_file},
  {"new_file", 0, new_file},
  {"new_sheet", 2, new_sheet},
  {"set_cell_value", 5, set_cell_value},
  {"set_cell_style", 5, set_cell_style},
  {"set_row", 4, set_row},
  {"set_active_sheet", 2, set_active_sheet},
  {"save_as", 2, save_as},
  {"close_file", 1, close_file},
};

ERL_NIF_INIT(Elixir.Excelizir.Base, excelixir_nif_funcs, NULL, NULL, NULL, NULL)