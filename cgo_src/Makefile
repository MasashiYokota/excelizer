ERL_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)
CFLAGS = -fPIC -Wall -I$(ERL_PATH)/include -std=gnu99 -arch x86_64 -finline-functions
LDFLAGS = -L$(ERL_PATH)/lib -arch x86_64 -flat_namespace -undefined suppress

libgo_excelizir.a: excelizir.go
	CGO_CFLAGS='${CFLAGS}' CGO_LDFLAGS='${LDFLAGS}' go build -v -buildmode=c-archive -o libgo_excelizir.a excelizir.go

libgo_excelizir.h: excelizir.go
	go tool cgo -exportheader libgo_excelizir.h excelizir.go

excelizir_nif.so: excelizir.c libgo_excelizir.a libgo_excelizir.h
	gcc ${CFLAGS} -shared -dynamiclib -I. -L. ${LDFLAGS} -L. -lgo_excelizir excelizir.c -o excelizir_nif.so

clean:
	rm -rf excelizir_nif.so libgo_excelizir.h libgo_excelizir.a

.PHONY: clean