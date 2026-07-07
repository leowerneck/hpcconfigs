#!/bin/bash

set -e

# Title    : Teton Environment for ET/Lorene
# Author   : Leo Werneck
# Date     : 2026-02-19
# Compiler : gcc 13.4.0
# MPI      : OpenMPI 5.0.9
# Status   : Working
module purge
module load                    \
  gcc/13.4.0-gcc11-5dyu        \
  openmpi/5.0.9-gcc13-3nks     \
  hdf5/1.14.6-gcc13-ompi5-uw6m \
  fftw/3.3.10-gcc13-omp

# Useful helper to get the base path of the modules
get_module_path() {
  path=$(module show "$1" 2>&1 | awk -F \" '
  /^prepend_path{"PATH"/ {sub(/\/bin$/, "", $4); print $4; exit}
  /^prepend_path{"LIBRARY_PATH"/ {sub(/\/lib$/, "", $4); print $4; exit}
  /^prepend_path{"CPATH"/ {sub(/\/include$/, "", $4); print $4; exit}
  /^prepend_path{"LD_LIBRARY_PATH"/ {sub(/\/lib$/, "", $4); print $4; exit}')
  if [ ! -d "$path" ]; then
    echo "Error: could not find path for module $1"
    exit 1
  fi
  echo "$path"
}

if [[ -z ${LOCAL_ROOT:-} ]]; then
    echo "
LOCAL_ROOT environment variable must be set.
This directory should contain the installation of the following libraries:
  - hwloc
  - gsl
  - openblas
"
    exit 1
fi

if [[ -z ${ET_WORK_DIR:-} ]]; then
    echo "
ET_WORK_DIR environment variable must be set.
This directory represents the working directory where the ET will reside. It
is normally set to somewhere in /scratch/\${USER}.
"
    exit 1
fi

# Local module directory
SZIP_LIB_DIR=/apps/spack/opt/gcc-13.4.0/libaec-1.1.5-6ljsh6eimvuvw26cjuqtrzemvkorexjp/lib64

# Adjust these manually if module isn't available
OMPI_ENV_ROOT=$(get_module_path openmpi)
HDF5_ENV_ROOT=$(get_module_path hdf5)
FFTW_ENV_ROOT=$(get_module_path fftw)
HWLOC_ENV_ROOT=$LOCAL_ROOT
GSL_ENV_ROOT=$LOCAL_ROOT
OPENBLAS_ENV_ROOT=$LOCAL_ROOT

# Download Lorene, if not found
export HOME_LORENE=${ET_WORK_DIR}/Lorene
if [[ ! -d $HOME_LORENE ]]; then
    wget https://github.com/leowerneck/apptainer_libs/raw/refs/heads/main/Lorene.tar.gz
    tar xzvf Lorene.tar.gz
    rm -f Lorene.tar.gz
fi

# Generate ET configuration file
cat << EOF > "${ET_WORK_DIR}"/et.cfg
# These options expect you to have ran the following command:
# module load                    \\
#   gcc/13.4.0-gcc11-5dyu        \\
#   openmpi/5.0.9-gcc13-3nks     \\
#   hdf5/1.14.6-gcc13-ompi5-uw6m \\
#   fftw/3.3.10-gcc13-omp
VERSION = teton-gcc13-2026-02-19

CPP = cpp
FPP = cpp
CC  = mpicc
CXX = mpicxx
F77 = mpifort
F90 = mpifort

CPPFLAGS = -O2 -D_XOPEN_SOURCE -D_XOPEN_SOURCE_EXTENDED
FPPFLAGS = -O2 -traditional
CFLAGS   = -O2 -march=native -std=c99
CXXFLAGS = -O2 -march=native -std=c++17
F77FLAGS = -O2 -march=native -fcray-pointer -ffixed-line-length-none -fno-range-check
F90FLAGS = -O2 -march=native -fcray-pointer -ffixed-line-length-none -fno-range-check

LDFLAGS = -rdynamic

C_LINE_DIRECTIVES = yes
F_LINE_DIRECTIVES = yes

VECTORISE                            = yes
VECTORISE_INLINE                     = yes
VECTORISE_ALWAYS_USE_UNALIGNED_LOADS = yes

DEBUG           = no
CPP_DEBUG_FLAGS = -DCARPET_DEBUG
FPP_DEBUG_FLAGS = -DCARPET_DEBUG
C_DEBUG_FLAGS   = -O0
CXX_DEBUG_FLAGS = -O0
F77_DEBUG_FLAGS = -O0 -check bounds -check format
F90_DEBUG_FLAGS = -O0 -check bounds -check format

OPTIMISE           = yes
CPP_OPTIMISE_FLAGS =
FPP_OPTIMISE_FLAGS =
C_OPTIMISE_FLAGS   = -O2
CXX_OPTIMISE_FLAGS = -O2
F77_OPTIMISE_FLAGS = -O2
F90_OPTIMISE_FLAGS = -O2

CPP_NO_OPTIMISE_FLAGS  =
FPP_NO_OPTIMISE_FLAGS  =
C_NO_OPTIMISE_FLAGS    = -O0
CXX_NO_OPTIMISE_FLAGS  = -O0
CUCC_NO_OPTIMISE_FLAGS =
F77_NO_OPTIMISE_FLAGS  = -O0
F90_NO_OPTIMISE_FLAGS  = -O0

PROFILE           = no
CPP_PROFILE_FLAGS =
FPP_PROFILE_FLAGS =
C_PROFILE_FLAGS   = -pg
CXX_PROFILE_FLAGS = -pg
F77_PROFILE_FLAGS = -pg
F90_PROFILE_FLAGS = -pg

OPENMP           = yes
CPP_OPENMP_FLAGS = -fopenmp
FPP_OPENMP_FLAGS = -fopenmp
C_OPENMP_FLAGS   = -fopenmp
CXX_OPENMP_FLAGS = -fopenmp
F77_OPENMP_FLAGS = -fopenmp
F90_OPENMP_FLAGS = -fopenmp

WARN           = yes
CPP_WARN_FLAGS =
FPP_WARN_FLAGS =
C_WARN_FLAGS   =
CXX_WARN_FLAGS =
F77_WARN_FLAGS =
F90_WARN_FLAGS =

MPI_DIR      = ${OMPI_ENV_ROOT}
MPI_INC_DIRS = ${OMPI_ENV_ROOT}/include
MPI_LIB_DIRS = ${OMPI_ENV_ROOT}/lib

HDF5_DIR      = ${HDF5_ENV_ROOT}
HDF5_INC_DIRS = ${HDF5_ENV_ROOT}/include
HDF5_LIB_DIRS = ${HDF5_ENV_ROOT}/lib ${SZIP_LIB_DIR}
HDF5_LIBS     = hdf5

HWLOC_DIR      = ${HWLOC_ENV_ROOT}
HWLOC_INC_DIRS = ${HWLOC_ENV_ROOT}/include
HWLOC_LIB_DIRS = ${HWLOC_ENV_ROOT}/lib
HWLOC_LIBS     = hwloc

PTHREADS_DIR = NO_BUILD

# These lines are needed if you plan on using the latest version
# of LORENE (e.g., for tabulated EOS). You may need to build your
# own GSL/FFTW3, and also export the lib paths below to LD_LIBRARY_PATH
# in your job scripts.
GSL_DIR      = ${GSL_ENV_ROOT}
GSL_INC_DIRS = ${GSL_ENV_ROOT}/include
GSL_LIB_DIRS = ${GSL_ENV_ROOT}/lib
GSL_LIBS     = gsl

FFTW3_DIR      = ${FFTW_ENV_ROOT}
FFTW3_INC_DIRS = ${FFTW_ENV_ROOT}/include
FFTW3_LIB_DIRS = ${FFTW_ENV_ROOT}/lib
FFTW3_LIBS     = fftw3

OPENBLAS_DIR      = ${OPENBLAS_ENV_ROOT}
OPENBLAS_INC_DIRS = ${OPENBLAS_ENV_ROOT}/include
OPENBLAS_LIB_DIRS = ${OPENBLAS_ENV_ROOT}/lib
OPENBLAS_LIBS     = openblas

LORENE_DIR = $HOME_LORENE
EOF

# Generate LORENE local settings
cat << EOF > "${HOME_LORENE}"/local_settings
GSL_DIR  = ${GSL_ENV_ROOT}
FFTW_DIR = ${FFTW_ENV_ROOT}

CXX = g++
F77 = gfortran

CXXFLAGS = -O3 -fopenmp -march=native -DNDEBUG -std=c++17 -DMPICH_IGNORE_CXX_SEEK -rdynamic
F77FLAGS = -O3 -fopenmp -march=native -DNDEBUG -fcray-pointer -ffixed-line-length-none -fno-range-check

INC        = -I\$(HOME_LORENE)/C++/Include -I\$(HOME_LORENE)/C++/Include_extra -I\$(GSL_DIR)/include -I\$(FFTW_DIR)/include
RANLIB     = ls
MAKEDEPEND = cpp \$(INC) -M >> \$(df).d \$<
DEPDIR     = .deps
FFT_DIR    = FFTW3
LIB_CXX    = -L\$(FFTW_DIR)/lib -lfftw3
LIB_LAPACK =
LIB_GSL    = -L\$(GSL_DIR)/lib -lgsl -lgslcblas
LIB_PGPLOT =
EOF
