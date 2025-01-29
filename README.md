# Rascal-lucene

This package provides a two-way integration of Rascal with Lucene:
* inject Rascal functions for key components in the Lucene analysis and search pipelines (think Tokenizers and Analyzers)
* call Lucene analysis and search components directly from Rascal
* and finally compose and use fully functional Lucene pipelines

Rascal's `loc` filesystems are transparantly mapped to Lucene, such that you can index all types
of physical and logical `loc` entities.
