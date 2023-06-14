.DEFAULT_GOAL = test

FC          = ftn
FLINKER     = $(FC)
OPTFLAGS    = -o3 -fallow-argument-mismatch


FFLAGS_OPT = $(OPTFLAGS) 



# Pattern rule for .F90
%.o : %.F90
	$(FC) -c $(FFLAGS_OPT) $< -o $@



test: main.F90
	$(FLINKER) $(FFLAGS_OPT) main.F90  -lstdc++ -o $@



clc:
	-rm -f *.o *.o* test 

