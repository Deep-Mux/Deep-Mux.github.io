## Cold start
Model inference time may increase after model has been idle for some time. It happens due to the fact that we need to load model into the memory before executing it. 
Increase in latency depends on the model size. E.g. for _200MB_ model it would take about _500ms_ to load. You can project loading time onto your model as it scales linearly. 
Time after which model is unloaded is not fixed and is subject to constant adjustment. Think tens of seconds to minutes.

If the model is loaded when a request occurs there is _2-3 ms_ of latency per request added by the infrastructure.

## Billing 
You are charged **only** for inference time and not for any kind of infrastructure latency.
Note that request times on the client may differ from the ones observed in monitoring due to network latency / throughput.
