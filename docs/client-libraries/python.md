# DeepMux Python client library

**deepmux** is a PaaS solution to effortlessly deploy trained machine learning models on the cloud and generate predictions without setting up any hardware.

At the moment only **pytorch** models are supported.

## API Token
To use `deepmux-python` you will need an API token. You can always get one here: [app.deepmux.com/api_key](https://app.deepmux.com/api_key)

## Installation

```
pip install deepmux
```

## Creating models

You can always create a model using `create_model` function.

```python
from deepmux import create_model
```
There are multiple parameters you need to pass to create_model function:

* `pytorch_model`: Pre-trained pytorch model. Once the model is uploaded
* `model_name`: Model name by which you can refer to it once it is uploaded. 
* `input_shape`: List of input tensor shapes for each model input. A typical model would work with input shape of `[[1, 3, 224, 224]]`. Note the nested list, if your model has multiple inputs, you can pass input shapes in the topmost list like this: `[[2, 2], [1, 3]]` that would stand for two inputs of sizes 2x2 and 1x3 respectively.
* `output_shape`: List of output tensor shapes for each model input. Semantics are the same as the same as for `input_shape`.


Below is an artificial example of creating a model with two inputs and a single output:

```python
import torch
from deepmux import create_model

class MyNet(torch.nn.Module):
    
    def __init__(self):
        super().__init__()
        self.model1 = torch.nn.Sequential(
            torch.nn.Linear(2, 4),
            torch.nn.ReLU()
        )
        
        self.model2 = torch.nn.Sequential(
            torch.nn.Linear(8, 4),
        )

    def forward(self, x, y):
        x1 = self.model1(x)
        y1 = self.model1(y)
        return self.model2(torch.cat((x1, y1), 0))

net = MyNet()

# Train or load weights
# ...


token = '<YOUR API TOKEN>'

deepmux_model = create_model(
    net,
    model_name='my_net',
    input_shape=[[2], [2]],
    output_shape=[4],
    token=token)

```

## Getting models by name
Once the model was created you can refer to the model by it's name.

This function is useful in production environment since you don't need to know anything about the model apart from it's name to execute it.

Going forward with the example from previous point:
```python
from deepmux import get_model

token = '<YOUR API TOKEN>'

deepmux_model = get_model('my_net', token)
```

## Running models

After initializing your model with `create_model` or `get_model` you can run the model. All computations will be performed on **deepmux** infrastucture.

To run the model you must pass a `numpy.ndarray` for each input. Shapes of input tensors must match model input shapes.

Note that `dtype` of the input data must match the data type of the uploaded model.

Again, with our `MyNet` example:
```python

model_input = [
    np.array([2.0, 3.0], dtype=np.float32),
    np.array([2.0, 3.0], dtype=np.float32)
]

output = deepmux_model.run(*model_input)
```

## Example from the tutorial
```python

import torch
from deepmux import create_model


# Initialize a PyTorch model
class MyNet(torch.nn.Module):
    
    def __init__(self):
        super().__init__()
        self.model1 = torch.nn.Sequential(
            torch.nn.Linear(2, 4),
            torch.nn.ReLU()
        )
        
        self.model2 = torch.nn.Sequential(
            torch.nn.Linear(8, 4),
        )

    def forward(self, x, y):
        x1 = self.model1(x)
        y1 = self.model1(y)
        return self.model2(torch.cat((x1, y1), 0))


# Not training the model and using default weights here
net = MyNet()


# Upload model to DeepMux
token = '<YOUR API TOKEN>'

deepmux_model = create_model(
    net,
    model_name='my_net',
    input_shape=[[2], [2]],
    output_shape=[4],
    token=token)


# get_model call is redundant here since create_model returns a reference to the model
# deepmux_model = get_model('my_net', token)


# Run model
model_input = [
    np.array([2.0, 3.0], dtype=np.float32),
    np.array([2.0, 3.0], dtype=np.float32)
]

output = deepmux_model.run(*model_input)
```


## Example on a model from PyTorch Hub

Below is an example of a complete ImageNet classifier achieved with pretrained `squeezenet` model.

### Creating the model
```python
import numpy as np
import torch

from deepmux import create_model

token = "<YOUR API TOKEN>"

pytorch_model = torch.hub.load('pytorch/vision:v0.5.0', 'squeezenet1_0', pretrained=True)

create_model(
    pytorch_model,
    model_name='my_squeezenet',
    input_shape=[1, 3, 227, 227],
    output_shape=[1, 1000],
    token=token)

```

### Running the model
```python
# Note: we no longer need pytorch
from deepmux import get_model

token = "<YOUR API TOKEN>"

deepmux_model = get_model('my_squeezenet', token)

dummy_input = np.zeros([1, 3, 227, 227], dtype=np.float32)

output = deepmux_model.run(dummy_input)

```

## Colab demo

Try our [demo](https://colab.research.google.com/drive/1Hxx5k-o4_WRMptX2hz8Ht0_HBpvziiMs?authuser=2#scrollTo=HQhBKggbgeEK)
or contact us at [dev@deepmux.com](mailto:dev@deepmux.com) if you have any questions left.
