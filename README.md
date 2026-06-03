# Note to CMC users

Please use the official internal repository. This repository is intended for
external users.

# Quick Start Guide

**See the extended instructions below for additional details.**

## Requirements

- Fortran and C compilers
- MPI implementation (e.g. OpenMPI + dev packages)
- Optional: OpenMP
- Numerical libraries (BLAS/LAPACK or MKL)
- Unix tools: cmake (≥ 3.20), bash, sed


### 1. Clone the repository

```
git clone --branch 6.3 --recursive https://github.com/ECCC-ASTD-MRD/sps.git
cd sps

# If you cloned without the --recursive option above, update submodules:
git submodule update --init --recursive
```

### 2. Download required data  (~3 GB)

```
./download-dbase.sh .
```

### 3. Configure environment (depending on the compiler)

```
. ./.common_setup gnu
# or
. ./.common_setup intel
```

### 4. Build

*Option A - Standard CMake*

```
mkdir -p build
cd build
cmake ..
make -j work
```

*Option B - Helper scripts*

```
. ./.initial_setup
cado cmake
cado work -j
```

### 5. Run

```
cd $SPS_WORK
sps.sh --dircfg configurations/SPS_cfgs --ptopo 2x2x1 --inorder
```

### 6. Inspect output

To see or list the records in the output files, use either of our tools, 
voir, fststat, SPI or xrec, available in other repositories:

```
voir -iment RUNMOD/output/cfg_0000/ ...  
fststat -fst RUNMOD/output/cfg_0000/ ...  
xrec -imflds RUNMOD/output/cfg_0000/ ...  
```

fst-tools: https://github.com/ECCC-ASTD-MRD/fst-tools  
SPI: https://github.com/ECCC-ASTD-MRD/SPI-Bundle  
xrec: https://github.com/ECCC-ASTD-MRD/xrec  


-----------------------------------------------------------------
# Extended instructions:

## Compiler support

- GNU (default): gcc, gfortran, OpenMPI
- Intel: you may have to use: ```cmake .. -DCOMPILER_SUITE=intel```
- Intel: you may need to modify ```-march``` to generate code that can run on your
  system

Compiler flags can be adjusted in:
- CMakeLists.txt, under the section **# Adding specific flags for SPS**.
- cmake_rpn/modules/ec_compiler_presets/default/Linux-x86_64/gnu.cmake or intel.cmake

Make sure the compilers and libraries paths are set in the appropriate
environment variables (PATH and LD_LIBRARY_PATH).  

Here are some examples of commands for gnu compiler, which you will need to
adapt for your setup: 

  - On Ubuntu:
  
```
    export PATH=/usr/lib/openmpi/bin:${PATH}
    export LD_LIBRARY_PATH=/usr/lib/openmpi/lib:$LD_LIBRARY_PATH
# or
    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/openmpi/lib:$LD_LIBRARY_PATH
```

  - On Fedora:

```
    export PATH=/usr/lib64/openmpi/bin:$PATH
    export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH
```

The default compiler suite is GNU. If you want to compile with other compilers,
add ```-DCOMPILER_SUITE=<compiler suite name (gnu|intel|...)>``` to the CMake
command line.  

This release has been tested with GNU and Intel compilers on Linux x86_64.
Other compilers have also been used in the past, but have not been tested
with the current release.  You will likely have to modify the *.cmake files
in the **cmake_rpn/modules/ec_compiler_presets/default/** folder.

## Useful CMake options

```
-DCMAKE_VERBOSE_MAKEFILE=ON   # verbose build
-DWITH_OPENMP=OFF             # disable OpenMP
```
 
## Building and installing SPS

If you get error messages (for example, compiler, OpenMP or MPI/OpenMPI not
found), make sure that the ```PATH``` and ```LD_LIBRARY_PATH``` environment
variables contain the appropriate paths, and use
```-DCMAKE_VERBOSE_MAKEFILE=ON``` to your **cmake** command line.

If the compiler or compile options are not right:
- Remove the content of the build directory
- Make appropriate changes to the cmake files corresponding to the
  compiler suite you are using
- Re-launch the commands starting at cmake

The installation process will create a directory named after the operating system
on which the compilation was executed, and the compiler you used
(work-[OS_NAME]-[COMPILER_NAME]). For example
*work-FedoraLinux-37-x86_64-gnu-12.3.1* would be created in the main directory.

A script named sps-config is also installed. It displays a summary of the
architecture, compiler, and flags used.

## Structure of the working environment

The following environment variables are created:
- sps_DIR = directory where the git clone was created
- SPS_WORK = work directory
- SPS_ARCH = architecture, for example FedoraLinux-37-x86_64-gnu-12.3.1
- SPS_MODEL_DFILES = sps database directory
- COMPILER_SUITE = compiler suite, for example gnu
- COMPILER_VERSION = compiler version, for example 12.3.1

## Running SPS

Go to the working directory, named *work-[OS_NAME]-[COMPILER_NAME]*, for
example *work-FedoraLinux-37-x86_64-gnu-12.3.1*

```
cd work-[OS_NAME]-[COMPILER_NAME]
or
cd $SPS_WORK
sps.sh --dircfg configurations/SPS_cfgs --ptopo 2x2x1
```

*sps.sh* ```-ptopo``` argument can be used to specify the number of CPU to
use.  For example,  ```-ptopo 2x2x1``` will use 4 cpus for a LAM, and
8 cpus for global Yin-Yang.

If you get an error message saying sps.sh or sps_dbase is not found, make
sure to set the environment variables using the setup file situated in the
main directory:

```
./.common_setup gnu
# or
./.common_setup intel
```

An in-house script (**r.run_in_parallel**) is used to run the model. If you
want to use another command, or if it doesn't work in your environment, edit
the file *scripts/sps.sh* to change the script.

See **README** in the work directory for other information on the different configurations.

## Working with model outputs

The model stores its outputs in FST files.  The following tools can be used
to perform various tasks on the output files. They are available for
download and installation here: https://github.com/ECCC-ASTD-MRD/fst-tools

- ```voir``` lists the records in FST files:
  ```
  voir -iment RUNMOD.dir/output/cfg_0000/...
  ```

- ```fststat``` produces statistical means of the records in a FST file:
  ```
  fststat -fst RUNMOD.dir/output/cfg_0000/...
  ```

[SPI](https://github.com/ECCC-ASTD-MRD/SPI-Bundle) is a scientific and
meteorological virtual globe offering processing, analysis and visualization
capabilities, with a user interface similar to Google Earth and NASA World
Wind, developed by Environment Canada.

[xrec](https://github.com/ECCC-ASTD-MRD/xrec) is another visualization
program which can be used to display 2D meteorological fields stored in the
FST files, developed by Research Informatics Services, Meteorological
Research Division, Environment and Climate Change Canada.

## Configurations files

The execution of all three components of SPS is configurable through the use
of three configuration files called:
- sps.cfg: namelists to configure the model execution
- outcfg.out: to configure the model output
- configexp.cfg: to configure the execution shell environment
- physics_input_table

Examples of these files can be found in the test cases in the configurations
directory.

## Running your own configuration

Put the three configurations files (sps.cfg, outcfg.out and configexp.cfg)
in a directory structure such as: **experience/cfg_0000** in the
configurations directory.

The master directory name (**experience** in the example above) can be
any valid directory name. However, the second directory must have the name
\textit{cfg\_0000}.

Then use the sps.sh script to run the model:

```
cd work-[OS_NAME]-[COMPILER_NAME]
sps.sh --dircfg configurations/experience
```
