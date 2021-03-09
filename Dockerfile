FROM rocker/verse
MAINTAINER Matt Johnson <Johnson.Matt1818@gmail.com>
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('shinythemes')"
RUN R -e "install.packages('plotly')"
