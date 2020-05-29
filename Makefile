all:
	cd go_src && make excelizir_nif.so && cd .. && cp go_src/excelizir_nif.so priv

format:
	astyle -s2 -n --style=google go_src/*.c

check:
	astyle -s2 -n --style=google --dry-run go_src/excelizir.c

clean:
	cd go_src && make clean && cd .. && rm priv/excelizir_nif.so

.PHONY: clean
