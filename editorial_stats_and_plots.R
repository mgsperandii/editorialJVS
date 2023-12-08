# Code to reproduce the main stats in the article and the plot in Figure 1.

# R version used: 4.1.2 "Bird Hippie" (2021-11-01)
# Rstudio version used: ‘2023.9.1.494’ "Desert Sunflower"
# Package tidyverse version 2.0.0
# Package scales version 1.2.1 
# Package ggpubr version 0.6.0

# load packages----
library(tidyverse)
library(scales)
library(ggpubr)

# upload data----
data <- read_delim("/Users/Marta/Documenti/EcoInformatics/editorial/editorialdata_2211.csv",
                 delim = ";")

#overall stats for the text-----
# DATA ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# number of articles analysed
data %>% 
  filter(!is.na(data_avail)) %>%  #1902 articles if we exclude NAs (commentaries and obituaries)
  count(journal) # number of articles per journal: AVS has 718, JVS has 1184

# overall (or per journal) data *availability* 
data %>%
  filter(!is.na(data_avail)) %>% #removing NAs (commentaries and obituaries)
  group_by(journal) %>% # to get overall availability, remove grouping by silencing this line
  count(data_avail) %>% 
  mutate(freq = n / sum(n)) %>% 
  filter(data_avail == 1) # only show avail == 1

# overall (or per journal) data *accessibility* 
data %>%
  filter(data_avail == 1) %>% # filtering for available data
  group_by(journal) %>%  # to get overall accessibility, remove grouping by silencing this line
  count(data_access) %>% 
  mutate(freq = n / sum(n)) %>% 
  filter(data_access == 1) # only show access == 1


# CODE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# overall (or per journal) code *availability* 
data %>%
  filter(!is.na(code_avail)) %>% #removing NAs
  #group_by(journal) %>% 
  count(code_avail) %>% 
  mutate(freq = n / sum(n)) %>% 
  filter(code_avail == 1) # only show avail == 1


# overall code accessibility per journal
data %>%
  filter(code_avail == 1) %>% # filtering for available data
  group_by(journal) %>% # remove grouping to get overall availability
  count(code_access) %>% 
  mutate(freq = n / sum(n)) %>% 
  filter(code_access == 1) # only show access == 1

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Reasons for data or code not accessible 
# reasons for data not accessible
data %>% 
select(-c(code_avail:code_private_repo, archiving_loc)) %>% 
  filter(data_avail == 1 & data_access == 0) %>% # filtering for available but not accessible data
  mutate(other_reas = ifelse(data_broken_link == 0 & data_private_repo == 0, 1, 0)) %>% 
  relocate(other_reas, .after = data_private_repo) %>% 
  summarise(across(data_avail:other_reas, sum)) %>% 
  mutate(perc_brok = data_broken_link/data_avail,
         perc_private = data_private_repo/data_avail,
         perc_other = other_reas/data_avail)
  
# reasons for code not accessible
data %>% 
  select(-c(data_avail:data_private_repo, archiving_loc)) %>% 
  filter(code_avail == 1 & code_access == 0) %>% # filtering for available but not accessible code
  mutate(other_reas = ifelse(code_broken_link == 0 & code_private_repo == 0, 1, 0)) %>% 
  relocate(other_reas, .after = code_private_repo) %>% 
  summarise(across(code_avail:other_reas, sum)) %>% 
  mutate(perc_brok = code_broken_link/code_avail,
         perc_private = code_private_repo/code_avail,
         perc_other = other_reas/code_avail)

# stats for the table------
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# stats on data availab per year (for the plots)
data_stats <- data %>%
  filter(!is.na(data_avail)) %>% #removing NAs
  mutate(year = as.factor(year), # necessary or it drops the years with 0 papers
         data_avail = as.factor(data_avail)) %>% 
  group_by(journal, year) %>% 
  count(data_avail, .drop = FALSE) %>% 
  mutate(freq = n / sum(n)) 

# stats on code availab per year (for the plots)
code_stats <- data %>%
  filter(!is.na(code_avail)) %>% #removing NAs
  mutate(year = as.factor(year),
         code_avail = as.factor(code_avail)) %>% 
  group_by(journal, year) %>%
  count(code_avail, .drop = FALSE) %>% 
  mutate(freq = n / sum(n)) 

# stats for the results: min and max percentages of available data and code 
data_stats %>%
  filter(data_avail == 1) %>% 
  mutate(type = "data") %>% 
  select(-data_avail) %>% 
  bind_rows(code_stats %>% 
              filter(code_avail == 1) %>% 
              mutate(type = "code") %>% 
              select(-code_avail)) %>% 
  ungroup() %>% 
  group_by(type) %>% 
  #slice_min(n = 1, order_by = freq) #%>% # to have the minimum percentages
  slice_max(n = 1, order_by = freq)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# comparing DATA availability in the period 2015-2018 vs 2020-2023
data_stats %>%
  filter(data_avail == 1) %>% 
  mutate(type = "data") %>% 
  ungroup() %>% 
  #filter(year %in% c("2015", "2016", "2017", "2018")) %>% # avg n. papers for AVS 6.5; JVS: 8
  filter(year %in% c("2020", "2021", "2022", "2023")) %>% # avg n. papers for AVS 46; JVS: 67.5
  group_by(journal) %>% 
  summarise(avg_n_articles = mean(n))
 
# comparing CODE availability in the period 2015-2018 vs 2020-2023
code_stats %>%
  filter(code_avail == 1) %>% 
  mutate(type = "code") %>% 
  ungroup() %>% 
  #filter(year %in% c("2015", "2016", "2017", "2018")) %>% # avg n. papers with code available for AVS 1.25; JVS: 6.75
  filter(year %in% c("2020", "2021", "2022", "2023")) %>% # avg n. papers with code available for AVS 46; JVS: 67.5
  group_by(journal) %>% 
  summarise(avg_n_articles = mean(n))

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# plot Figure 1----
data_stats %>%
  filter(data_avail == 1) %>% # only keep stats related to avail. data
  mutate(type = "data") %>% # add a variable for later faceting
  select(-data_avail) %>% # remove unnecessary column
  bind_rows(code_stats %>% 
              filter(code_avail == 1) %>% # only keep stats related to avail. code
              mutate(type = "code") %>% # add a variable for later faceting
              select(-code_avail)) %>%# remove unnecessary column
  ungroup() %>% 
  mutate(type = fct_relevel(type, "data"), # relevel factor to have JVS first
         journal = fct_relevel(journal, "JVS")) %>% 
  ggplot(aes(x = year, y = freq, color = journal, group = journal)) + 
  annotate(geom = "rect", xmin = 6.75, xmax = 7.25, ymin = -Inf, ymax = Inf, col = "grey", alpha = 0.3) +
  scale_x_discrete() +
  geom_point(alpha = .5, size = 4) +
  geom_line(aes(group = journal)) +
  scale_color_manual(values = c("JVS" = "blue", "AVS" = "darkgreen"), name = "Journal") +
  scale_y_continuous(labels = label_percent()) + # requires scales!
  labs(y = "% of articles", x = "") + 
  facet_wrap(~type,
             labeller = as_labeller(c(data = "data available", code = "code available"))) +
  theme_pubr() +
  theme(axis.text = element_text(size = 15), 
        axis.title = element_text(size = 15), 
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        legend.text = element_text(size = 15),
        #panel.grid.major.x = element_blank(), panel.grid.major.y = element_blank(),
        #panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = "white", colour = "grey50"),
        panel.border = element_rect(linetype = "solid", fill = NA, color = "grey70"),
        strip.text = element_text(face = "bold", size = 15),
        strip.background = element_rect(colour="black", fill = NA, linewidth = 1))

  
