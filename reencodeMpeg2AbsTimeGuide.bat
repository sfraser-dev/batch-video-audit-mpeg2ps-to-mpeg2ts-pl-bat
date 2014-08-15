:: Re-encode to to mpeg2 video, mp2 audio and put in TS container.
:: ffmpeg -fflags + genpts -i FILEIN.mpg -c:v mpeg2video -c:a mp2 -b:v 6M -f mpegts FILEOUT.mpg
ffmpeg -i FILEIN.mpg -c:v mpeg2video -c:a mp2 -b:v 6M -f mpegts FILEOUT.mpg
:: Convert TS FILEOUT.mpg to absolute time (not relative time)
mpegtool -nodisplay -filetime -i "FILEOUT.mpg" 

