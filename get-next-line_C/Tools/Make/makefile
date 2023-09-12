# SVN-Id: $Id: makefile 69803 2018-01-11 07:12:38Z ostwal01 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/makefile $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# See /doc for detailed documentation
#
# This file is part of the core make process files and should not be
# modified by users. Please see the files in ./config directory for
# all configuration options.
#
# The Makefile is the entry point of the make process. It includes
# further make modules (*.mk) to provide functions for compiling,
# assembling and linking the project, run QA-C checks and TESSY tests
# and further support functions like automatic file list generation.
#
######################################################################

######################################################################
# Include of sub-make definitions
######################################################################

# Include internal configuration and user configuration files for make
# process.
include intcfg.mk
include $(addprefix ${MK_CONFIG_DIR}/,${MK_CONFIG_FILES})

# include further make modules
include utils.mk
include info.mk
include std_sw_trace.mk
include toolchecks.mk

# Make process tests will not be included by default in the Eclipse
# dirstribution, so ignore include errors here.
-include tests/testing.mk


######################################################################
# Generation of source and header list files.
######################################################################

# include existing dependency rule files for incremental build
include $(wildcard ${DependencyDir}/*.$(DEP_EXT))
include $(wildcard ${FileVPath})


# Macro definitions for path and file list handling

source = $(shell cat ${SrcListDir}/c_filelist.txt 2> /dev/null)
header = $(shell cat ${SrcListDir}/h_filelist.txt 2> /dev/null)
asm_source = $(shell cat ${SrcListDir}/${ASM_SRC_EXT}_filelist.txt 2> /dev/null)

source_filtered     = $(filter-out $(blacklist),$(source))
header_filtered     = $(filter-out $(blacklist),$(header))
asm_source_filtered = $(filter-out $(blacklist),$(asm_source))

SourceNoPath        = $(notdir $(source_filtered))
HeaderNoPath        = $(notdir $(header_filtered))
AsmNoPath           = $(notdir $(asm_source_filtered))

ObjList             = $(addsuffix .${C_OBJ_EXT}, $(basename $(SourceNoPath)))
ObjListAsm          = $(addsuffix .${ASM_OBJ_EXT}, $(basename $(AsmNoPath)))
ModuleList          = $(basename $(SourceNoPath))
ModuleListSize      = $(words $(ModuleList))
ObjWithPath         = $(addprefix ${ObjDir}/,$(ObjList))
ObjWithPathAsm      = $(addprefix ${ObjDir}/,$(ObjListAsm))
DepFilePattern      = ${DependencyDir}/$*.$(DEP_EXT)
DepTargetPattern    = $*.${C_OBJ_EXT}

IncludePaths        = $(sort $(dir ${header_filtered}))
ifneq ($(COMPILER_INC_PATH),)
IncludePaths       += $(COMPILER_INC_PATH)
endif

IPath               = $(addprefix -I, $(IncludePaths))


# These modules use the calculated source / header file lists, so they
# are included here.
ifneq ($(QAC_VERSION), QAC9)
include ${QacPrj}/qac.mk
else
include ${QacPrj}/qac9.mk
endif
include ${TessyPrj}/tessy.mk


######################################################################
# Provide the SVN working copy revision to the build process.

# Set the SVN_WC_REV variable to the SVN working copy
# revision. Ensures that the value of this variable is only calculated
# once for the whole make process call chain.
######################################################################

# Command to retrieve the working copy revision or NO_WORKINGCOPY.
define SvnVersionCmd
    if [ -x ${SVNVERSION_BIN} ]; then \
        SVN_REV=`${SVNVERSION_BIN}`; \
        if echo $${SVN_REV} | grep -Eq '^[0-9].*'; \
        then \
            echo "$${SVN_REV}"; \
        else \
            echo "NO_WORKINGCOPY"; \
        fi;
    else \
        echo "NO_SVNVERSION"; \
    fi;
endef

# Determine working copy revision and export value to make it
# available for all further sub-makes.
ifeq (${SVN_WC_REV},)
    export SVN_WC_REV := $(shell $(SvnVersionCmd))
endif


######################################################################
# Buildmode support
#
# Here the build mode dependent variables, mainly output directories
# and compiler, assembler, linker options are set.
######################################################################

# Check if the requested build mode is in the list of available build
# modes.
ifeq ($(filter ${BUILDMODE},${BUILDMODES}),)
  $(error Buildmode '${BUILDMODE}' is not configured in project.mk)
endif

# Workaround to convert variable content to uppercase.
BUILDMODE_UC := $(shell echo ${BUILDMODE} | tr 'a-z' 'A-Z')

TargetSubDir = ${TargetDir}/${BUILDMODE}
ObjDir  = ${TargetSubDir}/obj
ListDir = ${TargetSubDir}/list
BinDir  = ${TargetSubDir}/bin
Target = ${TARGET_${BUILDMODE_UC}}
CFLAGS  = ${CFLAGS_${BUILDMODE_UC}}
AFLAGS  = ${AFLAGS_${BUILDMODE_UC}}
LDFLAGS = ${LDFLAGS_${BUILDMODE_UC}}

# Check if buildmode related variables are all set.
REQ_COMPILE_VARS=CFLAGS LDFLAGS AFLAGS Target
$(call CheckAllDefined,${REQ_COMPILE_VARS},Compiler settings)

# Merge / preprocess variables from compile_opt.mk
CC_DEFINES = $(addprefix -D, ${CC_DEFLIST})
CC_DEFINES_GNU = $(addprefix -D, ${CC_DEFLIST_GNU})
CFLAGS_COMMON += ${CC_DEP_CHECK} ${CC_DEFINES}

# Specify path where make finds object files
vpath %.${C_OBJ_EXT} ${ObjDir}


######################################################################
# Definition of implicit target generation rules
######################################################################

.PHONY: all
all: checktools_BASIC checktools_COMPILER check_target_dirs
	$(pre_build_extension)
	
	$(MAKE) checklists
	$(MAKE) ${Target}
	
	$(post_build_extension)
	@echo "Done building target '$@'."


######################################################################
# Link object files
######################################################################
${Target}: ${ObjList} ${ObjListAsm}
	$(pre_link_extension)

	@echo "Linking '$(notdir $@)' using build mode '${BUILDMODE}'."
	${LD} ${LDFLAGS} -o $@ ${ObjWithPath} ${ObjWithPathAsm}

	$(post_link_extension)


######################################################################
# Compile C files
######################################################################
%.${C_OBJ_EXT}: %.c
	$(pre_compile_extension)

	@echo "Compiling '$(notdir $<)' using build mode '${BUILDMODE}'."
# realpath handling of pre-requisite is needed for CI warning navigation
	${CC} \
		${IPath} \
		${CFLAGS} \
		-o ${ObjDir}/$@ \
		$(realpath $<)

	$(post_compile_extension)

# optional dependency retrieval supporting incremental build
ifeq ($(DEP_CHECK_GNU), ON)
	@echo "Retrieving dependencies of '$(notdir $<)'."
	$(GCCBIN) \
		${IPath} \
		${CC_DEFINES_GNU} \
		-MM -E -MT ${DepTargetPattern} \
		-MF ${DepFilePattern} $<
endif	


######################################################################
# Assemble ASM files
######################################################################
%.${ASM_OBJ_EXT}: %.${ASM_SRC_EXT}
	$(pre_assemble_extension)

	@echo "Assembling '$(notdir $<)' using build mode ${BUILDMODE}."
	${ASM} \
		${IPath} \
		${AFLAGS} \
		-o ${ObjDir}/$@ \
		$(realpath $<)

	$(post_assemble_extension)


######################################################################
# Rules for gathering of sources & header resources the target depends
# on.
######################################################################
.PHONY: preparelists
ifeq ($(AUTO_SRC_LIST), ON)
preparelists: checktools_BASIC
	@echo "Forcing rebuild of source and header file lists."

	# ensure, that needed directories exist
	[ -d ${SrcListDir} ] || mkdir -p ${SrcListDir}
	[ -d ${DependencyDir} ] || mkdir -p ${DependencyDir}

	$(MAKE) cleanlists
	$(MAKE) ${SrcListDir}/c_filelist.txt
	$(MAKE) ${SrcListDir}/$(ASM_SRC_EXT)_filelist.txt
	$(MAKE) ${SrcListDir}/h_filelist.txt
	$(MAKE) ${FileVPath}

	@echo "Source and header file list rebuilt."
else
preparelists: 
	@echo "Skipped creation of header list: disabled via " \
		"AUTO_SRC_LIST -> $(AUTO_SRC_LIST)"
endif


# Generate a filelist used for the make process.
${SrcListDir}/%_filelist.txt:
	@echo "Creating '*.$*' file list."
	
	$(FINDBIN) ${SourceDir} -name "*.$*" > $@


# Generate vpath definitions, so make knows the search path to all required 
# files. 
${FileVPath}:
	@echo "Creating vpath include."
	
	rm -f ${FileVPath}; \
	$(foreach f,$(source_filtered) $(asm_source_filtered),\
	echo vpath $(notdir $f) $(dir $f) >> ${FileVPath};\
	)


######################################################################
# Check source lists for duplicate files
######################################################################

SourceDuplicates  = $(call FindDuplicates,${SourceNoPath})
HeaderDuplicates  = $(call FindDuplicates,${HeaderNoPath})
AsmDuplicates     = $(call FindDuplicates,${AsmNoPath})

.PHONY: checklists
checklists:
ifneq ($(SourceDuplicates)$(HeaderDuplicates)$(AsmDuplicates),)
    # source- or header duplicates exist
    # post adressed file info from source-/header lists to console
	@echo "Discovered duplicate sources:"
	for dup in $(SourceDuplicates); do grep -s -h $$dup ${SrcListDir}/c_filelist.txt ; done
	for dup in $(HeaderDuplicates); do grep -s -h $$dup ${SrcListDir}/h_filelist.txt ; done
	for dup in $(AsmDuplicates)   ; do grep -s -h $$dup ${SrcListDir}/${ASM_SRC_EXT}_filelist.txt ; done
    # trigger make error
	$(MAKE) lk_err_dup_src
endif

.PHONY: lk_err_dup_src
lk_err_dup_src: ; $(error Build process encountered duplicate source/header files!)


######################################################################
# Check if the output directories for the compiler and linker
# processes exist. If not, create them.
######################################################################
.PHONY: check_target_dirs
check_target_dirs:
	@echo "Ensure directories in '${TargetSubDir}' exist."
	$(foreach DIR,${ObjDir} ${BinDir} ${ListDir},\
		[ -d ${DIR} ] || mkdir -p ${DIR}; \
	)


######################################################################
# Rule for cleaning of build results
######################################################################
.PHONY: clean
clean: check_target_dirs
	@echo "Cleaning build output."
	rm -f ${ObjDir}/*.*
	rm -f ${ListDir}/*.*
	rm -f ${BinDir}/*.*
	rm -f ${DependencyDir}/*.*


######################################################################
# Rule for cleaning of source/header resources required for build
######################################################################
.PHONY: cleanlists
cleanlists:
ifeq ($(AUTO_SRC_LIST), ON)
	@echo "Cleaning source, header and vpath lists."
	rm -f \
		${SrcListDir}/*_filelist.txt \
		${FileVPath}
else
	@echo "Skipped deletion of source-/header- and depend list: " \
		"automatic source list handling is disabled."
endif
