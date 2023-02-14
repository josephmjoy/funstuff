echo off
rem Image scaler for digital frame display using the ImageMagick (V7+) "magick" command.
rem History: Feb 2023 - Script created by JMJ
rem Usage: scalepics (it takes no arguments)
rem Input subfolder: "input"
rem Files processed: all files that have extension jpg, jpeg, png, tif, tiff (and UC variants)
rem Output subfolder: "output"
rem Output format: jpg, quality set below (80 recommended)
rem Output file name: Input file name with "XQ_" prepended, where Q is quality/10.
rem Overwriting behaviour: files are not ovewritten. If a file exists it is reported to stdout.
rem ImageMagick parameters:
rem     Read modifier set to 1280x800
rem     JPG output with specified quality
rem     This is also reflected in the "X8_" prefix (when quality is 80)

rem We enable the following sellocal configuration so that we can use the updated values of
rem certain variables within the FOR loop (INFILE, OUTFILE). Note that, for example, %INFILE%
rem evaluates to just the statically-computed value (which will be empty to start out with).
rem With the EnableDelayedExpansion option, !INFILE! will evaluate to the current value
rem (updated within the for loop).
setlocal EnableDelayedExpansion
set INDIR=input
set OUTDIR=output
rem magick interprets resolution as "max resolution in either dimension, preserving aspect ratio"
set RESOLUTION=1280x800
rem Q*10 is the JPG output quality and it is reflected in the output file name.
rem A quality of 80 is recommended (good quality, reasonable size)
set Q=8

for %%X in (%INDIR%/*.jpg %INDIR%/*.bmp %INDIR%/*.jpeg   %INDIR%/*.TIF %INDIR%/*.TIFF) do (

    rem Note that "%%~nX" extracts just file name without extension
    set INFILE=%INDIR%/%%X
    set OUTFILE=%OUTDIR%/X%Q%_%%~nX.jpg
    rem since the above are set *inside* the for loop, they must be referenced using !var!...
    rem echo INFILE:!INFILE! OUTFILE:!OUTFILE!
    if not exist !OUTFILE! (
        rem Example: magick input/in_jpg.jpg[1280x800] -quality 80% output/X8_in_jpg.jpg
        magick !INFILE![%RESOLUTION%] -quality %Q%0%% !OUTFILE!
    ) else (
        echo Not regenerating existing file "!INFILE!"
    )
)

endlocal