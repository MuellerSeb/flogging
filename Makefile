# Builds flogging as a shared library

F90=.f90
OBJ=.o
LIB = libflogging.so
SRC = src
BUILD = $(SRC)


FC = mpif90
ifeq ($(FC),nagfor)
	FLAGS = -fpp -colour -free -Iinclude -DNAG
	LIB_FLAGS =
else
	FLAGS = -fpic -O3 -cpp -ffree-line-length-none -Iinclude
	LIB_FLAGS = -shared
endif
ifeq (USE_MPI,1)
	FLAGS += -DUSE_MPI
endif

SOURCES = $(wildcard $(SRC)/*$(F90))
OBJS = $(patsubst $(SRC)/%$(F90), $(BUILD)/%$(OBJ), $(SOURCES))

$(LIB): $(OBJS)
	$(FC) $(LIB_FLAGS) -o $(LIB) $(OBJS)

$(BUILD)/%$(OBJ): $(SRC)/%$(F90)
	$(FC) $(FLAGS) -c $< -o $@

$(BUILD)/flogging.o: $(BUILD)/vt100.o

# Some test executables
#
test : src/flogging.f90 src/tests/test_flogging.f90 src/vt100.f90 include/flogging.h
	$(FC) $(FLAGS) -Iinclude src/vt100.f90 src/flogging.f90 src/tests/test_flogging.f90 -o test

test_mpi : src/flogging.f90 src/tests/test_flogging.f90 src/vt100.f90 include/flogging.h
	$(FC) $(FLAGS) -DUSE_MPI -Iinclude src/vt100.f90 src/flogging.f90 src/tests/test_flogging.f90 -o test_mpi

.PHONY: clean doc
clean:
	@find . -name '*.o' -delete
	@find . -name '*.mod' -delete
	@find . -name '*.so' -delete
	@rm -f test test_mpi

doc:
	ford flogging.md
doc_deploy: doc
	git subtree push --prefix doc origin gh-pages
