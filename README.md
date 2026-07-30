# Parsenip

Parsenip is a parser combinator library for Coalton.

```lisp
  (define (sum_)
    (chainl1 (prod) (sum-op)))
    
  (define (prod)
    (chainl1 (atm) (prod-op)))
  
  (define (atm)
    (alt (lexeme (map Atom (next-ufix)))
         (do
          (lexeme (next-token #\())
          (ex <- (sum_))
          (lexeme (next-token #\)))
          (pure ex)))) 

  (define (expr)
    (take-left (sum_) (eof)))
```

Parsenip tries to hit the sweet spot by being both fast and flexible. In functional programming, being able to [parse any kind of value stored in any kind of container](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/) is very useful. But, flexible parsing libraries tend to be slower. The fastest combinator parsing libraries, like [flatparse](https://github.com/AndrasKovacs/flatparse), gain speed by locking the programmer into a particular token type stored in a particular container.

### Parsenip Sources

Parsenip tries to get the best of both by parsing over a generic, cursor-based source:

```lisp
(define-class (Source :s :c :t (:s -> :c :t))
  (initial-cursor
   (:s -> :c))
  (advance-n
   (:s * :c * UFix -> Optional :c))
  (curse
   (:s * :c -> Optional :t)))
```

Generally speaking, Parsenip aims to provide `Source` instances for commonly used data structures, like `Vector`, `List`, and `String`. It also aims to provide more complex sources that are hidden behind top-level helper functions, like `parse-file-chars!`. Unless you really want to get the most performance possible when parsing, you should be able to just parse on whatever you have without worrying too much, and it should work pretty well.

#### Details

A `Source` can be any kind of container that can generate an initial cursor, advance that cursor, and get the value of a cursor. The source is static throughout the entire parse, and the advanced cursor is threaded throughout the program. Sources that are optimized for speed can use an unboxed `UFix` cursor for fast access and advancement:

```lisp
  (define-instance (Source (Vector :t) UFix :t)
    ...
    (define (curse vec i)
      (v:index i vec)))
```

But the `Source` class makes no assumptions about what the cursor is, or how the source uses it. This is flexible enough to support a `List` instance where the source is actually ignored, and the cursor is the list itself!

```lisp
  (define-instance (Source (List :t) (List :t) :t)
    ...
    (define (curse _ lst)
      (l:head lst))
```

The `Source` class has other methods that support mid-parse reading and reclamation of memory. This allows for more complex sources that can act as a sliding window along an infinite buffer, reading tokens as needed from a file or network stream:

As an example, a `BufferedSource` stores tokens in an auto-expanding circular buffer that can fill new tokens as needed and can perform O(1) reclamation of unused tokens when the parser can commit to not backtracking before the current cursor.

```lisp
  (define-struct (BufferedSource :a)
    (buffer (CircularBuffer :a))
    (fill (Void -> Optional :a)))
```

## Status

Parsenip is currently in alpha status. With that said, the core combinators provided and their interfaces were ~~stolen~~inspired by other parser libraries in the functional programming ecosystem, particularly flatparse and attoparsec. As such, their public interfaces have been battle-tested before and are unlikely to change. 

Most of the remaining work to Parsenip is likely to be:

1. Adding more convenience functions over parsing specific token types, particularly `Char` and `U8` (bytes).
2. Adding more `Source` implementations and top-level runners to make parsing more flexible.
3. Optimizing the existing combinators.
4. Optimizing the custom source data structures for common use cases, particularly bulk-reading bytes from a file.
