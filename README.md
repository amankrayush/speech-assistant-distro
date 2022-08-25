# Speech Assistant Distro

## Overview

This project for distribution of speech recognition applications : 

  * [speech-recognition-open-api](https://github.com/Open-Speech-EkStep/speech-recognition-open-api) - Converts speech into text using an API powered by deep learning neural network algorithms for automatic speech recognition (ASR). To know more, [Click Here](https://open-speech-ekstep.github.io/asr_model_api/)
  
  * [speech-recognition-open-api-proxy](https://github.com/Open-Speech-EkStep/speech-recognition-open-api-proxy) - This project is a proxy to provide support for real-time streaming functionality for [Open Speech API](https://open-speech-ekstep.github.io/) from browsers or any clients that doesn't support gprc bi-directional streaming. Refer the real-time streaming documentation for architecture details [here](https://open-speech-ekstep.github.io/asr_streaming_service/)

-----------

## Installation

* Install [Git](https://git-scm.com/downloads)
* Install [docker](https://docs.docker.com/engine/install/)

---------

## Setup

1. clone the [repo](https://github.com/amankrayush/speech-assistant-distro/).
```
git clone git@github.com:amankrayush/speech-assistant-distro.git
```
2. download model for languages (To recognize speech and convert it into text for particular language)
```
sh ./scripts/download_models.sh "english Hindi"
```

3. update the network name in docker-compose.yml file as per your requirement. 
```
networks:
  default:
    name: bahmni-docker_default
    external: true
```
  Note : 
  * speech-Assistant-Distro is intergrated with [Bahmni](https://github.com/Bahmni/bahmni-package), that's why network name is mentioned as 'bahmni-docker_default'
  * remove the networks field if you don't need external network, else update it with external network name and external network should exist in docker when we are making distro applications up.

4. make applications up (make sure models are available - mentioned in step 2)
```
docker-compose up -d
```

-------------

### Notes:

* speech streaming functionality will be served by [proxy server](https://github.com/Open-Speech-EkStep/speech-recognition-open-api-proxy) which has exposed at 9009 port.