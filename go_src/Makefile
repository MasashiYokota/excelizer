ERL_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)
CFLAGS = -fPIC -I$(ERL_PATH)/include  -std=gnu99 -arch x86_64  -finline-functions
LDFLAGS = -L$(ERL_PATH)/lib -arch x86_64 -flat_namespace -undefined suppress

do:excelizir
	echo "success"

libexcelizir.so:libexcelizir.go
	CGO_CFLAGS='${CFLAGS}' CGO_LDFLAGS='${LDFLAGS}' go build -v -buildmode=c-shared -o libexcelizir.so libexcelizir.go

libexcelizir.h:libexcelizir.go
	go tool cgo -exportheader libexcelizir.h libexcelizir.go

excelizir:excelizir.c libexcelizir.so libexcelizir.h
	gcc -o excelizir excelizir.c -I./ ${CFLAGS} -L./ ${LDFLAGS} -lexcelizir

clean:
	rm -rf excelizir libexcelizir.h libexcelizir.so
