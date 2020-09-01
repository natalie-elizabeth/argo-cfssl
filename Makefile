.PHONY: setup csr csr-approve

csr:
	./csr.sh
setup: 
	./setup.sh

csr-approve:
	./csrapprove.sh