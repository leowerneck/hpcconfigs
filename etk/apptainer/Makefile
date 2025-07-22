# Makefile for layered Apptainer build

# Thorn list, defaults to bns.th
THORNLIST ?= bns.th

# Define inputs
OS_INPUT     := layer1_os.def
LORENE_INPUT := layer2_lorene.def
ET_INPUT     := layer3_et.def

# Define image names
OS_IMAGE     := layer1_os.sif
LORENE_IMAGE := layer2_lorene.sif
ET_IMAGE     := et_$(basename $(THORNLIST)).sif

# Get full path to thornlist
THORNLIST_FULLPATH := $(shell realpath $(THORNLIST))

# Default target: build the final image
all: $(ET_IMAGE)

# Rule to build the final Einstein Toolkit image
# This depends on the ET definition file, the OS base image, and the thornlist
$(ET_IMAGE): $(LORENE_IMAGE) $(ET_INPUT) $(THORNLIST)
	@echo "=== Building Layer 3/3 --- Einstein Tookit ==="
	@echo "    >>> Using thornlist: $(THORNLIST_FULLPATH)"
	apptainer build --force \
		--bind $(THORNLIST_FULLPATH):/input_thornlist.th \
		$(ET_IMAGE) $(ET_INPUT)

$(LORENE_IMAGE): $(LORENE_INPUT) $(OS_IMAGE)
	@echo "=== Building Layer 2/3 --- LORENE ==="
	apptainer build --force $(LORENE_IMAGE) $(LORENE_INPUT)

$(OS_IMAGE): $(OS_INPUT)
	@echo "=== Building Layer 1/3 --- Base OS Image ==="
	apptainer build --force $(OS_IMAGE) $(OS_INPUT)

# Rule to clean up generated images
clean:
	@echo "=== Cleaning up generated images ==="
	rm -f $(OS_IMAGE) $(LORENE_IMAGE) $(ET_IMAGE)

.PHONY: all clean
