# FAQ

### What if my model is written in a framework that is not supported by DeepMux?
We support models in ONNX format, which is quite universal. You can convert your model to ONNX and uplad it to deepmux. If it is not possible, feel free to contact us at [dev@deepmux.com](mailto:dev@deepmux.com) and we will figure out a solution for you.


### What if model has multiple inputs / outputs?
To create a model with multiple inputs / outputs, you need to pass a list of shapes into input_shape and output_shape parameters. For example, `[[2, 2], [1, 3]]` would stand for two inputs of sizes 2x2 and 1x3 respectively.

### Are variable input / output sizes supported?

Short answer would be: not yet. Nevertheless you can create a model and predefine it's expected input shape to resize your input before passing it to the model. Variable output shapes are not possible at the moment.

