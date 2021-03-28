.PHONY: clean
.PHONY: mariokart_eval_tool

#cleans entire repository of derived elements
clean:
	rm derived_data/*.csv
	rm derived_graphics/*.png

# rshiny app
mariokart_eval_tool:\
 source_data/karts.csv \
 source_data/bikes.csv \
 source_data/characters.csv\
 MarioKartShiny.R
	Rscript MarioKartShiny.R ${PORT}



#plot output
readme_graphics/Character.Speed.plot.png:\
 source_data/characters.csv\
 tidy_plots.R
	Rscript tidy_plots.R