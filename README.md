# This repo includes code and data to reproduce stats and figures included in the 2024 JVS editorial (doi: ).

*R and RStudio versions used*
- R version used: R version 4.1.2 "Bird Hippie" (2021-11-01)
-  Rstudio version used: ‘2023.9.1.494’ "Desert Sunflower"

*Version of the main R packages used:*
- tidyverse version 2.0.0
- scales version 1.2.1 
- ggpubr version 0.6.0

*data:*
a dataframe including 1965 rows (observations, i.e. scanned articles) and 15 columns, whose description follows:
- user: the user that entered data for the observation, i.e. the person responsible for scanning the article
- journal: the journal where the article was published (JVS or AVS)
- year, volume and issue: the year, volume and issue in which the article was published
- doi: the doi of the article
- code_avail: code availability (0: code not available; 1: code available)
- code_access: code accessibility (0: code not accessible; 1: code accessible)
- code_broken_link: the code was not accessible due to broken link (0-1)
- code_private_repo: the code was not accessible due to the repository being private (0-1)
- data_avail: data availability (0: data not available; 1: data available)
- data_access: data accessibility (0: data not accessible; 1: data accessible)
- data_broken_link: the data was not accessible due to broken link (0-1)
- data_private_repo: the data was not accessible due to the repository being private (0-1)
-archiving_loc: where the data as archived (E: external repository; S: archived as supplementary material; M: mixed, a combination of external repo and supplementary material)
