# SimpleC_Like_Parser
A flex/bison parser for a simplified version of C

To run use terminal commands:

bison −y −d pars.y
flex pars.l
gcc −c y.tab.c lex.yy.c
gcc y.tab.o lex.yy.o −o pars.exe
./pars.exe foo
