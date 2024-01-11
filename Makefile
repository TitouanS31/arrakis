.PHONY: all build buildFF buildS buildNBA format edit demoFF demoS fetchNBA clean

# Parameters for Ford-Fulkerson algorithm
src?=0
dst?=12
graph_folder?=graphs
graph?=graph2.txt

# Parameters for competition analysis 
stats_folder?=stats
stats?=statsCricket.txt

# Output file name without extension
output?=outfile
output_txt?=${output}.txt
output_svg?=${output}.svg

all: build

build: buildFF buildS buildNBA

buildNBA: 
	@echo "\n   🚨  COMPILING  🚨 \n"
	cd nba && dotnet build

buildFF:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ffmain.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

buildS:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/smain.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

demoFF: buildFF
	> ${output_txt}
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ffmain.exe ${graph_folder}/${graph} ${output_txt} $(src) $(dst)
	dot -Tsvg ${output_txt} > ${output_svg}
	@echo "\n   🥁  RESULT (content of ${output_txt})  🥁\n"
	@cat ${output_txt}

demoS: buildS
	> ${output_txt}
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./smain.exe ${stats_folder}/${stats} ${output_txt}
	@echo "\n   🥁  RESULT (content of ${output_txt})  🥁\n"
	@cat ${output_txt}

fetchNBA: buildNBA
	> ${output_txt}
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	cd nba && dotnet run
	cp $$(ls -t nba/statsNBA_??_??_????.txt | head -1) ${stats_folder}
	mv $$(ls -t nba/statsNBA_??_??_????.txt | head -1) ${output_txt}
	@echo "\n   🥁  RESULT (content of ${output_txt})  🥁\n"
	@cat ${output_txt}

format:
	ocp-indent --inplace src/*

edit:
	code . -n

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean || true
	rm -f ${output_txt} ${output_svg}
	rm -rf nba/obj
	rm -rf nba/bin
	rm -f nba/statsNBA_??_??_????.txt
