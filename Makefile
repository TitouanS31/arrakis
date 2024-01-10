.PHONY: all build buildFF buildS format edit demoFF demoS clean

# Parameters for Ford-Fulkerson algorithm
src?=0
dst?=12
graph_folder?=graphs
graph?=graph2.txt

# Parameters for competition analysis 
stats_folder?=stats
stats?=statsNBA.txt

# Output file name
output?=outfile

all: build

build: buildFF buildS

buildFF:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ffmain.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .


buildS:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/smain.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

demoFF: buildFF
	> ${output}
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ffmain.exe ${graph_folder}/${graph} ${output} $(src) $(dst)
	@echo "\n   🥁  RESULT (content of ${output})  🥁\n"
	@cat ${output}

demoS: buildS
	> ${output}
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./smain.exe ${stats_folder}/${stats} ${output}
	@echo "\n   🥁  RESULT (content of ${output})  🥁\n"
	@cat ${output}

format:
	ocp-indent --inplace src/*

edit:
	code . -n

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
