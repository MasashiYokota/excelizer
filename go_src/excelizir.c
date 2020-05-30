// #include "libexcelizir.h"
#include <stdio.h>
#include "erl_nif.h"
#include "libgo_excelizir.h"

ERL_NIF_TERM read_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary erl_filename;
  ErlNifBinary erl_sheet_name;
  enif_inspect_binary(env, argv[0], &erl_filename);
  enif_inspect_binary(env, argv[1], &erl_sheet_name);
  return ReadSheet(env, erl_filename, erl_sheet_name);
}

ERL_NIF_TERM open_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary erl_filename;
  enif_inspect_binary(env, argv[0], &erl_filename);
  return OpenFile(env, erl_filename);
}

ERL_NIF_TERM new_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary erl_file_id;
  ErlNifBinary erl_sheet_name;
  enif_inspect_binary(env, argv[0], &erl_file_id);
  enif_inspect_binary(env, argv[1], &erl_sheet_name);
  return NewSheet(env, erl_file_id, erl_sheet_name);
}

ERL_NIF_TERM close_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary erl_file_id;
  enif_inspect_binary(env, argv[0], &erl_file_id);
  return CloseFile(env, erl_file_id);
}

static ErlNifFunc excelixir_nif_funcs[] = {
  {"read_sheet", 2, read_sheet},
  {"open_file", 1, open_file},
  {"close_file", 1, close_file},
};

ERL_NIF_INIT(Elixir.Excelizir.Base, excelixir_nif_funcs, NULL, NULL, NULL, NULL)
