grammar Simple;

@parser::header {
import java.util.Map;
import java.util.HashMap;
}

@parser::members {
Map<String, Object> symbolTable = new HashMap<String,Object>();
}

program: PROGRAM ID BRACKET_OPEN
        sentence*
        BRACKET_CLOSE;

sentence: var_decl | var_assign | println;
var_decl: VAR ID SEMICOLON
      {symbolTable.put($ID.text,0);};

var_assign: ID ASSIGN expression SEMICOLON
      {symbolTable.put($ID.text, $expression.value);};

println: PRINTLN expression SEMICOLON
      {System.out.println($expression.value);}
    |
      PRINTLN COPEN ID COPEN COMA expression ((COMA|SEMICOLON) expression?)*
      {System.out.println( $ID.text + " "+ $expression.value);};
      expression returns [Object value]:
      NUMBER {$value = Integer.parseInt($NUMBER.text);}
    |
      ID {$value = symbolTable.get($ID.text);};
      
PROGRAM: 'program';
VAR: 'var';
PRINTLN: 'println';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
AND: '&&';
OR: '||';
NOT: '!';
GT: '>';
LT: '<';
GEQ: '>=';
LEQ: '<=';
EQ: '==';
NEQ: '!=';
COPEN: '"';
ASSIGN: '=';
BRACKET_OPEN: '{';
BRACKET_CLOSE: '}';
PAR_OPEN: '(';
PAR_CLOSE: ')';
COMA: ',';
SEMICOLON: ';';
ID: [a-zA-Z_][a-zA-Z0-9_]*;
NUMBER: [0-9]+;
WS: [ \t\r\n]+ -> skip;
