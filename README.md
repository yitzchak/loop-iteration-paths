# loop-iteration-paths

> **_NOTE:_** [Khazern][], a new implementation of LOOP, now has
> "iteration paths" as described below. It can be used extrinsically,
> i.e. as a supplement to the CL implementation's own LOOP and has
> many more built-in iteration path extensions available. I created
> loop-iteration-paths as way to research and document the existing
> extension mechanisms of CL implementations. I have not yet decided
> whether to publish loop-iteration-paths to Quicklisp or OCICL.

The original Technical Memo 169 "Loop Iteration Macro" which defined
LOOP for Lisp Machine Lisp and Maclisp also specified an extension
mechanism known as an "iteration path." The syntax of which was
essentially:

```
for-as-iteration-path ::= {FOR | AS} var [type-spec] BEING
                          {path-exclusive | path-inclusive}
                          {path-using | path-preposition}*
path-exclusive        ::= {EACH | THE} path-name
path-inclusive        ::= form AND {ITS | EACH | HIS | HER | THEIR}
                          path-name
path-using            ::= USING ({using-name var}+)
path-preposition      ::= preposition-name form
preposition-name      ::= name
using-name            ::= simple-var
path-name             ::= symbol
```

It was also possible to omit the `path-name`. In this case the macro
expansion of LOOP used a default iteration path called `attachments`
which was also permitted to rewrite the for-as-iteration-path clause
at expansion time.  Later, Lisp Machine Lisp used the path named
`default-loop-path` instead of `attachments`.

Inclusive iteration paths are those in which the initial
value of `var` was `form` itself. An example given in the Lisp Machine
Manual is that of the CDRS iteration path:

```common-lisp
(loop for x being the cdrs of '(a b c . d) collect x)
; => ((b c . d) (c . d) d)

(loop for x being '(a b c . d) and its cdrs collect x)
; => ((a b c . d) (b c . d) (c . d) d)
```

New iteration paths were created using `DEFINE-LOOP-PATH` with their
own prepositions and internal LOOP variables, which could be accessed
via USING.

## Common Lisp LOOP

The first LOOP for Common Lisp was converted from the Symbolics code
(LOOP 829) by Glenn Burke and is known as MIT LOOP. It included the
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

## Sequence Iteration

### ELEMENTS Iteration Path

The ELEMENTS iteration path iterates over sequences. If the extensible
sequence protocol is available it will use MAKE-SEQUENCE-ITERATOR from
that protocol. Otherwise it will use ELT and iterate an index into the
sequence.

```
path-name        ::= {ELEMENT | ELEMENTS}
preposition-name ::= {IN | OF | START | END | FROM-END}
using-name       ::= {INDEX}
```

* The IN and OF prepositions are synonyms and specify the form that
  evaluates to the sequence. One of these prepositions is required.
* The START preposition specifies the starting index of the
  iteration. It is optional and if not specified it will default to 0.
* The END preposition specifies the ending index of the iteration. It
  is optional and if not specified it will default to the sequence
  length.
* The FROM-END preposition specifies the iteration direction. If it is
  non-NIL then iteration will go from END to START. Otherwise
  iteration will go from START to END. It is optional and if not
  specified it will default to NIL.
* The INDEX phrase in USING names a variable to store the current
  iteration index. It is optional.

## Stream Iteration

All stream iteration paths have the following prepositions and USING
phrases:

* The IN and OF prepositions are synonyms and specify the form that
  evaluates to the stream. If one of these prepositions is not
  specified then \*STANDARD-INPUT\* is used.
* The CLOSE preposition specifies whether the stream should be closed
  when the LOOP is terminated. If it is non-NIL then the stream is
  closed via UNWIND-PROTECT when the loop terminates. It is optional
  and if not specified it will default to NIL
* The STREAM phrase in USING names a variable to store the current
  stream. It is optional.

### BYTES Iteration Path

The BYTES iteration path iterates over an input stream using
READ-BYTE. It terminates on EOF.

```
path-name        ::= {BYTE | BYTES}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM}
```

## CHARACTERS Iteration Path

The CHARACTERS iteration path iterates over an input stream using
READ-CHAR. It terminates on EOF.

```
path-name        ::= {CHARACTER | CHARATERS}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM}
```

## LINES Iteration Path

The LINES iteration path iterates over an input stream using
READ-LINE. It terminates on EOF.

```
path-name        ::= {LINE | LINES}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM | MISSING-NEWLINE-P}
```

In addition to the standard stream prepositions and USING phrases it
also has the MISSING-NEWLINE-P USING phrase. This phrase is optional
and specifies the name of variable to store the second value returned
from READ-LINE which is non-NIL if the line was not terminated by a
newline.

## OBJECTS Iteration Path

The OBJECTS iteration path iterates over an input stream using
READ. It terminates on EOF.

```
path-name        ::= {OBJECT | OBJECTS}
preposition-name ::= {IN | OF | CLOSE}
using-name       ::= {STREAM}
```

[Khazern]: https://github.com/s-expressionists/Khazern/