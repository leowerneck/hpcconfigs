# Makefile for layered Apptainer build

# Thorn list, defaults to bns.th
THORNLIST ?= bns.th

# Define inputs
OS_INPUT := layer1_os.def
ET_INPUT := layer2_et.def

# Define image names
OS_IMAGE := layer1_os.sif
ET_IMAGE := et_$(basename $(THORNLIST)).sif

# Default target: build the final image
all: $(ET_IMAGE)

# Rule to build the final Einstein Toolkit image
# This depends on the ET definition file, the OS base image, and the thornlist
$(ET_IMAGE): $(OS_INPUT) $(OS_IMAGE) $(ET_INPUT) $(THORNLIST)
	@echo "--- Building Final Einstein Toolkit Image ---"
	@echo "    >>> Using thornlist: $(THORNLIST)"
	apptainer build --force \
		--bind $(shell realpath $(THORNLIST)):/input_thornlist.th \
		$(ET_IMAGE) $(ET_INPUT)

# Rule to build the OS base image
# This depends only on the OS definition file
$(OS_IMAGE): $(OS_INPUT)
	@echo "--- Building Base OS Image ---"
	apptainer build --force $(OS_IMAGE) $(OS_INPUT)

# Rule to clean up generated images
clean:
	@echo "--- Cleaning up generated images ---"
	rm -f $(OS_IMAGE) $(ET_IMAGE)

.PHONY: all clean
