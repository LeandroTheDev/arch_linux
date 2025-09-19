#!/bin/bash

# Davince resolve does not have some codecs because of licenses bullshits, this will convert the files to be compatible with davince, requires ffmpeg

convert_video() {
    input="$1"
    filename=$(basename -- "$input")
    name="${filename%.*}"
    ffmpeg -i "$input" \
        -c:v prores_ks -profile:v 3 \
        -pix_fmt yuv422p10le \
        -c:a pcm_s16le \
        "${name}_resolve.mov"
}

# Flags
folderPath=""
filePath=""

# Argument parser
while [[ $# -gt 0 ]]; do
    case "$1" in
        --folderPath)
            folderPath="$2"
            shift 2
            ;;
        --filePath)
            filePath="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validations
if [[ -n "$folderPath" && -n "$filePath" ]]; then
    echo "Use only one parameter: --folderPath OR --filePath."
    exit 1
fi

if [[ -n "$folderPath" ]]; then
    if [[ ! -d "$folderPath" ]]; then
        echo "Folder not found: $folderPath"
        exit 1
    fi
    echo "Converting all videos in: $folderPath"
    shopt -s nullglob
    for video in "$folderPath"/*.{mp4,mkv,mov}; do
        echo "Converting: $video"
        convert_video "$video"
    done
    exit 0
fi

if [[ -n "$filePath" ]]; then
    if [[ ! -f "$filePath" ]]; then
        echo "File not found: $filePath"
        exit 1
    fi
    echo "Converting single file: $filePath"
    convert_video "$filePath"
    exit 0
fi

# Interactive input
read -rp "Enter the path of a video file or folder: " input
if [[ -f "$input" ]]; then
    echo "Converting file: $input"
    convert_video "$input"
elif [[ -d "$input" ]]; then
    echo "Converting all videos in: $input"
    shopt -s nullglob
    for video in "$input"/*.{mp4,mkv,mov}; do
        echo "Converting: $video"
        convert_video "$video"
    done
else
    echo "Invalid path: $input"
    exit 1
fi
