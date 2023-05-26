# caikit-text-generation

* Environment setup

```sh 
python3 -m caikit.runtime.dump_services protos
python3.9 -m venv caikit-env-3.9
source ./caikit-env-3.9/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
```

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