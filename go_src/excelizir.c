// #include "libexcelizir.h"
#include <stdio.h>
#include "erl_nif.h"
#include "libgo_excelizir.h"

// erlang string と c string変換 https://stackoverflow.com/questions/12928943/how-do-you-return-a-string-from-an-erlang-c-node

ERL_NIF_TERM read_sheet(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary enifFilename;
  ErlNifBinary enifSheetName;
  enif_inspect_binary(env, argv[0], &enifFilename);
  enif_inspect_binary(env, argv[1], &enifSheetName);
  return ReadSheet(env, enifFilename, enifSheetName);
}

static ErlNifFunc excelixir_nif_funcs[] = {
  {"read_sheet", 2, read_sheet},
};

ERL_NIF_INIT(Elixir.Excelizir.Base, excelixir_nif_funcs, NULL, NULL, NULL, NULL)
