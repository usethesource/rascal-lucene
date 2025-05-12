@license{
Copyright (c) 2025, NWO-I Centrum Wiskunde & Informatica (CWI)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
@synopsis{Bridges Rascal grammars and parser generation to the Lucene "Analyzer" and "Tokenizer" interfaces.}
@description{
By leveraging the information in ParseTree instances we can provide, selectively, tokens for any source file that
we have a grammar for:
* ((analyzerFromGrammar)) combines a ((tokenizerFromGrammar)) with a ((lowerCaseFilter)). It makes an entire source file searchable.
* ((identifierAnalyzerFromGrammar)) selects only the identifiers in the source text, ignoring keywords and comments and such.
* ((commentAnalyzerFromGrammar)) focuses on the words in source code comments.

This functionality is based on the ((analysis::text::search::Lucene)) module, and its underlying adapter that bridges Rascal callbacks
to Lucene's search framework.
}
module analysis::text::search::Grammars

extend analysis::text::search::Lucene;
import ParseTree;
import String;

Analyzer analyzerFromGrammar(type[&T <: Tree] grammar) = analyzer(tokenizerFromGrammar(grammar), [lowerCaseFilter()]);

Analyzer identifierAnalyzerFromGrammar(type[&T <: Tree] grammar) = analyzer(identifierTokenizerFromGrammar(grammar), [lowerCaseFilter()]);

Analyzer commentAnalyzerFromGrammar(type[&T <: Tree] grammar) = analyzer(commentTokenizerFromGrammar(grammar), [lowerCaseFilter()]);

@synopsis{Use a generate parser as a Lucene tokenizer. Skipping nothing.}
Tokenizer tokenizerFromGrammar(type[&T <: Tree] grammar) = tokenizer(list[Term] (str input) {
   try {
     tr = parse(grammar, input, |lucene:///|, allowAmbiguity=true);
     return [term("<token>", token@\loc, "<type(token.prod.def,())>") | token <- tokens(tr, isToken) ];
   }
   catch ParseError(_):
     return [term(input, |lucene:///|(0, size(input)), "entire input")];
});

@synopsis{Use a generated parser as a Lucene tokenizer, and skip all keywords and punctuation.}
Tokenizer identifierTokenizerFromGrammar(type[&T <: Tree] grammar) = tokenizer(list[Term] (str input) {
   try {
     tr = parse(grammar, input, |lucene:///|, allowAmbiguity=true);
     return [term("<token>", token@\loc, "<type(token.prod.def, ())>") | token <- tokens(tr, isToken), isLexical(token)];
   }
   catch ParseError(_):
     return [term(input, |lucene:///|(0, size(input)), "entire input")];
});

@synopsis{Use a generated parser as a Lucene tokenizer, and skip all keywords and punctuation.}
Tokenizer commentTokenizerFromGrammar(type[&T <: Tree] grammar) = tokenizer(list[Term] (str input) {
   try {
     tr = parse(grammar, input, |lucene:///|, allowAmbiguity=true);
     return [term("<comment>", comment@\loc, "<type(comment.prod.def,())>") | comment <- tokens(tr, isComment)];
   }
   catch ParseError(_):
     return [term(input, |lucene:///|(0, size(input)), "entire input")];
});

list[Tree] tokens(amb({Tree x, *_}), bool(Tree) isToken) = tokens(x, isToken);

default list[Tree] tokens(Tree tok, bool(Tree) isToken) {
  if (isToken(tok)) {
    return [tok];
  }
  else {
    return [*tokens(a, isToken) | tok has args, a <- tok.args];
  }
}

bool isTokenType(lit(_)) = true;
bool isTokenType(cilit(_)) = true;    
bool isTokenType(lex(_)) = true;  
bool isTokenType(layouts(_)) = true;
bool isTokenType(label(str _, Symbol s)) = isTokenType(s);
default bool isTokenType(Symbol _) = false;

bool isToken(appl(prod(Symbol s, _, _), _)) = true when isTokenType(s);
bool isToken(char(_)) = true;
default bool isToken(Tree _) = false;

bool isLexical(appl(prod(Symbol s, _, _), _)) = true when lex(_) := s || label(_, lex(_)) := s;
default bool isLexical(Tree _) = false;

bool isComment(Tree t) = true when t has prod, /"category"("comment") := t.prod;
default bool isComment(Tree _) = false;
