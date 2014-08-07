@echo off
:: Converting the container using FFMPEG
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
:: Create a backup of the original video
SET THE_BACKUP_NAME="%THE_DRIVE_LETTER%%THE_PATH%%THE_FILE%.%CONTAINER_EXTN%_bak"
move /Y %THE_ORIGINAL_NAME% %THE_BACKUP_NAME%

:: Use FFMPEG to reconstruct the container
ffmpeg -i %THE_BACKUP_NAME% -c:v copy -c:a copy %THE_ORIGINAL_NAME%
goto:eof
