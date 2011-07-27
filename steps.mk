# Makefile for each steps
# Copyright 2006 Yann E. MORIN <yann.morin.1998@anciens.enib.fr>

# ----------------------------------------------------------
# This is the steps help entry

help-build::
	@echo  '  list-steps         - List all build steps'

help-env::
	@echo  '  STOP=step          - Stop the build just after this step (list with list-steps)'
	@echo  '  RESTART=step       - Restart the build just before this step (list with list-steps)'

# ----------------------------------------------------------
# The steps list

# Please keep the last line with a '\' and keep the following empy line:
# it helps when diffing and merging.
CT_STEPS := libc_check_config   \
            gmp                 \
            mpfr                \
            ppl                 \
            cloog               \
            mpc                 \
            zlib                \
            bzip2               \
            xz                  \
            libelf              \
            elfutils            \
            libunwind           \
            popt                \
            expat               \
            ncurses             \
            pcre                \
            sqlite              \
            attr                \
            acl                 \
            xmlrpcpp            \
            binutils            \
            elf2flt             \
            sstrip              \
            cc_core_pass_1      \
            kernel_headers      \
            libc_start_files    \
            cc_core_pass_2      \
            libc                \
            cc                  \
            libc_finish         \
            zlib_target         \
            bzip2_target        \
            xz_target           \
            libelf_target       \
            elfutils_target     \
            libunwind_target    \
            popt_target         \
            expat_target        \
            ncurses_target      \
            pcre_target         \
            sqlite_target       \
            attr_target         \
            acl_target          \
            xmlrpcpp_target     \
            binutils_target     \
            companion_tools_libtool_build_for_target \
            cross_me_harder     \
            target_me_harder    \
            debug               \
            test_suite          \
            finish              \

# Make the list available to sub-processes (scripts/crosstool-NG.sh needs it)
export CT_STEPS

# Print the steps list
PHONY += list-steps
list-steps:
	@echo  'Available build steps, in order:'
	@for step in $(CT_STEPS); do    \
	     echo "  - $${step}";       \
	 done
	@echo  'Use "<step>" as action to execute only that step.'
	@echo  'Use "+<step>" as action to execute up to that step.'
	@echo  'Use "<step>+" as action to execute from that step onward.'

# ----------------------------------------------------------
# This part deals with executing steps

$(CT_STEPS):
	$(SILENT)$(MAKE) -rf $(CT_NG) V=$(V) RESTART=$@ STOP=$@ build

$(patsubst %,+%,$(CT_STEPS)):
	$(SILENT)$(MAKE) -rf $(CT_NG) V=$(V) STOP=$(patsubst +%,%,$@) build

$(patsubst %,%+,$(CT_STEPS)):
	$(SILENT)$(MAKE) -rf $(CT_NG) V=$(V) RESTART=$(patsubst %+,%,$@) build
