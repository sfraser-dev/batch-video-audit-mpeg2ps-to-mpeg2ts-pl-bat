@echo off
:: Recursively search (current and subfolders) for files with the extension CONTAINER_EXTN
SET CONTAINER_EXTN=err
:: "delims=" means do not parse into tokens (preserve each line). 
for /f "delims=" %%f in ('dir "*.%CONTAINER_EXTN%" /s/b') do @call:removeit "%%f"
goto:eof

:removeit
SET THE_ORIGINAL_NAME="%~f1"
:: Test it first!
dir %THE_ORIGINAL_NAME%
::del /Q /F %THE_ORIGINAL_NAME%
goto:eof

