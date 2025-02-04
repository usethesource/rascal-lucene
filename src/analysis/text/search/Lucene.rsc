@license{
Copyright (c) 2025, NWO-I Centrum Wiskunde & Informatica (CWI)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
@synopsis{Simple interface to the Lucene text analysis library}
@description{
This module wraps the Apache Lucene framework for text analysis. 

* It integrates deeply by
providing the interfaces for the analysis extension points of Lucene via Rascal callback functions: Analyzers, Tokenizers, Filters.
* It provides access to the full library of Lucene's text analyzers via their class names.
* It is a work in progress. Some configurability of Lucene is not yet exposed, for example
programmable weights for fields and the definition of similarity functions per document field. Also Query expressions are not yet exposed.
* This wrapper provides full abstraction over source locations. Both the directory of the index
as well as the locations of input documents are expressed using any existing rascal `loc`.
}
module analysis::text::search::Lucene

@synopsis{A Lucene document has a src and an open set of keyword fields which are also indexed}
@description{
A lucene document has a `src` origin and an open set of keyword fields. 
Add as many keyword fields to a document as you want. They will be added to the Lucene document as "Fields".

* fields of type `str` will be stored and indexed as-is
* fields of type `loc` will be indexed but not stored
}
data Document = document(loc src, real score=.0);

data Analyzer 
  = analyzerClass(str analyzerClassName)
  | analyzer(Tokenizer tokenizer, list[Filter] pipe)
  ;

@synopsis{A fieldsAnalyzer declares using keyword fields which Analyzers to use for which Document field.}
@description{
The `src` parameter of `fieldsAnalyzer` aligns with the `src` parameter of a Document: this analyzer is used
to analyze the `src` field. Any other keyword fields, of type `Analyzer` are applied to the contents of a
`Document` keyword field of type `loc` or `str` with the same name.
}
data Analyzer  
  = fieldsAnalyzer(Analyzer src) 
  ;

data Term = term(str chars, loc src, str kind);
    
data Tokenizer
  = tokenizer(list[Term] (str input) tokenizerFunction)
  | tokenizerClass(str tokenizerClassName)
  ;
  
data Filter
  = \editFilter(str (str term) editor)             // replace terms with other terms
  | \removeFilter(bool (str term) accept)          // only accept certain terms and remove the others
  | \splitFilter(list[str] (str term) splitter)    // split a term into several (sequentially positioned) terms, replacing the original term
  | \synonymFilter(list[str] (str term) generator) // introduce alternative terms at the same position in the input stream, replacing the original term
  | \tagFilter(str (str term, str current) tagger) // tag a term with a new type tag/category
  | \filterClass(str filterClassName)              // use an existing filterclass (if it has a nullary constructor)
  ;  

@javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Creates a Lucene index at a given folder location from the given set of Documents, using a given set of text analyzers}
java void createIndex(loc index, set[Document] documents, Analyzer analyzer = standardAnalyzer(), str charset="UTF-8", bool inferCharset=!(charset?));

@javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Searches a Lucene index indicated by the indexFolder by analyzing a query with a given set of text analyzers and then matching the query to the index.}
java set[Document] searchIndex(loc index, str query, Analyzer analyzer = standardAnalyzer(), int max = 10);

@javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Searches a document for a query by analyzing it with a given analyzer and listing the hits inside the document, for debugging and reporting purposes.}
java list[loc] searchDocument(loc doc, str query, Analyzer analyzer = standardAnalyzer(), int max = 10, str charset="UTF-8", bool inferCharset=!(charset?));

@javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Simulate analyzing a document source location like `createIndex` would do, for debugging purposes} 
java list[Term] analyzeDocument(loc doc, Analyzer analyzer = standardAnalyzer());

@javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Simulate analyzing a document source string like `createIndex` would do, for debugging purposes} 
java list[Term] analyzeDocument(str doc, Analyzer analyzer = standardAnalyzer());

@javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Inspect the terms stored in an index for debugging purposes (what did the analyzers do to the content of the documents?)}
java rel[str chars, int frequency] listTerms(loc index, str field, int max = 10);

 @javaClass{analysis.text.search.LuceneAdapter}
@synopsis{Inspect the fields stored in an index for debugging purposes (which fields have been indexed, for how many documents, and how many terms?)}
java rel[str field, int docCount, int sumTotalTermFreq] listFields(loc index); 


Analyzer classicAnalyzer()    = analyzerClass("org.apache.lucene.analysis.standard.ClassicAnalyzer");
Analyzer simpleAnalyzer()     = analyzerClass("org.apache.lucene.analysis.core.SimpleAnalyzer");
Analyzer standardAnalyzer()   = analyzerClass("org.apache.lucene.analysis.standard.StandardAnalyzer");
Analyzer whitespaceAnalyzer() = analyzerClass("org.apache.lucene.analysis.core.WhitespaceAnalyzer");  

Tokenizer classicTokenizer()   = tokenizerClass("org.apache.lucene.analysis.standard.ClassicTokenizer");
Tokenizer lowerCaseTokenizer() = tokenizerClass("org.apache.lucene.analysis.core.LowerCaseTokenizer");

Filter lowerCaseFilter() = filterClass("org.apache.lucene.analysis.LowerCaseFilter");
