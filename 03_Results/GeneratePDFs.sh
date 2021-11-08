#!/bin/bash
#sudo apt-get install texlive-xetex
pandoc Longtext.md --pdf-engine=xelatex -o Longtext.pdf
pandoc Float.md --pdf-engine=xelatex -o Float.pdf
