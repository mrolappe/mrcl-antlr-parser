grammar Mrcl;

mrclFile:
    moduleDecl?
    imports?
    toplevel*
    EOF
    ;

moduleDecl:
    MODULE ID //EOL
    ;

imports:
    IMPORT ID
    ;

toplevel:
    proc
    | stmt
//    | expr
    | constantDefinition
    ;

proc:
    PROC ID paramList?
    '{'
    '}'
    ;

paramList:
    '(' ')'
    | '(' param ')'
    | '(' param (',' param)+ ')'
    ;

param:
    ID ':' ID
    ;

stmt:
    PRINTLN STRING_LITERAL
    ;

constantDefinition:
    CONST ID '=' constantExpression
    ;

constantExpression:
    STRING_LITERAL
    ;

CONST: 'const';
IMPORT: 'import';
MODULE: 'module';
PRINTLN: 'println';
PROC: 'proc';

STRING_LITERAL: '"' (ESC|~["\\])*? '"';
ID: [a-zA-Z]+;
LINE_COMMENT: '//' .*? '\r'? ('\n'|EOF) -> channel(HIDDEN);
BLOCK_COMMENT: '/*' .*? '*/' -> channel(HIDDEN);

EOL: [\r]? [\n]+ -> channel(HIDDEN);
WS: [ \t]+ -> channel(HIDDEN);
fragment ESC: '\\' [btnr"\\];

/** "catch all" rule for any char not matched in a token rule of your
 *  grammar. Lexers in Intellij must return all tokens good and bad.
 *  There must be a token to cover all characters, which makes sense, for
 *  an IDE. The parser however should not see these bad tokens because
 *  it just confuses the issue. Hence, the hidden channel.
 */
ERRCHAR: . -> channel(HIDDEN);