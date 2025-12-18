@license{
Copyright (c) 2025, NWO-I Centrum Wiskunde & Informatica (CWI)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

@synopsis{Provides the library of stemmers written in the Snowball languages, and compiled to Java, which are
distributed with Lucene as a Rascal module.}
@description{
See [the Snowball homepage](http://snowball.tartarus.org) for more informations
}
@examples{
```rascal-shell
import analysis::text::stemming::Snowball;
stem("bikes")
```
}
module analysis::text::stemming::Snowball

data Language
  = armenian()
  | basque()
  | catalan()
  | danish()
  | dutch()
  | english()
  | finnish()
  | french()
  | german()
  | german2()
  | hungarian()
  | irish()
  | italian()
  | lithuanian()
  | norwegian()
  | portugese()
  | romanian()
  | russian()
  | spanish()
  | swedish()
  | turkish()
  ;
  

@synopsis{Stemming algorithms from the Tartarus Snowball [the Snowball homepage](http://snowball.tartarus.org) for various languages.}
@description{
This library wrapped into a single function supports Armenian, Basque, Catalan, Danish,
Dutch, English, Finnish, French, German, Hungarian, Irish, Italian, Lithuanian, Norwegian, Portugese,
Romanian, Russian, Spanish, Swedish and Turkish.
}  
@javaClass{analysis.text.stemming.Snowball}
java str stem(str word, Language lang=english());

@javaClass{analysis.text.stemming.Snowball}

@synopsis{Kraaij-Pohlmann is a well-known stemmer for the Dutch language.}
@description{
See http://snowball.tartarus.org/algorithms/kraaij_pohlmann/stemmer.html
}
java str kraaijPohlmannStemmer(str word);

@javaClass{analysis.text.stemming.Snowball}

@synopsis{Porter stemming is a "standard" stemming algorithm for English of sorts.}
@description{
See http://snowball.tartarus.org/algorithms/porter/stemmer.html for more information.
}
java str porterStemmer(str word);

@javaClass{analysis.text.stemming.Snowball}

@synopsis{Lovins designed the first stemmer according to the Tartarus website.}
@description{
See http://snowball.tartarus.org/algorithms/lovins/stemmer.html
}
java str lovinsStemmer(str word);
