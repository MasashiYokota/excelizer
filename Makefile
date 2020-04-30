all:
	cd go_src && GOOS=linux GOARCH=amd64 go build -o ../priv/nif_excelize lib.go && cd ..
