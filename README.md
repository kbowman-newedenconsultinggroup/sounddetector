# sounddetector

This is a python script that is used to detect a sequence of specific sounds (notes) and report the event via mqtt.  I use this to listen for the unique (hopefully) sound of my doorbell, and notify my Home Assistant that the doorbell is ringing.  The supporting files are used to tie these pieces together and do something when the doorbell rings.

## Getting Started

The meat of this is in the sounddetector.py script.  This was stolen from the work of Allen Pan (https://www.raspberrypi.org/blog/zelda-home-automation/) which used Benjamin Chodroff's underlying sound detection to do similar work (https://benchodroff.com/2017/02/18/using-a-raspberry-pi-with-a-microphone-to-hear-an-audio-alarm-using-fft-in-python/) to detect a smoke alarm.  This also uses Chec_603's mqtt bash execution script (https://unix.stackexchange.com/questions/188525/how-to-subscribe-a-bash-script-as-a-mqtt-client) to control the process.

This has been tuned for my specific two-tone, rather slow, doorbell.  As Allen and Benjamin show, it's relatively easy to tune for other sounds, or multiple sounds.

The yaml files are examples I use in my Home Assistant Config to expose:
-- The timestamp of the last time the doorbell was detected
-- A switch to turn on/off the detector
-- An automation to notify my mobile when someone rings the doorbell with a link to my front-door camera (actually my garagecamera currently, but will be updated when the front door camera is installed.)

### Prerequisites

This uses Python and bash.  Several modules are needed for python - listed in the imports.  I use Mosquitto for my MQTT broker.  

All of this can be run on any linux host in the house that has a microphone.  I am using an old Logitech C270 webcam currently.  My doorbell is an intercom system that is quite loud and can be heard in every room of the house easily.  Volume is not a problem for me.  YMMV


### Installing

I install two systemd services.  Sample files are in the repo.  The sounddetectorlistener.service is always running.  The sounddetector.service is started and stopped by Home Assistant sending the appropriate ```systemctl (start|stop) sounddetector``` command via mqtt.

Copy and modify the appropriate yaml into your Home Assistant configuration. I display these three components (process control, automation control, last ring time) via a vertical + horizontal card in lovelace.

## Testing and Tuning

Included here is a test.wav file which is the recording of my doorbell I made and analyzed with audacity.  Included here as it's less impactful to the WAF to test by ```play test.wav``` than by constantly ringing the doorbell.

Tuning knobs include the frequencies, bandwidth, and counters.  I left some 'extra' of these in the code - Allen Pan uses multiple different notes (frequencies) as he played entire 6-note songs.  I only need two notes, for now. Benjamin Chodroff listens for multiple beeps.  I only need one beep of each of my two notes, for now.  Tuning can be done by running sounddetecr.py at the command line in debug mode and playing the wav file.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Big tips to Allen Pan, Benjamin Chodroff, and Darkerego (Chev_603) for the code
* Inspired by this thread: https://community.home-assistant.io/t/diy-audio-sensor/29506
* Huge thanks to danielperna84 for pointing me in the right direction!
