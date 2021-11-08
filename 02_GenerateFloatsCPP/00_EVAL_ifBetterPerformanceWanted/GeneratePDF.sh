#!/bin/bash
#sudo apt-get install texlive-xetex
pandoc README.md --pdf-engine=xelatex -o README.pdf
#pandoc README.md --pdf-engine=pdflatex -o README.pdf
