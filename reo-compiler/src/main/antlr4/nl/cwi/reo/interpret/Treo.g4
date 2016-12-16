grammar Treo;

file    : ('namespace' ID ('.' ID)*)? ('using' ID ('.' ID)*)* ('include' STRING)* defn* ;

// Definitions
defn    : value '=' value                                     # defn_equation
        | var cexpr                                           # defn_definition ;  
value   : var | STRING | bexpr | iexpr | cexpr | list;
list    : '<' '>' | '<' value (',' value)* '>' ;

// Components
cexpr    : var                                                # comp_variable
        | sign '{' atom '}'                                   # comp_atomic
        | sign body                                           # comp_composite ;
cterm   : cexpr list? nodes                                   # inst_reference
        | 'for' ID '=' iexpr '..' iexpr body                  # inst_iteration
        | 'if' bexpr body (('else' bexpr body)* 'else' body)? # inst_condition ;
body    : '{' (cterm | defn)* '}' ;

// Boolean expressions
bexpr    : BOOL                                               # bexpr_boolean
        | var                                                 # bexpr_variable
        | iexpr op=(LEQ | LT | GEQ | GT | EQ | NEQ) iexpr     # bexpr_relation
        | '(' bexpr ')'                                       # bexpr_brackets
        | '!' bexpr                                           # bexpr_negation
        | bexpr AND bexpr                                     # bexpr_conjunction
        | bexpr OR bexpr                                      # bexpr_disjunction ;

// Signatures
sign    : params? iface ;
params  : '<' '>' | '<' param (',' param)* '>' ;
param   : var? ptype | var ;
ptype   : ':' type                                            # ptype_typetag
        | sign                                                # ptype_signature ;
iface   : '(' ')' | '(' node (',' node)* ')' ;
node    : var? io=(IN | OUT | MIX) type? | var ;

// Type tags for uninterpreted data
type    : ID | ID ('*' type) | '(' type ')' | <assoc=right> type ':' type ; 

// Interface instantiation
nodes : '(' ')' | '(' var (',' var)* ')' ;
        
// Variable lists
var     : (ID '.')* ID indices* ;
indices : '[' iexpr ']' | '[' iexpr '..' iexpr ']' ;

// Integer expressions
iexpr    : NAT                                                # iexpr_natural
        | var                                                 # iexpr_variable
        | '(' iexpr ')'                                       # iexpr_brackets
        | <assoc=right> iexpr POW iexpr                       # iexpr_exponent
        | MIN iexpr                                           # iexpr_unarymin
        | iexpr op=(MUL | DIV | MOD) iexpr                    # iexpr_multdivrem
        | iexpr op=(ADD | MIN) iexpr                          # iexpr_addsub ;

// Semantics
atom    : gpl                                                 # atom_sourcecode
        | pa                                                  # atom_portautomata
        | cam                                                 # atom_constraintautomata
        | wa                                                  # atom_workautomata 
        | sa                                                  # atom_seepageautomata ;
gpl     : '#GPL' STRING ;
pa      : '#PA' pa_tr* ;
pa_tr   : ID '*'? '->' ID ':' idset ;
idset   : '{' '}' | '{' ID (',' ID)* '}' ;
cam     : '#CAM' cam_tr* ;
cam_tr  : ID '*'? '->' ID ':' idset ',' dc ;
dc      : dt                                                  # cam_dc_term 
        | dc POW dt                                           # cam_dc_exponent
        | FORALL ID ':' dc                                    # cam_dc_universal
        | EXISTS ID ':' dc                                    # cam_dc_existential
        | dt op=(MUL | DIV | MOD) dc                          # cam_dc_multdivrem
        | dt op=(ADD | MIN) dc                                # cam_dc_addsub
        | dt op=(LEQ | LT | GEQ | GT) dc                      # cam_dc_ineq
        | dt op=(EQ | NEQ) dc                                 # cam_dc_neq
        | dt AND dc                                           # cam_dc_and
        | dt OR dc                                            # cam_dc_or ;
dt      : '(' dc ')'                                          # cam_dt_brackets
        | ID '(' dc (',' dc )* ')'                            # cam_dt_function
        | ID '\''                                             # cam_dt_next
        | '-' dt                                              # cam_dt_unaryMin
        | '!' dt                                              # cam_dt_not
        | STRING                                              # cam_dt_data
        | ID                                                  # cam_dt_variable ;
wa      : '#WA' wa_expr* ;
wa_expr : ID '*'? ':' jc                                      # wa_invariant
        | ID '*'? '->' ID ':' idset ',' jc ',' idset          # wa_transition ;   
jc      : 'true'                                              # wa_jc_bool
        | '(' jc ')'                                          # wa_jc_brackets
        | ID '==' NAT                                         # wa_jc_eq
        | ID '<=' NAT                                         # wa_jc_leq
        | ID '>=' NAT                                         # wa_jc_geq
        | jc '&&' jc                                          # wa_jc_and
        | jc '||' jc                                          # wa_jc_or ;
sa      : '#SA' sa_tr* ;
sa_tr   : ID '*'? '->' ID ':' idset ',' sfunc                 # sa_transition ;
sfunc   : ( ID ':=' pbexpr (',' ID ':=' pbexpr)* )?           # sa_seepagefunction ;
pbexpr   : BOOL                                               # sa_pbe_bool
        | ID                                                  # sa_pbe_variable
        | pbexpr '&&' pbexpr                                  # sa_pbe_and
        | pbexpr '||' pbexpr                                  # sa_pbe_or ;

// Tokens
LEQ     : '<=' ;
LT      : '<' ;
GEQ     : '>=' ;
GT      : '>' ;
FORALL  : 'A' ;
EXISTS  : 'E' ;
EQ      : '==' ;
NEQ     : '!=' ;
AND     : '&&' ;
OR      : '||' ;
IN      : '?' ;
OUT     : '!' ;
MIX     : ':' ;
POW     : '^' ;
MUL     : '*' ;
DIV     : '/' ;
MOD     : '%' ;
ADD     : '+' ;
MIN     : '-' ;
NAT     : ('0'|[1-9][0-9]*) ;
BOOL    : 'true'|'false' ;
ID      : [a-zA-Z_][a-zA-Z0-9_]*;
STRING  : '\"' .*? '\"' ;
SPACES  : [ \t\r\n]+ -> skip ;
SL_COMM : '//' .*? ('\n'|EOF) -> skip ;
ML_COMM : '/*' .*? '*/' -> skip ;