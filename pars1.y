%{
	#include <stdio.h>
	#include <math.h>
	void yyerror(char *); 
	extern FILE *yyin;								
	extern FILE *yyout;
	extern yylineno;
	int errors;								
%}

%token WORKBOOK 
%token WORKSHEET 
%token STYLES 
%token STYLE 
%token TABLE 
%token COLUMN 
%token ROW
%token CELL
%token DATA
%token QUOT
%token CLOSE_DEC OPEN_DEC
%token ASSIGN SLASH
%token STRING BOOLEAN INT
%token SSNAME SSID PROTECTED TYPE
%token EXPANDEDCOLUMNCOUNT EXPANDEDROWCOUNT STYLEID
%token WIDTH  HEIGHT HIDDEN 
%token DATA_TYPE
%token MERGE_ACROSS MERGE_DOWN

%start program
%%
program: start_workbook worksheet_list end_workbook
|start_workbook styles_list worksheet_list end_workbook;
start_workbook: OPEN_DEC WORKBOOK CLOSE_DEC;
end_workbook: OPEN_DEC SLASH WORKBOOK CLOSE_DEC;
worksheet_list: worksheet|worksheet_list worksheet;
styles_list: styles|styles_list styles;

worksheet: start_worksheet end_worksheet|start_worksheet table_list end_worksheet;
start_worksheet: OPEN_DEC WORKSHEET CLOSE_DEC |OPEN_DEC WORKSHEET SSNAME ASSIGN STRING CLOSE_DEC;
end_worksheet: OPEN_DEC SLASH WORKSHEET CLOSE_DEC;
table_list: table|table_list table;

styles: start_styles end_styles|start_styles style_list end_styles;
style_list: style|style_list style;
start_styles: OPEN_DEC STYLES CLOSE_DEC;
end_styles: OPEN_DEC SLASH STYLES CLOSE_DEC;

style: start_style end_style;
start_style:OPEN_DEC STYLE SSID ASSIGN STRING CLOSE_DEC;
end_style:OPEN_DEC SLASH STYLE CLOSE_DEC;

table: start_table row_list close_table|
start_table col_list close_table|
start_table col_list row_list close_table;
start_table:OPEN_DEC TABLE CLOSE_DEC|OPEN_DEC TABLE table_char_list CLOSE_DEC;
table_char:EXPANDEDCOLUMNCOUNT ASSIGN INT|
EXPANDEDROWCOUNT ASSIGN INT|
STYLEID ASSIGN STRING;
table_char_list: table_char|table_char table_char|table_char table_char table_char;
close_table: OPEN_DEC SLASH TABLE CLOSE_DEC; 


assign_hidden: HIDDEN ASSIGN BOOLEAN;
assign_style: STYLEID ASSIGN STRING;
assign_height: HEIGHT ASSIGN INT;
assign_width: WIDTH ASSIGN INT;

col_list: col|col_list col;
col: start_col end_col|start_col col_attr_list end_col;
start_col: OPEN_DEC COLUMN;
end_col: SLASH CLOSE_DEC;
col_attr: assign_hidden|assign_width|assign_style;
col_attr_list: col_attr| col_attr col_attr| col_attr col_attr col_attr;

row_list:row|row_list row;
row_attr: assign_hidden|assign_height|assign_style;
row_attr_list: row_attr| row_attr row_attr| row_attr row_attr row_attr;
row:start_row end_row|start_row cell_list end_row;
start_row: OPEN_DEC ROW CLOSE_DEC|OPEN_DEC ROW row_attr_list CLOSE_DEC;
end_row: OPEN_DEC SLASH ROW CLOSE_DEC;

cell_list: cell | cell_list cell;

cell:start_cell end_cell|start_cell data_list end_cell;
data_list: data|data_list data;
start_cell:OPEN_DEC CELL CLOSE_DEC|OPEN_DEC CELL cell_attr_list CLOSE_DEC;
end_cell:OPEN_DEC SLASH CELL CLOSE_DEC;
cell_attr_list:cell_attr|cell_attr cell_attr|cell_attr cell_attr cell_attr;
cell_attr: MERGE_ACROSS ASSIGN INT| MERGE_DOWN ASSIGN INT| STYLEID ASSIGN STRING;


data: start_data end_data |start_data text end_data;
start_data: OPEN_DEC DATA CLOSE_DEC| OPEN_DEC DATA data_attr_list CLOSE_DEC;
end_data:OPEN_DEC SLASH DATA CLOSE_DEC;
data_attr_list: data_attr|data_attr data_attr| data_attr data_attr data_attr;
data_attr: TYPE ASSIGN DATA_TYPE;
text: text_part| text text_part;
text_part: STRING|INT|SLASH|ASSIGN;
 




%%

void yyerror(char *s){
     errors++;
     printf("Error at Line: %d.\n", yylineno);
}
	
int main (int argc, char **argv){
	argv++;
	argc--;
	errors=0;
	  
	if(argc>0)
		{
		yyin=fopen(argv[0], "r");
		
		yyparse();
	
		if(errors==0)
			printf("Parsing Succesful!\n"); 
		else 
			printf("Parsing failed\n");
	 } 
	else
	printf("No file to parse\n");
}
