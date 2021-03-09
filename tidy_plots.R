#data & lib load
characters <- read.csv("source_data/characters.csv")
library(tidyverse)

### Prelim Plots for README ###

g1 <- characters %>% 
  filter(Speed != 0) %>%
  ggplot(aes(x=reorder(Character, Speed), y=Speed)) + 
  geom_bar(aes(fill = Class), stat = "identity") +
  coord_flip() +
  labs(title = "Character Speed Bonus", 
       x = "Character", 
       y = "Speed",
       caption = "Other characters have a bonus speed of 0") +
  scale_fill_discrete(breaks=c("Light", "Medium", "Heavy")) +
  theme_minimal() +
  theme(plot.caption =element_text(size=12, hjust=0.5, face="italic", color="red"))


ggsave("readme_graphics/Character.Speed.plot.png")
