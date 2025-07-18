# Makefile for layered Apptainer build

# Define inputs
LAYER1_INPUT := layer1_os.def
LAYER2_INPUT := layer2_et.def

# Define image names
LAYER1_IMAGE := layer1_os.sif
LAYER2_IMAGE := layer2_et.sif

# Default target: build the final image
all: $(LAYER2_IMAGE)

# Rule to build the final Einstein Toolkit image
# This depends on the ET definition file, the OS base image, and the thornlist
$(LAYER2_IMAGE): $(LAYER1_INPUT) $(LAYER1_IMAGE) $(LAYER2_INPUT)
	@echo "--- Building Final Einstein Toolkit Image ---"
	apptainer build --force $(LAYER2_IMAGE) $(LAYER2_INPUT)

# Rule to build the OS base image
# This depends only on the OS definition file
$(LAYER1_IMAGE): $(LAYER1_INPUT)
	@echo "--- Building Base OS Image ---"
	apptainer build --force $(LAYER1_IMAGE) $(LAYER1_INPUT)

# Rule to clean up generated images
clean:
	@echo "--- Cleaning up generated images ---"
	rm -f $(LAYER1_IMAGE) $(LAYER2_IMAGE)

.PHONY: all clean
