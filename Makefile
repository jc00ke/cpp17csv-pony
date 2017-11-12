BINARY_NAME=cpp17csv
COMPILER=ponyc

all:
	$(COMPILER)

.PHONY: clean

clean:
	rm $(BINARY_NAME)
