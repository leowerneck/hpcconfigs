#!/bin/bash

# Copyright 2022 Leo Werneck
# This script is provided under the BSD 2-clause
# license (see bottom of this file).

if [[ $# -gt 1 ]]; then
    printf "nmentions - incorrect usage\n"
    printf "    Correct usage is: nmentions [simple (default) or full]\n"
    exit 1
fi

if [[ $1 == "simple" ]] || [[ $# -eq 0 ]]; then
    printf "Report type: simple\n"
    type="simple"
elif [[ $1 == "full" ]]; then
    printf "Report type: full\n"
    type="full"
else
    printf "nmentions - unrecognized option $1\n"
    printf "    Correct usage is: nmentions [simple (default) or full]\n"
fi

# Get all files in this and child directories.
# Do not include:
#  - Directories (these end with a "/" using the find command below)
#  - Makefiles
#  - make.code.defn files
files=`find . -type d -printf '%p/\n' -or -print | awk '$0 !~ /\/$/ && $0 !~ /.*Makefile.*/ && $0 !~ /.*make\.code\.defn.*/ { print }' | sort`

printf "%s\n" $files
echo $files

# Now use awk to check if the files are used
# Notes:
#  - printf writes each entry in files in a new line
#  - echo writes entries in files as a space separated string
printf "%s\n" $files | awk -v type=$type '
FNR==NR {
    # First file; should contain list of filenames
    fname = $0
    sub(/\.\//, "", fname) # Remove leading "./"
    sub(/\..*$/, "", fname) # Remove file extension
    nmentions[fname] = 0
    order[++nfiles] = fname # This helps with the sorting
    if( length(fname) > maxlength )
        maxlength = length(fname)
}

FNR!=NR {
    # All other files
    for( fname in nmentions )
        if( match($0, fname) )
            nmentions[fname]++ # Count a match as a mention
}

END {
    line = sprintf("%*s", maxlength+9, " ")
    gsub(/ /, "-", line)
    printf("    %-*s %-8s\n    %s\n", maxlength, "Filename", "Mentions", line)
    if( type=="full" ) {
        for(n=1;n<=nfiles;n++) {
            fname = order[n]
            mentions = nmentions[fname]
            info = sprintf("%-*s %5d", maxlength, fname, mentions)
            gsub(/ /, ".", info)
            if( mentions < 3 ) {
                if( mentions == 0 ) {
                    warn = "\033[1;31m <--- Unused\033[0m"
                    gsub(/[0-9]*$/,sprintf("\033[1;31m%d\033[0m", mentions), info)
                } else {
                    warn = "\033[1;33m <--- Maybe unused\033[0m"
                    gsub(/[0-9]*$/,sprintf("\033[1;33m%d\033[0m", mentions), info)
                }
            }
            else {
                warn = ""
                gsub(/[0-9]*$/,sprintf("\033[1;32m%d\033[0m", mentions), info)
            }
            printf("    %s%s\n", info, warn)
        }
    } else {
        for(n=1;n<=nfiles;n++) {
            fname = order[n]
            mentions = nmentions[fname]
            if( mentions < 3 ) {
                info = sprintf("%-*s %5d", maxlength, fname, mentions)
                gsub(/ /, ".", info)
                if( mentions == 0 ) {
                    warn = "\033[1;31m <--- Unused\033[0m"
                    gsub(/[0-9]*$/,sprintf("\033[1;31m%d\033[0m", mentions), info)
                } else {
                    warn = "\033[1;33m <--- Maybe unused\033[0m"
                    gsub(/[0-9]*$/,sprintf("\033[1;33m%d\033[0m", mentions), info)
                }
                printf("    %s%s\n", info, warn)
            }
        }
    }
} ' - `echo $files`

# LICENSE
#
# Copyright 2022 Leo Werneck
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
