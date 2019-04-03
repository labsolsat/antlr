grammar ExprCompl;
// START:members
@header {
import java.util.HashMap;
}
@members {
HashMap memory = new HashMap();
}
// END:members
// START:stat
prog: stat+ ;
stat: expr NEWLINE {System.out.println($expr.value);}
  | ID '=' expr NEWLINE
    {memory.put($ID.text, new Integer($expr.value));}
  | NEWLINE
  ;
// END:stat
// START:expr
expr returns [int value]
  : e=multExpr {$value = $e.value;}
  ( '+' e=multExpr {$value += $e.value;}
  | '-' e=multExpr {$value -= $e.value;}
  )*;
// END:expr

multExpr returns [int value]
  : e=atom {$value = $e.value;} ('*' e=atom {$value *= $e.value;})*;
// END:multExpr
// START:atom
atom returns [int value]
    :
    INT {$value = Integer.parseInt($INT.text);}
    | ID // variable reference
      {
      Integer v = (Integer)memory.get($ID.text);
      if ( v!=null ) $value = v.intValue();
      else System.err.println("undefined variable "+$ID.text);
      }
      | '(' expr ')' {$value = $expr.value;};
// END:atom
// START:tokens
ID : ('a'..'z'|'A'..'Z')+ ;
INT : '0'..'9'+ ;
NEWLINE:'\r'? '\n' ;
WS : (' '|'\t'|'\n'|'\r')+ {skip();};
