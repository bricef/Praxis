



BINARY_DIRS = $(sort $(subst cmd,bin,$(wildcard ./cmd/*)))
SOURCES = $(shell find pkg -type f -name '*.go')

all: ${BINARY_DIRS}

bin/%: cmd/%/main.go ${SOURCES}
	go build -o $@ $<

clean:
	rm -rf bin

test:
	go clean -testcache
	go test ./...

output/%.png: bin/%
	$<

.PHONY: clean test run build