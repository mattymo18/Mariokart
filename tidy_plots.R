#data & lib load
characters <- read.csv("source_data/characters.csv")
library(tidyverse)

### Prelim Plots for README ###

g1 <- characters %>% 
  ggplot(aes(x=reorder(Character, Speed), y=Speed)) + 
  geom_bar(aes(fill = Class), stat = "identity") +
  coord_flip() +
  labs(title = "Character Speeds", 
       x = "Character", 
       y = "Speed") +
  scale_fill_discrete(breaks=c("Light", "Medium", "Heavy")) +
  theme_minimal()

ggsave("readme_graphics/Character.Speed.plot.png")