all:
	cd cgo_src && make excelizir_nif.so && cd .. && cp cgo_src/excelizir_nif.so priv

format:
	astyle -s2 -n --style=google cgo_src/*.c

check:
	astyle -s2 -n --style=google --dry-run cgo_src/excelizir.c

clean:
	cd cgo_src && make clean && cd .. && rm priv/excelizir_nif.so

.PHONY: clean
