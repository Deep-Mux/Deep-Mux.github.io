# Functions Quickstart 

In this tutorial we are going to create a demo python funciton in a step-by-step manner and deploy it on the DeepMux platform.

## What are deepmux functions

DeepMux functions are serverless functions that allow you to write complex data processing algorithms without caring about setting up complex infrastructure.

## Making sure deepmux-cli is installed

Check out the [Installation guide](/cli/) for detailed instructions.


## Setting up the project

We recommend creating your project in a separate directory. For example:
```bash
mkdir -p myproject
cd myproject
```

List function environments and choose the appropriate.

Environments are used to define language you are going to use to code the function and provide some pre-installed libraries.

```bash
deepmux env
```
We are going to use `python3.7` environment

Then initialize the project with the following command:

```bash
deepmux init
```

This will create `deepmux.yaml` and `.deepmuxignore` files in your current directory.

Contents of `deepmux.yaml`:

```yaml
name: <required, function name>
env: <required, function env>
python:
  call: <required, module:function to call>
  requirements: <optional, path to requirements.txt>
```

Fill the `name` field with `myproject` and `env` with `python3.7`. You can use `deepmux env` command to list all available environments.


Contents of `.deepmuxignore`:

```
.deepmuxignore
```

It is a standard ignore file and should contain ignore patterns.

We are going to fill in `name`, `env`, `call` and `requirements` sections later.


## Implementing function

Now it's time to implement the function itself.

In this example we will implement a functions that simply reverses it's input.

Create `main.py` file in the project directory and fill it with the following code:

```python
def reverse_function(data):
    return data[::-1]

```
> Functions written in Python accept `bytes` and return `bytes`.

Let's save this function to a file `main.py` and add it as an entrypoint.

You need to open `deepmux.yaml` and add `main:reverse_function` to the `call:` section.

At this point `deepmux.yaml` would look like:
```yaml
name: myproject
env: python3.7
python:
  call: main:reverse_function
  requirements: <optional, path to requirements.txt>
```

And the project structure should look like:

```
myproject/
myproject/deepmux.yaml
myproject/main.py
```

## Add requirements (Optional)

> If you don't have any requirements just delete the last line from `deepmux.yaml` file and skip this section.

You can add requirements for your function. Let's say we need `numpy` package in our function.


Write`requirements.txt` file

```txt
numpy==1.19.4
```

And add path to the file in your `deepmux.yaml`:
```yaml
name: myproject
env: python3.7
python:
  call: main:reverse_function
  requirements: requirements.txt
```


## Uploading the function

Once we've finished with the function, requirements and `deepmux.yaml` we are able to upload function to the platform via cli.
```bash 
deepmux upload
```

Function will take some time to process. You can use 
```
deepmux list
```
command to get your functions and their statuses or simply check your functions via the [Web UI](https://app.deepmux.com/functions).

## Running the function

Once your function has finished processing and is in `READY` state you can call it with an HTTP request.

Here's an example using curl:
```bash
curl -X POST \
     -H "X-Token: <YOUR API TOKEN>" \
     https://api.deepmux.com/v1/function/myproject/run \
     --data "Hello!"
```
You should see the following on the screen:
```
!olleH
```

You also could run your function via cli:
```bash
deepmux run --name myproject --data 'hello!'
!olleh
```

Done! Now you are ready to implement more complex functions and enjoy deploying them on the DeepMux platform.
