# Arrakis #  

Arrakis is an OCaml/C# project created by Titouan Seraud and Hugo Girard during first semester of our 4th year of INSA.  

## What is Arrakis ? ##  

This project implements [Ford-Fulkerson algorithm](https://en.wikipedia.org/wiki/Ford%E2%80%93Fulkerson_algorithm) using OCaml.  

It applies Ford-Fulkerson to a real-life problem: knowing if a (probably sport) team can still win a championship at a given moment. We also use OCaml to answer this problem. 

[Here](https://medium.com/swlh/real-world-network-flow-cricket-elimination-problem-55a3036a5d60) is the article that inspired Arrakis, for further understanding.  

## How to use Arrakis ? ##  

Arrakis has three distinct execution modes, you will find specific instructions for each execution mode below.  

Anyway, you will have to clone this repository in wanted folder.  

Arrakis needs a .txt file containing specific championship datas to work, please check the file format:  

```
4 <- Number of teams
France 61 0 5 6 7 <- Team name + Number of wins + Number of games remaining against all 4 teams 
England 63 5 0 4 2 
Spain 72 6 4 0 1   
Italy 58 7 2 1 0 
```
### Vanilla execution ###  

If you want to use Ford-Fulkerson algorithm on a graph, just put .txt file corresponding to your graph to `./arrakis/graphs` folder.  

Then, change this line `graph?=yourTxtName.txt` in `./arrakis/Makefile` to match your .txt file name.  

Finally, type `make demoFF` in terminal to start program.  

It will print, in `./arrakis/outfile` and in terminal, the final graph with maximal flow.  

### Custom championship execution ###

If you want to use Arrakis for your favourite championship (that is not NBA), you will have to create your own custom text file, respecting the format above.  

Keep in mind that Arrakis only works for championship with Win/Lose games, championships with Draw possibility aren't supported yet.  

Put your .txt file in `./arrakis/stats` folder. Then, change this line `stats?=yourTxtName.txt` in `./arrakis/Makefile` to match your .txt file name.  

Finally, type `make demoS` in terminal to start program.  

It will print, in `./arrakis/outfile` and in terminal, the graph associated to every team, and the result of Arrakis (can they still finish first ?).  

### NBA execution ###

If you want to use Arrakis on NBA championship, you will have to type `make fetchNBA` in terminal.  

A C# program will create .txt file matching current state of the NBA, using this [site](https://tankathon.com/), and adapted to Arrakis.  

Then, change this line `stats?=yourTxtName.txt` in `./arrakis/Makefile` to match NBA .txt file name that just has been created.  

Finally, type `make demoS` in terminal to start program.  

It will print, in `./arrakis/outfile` and in terminal, the graph associated to every team, and the result of Arrakis (can they still finish first ?).


