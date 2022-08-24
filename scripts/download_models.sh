#! /bin/bash 

cd "$(dirname "$0")"/..
shopt -s nocasematch

vakhyash_api_host_url="vakhyash-api:50051"
max_connection_to_proxy_server="10"
supported_languages=(english hindi tamil)

english=0
hindi=1
tamil=2
supported_languages_code=([english]="en" [hindi]="hi" [tamil]="ta")

model_dict_data=""
language_map_data=""

update_model_dict_data () {
    if [[ $model_dict_data != "" ]]; then
       model_dict_data+=","
    fi
    data="\"$1\": {
        \"path\": \"/$2/$2_infer.pt\",
        \"enablePunctuation\": true,
        \"enableITN\": true
    }"
    model_dict_data+="$data"
}

write_model_dict_file () {
    data="{ $1 }"
    echo "$data" > model_dict.json
}

update_language_map_data () {
    if [[ $language_map_data != "" ]]; then
       language_map_data+=", "
    fi
    language_map_data+="\"$1\""
}

write_language_map_file () {
    data="{
    \"$1\": {
      \"languages\": [
        "$2"
      ],
      \"maxConnectionCount\": $3
    }
}"
    echo "$data" > language_map.json
}



isLanguageSupported () {
   for i in "${!supported_languages[@]}"; do
     if [[ ${supported_languages[$i]} = $1 ]]; then
       return 1
     fi
   done
   return 0
}

downloadFile () {
    code=$(curl -O -w "%{http_code}" $1)
    if [[ $code != 200  ]] ; then
        echo "unable to download file : $1"
        exit 1
     fi 
}
    
downloadLanguageModelFiles () {
    dictFilePath="https://storage.googleapis.com/vakyansh-open-models/models/$1/$2-IN/dict.ltr.txt"
    inferFilePath="https://storage.googleapis.com/vakyansh-open-models/models/$1/$2-IN/$1_infer.pt"
    lexiconFilePath="https://storage.googleapis.com/vakyansh-open-models/models/$1/$2-IN/lexicon.lst"
    binaryFilePath="https://storage.googleapis.com/vakyansh-open-models/models/$1/$2-IN/lm.binary"

    file_path_arr=($dictFilePath $inferFilePath $lexiconFilePath $binaryFilePath)

    for i in "${!file_path_arr[@]}"; do
        downloadFile ${file_path_arr[$i]}
    done
}

languages="$1"

for lang in $languages; do
    isLanguageSupported $lang

    response=$?

    if [[ $response == 0  ]] ; then
        echo "language is not supported : $lang"
        exit 1
    fi
done

mkdir -p api/deployed_models && cd "$_"

for lang in $languages; do

    language=$(echo $lang | tr '[:upper:]' '[:lower:]')

    mkdir -p "$language" && cd "$_"

    downloadLanguageModelFiles $language ${supported_languages_code[language]}

    cd .. 
    update_model_dict_data ${supported_languages_code[language]} $language 
    update_language_map_data ${supported_languages_code[language]}
done

write_model_dict_file "$model_dict_data"

cd ../..

mkdir -p proxy/deployed_models && cd "$_"

write_language_map_file "$vakhyash_api_host_url" "$language_map_data" $max_connection_to_proxy_server