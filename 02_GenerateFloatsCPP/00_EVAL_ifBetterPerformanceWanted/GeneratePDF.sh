#!/bin/bash
#sudo apt-get install texlive-xetex
pandoc README.md --pdf-engine=xelatex -o README.pdf
