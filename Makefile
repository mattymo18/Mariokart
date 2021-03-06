.PHONY: clean

#cleans entire repository of derived elements
clean:
	rm derived_data/*.csv
	rm derived_graphics/*.png


readme_graphics/Character.Speed.plot.png:\
 source_data/characters.csv\
 tidy_plots.R
	Rscript tidy_plots.R