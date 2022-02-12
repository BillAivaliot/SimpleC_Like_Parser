# SimpleXML_Like_Parser
A flex/bison parser for a simplified version of XML

To run use terminal commands:

bison −y −d pars1.y
flex pars3.l
gcc −c y.tab.c lex.yy.c
gcc y.tab.o lex.yy.o −o pars.exe
./pars.exe foo
