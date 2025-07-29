#!/bin/bash

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
            echo "❌ Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validações
if [[ -n "$folderPath" && -n "$filePath" ]]; then
    echo "❌ Use apenas um parâmetro: --folderPath OU --filePath."
    exit 1
fi

if [[ -n "$folderPath" ]]; then
    if [[ ! -d "$folderPath" ]]; then
        echo "❌ Pasta não encontrada: $folderPath"
        exit 1
    fi
    echo "🔄 Convertendo todos os vídeos em: $folderPath"
    shopt -s nullglob
    for video in "$folderPath"/*.{mp4,mkv,mov}; do
        echo "🎥 Convertendo: $video"
        convert_video "$video"
    done
    exit 0
fi

if [[ -n "$filePath" ]]; then
    if [[ ! -f "$filePath" ]]; then
        echo "❌ Arquivo não encontrado: $filePath"
        exit 1
    fi
    echo "🎥 Convertendo arquivo único: $filePath"
    convert_video "$filePath"
    exit 0
fi

# Entrada interativa
read -rp "Informe o caminho de um arquivo de vídeo ou pasta: " input
if [[ -f "$input" ]]; then
    echo "🎥 Convertendo arquivo: $input"
    convert_video "$input"
elif [[ -d "$input" ]]; then
    echo "🔄 Convertendo todos os vídeos em: $input"
    shopt -s nullglob
    for video in "$input"/*.{mp4,mkv,mov}; do
        echo "🎥 Convertendo: $video"
        convert_video "$video"
    done
else
    echo "❌ Caminho inválido: $input"
    exit 1
fi
