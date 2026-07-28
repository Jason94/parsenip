## Generate Docs

To generate docs, run this command in a REPL:

```lisp
(asdf:load-system "parsenip/docs")
```

Once the system has been loaded, regen the docs by running:

```lisp
(parsenip/docs:write-docs)
```
