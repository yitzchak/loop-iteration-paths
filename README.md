# loop-iteration-paths

The orignal Technical Memo 169 "Loop Iteration Macro" which defined
LOOP for Lisp Machine Lisp and Maclisp also specified an extension
mechanism know as an "iteration path." The syntax of which
essentially:

```
for-as-iteration-path ::= {FOR | AS} var [type-spec] BEING
                          {path-exclusive | path-inclusive}
                          {path-using | path-preposition}*
path-exclusive        ::= {EACH | THE} path-name
path-inclusive        ::= form AND {ITS | EACH | HIS | HER | THEIR}
                          path-name
path-using            ::= USING ({using-name simple-var}+)
path-preposition      ::= preposition-name form
preposition-name      ::= name
using-name            ::= simple-var
path-name             ::= symbol
```

It was also possible to omit the `path-name`. In this case the macro
expansion of LOOP used a default iteration patch called `attachments`
which was also permitted to rewrite the for-as-iteration-path clause
at expansion time.  Later, Lisp Machine Lisp used the path named
`default-loop-path` instead of `attachments`.

New iteration paths were created using `DEFINE-LOOP-PATH` with their
own preposition and internal LOOP variables, which could be accessed
via USING. Inclusive iteration paths are those in which the initial
value of `var` was `form` itself. An example given in the Lisp Machine
Manual is that of the CDRS iteration path:

```common-lisp
(loop for x being the cdrs of '(a b c . d) collect x)
; => ((b c . d) (c . d) d)

(loop for x being '(a b c . d) and its cdrs collect x)
; => ((a b c . d) (b c . d) (c . d) d)
```

## Common Lisp LOOP

The first LOOP for Common Lisp was converted from the Symbolics code
(LOOP 829) by Glenn Burke as is known as MIT LOOP. It included the
iteration path extension mechanism and the "attachments" default
path. Eventually the default path mechanism and the token THEIR was
removed.

Most modern Common Lisp implementations still have the iteration path
extension mechanism, although it is often not exported from the LOOP
package. The hash table and package symbol subclauses are the residual
syntax of the original iteration path syntax. If the Lisp
implementation supports iteration paths then hash table and symbol
iteration is actually implemented via this mechanism.

ABCL, CCL, CMUCL, Clasp, ECL and SBCL are implementations that still
have iteration paths. CLISP does not, as its LOOP implementation is
not derived from MIT LOOP.

## ELEMENTS Iteration Path

```
path-name        ::= {ELEMENT | ELEMENTS}
preposition-name ::= {IN | OF}
using-name       ::= {INDEX}
```

## BYTES Iteration Path

```
path-name        ::= {BYTE | BYTES}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM}
```

## CHARACTERS Iteration Path

```
path-name        ::= {CHARACTER | CHARATERS}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM}
```

## LINES Iteration Path

```
path-name        ::= {LINE | LINES}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM | MISSING-NEWLINE-P}
```

## OBJECTS Iteration Path

```
path-name        ::= {OBJECT | OBJECTS}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM}
```