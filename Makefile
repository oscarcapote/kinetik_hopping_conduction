MAIN = main
EXECS = main.out der.out
SIZES = 50 100 150
RESULTS = $(patsubst %,./results/L%/,$(SIZES))
RESULTS_MAINS = $(addsuffix main.out,$(RESULTS))
RESULTS_DERS =  $(addsuffix der.out,$(RESULTS))
PLOTS = basic_plots.gp
#MODULES = geometry mtfort search_arguments
MODULES = $(wildcard ./modules/*.f90)
MODULES_OBJ = $(patsubst ./modules/%.f90,%.o,$(MODULES))
F90 = gfortran


.PHONY:install
install:main.out der.out analysis
	@$(MAKE) clean


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

.PHONY:derivatives
derivatives:der.out
der.out:derivatives.f90
	gfortran derivatives.f90 -o der.out

.PHONY:analysis

analysis: main.out der.out  
	@$(MAKE) $(RESULTS_MAINS)
	@$(MAKE) $(RESULTS_DERS)
	@$(MAKE) gnuplots
	@$(MAKE) loopScript

$(RESULTS_MAINS) :main.out
	@mkdir -p $(dir $@)
	cp $(notdir $@) $@

$(RESULTS_DERS) :der.out
	@mkdir -p $(dir $@)
	cp $(notdir $@) $@

.PHONY:gnuplots
gnuplots:./scripts/basic_plots.gp
	$(foreach var,$(RESULTS),cp ./scripts/basic_plots.gp $(var);)
	$(foreach var,$(SIZES),sed -i 's/SIZE/'$(var)'/g' ./results/L$(var)/basic_plots.gp;)

.PHONY:loopScript
loopScript:./scripts/loop_T.sh
	$(foreach var,$(RESULTS),cp ./scripts/loop_T.sh $(var);)
	$(foreach var,$(SIZES),sed -i 's/SIZE/'$(var)'/g' ./results/L$(var)/loop_T.sh;)


