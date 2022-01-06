# Grammar

Contains T-Lang grammar rules

## Overview

```
// AST Tokens

FILE_BODY_NODE = "FBN"
CODE_INLINING_BODY = "CIB"
FUNC = "FNC"
FUNC_ARG = "FAG"
FUNC_CALL = "FCL"

// Keys

CODE_INLINING_BEGIN = "@{"
CODE_INLINING_END = "}"
STRING_DELIMETER = "\""
NEW_LINE = "\n"
CHAR = .
STRING = STRING_DELIMETER CHAR* STRING_DELIMETER
NUMBER = [0-9]+("."[0-9]+)?
FUNC_ARGS_START = "("
FUNC_ARGS_FINISH = ")"
VARIABLE_NAME_AND_TYPE_DELIMETER = ":"
BLOCK_START = "{"
BLOCK_FINISH = "}"

// Keywordds

RETURN_KEYWORD = "return"
FUNC_KEYWORD = "fn"
"
// Rules

// -- Common

any_name_rule = [a-zA-Z_\-]+[0-9]*
return_expression_rule = RETURN_KEYWORD expression_rule

// -- Function

func_call_args = expression_rule ("," expression_rule)*
func_call_rule = any_name_rule FUNC_ARGS_START func_call_args? FUNC_ARGS_FINISH -> (FUNC_CALL^ any_name_rule func_call_args?)

func_body_decl = code_block_rule
func_arg_decl = any_name_rule VARIABLE_NAME_AND_TYPE_DELIMETER any_name_rule -> (FUNC_ARG^ any_name_rule any_name_rule)
func_args_decl = func_arg_decl ("," func_arg_decl)*
func_decl_rule = FUNC_KEYWORD any_name_rule FUNC_ARGS_START func_args_decl? FUNC_ARGS_FINISH any_name_rule BLOCK_START func_body_decl BLOCK_FINISH-> (FUNC any_name_rule func_args_decl? any_name_rule)

// -- Base

expression_rule = NUMBER | STRING | func_call_rule | any_name_rule 

code_block_rule = return_expression_rule

code_inlining_expression_rule = NUMBER | STRING

code_inlining_rule = code_inlining_expression_rule* -> (CODE_INLINING_BODY^ code_inlining_expression_rule*)

template_rule = code_inlining_rule | CHAR -> (FILE_BODY_NODE^ code_inlining_rule CHAR) 

entry_point_rule = template_rule*
```
