echo on
@echo cleaning Doxygen output directory
@rmdir /S /Q .\Doc
@mkdir .\Doc
@D:\Programme\Eclipse\Pilot\doxygen\doxygen.exe doxygen.txt
PAUSE
