# caikit-text-generation

## Environment setup

```sh 
python3 -m caikit.runtime.dump_services protos
python3.9 -m venv caikit-env-3.9
source ./caikit-env-3.9/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
```

## Start server and client

* Start the server in the first terminal

```sh
source ./caikit-env-3.9/bin/activate
python start_runtime.py
```

* Start the client in the second terminal

```sh
source ./caikit-env-3.9/bin/activate
python client.py
```

## Create `protos`

Execute the following command in the third terminal.
The command will create a folder with the proto files on your local computer.

```sh
source ./caikit-env-3.9/bin/activate
export CONFIG_FILES=text_generation/config.yml
python3 -m caikit.runtime.dump_services protos
```

## Use `grpcurl`

* List the services

```sh
grpcurl -import-path ./protos -proto textgenerationservice.proto list
```

Example output:

```sh
caikit.runtime.TextGeneration.TextGenerationService
```

* Try to use `grpcul`

```sh
grpcurl -import-path ./protos -proto textgenerationservice.proto -d '{"text_input":{"text":"I am not"}}' -plaintext localhost:8085 caikit.runtime.TextGeneration.TextGenerationService/HfModulePredict
```

* List the services

```sh
grpcurl -import-path ./protos -proto textgenerationservice.proto -plaintext localhost:8085 list
```

Example output:

```sh
caikit.runtime.TextGeneration.TextGenerationService
```

## Container

* Build a container image and execute a container image

```sh
docker build -f Dockerfile -t example:v1 .
docker run -it example:v1
```

* Verify the created `protos`

Navigate inside the container to the `protos` folder.

```sh
cd protos
ls
```

* Example output

```sh
hfmodulerequest.proto                textoutput.proto
modelpointer.proto                   traininginforequest.proto
producerid.proto                     traininginforesponse.proto
producerpriority.proto               trainingjob.proto
textgenerationservice.proto          trainingmanagement.proto
textgenerationtrainingservice.proto  trainingstatus.proto
textinput.proto
```

