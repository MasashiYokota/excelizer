all:
	cd go_src && make && cd .. && cp go_src/*.so priv
