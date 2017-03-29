MAIN = main
#MODULES = geometry mtfort search_arguments
MODULES = $(wildcard ./modules/*.f90)
MODULES_OBJ = $(patsubst ./modules/%.f90,%.o,$(MODULES))
F90 = gfortran


main.out : $(MODULES_OBJ) $(MAIN).o
	@echo compilando main.out
	$(F90) $(MODULES_OBJ) $(MAIN).o -o main.out


# compile any .f90 file into a .o file :
$(MODULES_OBJ) : $(MODULES)
	$(F90) -c $^

$(MAIN).o: $(MODULE_OBJ) $(MAIN)_KMC.f90
	@echo $^
	$(F90) -c $(MODULE_OBJ) $(MAIN)_KMC.f90 -o $(MAIN).o

.PHONY: all
all:
	@echo $(MODULES)
	@echo $(MODULES_OBJ)

.PHONY: clean
clean:
	@rm *.o
	@rm *.mod

.PHONY: modules
modules:$(MODULES_OBJ)

