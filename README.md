# How to get, compile and run SPS at the CMC.

# Table of Contents

1. [Two git repositories](#two-git-repositories)
2. [For developers](#for-developers)
   1. [How to contribute to the official physics using sps-dev repository](#how-to-contribute-to-the-official-physics-using-sps-dev-repository)
   2. [How to work with branches under sps-dev](#how-to-work-with-branches-under-sps-dev)
3. [Getting MIG SPS git repository](#getting-mig-sps-git-repository)
4. [Choosing a version](#choosing-a-version)
5. [Linking to SPS database](#linking-to-sps-database)
6. [Preparing SPS compilation](#preparing-sps-compilation)
    1. [Information on scripts](#information-on-scripts)
7. [Building and installing SPS](#building-and-installing-sps)
8. [Running SPS](#Running SPS)
    1. [Running SPS using DDT](#running-sps-using-ddt)
    2. [Running SPS using GDB](#running-sps-using-gdb)
9. [Some tips for compilation](#some-tips-for-compilation)
10. [Structure of the working environment](#structure-of-the-working-environment)


## Two git repositories

The official SPS git repository is under
[MIG/sps](https://gitlab.science.gc.ca/MIG/sps/). It is used for tagging and
releasing official versions of SPS, and contains only the main branches. 

The development SPS git repository is under
[continental-surface-hydrology/sps-dev/](https://gitlab.science.gc.ca/continental-surface-hydrology/sps-dev/),
where developers create their own branches and open issues related to the
development of SPS. 

Please clone the appropriate git repository according to your needs. Once
the git repository is cloned, instructions on how to compile and use SPS are
identical.

## For developers

### How to contribute to the official physics using sps-dev repository

Read the [wiki page](https://gitlab.science.gc.ca/continental-surface-hydrology/sps-dev/-/wikis/How-to-contribute-to-the-official-physics-using-SPS-DEV-repository) which describes how developers of models of continental
surfaces can prepare contributions to the official physics using the sps_dev
repository.

### How to work with branches under sps-dev

Read the [wiki
page](https://gitlab.science.gc.ca/continental-surface-hydrology/sps-dev/-/wikis/How-to-work-with-branches-under-sps-dev)
which describes how developers of models of continental surfaces can
download and update branches of other developers under sps-dev.

## Getting MIG SPS git repository

For all other uses, and if you are not planning on contributing to the
official physics repository (see above), you can download the official SPS
git repository under [MIG/sps](https://gitlab.science.gc.ca/MIG/sps/) by
following one of the methods listed below.

Warning: the repositories use submodules. Make sure you follow the
instructions.

### Choose one of the following methods:

1. cloning only the necessary components:
```
git clone git@gitlab.science.gc.ca:MIG/sps.git
cd sps
```

2. or cloning everything, including rpn-si libraries (rmn, vgrid, rpncomm, tdpack) in one step:
```
git clone --recursive git@gitlab.science.gc.ca:MIG/sps.git
cd sps
```

3. or cloning in several steps
```
git clone git@gitlab.science.gc.ca:MIG/sps.git
cd sps
```
Update only cmake_rpn submodules, for example if you want to modify the default compilation flags
```
git submodule update --init cmake_rpn
```
Update everything: rpn-si libraries, utilities and cmake_rpn submodules
```
git submodule update --init --recursive
```

## Choosing a version

```
git branch # what is the current branch
git branch -a # list all branches (look at the list of remote branches to choose from)
git tag # list tags (if you want to select a tagged version)
git checkout <hash|branch|tag> # checkout a branch, a tag, or a specific hash.  Example: git checkout sps_6.3-branch
```
Before making changes, create your own branch from the current branch
```
git checkout -b mybranch
```

## Linking to SPS database

To be done once:
 
```
./scripts/link-dbase.sh
```

## Preparing SPS compilation

Using Intel compiler suite:

```
. ./.eccc_setup_intel
```

or using GNU compiler suite (please note you cannot compile with Intel and
then with GNU in the same shell):

```
. ./.eccc_setup_gnu
```

Before the first build, or if you made important changes (such as updating
other submodules, or adding or removing source files):
```
. ./.initial_setup
```

### Information on scripts

Scripts in `scripts/support` and `scripts/rpy` directories are a copy of scripts
already loaded from SSM domains when a `.eccc_setup*` file is called.  By
default, they are not used, but if you want to test or modify them, you can
override SSM scripts by setting `GOAS_SCRIPT_MODE` variable before sourcing
`.eccc_setup_intel` or `.eccc_setup_gnu`:

```
export GOAS_SCRIPT_MODE=true
```

Please also note that if you load maestro, maestro scripts will be used,
either in a maestro suite or when running SPS interactively. Otherwise, goas
task setup files situated in the scripts directory will be used instead.

## Building and installing SPS

A script called `cado` can be used instead of the usual cmake commands. See
`cado -h` (short help) or `cado help` for options.  For example: `cado
cmake` generates Makefiles to compile sps, modelutils and rpnphy. The cmake
command used by cado script is printed at the end of the process.


Configure:
```
cado cmake
```

Compile:
```
cado build -j
```
Install in working directory
```
cado work -j
```

`cado work -j` can be used to compile and install in the same step.

In development mode, SPS is compiled using Intel shared libraries: use the
following command to compile with static libraries:
```
cado cmake-static
```

See others options with cado -h (short help) or cado help

## Running SPS

Example on how to run SPS:

```
cd $SPS_WORK
sps.sh --dircfg ./configurations/SPS_cfgs --ptopo 2x2x1 --inorder
```

### Running SPS using DDT

Example on how to run SPS using DDT:

```
cd $SPS_WORK
sps.sh --dircfg ./configurations/SPS_cfgs --ptopo 2x2x1 --btopo=1x1 -debugger ddt
```

### Running SPS using GDB

Example on how to run SPS using GDB:
```
cd $SPS_WORK
sps.sh --dircfg ./configurations/SPS_cfgs --ptopo 2x2x1 --btopo=1x1 -debugger gdb
sps.sh --dircfg ./configurations/SPS_cfgs --ptopo 2x2x1 --btopo=1x1 -debugger
```

If you come back later, and you want to run the executables you compiled
before, you just need to use the following command before going into the
$SPS_WORK directory:
```
. ./.eccc_setup_intel
or, if you compiled with gnu:
. ./.eccc_setup_gnu
and then:
cd $SPS_WORK
```

## Some tips for compilation

When the `cado cmake` command is called, information is printed, among which
the list of compilation flags used, such as (example with Intel on science
side):
```
-- (EC) CMAKE_C_FLAGS=-fp-model precise -traceback -Wtrigraphs -xICELAKE-SERVER -diag-disable=10441 -qmkl 
-- (EC) CMAKE_Fortran_FLAGS=-convert big_endian -align array32byte -assume byterecl -fp-model source -fpe0 -traceback -stand f08 -xICELAKE-SERVER -diag-disable=5268,7025,7373 -qmkl -static-intel
```

If you choose the debug version (`cado cmake-debug`), some flags are added to the previous ones, and, again, printed when `cado cmake-debug` is called:
```
-- (EC) CMAKE_C_FLAGS_DEBUG=-O0 -g -ftrapuv
-- (EC) CMAKE_Fortran_FLAGS_DEBUG=-O0 -g -ftrapuv
```
With `cado cmake-debug-extra`:
```
-- (EC) CMAKE_C_FLAGS=-fp-model precise -traceback -Wtrigraphs -xICELAKE-SERVER -diag-disable=10441 -Wall -qmkl 
-- (EC) CMAKE_Fortran_FLAGS=-convert big_endian -align array32byte -assume byterecl -fp-model source -fpe0 -traceback -stand f08 -xICELAKE-SERVER -diag-disable=5268,7025,7373 -warn all -check all -qmkl -static-intel
```

*Important note*: if you want to change the compilation type, for example, first, you compiled with the debug version (`cado cmake-debug`), and then you want to use the release version (`cado cmake`), you need to remove the contents of the build directory between these two commands. You can use the following command: `. ./.initial_setup` which will empty the build and work directories, and then you can proceed from the start with the `cado cmake` configure command.
 
The compilation flags come from default compiler rules set up by RPN-SI and are applied to all the compilation processes.

If you want to change those flags, you can either:
- update the `cmake_rpn` submodule so that you can edit the files and modify those flags directly:
  - `git submodule update --init cmake_rpn`
  - make the changes in the file corresponding to the platform and compiler used, such as:
    `cmake_rpn/modules/ec_compiler_presets/ECCC/rhel-8-icelake-64/inteloneapi-2022.1.2.cmake`
- or edit the `CMakeLists.txt` file and add the flags at the end of the following lines (for Intel):
```
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qmkl -static-intel -diag-disable 5268 ${STATIC_LINK_INTEL_FLAGS}")
```

If you want to change or add flags for a specific part of SPS, for example sps, you can either:
- change the flags for all sources, by editing the `src/sps/CMakeLists.txt`
  file and add the flags at the end of the following lines (for Intel):
```
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qmkl -static-intel -diag-disable 5268")
```
- or, if you want to change or add flags for a specific source file only,
  edit the `CMakeLists.txt` file situated in the directory where this source
  file is added.
  For example, for the source file `rpnphy/src/utils/sfclayer.F90`, edit the
  `rpnphy/src/CMakeLists.txt`, and modify the following line according to your
  needs (here we are adding the -C flag to the default flags:
```
set_source_files_properties(utils/sfclayer.F90 PROPERTIES COMPILE_OPTIONS "-C")
```

## Structure of the working environment

The structure of the build and work directories is different whether the
$storage_model environment variable exists:

The following environment variables are created (examples):
- `sps_DIR` = directory where the git clone was created
- `SPS_WORK` = work directory
- `SPS_ARCH` = architecture, for example ubuntu-22.04-amd64-64-intel-2022.1.2
- `COMPILER_SUITE` = compiler suite, for example Intel
- `COMPILER_VERSION` = compiler version, for example 2022.1.2

- `SPS_STORAGE_DIR` = where build and work directories are situated
  - Example if `${storage_model}` variable exists:
    - `SPS_STORAGE_DIR`=/local/storage/sps/ubuntu-22.04-amd64-64-intel-2022.1.2
    - in `sps_DIR`:
      - build-ubuntu-22.04-amd64-64-intel-2022.1.2 is a link, such as:
        /local/storage/sps/ubuntu-22.04-amd64-64-intel-2022.1.2/build
      - work-ubuntu-22.04-amd64-64-intel-2022.1.2 is a link, such as:
        /local/storage/sps/ubuntu-22.04-amd64-64-intel-2022.1.2/work

  - Example if `${storage_model}` variable doesn't exist:
    - `SPS_STORAGE_DIR`=$HOME/sps/
    - directories situated in `sps_DIR`:
      - build-ubuntu-22.04-amd64-64-intel-2022.1.2
      - work-ubuntu-22.04-amd64-64-intel-2022.1.2
