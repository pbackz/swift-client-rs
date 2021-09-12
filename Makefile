all := $(wildcard *.sh)

check-all: ; shellcheck -x $(all)
