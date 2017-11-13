BINARY_NAME=cpp17csv
COMPILER=ponyc

all: compile

compile:
	$(COMPILER)

test: compile
	./test.sh

.PHONY: clean

clean:
	rm $(BINARY_NAME)
