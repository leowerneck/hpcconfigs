# Makefile for layered Apptainer build

# Thorn list, defaults to bns.th
THORNLIST ?= bns.th

# Define inputs
OS_INPUT  := layer1_os.def
UCX_INPUT := layer2_ucx.def
MPI_INPUT := layer3_mpi.def
LOR_INPUT := layer4_lorene.def
ET_INPUT  := layer5_et.def

# Define image names
OS_IMAGE  := $(OS_INPUT:.def=.sif)
UCX_IMAGE := $(UCX_INPUT:.def=.sif)
MPI_IMAGE := $(MPI_INPUT:.def=.sif)
LOR_IMAGE := $(LOR_INPUT:.def=.sif)
ET_IMAGE  := et.sif

# Get full path to thornlist
THORNLIST_FULLPATH := $(shell realpath $(THORNLIST))

# Default target: build the final image
all: $(ET_IMAGE)

# Rule to build the final Einstein Toolkit image
# This depends on the ET definition file, the OS base image, and the thornlist
$(ET_IMAGE): $(ET_INPUT) $(LOR_IMAGE)
	@echo "=== Building Layer 5 --- Einstein Toolkit ==="
	apptainer build --force                            \
		--bind $(THORNLIST_FULLPATH):/input_thornlist.th \
		$(ET_IMAGE) $(ET_INPUT)

$(LOR_IMAGE): $(LOR_INPUT) $(MPI_IMAGE)
	@echo "=== Building Layer 4 --- LORENE ==="
	apptainer build --force $(LOR_IMAGE) $(LOR_INPUT)

$(MPI_IMAGE): $(MPI_INPUT) $(UCX_IMAGE)
	@echo "=== Building Layer 3 --- MPI ==="
	apptainer build --force $(MPI_IMAGE) $(MPI_INPUT)

$(UCX_IMAGE): $(UCX_INPUT) $(OS_IMAGE)
	@echo "=== Building Layer 2 --- UCX ==="
	apptainer build --force $(UCX_IMAGE) $(UCX_INPUT)

$(OS_IMAGE): $(OS_INPUT)
	@echo "=== Building Layer 1 --- Base OS Image ==="
	apptainer build --force $(OS_IMAGE) $(OS_INPUT)

# Rule to clean up generated images
clean:
	@echo "=== Cleaning up generated images ==="
	rm -f $(OS_IMAGE) $(UCX_IMAGE) $(MPI_IMAGE) $(LOR_IMAGE) $(ET_IMAGE)

.PHONY: all clean
