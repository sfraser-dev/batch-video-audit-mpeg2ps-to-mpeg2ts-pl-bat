@echo off
:: Converting MPEG2 PS to MPEG2 TS
SET CONTAINER_EXTN=mpg
:: Recursively search (current and subfolders) for filenames of media containers; "delims=" means do
:: not parse into tokens (preserve each line). Thus, each media container filename is passed into the
:: %%f variable of the ffmpegConvert function.
for /f "delims=" %%f in ('dir "*.%CONTAINER_EXTN%" /s/b') do @call:ffmpegConvert "%%f"
goto:eof

:ffmpegConvert
SET THE_ORIGINAL_NAME="%~f1"
:: Grab different parts of the filename passed to this ffmpegConvert function
SET THE_DRIVE_LETTER=%~d1
SET THE_PATH=%~p1
SET THE_FILE=%~n1
SET THE_EXTN=%~x1
:: Generate a new name for the new TS file
SET THE_NEW_NAME="%THE_DRIVE_LETTER%%THE_PATH%%THE_FILE%.ts"
:: Use ffmpeg to convert from MPEG2 PS to MPEG2 TS
ffmpeg -fflags +genpts -y -i %THE_ORIGINAL_NAME% -c:v copy -c:a copy -f mpegts %THE_NEW_NAME%
goto:eof
