@license{
Copyright (c) 2025, NWO-I Centrum Wiskunde & Informatica (CWI)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
module analysis::text::search::StandardAnalyzers

extend analysis::text::search::Lucene;

Analyzer arabic() = analyzerClass("org.apache.lucene.analysis.ar.ArabicAnalyzer");
Analyzer armenian() = analyzerClass("org.apache.lucene.analysis.hy.ArmenianAnalyzer");
Analyzer basque() = analyzerClass("org.apache.lucene.analysis.eu.BasqueAnalyzer");
Analyzer bengali() = analyzerClass("org.apache.lucene.analysis.bn.BengaliAnalyzer");
Analyzer brazilian() = analyzerClass("org.apache.lucene.analysis.br.BrazilianAnalyzer");
Analyzer bulgarian() = analyzerClass("org.apache.lucene.analysis.bg.BulgarianAnalyzer");
Analyzer catalan() = analyzerClass("org.apache.lucene.analysis.ca.CatalanAnalyzer");
Analyzer czech() = analyzerClass("org.apache.lucene.analysis.cz.CzechAnalyzer");
Analyzer danish() = analyzerClass("org.apache.lucene.analysis.da.DanishAnalyzer");
Analyzer dutch() = analyzerClass("org.apache.lucene.analysis.nl.DutchAnalyzer");
Analyzer english() = analyzerClass("org.apache.lucene.analysis.en.EnglishAnalyzer");
Analyzer finnish() = analyzerClass("org.apache.lucene.analysis.fi.FinnishAnalyzer");
Analyzer galician() = analyzerClass("org.apache.lucene.analysis.gl.GalicianAnalyzer");
Analyzer german() = analyzerClass("org.apache.lucene.analysis.de.GermanAnalyzer");
Analyzer greek() = analyzerClass("org.apache.lucene.analysis.el.GreekAnalyzer");
Analyzer hindi() = analyzerClass("org.apache.lucene.analysis.hi.HindiAnalyzer");
Analyzer hungarian() = analyzerClass("org.apache.lucene.analysis.hu.HungarianAnalyzer");
Analyzer indonesian() = analyzerClass("org.apache.lucene.analysis.id.IndonesianAnalyzer");
Analyzer irish() = analyzerClass("org.apache.lucene.analysis.ga.IrishAnalyzer");
Analyzer italian() = analyzerClass("org.apache.lucene.analysis.it.ItalianAnalyzer");
Analyzer latvian() = analyzerClass("org.apache.lucene.analysis.lv.LatvianAnalyzer");
Analyzer lithuanian() = analyzerClass("org.apache.lucene.analysis.lt.LithuanianAnalyzer");
Analyzer norwegian() = analyzerClass("org.apache.lucene.analysis.no.NorwegianAnalyzer");
Analyzer persian() = analyzerClass("org.apache.lucene.analysis.fa.PersianAnalyzer");
Analyzer portugese() = analyzerClass("org.apache.lucene.analysis.pt.PortugeseAnalyzer");
Analyzer romanian() = analyzerClass("org.apache.lucene.analysis.ro.RomanianAnalyzer");
Analyzer russian() = analyzerClass("org.apache.lucene.analysis.ru.RussianAnalyzer");
Analyzer sorani() = analyzerClass("org.apache.lucene.analysis.chb.SoraniAnalyzer");
Analyzer spanish() = analyzerClass("org.apache.lucene.analysis.es.SpanishAnalyzer");
Analyzer swedish() = analyzerClass("org.apache.lucene.analysis.sv.SwedishAnalyzer");
Analyzer thai() = analyzerClass("org.apache.lucene.analysis.th.ThaiAnalyzer");
Analyzer turkish() = analyzerClass("org.apache.lucene.analysis.tr.TurkishAnalyzer");

Analyzer cjkAnalyzer() = analyzerClass("org.apache.lucene.analysis.cjk.CJKAnalyzer");
Analyzer stopAnalyzer() = analyzerClass("org.apache.lucene.analysis.core.StopAnalyzer");
Analyzer keywordAnalyzer() = analyzerClass("org.apache.lucene.analysis.core.KeywordAnalyzer");
Analyzer unicodeWhitespaceAnalyzer() = analyzerClass("org.apache.lucene.analysis.core.UnicodeWhitespaceAnalyzer");
Analyzer emailAnalyzer() = analyzerClass("org.apache.lucene.analysis.standard.UAX29URLEmailAnalyzer");
