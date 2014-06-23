@echo off
ffprobe -show_format_entry format_long_name 20140619144156437@DVR-Test_Ch1.mpg > tmp.txt
for /F "tokens=3" %%f in ('find /c /i "Program Steam" "./tmp.txt"') do set THECOUNT=%%f
echo.Number of occurrences = %THECOUNT%
