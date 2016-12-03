# Further Cleaning and Pruning the Dataset

Beyond the initial data "cleaning" steps described above in the Methods section, I took several steps to better organize the dataset to make it more ready for use in analyses.

## Pruning Within-Newspaper Duplicate Obituaries

As noted above, overlap in obituary download dates caused some obituaries to be downloaded twice. In addition, several obituaries were downloaded repeatedly from the same newspapers because they appeared over time in multiple forms in *Legacy.com's* search results. Several of these forms are non-exhaustively listed below:

* "Teaser" obituaries, which seemed to serve as placeholders for full, biographical texts, but presented only logistical death notice information (e.g., time and location of funerary services). These obituaries also sometimes contained a note that the full obituary would be published on a given date.
* Variants of the same text, but including a nickname of the deceased (e.g., "John Doe..." vs. "John 'Johnny' Doe...")
* Variants of the same text, but including spelling corrections (especially for place names).

To remove these duplicates, I grouped obituaries by newspaper and obituary text (i.e., condensing by exactly-matching obituary text strings)[^footnoteOnGroupingWithOrWithoutNameOfDeceased]. This removed approximately 16% of the original dataset's rows, leaving 177,272 rows. I then further condensed the dataset using the URL of each obituary (as each obituary listed in a *Legacy.com* search result page contains a link to a unique page comprising only that obituary). 1.66% of the remaining dataset contained a duplicate URL (e.g., from the "teaser" obituaries mentioned above). After confirming that no URLs were duplicated *across* newspapers (cross-newspaper duplicates are discussed below, as a separate area of consideration), for each URL in the dataset, I retained the obituary with the longest word count, assuming it to be the most updated version of the obituary text. This removed an additional 1,482 rows (0.836% of the remaining dataset) from the dataset (a portion of the 1.66% mentioned above), leaving 175,790 rows[^footNoteOnCleaningProductionDatasetRegardingWithinNewspaperDuplicates].

[^footnoteOnGroupingWithOrWithoutNameOfDeceased]: I compared this method to grouping by newspaper, obituary text, and name of the deceased. The two methods produced a difference of 218 rows. I then compared the names of the deceased for each pair of rows that contained matching obituary text but non-matching names (in order to confirm that obituaries of two separate people had not both been written from similar templates, e.g.), and found that in all cases, the paired obituaries qualitatively obviously referred to the same individuals, differing only in punctuation, capitalization, or other minor differences in the printed name of the deceased.

[^footNoteOnCleaningProductionDatasetRegardingWithinNewspaperDuplicates]: The "development" dataset was similarly cleaned: of its remaining rows, 0.181% were removed, leaving 15,957 rows (zero rows were removed from the development dataset for containing duplicate URLs).

## Removing Obituaries of Individuals of Unknown Age

Of the remaining dataset, 6.256% did not contain sufficient information for the automated age-coding algorithm to make a guess. Given the relatively low percentage of the dataset lacking an age guess, and the intention to use age as a predictor in the regression models below, I excluded these data from further analyses, rather than attempt (likely problematically) to impute age values. This left 164,792 rows in the dataset[^footNoteOnCleaningProductionDatasetRegardingUnknownAge].

[^footNoteOnCleaningProductionDatasetRegardingUnknownAge]: The "development" dataset was similarly cleaned: of its remaining rows, 5.634% were removed for being of uncertain age, leaving 15,058 rows.

## Removing Obituaries of Individuals of Uncertain Gender

Of the remaining dataset, 0.439% (724 rows) were assigned a gender category of "uncertain" by the automated coding algorithm. Given the low percentage of data in this third category (vs. "female," which 48.867% of the remaining dataset was coded as; and "male," which 50.694% of the remaining dataset was coded as), I excluded those rows from further analyses. This left 164,068 rows in the dataset[^footNoteOnCleaningProductionDatasetRegardingUnknownGender].

[^footNoteOnCleaningProductionDatasetRegardingUnknownGender]: The "development" dataset was similarly cleaned: of its remaining rows, 0.578% were removed for being of uncertain gender, leaving 14,971 rows (before removing these unknown rows, the percentages of obituaries coded as female vs. male were 49.416% and 50.001%, respectively).

## Assessing Across-Newspaper Duplicate Obituaries

A frequency table of obituary text strings (i.e., collapsing exactly-matching obituary texts and counting the frequency of each) revealed that 20.294% of the remaining dataset were duplicate obituaries *across newspapers* (within-newspaper duplicates having been removed following the description above; a check was also performed at this step to confirm that no within-newspaper duplicate obituary texts remained in the dataset).

These duplicate obituaries were not isolated to only a small number of newspapers: 393 papers in the sample printed at least one duplicate obituary. This is not conceptually problematic: it is understandable that an obituary be published in more than one newspaper, depending on the notoriety or width of the social circle of the deceased, and/or the number of newspapers operating simultaneously in the same geographic region. However, from an analysis perspective, this overlap required consideration. Steps taken to accommodate these duplicate obituaries are described further below.

# Analyses

## Calculation of a Measure of Network Distance, "Word-by-Hop"

Because not all lemmas contained in the obituary corpus were related to all Schwartz values (or, more specifically, to all of the words from Bardi et al.'s [2008] value lexicon), it was necessary to calculate a numeric value for each word's relationship with each of the value lexicon words that was able to represent "no relationship." Number of hops through the WordNet graph, while intuitive to use when answering Research Question 1, was inapposite for use especially in the regression context of Research Question 2, since it was only able to represent a lack of relationship (i.e., no path within 15 hops between two lemmas) with missing values; "0" hops, rather than signifying no relationship, signified a *perfect* relationship, that the lemmas being compared were identical. Thus, in a regression context, lemmas that were unrelated to given Bardi words would need to be either a) excluded from analyses in either a listwise or pairwise fashion, or b) imputed with an arbitrary value (such as 100). Neither of these solutions seemed satisfactory; therefore, a new calculation, called "word-by-hop[^footnoteOnWordByHopName]," was used.

[^footnoteOnWordByHopName]: "Word-by-hop" is a shorthand for "Words divided by median hops."

Word-by-hop values are not meaningful in isolation, but *can* be compared to one another to determine the relative fit between different pairs of lemmas. Larger word-by-hop values represent better "fit" with a Schwartz value, where fit is defined as "greater connection," rather than solely by "fewer hops."

### Final Calculation Formula for Word-by-Hop

This report first presents the final calculation for "word-by-hop," in order that it be presented as early as possible. Following that, it explains the step-by-step development of the calculation.

The equation for word-by-hop is as follows:

$$
\text{word-by-hop} =
\frac{
	\frac{
		\text{Number of words that have a path to Value v}
	}{
		\text{Total number of words in the obituary}
	}
}{
1 + \text{Median number of hops of the connected words to Value v}
}
$$

Word-by-hop has boundaries at [0, 1][^footnoteOnClosedInterval].

[^footnoteOnClosedInterval]: The notation is meant to denote a "closed" interval, i.e., one that includes its endpoints.


