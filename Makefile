BINARY_NAME=cpp17csv
COMPILER=ponyc
GENERATED_TEST_PREFIX=generated

all: compile

compile:
ifndef "$(DEGUG)"
		$(COMPILER) -d
else
		$(COMPILER)
endif

test: compile
	./test.sh

.PHONY: clean

clean: clean_test_files
	rm $(BINARY_NAME)

clean_test_files:
	rm $(GENERATED_TEST_PREFIX)*
