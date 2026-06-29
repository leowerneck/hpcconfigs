# Environment Setup for Teton (INL)

The basic usage is to run:
```sh
source env.sh
```
or
```sh
. env.sh
```
to generate the options files for the `Einstein Toolkit` and `LORENE`.

## What You Need to Change

For the command above to work correctly, you need to edit lines 29 and 40 in the file `env.sh` so that it correctly exports your local root directory and your et work directory. If you don't want to edit the file, you can run something like this:
```sh
export YOUR_LOCAL_DIR=/path/to/your/local/dir
export YOUR_ET_WORK_DIR=/path/to/your/et/work/dir
. env.sh
```

This is not recommended, though; it's usually better to just edit the `env.sh` file and place it somewhere in your scratch or home directory so it can be easily accessed.

## What You Need to Compile

For Teton specifically, you currently have to compile the following yourself:
* GSL
* OpenBlas
* hwloc

These should be installed in the directory pointed to by `YOUR_LOCAL_DIR` (`LOCAL_ROOT` in the `env.sh` script).

If using tabulated EOS, then you also need to compile `LORENE`. The `env.sh` script assumes that `LORENE` will be placed in `${ET_WORK_DIR}/Lorene`. Then, you run:
```sh
. env.sh
cd ${ET_WORK_DIR}/Lorene
make fortran
make export -j4
make cpp -j4
```
