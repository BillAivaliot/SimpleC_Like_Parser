
%{
	#include "y.tab.h"  
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int num_tab=0;//poses fores tab
	int i;
	int slash_found=0;
	char prev_text[20];
	char cur_text[20];
	void get_cur_text(char in[20]){
		memset(cur_text, 0, 20);
		strcat(cur_text,in);
		

	}
	void add_slash_to_text(){
		char text[20];//boh8htikh
		memset(text, 0, 20);//katharismos mnhmhs
		strcpy(text,"/");
		strcat(text, cur_text);
		memset(cur_text, 0, 20);
		strcat(cur_text, text);	
	}
	void replace_prev_text(){
		memset(prev_text, 0, 20);
		strcat(prev_text, cur_text);
		
	}
	void set_num_tabs(){
		if(strcmp(cur_text,"ss:Workbook")==0||strcmp(cur_text,"/ss:Worksheet")==0||strcmp(cur_text,"/ss:Styles")==0){
			num_tab=1;
		}else if(strcmp(cur_text,"ss:Worksheet")==0||strcmp(cur_text,"/ss:Table")==0||strcmp(cur_text,"ss:Styles")==0){
			num_tab=2;
		}else if(strcmp(cur_text,"ss:Table")==0||strcmp(cur_text,"/ss:Row")==0||strcmp(cur_text,"/ss:Column")==0){
			num_tab=3;
		}else if(strcmp(cur_text,"/ss:Cell")==0||strcmp(cur_text,"ss:Row")==0){
			num_tab=4;
		}else if(strcmp(cur_text,"ss:Cell")==0||strcmp(cur_text,"/ss:Data")==0){
			num_tab=5;
		}else if(strcmp(cur_text,"ss:Data")==0){
			num_tab=6;
		}else num_tab=0;

	}
%}
%option noyywrap
%option yylineno


quote \"
int    {quote}[0-9]+{quote}
string {quote}(\\.|[^\\"])*{quote}
blanc [ \t\n]
open_dec <
close_dec >
%%
"="                      {printf("\t%s\t", yytext); return ASSIGN;}
{open_dec}               {set_num_tabs(); for(i=0;i<num_tab;i++){printf("\t");}printf("%s", yytext);return OPEN_DEC;}



{close_dec}              {if(slash_found==1) {add_slash_to_text(); slash_found=0;}printf("%s\n", yytext);return CLOSE_DEC;}
"ss:Workbook"            {printf("%s", yytext);get_cur_text(yytext); return WORKBOOK;}
"ss:Worksheet"           {printf("%s", yytext); get_cur_text(yytext);return WORKSHEET;}
"ss:Styles"              {printf("%s", yytext); get_cur_text(yytext);return STYLES;}
"ss:Style"               {printf("%s", yytext); get_cur_text(yytext);return STYLE;}
"ss:Table"               {printf("%s", yytext); get_cur_text(yytext);return TABLE;}
"ss:Name"                {printf("\t%s", yytext);return SSNAME;}
"ss:ID"                  {printf("\t%s", yytext);return SSID;}
"ss:Row"				 {printf("%s",   yytext);get_cur_text(yytext);return ROW;}
"ss:Column"				 {printf("%s",   yytext);get_cur_text(yytext);return COLUMN;}
"ss:Cell"				 {printf("%s",   yytext);get_cur_text(yytext);return CELL;}
"ss:Data"				 {printf("%s",   yytext); return DATA;}
"ss:ExpandedColumnCount" {printf("\t%s", yytext); return EXPANDEDCOLUMNCOUNT;}
"ss:ExpandedRowCount"    {printf("\t%s", yytext); return EXPANDEDROWCOUNT;}
"ss:StyleID"             {printf("\t%s", yytext); return STYLEID;}
"ss:Protected"           {printf("\t%s", yytext); return PROTECTED;}
"/" 	                 {slash_found=1;printf("%s", yytext); return SLASH;}
"ss:Hiden"               {printf("\t%s", yytext); return HIDDEN;}
"ss:Height"              {printf("\t%s", yytext); return HEIGHT;}
"ss:Width"               {printf("\t%s", yytext); return WIDTH;}
{quote}"true"{quote}     {printf("%s", yytext); return BOOLEAN;}
{quote}"false"{quote}    {printf("%s", yytext); return BOOLEAN;}
"ss:Type"				 {printf("\t%s", yytext); return TYPE;}	
{quote}"Boolean"{quote}  {printf("%s", yytext); return DATA_TYPE;}
{quote}"DateTime"{quote} {printf("%s", yytext); return DATA_TYPE;}
{quote}"Number"{quote}   {printf("%s", yytext); return DATA_TYPE;}
{quote}"String"{quote}   {printf("%s", yytext); return DATA_TYPE;}
{int}                    {printf("%s", yytext); return INT;}
{string}                 {printf("%s", yytext); return STRING;}
{blanc}                  {/*ignore*/}
%%

