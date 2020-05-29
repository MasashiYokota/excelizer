ERL_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)
CFLAGS = -fPIC -I$(ERL_PATH)/include -std=gnu99 -arch x86_64 -finline-functions
LDFLAGS = -L$(ERL_PATH)/lib -arch x86_64 -flat_namespace -undefined suppress

do:excelizir.so
	echo "success"

libgo_excelizir.a:libexcelizir.go
	CGO_CFLAGS='${CFLAGS}' CGO_LDFLAGS='${LDFLAGS}' go build -v -buildmode=c-archive -o libgo_excelizir.a libexcelizir.go

libexcelizir.h:libexcelizir.go
	go tool cgo -exportheader libexcelizir.h libexcelizir.go

excelizir.so:excelizir.c libgo_excelizir.a libexcelizir.h
	gcc ${CFLAGS} -Wall -shared -dynamiclib -I. -L. ${LDFLAGS} -L../priv -lgo_excelizir excelizir.c -o excelizir_nif.so

clean:
	rm -rf excelizir.so libexcelizir.h libgo_excelizir.a
