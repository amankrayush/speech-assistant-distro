#!/bin/bash

cd "$(dirname "$0")"/..

mkdir -p api/deployed_models && cd "$_"

echo "downloading english models..."

mkdir english_test && cd "$_"

code=$(curl -O -w "%{http_code}" https://storage.googleapis.com/vakyansh-open-models/models/english/en-IN/dict.ltr.txt)

if [[ $code != 200  ]] ; then
    echo "Erorr occured while downloading dictionary file."
fi

code=$(curl -O -w "%{http_code}" https://storage.googleapis.com/vakyansh-open-models/models/english/en-IN/english_infer.pt)

if [[ $code != 200  ]] ; then
    echo "Erorr occured while downloading inference file."
fi

code=$(curl -O -w "%{http_code}" https://storage.googleapis.com/vakyansh-open-models/models/english/en-IN/lexicon.lst)

if [[ $code != 200  ]] ; then
    echo "Erorr occured while downloading lexicon file."
fi

code=$(curl -O -w "%{http_code}" https://storage.googleapis.com/vakyansh-open-models/models/english/en-IN/lm.binary)

if [[ $code != 200  ]] ; then
    echo "Erorr occured while downloading lm file."
fi

cd ..

echo "downloading hindi models..."

mkdir hindi && cd "$_"

code=$(curl -O https://storage.googleapis.com/vakyansh-open-models/models/hindi/hi-IN/dict.ltr.txt)
if [[ $code != 200  ]] ; then
    echo "Erorr occured while downloading dictionary file."
fi

echo "download successful !!."