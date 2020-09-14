all:
	mkdir -p priv && cd cgo_src && rm -rf excelizer_nif.so libgo_excelizer.h libgo_excelizer.a && make excelizer_nif.so && cd .. && cp cgo_src/excelizer_nif.so priv

format:
	astyle -s2 -n --style=google cgo_src/*.c

check:
	astyle -s2 -n --style=google --dry-run cgo_src/excelizer.c

clean:
	cd cgo_src && make clean && cd .. && rm priv/excelizer_nif.so

.PHONY: clean
