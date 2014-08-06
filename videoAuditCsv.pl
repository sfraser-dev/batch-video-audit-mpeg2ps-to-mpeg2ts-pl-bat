#!/usr/bin/perl -w
use strict;
use warnings;
use feature qw(say);
use File::Find; 
use File::Basename;
use Cwd;

my $name;
my $dir;
my $ext;
my $filePath;
my $fileDataset;
my $fileSubProject;
my $filePathName;
my @content;
my $fout;
my $FILEOUT;
my $container;
my $probe;
my @probeArr;
my $vidWidth;
my $vidHeight;
my $vidBR;
my $frameRate;
my $mediaType;
my $timeCode;
my $errName;
my $FILEIN;
my $vidError;

$fout = "VideoAudit.csv";
open ($FILEOUT, ">", $fout) || die "Couldn't open '".$fout."' for writing because: ".$!;

# Write a file header
say $FILEOUT "Project and Dataset, Video File, MPEG Container, Resolution Width, Resolution Height, Bitrate, Framerate, First Timecode, Video Error";

# find .mpg files recursively from this directory
find( \&mpgWanted, '.');
foreach my $mpgName (@content) {
    # file path and name
    ($name,$dir,$ext) = fileparse($mpgName,'\..*');
    $filePath = cwd();
    $fileSubProject = substr $dir, 2;
    $fileDataset = "$filePath/$fileSubProject";
    $filePathName = "$filePath/.../$name$ext";
  
    # container type
    $probe = `ffprobe -v quiet -show_format_entry format_long_name $mpgName`;
    if ($probe =~ "Program Stream") {
        $container = "ProgramStream";
    }
    elsif ($probe =~ "Transport Stream"){
        $container = "TransportStream";
    }
    else {
        $container = "ContainerERROR";
    }
  
    @probeArr = `ffprobe -v quiet -show_streams $mpgName`;
    foreach my $i (@probeArr){
        # video or audio stream?
        if ($i =~ "codec_type") {
            if ($i =~ "video"){
                $mediaType = "video";
            }
            else {
                $mediaType = "audio";
            }
        }
        # average frame rate
        elsif ( ($i =~ "avg_frame_rate=") && ($mediaType =~ "video") ) {
            chomp $i;
            # Remove carriage return (^M)
            $i =~ s/\r//g;
            $frameRate = $i;
        }
        # width
        elsif ($i =~ "width"){
            chomp $i;
            # Remove carriage return (^M)
            $i =~ s/\r//g;
            $vidWidth=$i;
        }
        # height 
        elsif ($i =~ "height"){
            chomp $i;
            # Remove carriage return (^M)
            $i =~ s/\r//g;
            $vidHeight=$i;
        }
        # timecode
        elsif ($i =~ "timecode"){
            chomp $i;
            # Remove carriage return (^M)
            $i =~ s/\r//g;
            $timeCode=$i;
        }
    }
    
    # video bitrate
    @probeArr = `ffprobe -v quiet -show_format $mpgName`;
    foreach my $i (@probeArr){
        if ($i =~ "bit_rate"){
            chomp $i;
            # Remove carriage return (^M)
            $i =~ s/\r//g;
            $vidBR = $i;
        }
    }

    # look for errors with FFMPEG
    $vidError = "No"; # reset for each video file
    $errName = $fileDataset . $name . ".err";
    system("ffmpeg -v error -i $mpgName -f null - >$errName 2>&1");
    open $FILEIN, $errName or die "Could not open $errName: $!";
    # parse the error log file to see if any errors exist
    while (my $line = <$FILEIN>){
        if ($line =~ "Error"){
            $vidError= "Yes";
        }
    }
    close ($FILEIN);

    # write to output file
    say $FILEOUT "$fileDataset, $name$ext, $container, $vidWidth, $vidHeight, $vidBR, $frameRate, $timeCode, $vidError";
    say "$filePathName ... done";
    
}
close $FILEOUT;
exit;

# subroutine to recursively find all files with ".mpg" extension
sub mpgWanted {
    if ($File::Find::name =~ /.mpg/){
        push @content, $File::Find::name;
    }
    return;
}


