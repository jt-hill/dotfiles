; nvim-paredit support for Racket (upstream ships none).
; In tree-sitter-racket, `list` covers (), [] and {}, and is also the inner
; node of #(...), #s(...) and #hash(...), so it reaches all of them.

(list) @form

(comment) @comment
(block_comment) @comment
(sexp_comment) @comment
