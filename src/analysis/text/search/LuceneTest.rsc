@license{
Copyright (c) 2025, NWO-I Centrum Wiskunde & Informatica (CWI)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
module analysis::text::search::LuceneTest

import analysis::text::search::Grammars;

import lang::pico::\syntax::Main;
import util::FileSystem;
import IO;
import List;

// a small grammar used to split an input text into words and non-words without loss of characters
lexical WordSplitter = Word* words;
lexical Word 
  = [A-Za-z0-9\-]+ !>> [A-Za-z0-9]
  | ![A-Za-z0-9\-]+ !>> ![A-Za-z0-9]
  ;

// we test using all pico programs in the library
public set[loc] programs = find(|project://rascal-lucene/src|, "pico");

// next to the src field we add comments and an extra field to index on.
data Document(loc comments = |unknown:///|, str extra = "");
data Analyzer(Analyzer comments = standardAnalyzer(), Analyzer extra = standardAnalyzer());

// an example filter which replaces all a's by b's for demo purposes
str abFilter(str token) = visit(token) {
  case /a/ => "b"
};

// an example filter which removes the word "ut" from a stream
bool utFilter(str token) = "ut" != token;

// an example filter which splits a specific word in two parts:
list[str] lauSplitDanda("laudanda") = ["lau", "danda"]; 

// this is a data source
list[str] extraWords = ["ut", "desint", "vires", "tamen", "est", "laudanda", "voluntas"];

// the first analyzer is for the `src` document, parser the program and extracts all identifiers
Analyzer  an() = analyzer(identifierTokenizerFromGrammar(#start[Program]), []);
  
// the second parses the program again, and lists all the tokens in source code comments, then maps them to lowercase.
Analyzer  commentAnalyzer() = analyzer(commentTokenizerFromGrammar(#start[Program]), [wordSplitFilter(), lowerCaseFilter()]);

// a word split filter written in Rascal using a generated grammar for the non-terminal `WordSplitter`
// notice how a splitFilter may not throw away input, only split it, otherwise offsets will be off.   
Filter wordSplitFilter() = splitFilter(list[str] (str term) {
  return ["<word>" | word <- ([WordSplitter] term).words];
});
   
// the final analyzer analyses the extra field by splitting the words, and changing all a's to b's, and removing `ut`
Analyzer  extraAnalyzer() = analyzer(classicTokenizer(), [ splitFilter(lauSplitDanda), \editFilter(abFilter), removeFilter(utFilter)]);
 
// We combine the analyzers for the different fields with a `fieldsAnalyzer`. 
// createIndex and searchIndex do not have access to default parameters (yet) since that is a
// Rascal feature and not a vallang feature, so each field has to be set explicitly:
Analyzer indexAnalyzer() = fieldsAnalyzer(an(), comments=commentAnalyzer(), extra=extraAnalyzer());

// where we store the lucene index (may be any loc as long as its a directory)
loc indexFolder = |tmp:///picoIndex|;
 
void picoIndex() {
  // always start afresh (for testing purposes)
  remove(indexFolder);
  
  docs = {document(p, comments=p, extra="<for (w <- extraWords) {><w> <}>"[..-1]) | p <- programs};
  
  createIndex(indexFolder, docs, analyzer=indexAnalyzer());
}

void picoSearch(str term) {  
  println("\'<term>\' results in identifiers:"); 
  iprintln(searchIndex(indexFolder, "src:<term>"));
  
  println("\'<term>\' results in comments:");
  iprintln(searchIndex(indexFolder, "comments:<term>"));
  
  println("\'<term>\' results in extra:");
  // make sure we use the same abFilter on the search query:
  iprintln(searchIndex(indexFolder, "extra:<term>", analyzer=fieldsAnalyzer(an(), extra=extraAnalyzer())));
}  
 
void extraSearch() {
  searchAll = "<for (t <- extraWords) {><t> || <}>"[..-4];
  println("\'<searchAll>\' results in extra:");
  iprintln(searchIndex(indexFolder, "extra:(<searchAll>)", analyzer=fieldsAnalyzer(standardAnalyzer(), comments=standardAnalyzer())));
}

test bool extraTermsTest() = listTerms(indexFolder, "extra") == {
  <"est",1>,
  <"tbmen",1>,
  <"vires",1>,
  <"dbndb",1>,
  <"voluntbs",1>,
  <"desint",1>,
  <"lbu",1>
};

test bool identifierTest() = document(loc l) <- searchIndex(indexFolder, "src:repnr") && l == |project://rascal-lucene/src/analysis/text/search/testdata/Fac.pico|;
test bool analyzerTest1() = size(analyzeDocument(|project://rascal-lucene/src/analysis/text/search/testdata/Fac.pico|, analyzer=an())) == 25;
test bool analyzerTest2() = size(analyzeDocument(|project://rascal-lucene/src/analysis/text/search/testdata/Fac.pico|, analyzer=commentAnalyzer())) == 7;
test bool searchDocTest1() = size(searchDocument(|project://rascal-lucene/src/analysis/text/search/testdata/Fac.pico|, "repnr", analyzer=an())) == 5;
test bool searchDocTest2() = size(searchDocument(|project://rascal-lucene/src/analysis/text/search/testdata/Fac.pico|, "repnr", analyzer=commentAnalyzer())) == 0;
test bool searchDocTest3() = size(searchDocument(|project://rascal-lucene/src/analysis/text/search/testdata/Fac.pico|, "check", analyzer=commentAnalyzer())) == 1;

void main() {
  picoIndex();
  picoSearch("x");
  picoSearch("input || x");
  picoSearch("input && output");
  picoSearch("bst");
}
