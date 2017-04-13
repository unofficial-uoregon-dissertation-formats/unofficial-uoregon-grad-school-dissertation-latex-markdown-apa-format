# Data Collection and Initial Processing

## Lexical Graph Database

### WordNet

@bardi_new_2008 composed a "value lexicon" of three "lexical indicators" (i.e., prototype words) for each of the 10 Schwartz values categories, for a total of 36 words (1 category title + 3 prototype words for each of the 10 categories, with some titles overlapping with prototype words). This Schwartz values dictionary is reprinted in Table \ref{bardiEtAlValueLexicon}.

Table: The Schwartz value lexicon, reprinted from @bardi_new_2008. \label{bardiEtAlValueLexicon}

|     Value      | Lexical indicators for each value |
|----------------|-----------------------------------|
| Power          | power, strength, control          |
| Achievement    | achievement, ambition, success    |
| Hedonism       | luxury, pleasure, delight         |
| Stimulation    | excitement, novelty, thrill       |
| Self-direction | independence, freedom, liberty    |
| Universalism   | unity, justice, equality          |
| Benevolence    | kindness, charity, mercy          |
| Tradition      | tradition, custom, respect        |
| Conformity     | restraint, regard, consideration  |
| Security       | security, safety, protection      |

In order to quantify the extent to which obituaries in the current project's corpus were concerned with each of the 10 Schwartz values, I paired Bardi et al.'s value lexicon with a network-graph-based dictionary/thesaurus of the full English language. In doing so, I enabled analyses of "lexical distance," as explained below (see the section defining "word-by-hop"), between words in any given obituary and the words from Bardi et al.'s value lexicon.

Beginning in 2005, and with updates periodically through 2010 (when it released its current version as of this writing, 3.1), @wordnet_main_citation published WordNet, a computer-readable dictionary/thesaurus of 147,478 words grouped in 117,791 definitions. WordNet version 3.1 was downloaded in SQLite[^footnoteOnSQLite] format from the WordNet SQL (WNSQL) project [@wordnet_sql], which repackaged the WordNet database for ready use. The database tables were converted into separate CSV files, which were then imported into Neo4J v2.3.3 Community Edition, an open-source graph database platform.

A traditional "relational database" (e.g., WordNet in its original form), which models data in a collection of linked "tables" (each conceptually equivalent to a spreadsheet, with ID numbers from one table recorded in columns in linked subsequent tables allowing related data to be joined during queries). In contrast, a graph database models data directly as nodes and relationships between them. Graph databases can thus be used more straightforwardly than traditional relational databases to find paths between nodes of different types (for example, from a word $x$ through a series of definitions and words to a final word, $y$).

The import of the WordNet tables into Neo4J expanded on work by @nagi_new_2013, who published a schema for representing the primary tables of WordNet in Neo4J. Nagi's schema specifically encompassed the Words, Senses, Synsets, Semlinks, and Linktypes tables of WordNet; the graph database constructed for this project additionally included WordNet's Morphs and Morphmaps tables. The graph database constructed for this project used three WordNet-derived relationship types ("Is a form of," "Is related to," and "Is defined as"), as well as one relationship type (not used in the analyses reported below) derived from the University of South Florida Free Association Norms dataset [@nelson_free_association_1998, see below], "Is freely associated with." These relationships are summarized in Table \ref{wordNetNodeAndRelationshipTypes}.

Table: Node and relationship types in the WordNet graph database. \label{wordNetNodeAndRelationshipTypes}

| From Node | Relationship Name         | To Node |
|-----------+---------------------------+---------|
| Word      | IS_FREELY_ASSOCIATED_WITH | Word    |
| Morph     | IS_A_FORM_OF              | Word    |
| Synset    | IS_RELATED_TO             | Synset  |
| Word      | IS_DEFINED_AS             | Synset  |


