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

ERL_NIF_TERM new_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return NewSheet(env, argc, argv);
}

ERL_NIF_TERM set_cell_value(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetCellValue(env, argc, argv);
}

ERL_NIF_TERM set_active_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return SetActiveSheet(env, argc, argv);
}

ERL_NIF_TERM close_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return CloseFile(env, argc, argv);
}

static ErlNifFunc excelixir_nif_funcs[] = {
  {"read_sheet", 2, read_sheet},
  {"open_file", 1, open_file},
  {"new_sheet", 2, new_sheet},
  {"set_cell_value", 4, set_cell_value},
  {"set_active_sheet", 2, set_active_sheet},
  {"close_file", 1, close_file},
};

ERL_NIF_INIT(Elixir.Excelizir.Base, excelixir_nif_funcs, NULL, NULL, NULL, NULL)
