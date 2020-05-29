all:
	cd go_src && make excelizir_nif.so && cd .. && cp go_src/excelizir_nif.so priv

clean:
	cd go_src && make clean && cd .. && rm priv/excelizir_nif.so

.PHONY: clean
