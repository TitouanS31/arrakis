.PHONY: all build buildFF buildS buildNBA format edit demoFF demoS fetchNBA clean

# Parameters for Ford-Fulkerson algorithm
src?=0
dst?=12
graph_folder?=graphs
graph?=graph2.txt

# Parameters for competition analysis 
stats_folder?=stats
stats?=statsCricket.txt

# Output file name
output?=outfile

all: build

build: buildFF buildS buildNBA

buildNBA: 
	@echo "\n   🚨  COMPILING  🚨 \n"
	cd nba
	dotnet build

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

fetchNBA: buildNBA
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	cd nba
	dotnet run

format:
	ocp-indent --inplace src/*

edit:
	code . -n

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean || true
	rm -rf nba/obj
	rm -rf nba/bin
	rm -f nba/statsNBA_????????.txt
