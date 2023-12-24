# Flutter's lossy StreamBuilder and a workaround.

## Getting Started

Flutter's StreamBuilder is not lossless when it comes to rebuilding the UI when events are fired fast enough. There are two branches in this repo.
1. `main`: This uses Flutter's StreamBuilder to listen to an event generated every 8ms. Looking at the logs of events fired and what gets rendered on the UI, you can see StremBuilder missing some events.
2. `custom_stream_builder`: We listen to the same event here, but wrote a custom widget which will render all events fired without missing out any events. 


### Why StreamBuilder is lossy

Flutter renders new frames depending on the screen's refresh rate. On a device with 120Hz screen refresh rate, each frame is built in an interval of 8ms. If events are getting fired in  < 4ms (or half the refresh rate of screen), more than one event is fired between frames. StreamBuilder on the next frame, only rebuilds to the latest event. This is how events are missed in StreamBuilder.

If the event frequecy <= frame rate of screen, events will be missed. Even if event frequecy == frame rate of screen, some events will be missed as not every time frames will be build within 8ms. 

Interestingly, this is simlilar to [Nyquist frequency](https://cmtext.indiana.edu/digital_audio/chapter5_nyquist.php) in signal processing.
