ERL_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)
CFLAGS = -fPIC -Wall -I$(ERL_PATH)/include -std=gnu99 -arch x86_64 -finline-functions
LDFLAGS = -L$(ERL_PATH)/lib -arch x86_64 -flat_namespace -undefined suppress

libgo_excelizer.a: excelizer.go
	CGO_CFLAGS='${CFLAGS}' CGO_LDFLAGS='${LDFLAGS}' go build -v -buildmode=c-archive -o libgo_excelizer.a excelizer.go

libgo_excelizer.h: excelizer.go
	go tool cgo -exportheader libgo_excelizer.h excelizer.go

excelizer_nif.so: excelizer.c libgo_excelizer.a libgo_excelizer.h
	gcc ${CFLAGS} -shared -dynamiclib -I. -L. ${LDFLAGS} -L. -lgo_excelizer excelizer.c -o excelizer_nif.so

clean:
	rm -rf excelizer_nif.so libgo_excelizer.h libgo_excelizer.a

.PHONY: clean
