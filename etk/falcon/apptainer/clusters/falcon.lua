-- Falcon modules
help([[
Falcon (IB/UCX) stack: UCX 1.15.0 + OpenMPI 4.1.6
Sets PATHs for builds and runs on Falcon.
]])
whatis("Falcon UCX/OpenMPI stack")

-- Ensures only one cluster stack is active
family("cluster")

-- Versions & flavor (adjust if you upgrade)
local ucx_ver  = "1.15.0"
local mpi_ver  = "4.1.6"
local mpi_flav = "openmpi"
local blas_ver = "0.3.30"
local blas_flav = "openblas"
local hdf5_ver = "1.14.6"
local fftw_ver = "3.3.10"
local gsl_ver = "2.8"

-- Root derived from your existing layout
local root = pathJoin("/opt", "ucx-"..ucx_ver, mpi_flav.."-"..mpi_ver)

-- Export your original env vars (for scripts that expect them)
setenv("FALCON_ROOT" , root)
setenv("MPI_FLAVOR"  , mpi_flav)
setenv("UCX_VERSION" , ucx_ver)
setenv("MPI_VERSION" , mpi_ver)
setenv("BLAS_FLAVOR" , blas_flav)
setenv("BLAS_VERSION", blas_ver)
setenv("HDF5_VERSION", hdf5_ver)
setenv("FFTW_VERSION", fftw_ver)
setenv("GSL_VERSION" , gsl_ver)
setenv("LIBS_ROOT"   , root)
setenv("LIBS_INC"    , pathJoin(root, "include"))
setenv("LIBS_LIB"    , pathJoin(root, "lib"))
setenv("LIBS_BIN"    , pathJoin(root, "bin"))
setenv("HOME_LORENE" , pathJoin(root, "Lorene"))

-- Paths
prepend_path("PATH",            pathJoin(root, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH",    pathJoin(root, "lib"))
prepend_path("CPATH",           pathJoin(root, "include"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "share/pkgconfig"))
prepend_path("MANPATH",         pathJoin(root, "share/man"))
