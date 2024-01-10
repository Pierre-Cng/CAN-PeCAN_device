# CAN Hardware Decoder (CHD)

## Description:
Build of a CAN decoder with a raspberry pi zero w and a CANHat.

## List of material:
* [RS485 CAN HAT for Raspberry Pi](https://www.amazon.com/RS485-CAN-HAT-Long-Distance-Communication/dp/B07VMB1ZKH/ref=sr_1_2?crid=2VKVGQISVE8EN&keywords=waveshare+rs485+canhat&qid=1704312361&sprefix=canhat+%2Caps%2C129&sr=8-2)
* [Raspberry Pi Zero WH](https://www.amazon.com/Raspberry-Bluetooth-Compatible-Connector-headers/dp/B0CG99MR5W/ref=sr_1_4?crid=24FPUDKHENO8M&keywords=raspberry+pi+zero+wh&qid=1704312449&sprefix=raspberry+pi+zero+wh%2Caps%2C116&sr=8-4)
* [DB9 connector RS232](https://www.amazon.com/Jienk-Serial-Solder-Connectors-Couplers/dp/B08JLFJJNT/ref=sr_1_13?crid=31WMACKUU3T3U&keywords=db9%2Bconnector&qid=1704312518&sprefix=db9%2B%2Caps%2C138&sr=8-13&th=1)
  
## Set up:

### 1) Set up the raspberry pi:
* Install Raspbian lite OS on the micro SD card thanks to the [Raspberry Pi imager](https://www.raspberrypi.com/software/).
* Set up the wifi and ssh connection parameters to be able to access the raspberry without monitor from your computer ([see here](https://www.learnrobotics.org/blog/raspberry-pi-without-a-monitor/#:~:text=Second%20Method%3A%20Raspberry%20Pi%20Without%20Monitor))

**Tips**: Set up a hotspot from your computer to have a private subnet where you can connect your raspberry.

### 2) Set up the CANHat:
You can follow [this tutorial](https://www.pragmaticlinux.com/2021/10/can-communication-on-the-raspberry-pi-with-socketcan/). Or in a nutshell:
* Plug the Hat on your Raspberry
* Modify config.txt:  
  * Open config.txt file with `sudo nano /boot/config.txt` and allow SPI protocole by uncommenting the line `dtparam=spi=on`
  * Add the following line to the file: `dtoverlay=mcp2515-can0,oscillator=12000000,interrupt=25,spimaxfrequency=2000000` to load the mcp2515 (CANHat controller) driver and set communication parameters
* Load the SocketCAN kernel modules:
  * Use the command `sudo modprobe can` and `sudo modprobe can_raw`
  * Verify the result with `lsmod | grep "can"`
* Configure and bring up the SocketCAN network interface:
  * Configure with `sudo ip link set can0 type can bitrate 500000 restart-ms 100`
  * Bring up with `sudo ip link set up can0`
  * Verify the result with `ip addr | grep "can"`

**Tips**: For step 2) you can direclty replace the config.txt by [this one](config.txt) and run [socketcan_init.sh](socketcan_init.sh) script to perform all the steps. Note that you need to perform those steps only once an for all, only the 'Configure and bring up the SocketCAN network interface' steps need to be perform at every Raspberry boot, please refer to next section.

### 3) Set up Socketcan interface on boot:
* Add [sockectcan_wakeup.sh](sockectcan_wakeup.sh) on `/bin/` directory
* change access rights with `sudo chmod +x /bin/socketcan_wakeup.sh`
* Add [sockectcan_wapeup.service](sockectcan_wapeup.service) on `/etc/systemd/system/`
* reload daemon with `sudo systemctl daemon-reload`
* Enable service with `sudo systemctl enable socketcan_wakeup.service`
* Start service with `sudo systemctl start socketcan_wakeup.service`
* Check status with `systemctl status socketcan_wakeup.service`
  
'''
for that you can create a service at boot with the script **socketcan_wakeup.sh**.
https://www.howtogeek.com/687970/how-to-run-a-linux-program-at-startup-with-systemd/#:~:text=1%20Running%20Programs%20at%20Startup.%20Sometimes%20the%20software,must%20tell%20systemd%20to%20reload%20the...%20More%20
https://www.linode.com/docs/guides/start-service-at-boot/
https://linuxhandbook.com/create-systemd-services/
https://www.digitalocean.com/community/tutorials/how-to-configure-a-linux-service-to-start-automatically-after-a-crash-or-reboot-part-1-practical-examples
'''

### 4) Send / Receive messages:
* Install package `sudo apt install can-utils`
* To receive use `candump -tz can0`
* To send use `cansend can0 456#00FFAA5501020304` for example

## Receiving / decoding strategy:
The CHD will be responsible for one specific CAN channel. It will be connect to it though a DB9 connector linked to the CANHat. A dbc file will be assign to the CHD. The package [CAN-CandumpDecoder](https://github.com/Pierre-Cng/CAN-CandumpDecoder.git) will be used with the [candump](https://manpages.debian.org/testing/can-utils/candump.1.en.html) command as the following: `candump -l can0 | py -m CandumpDecoder --channel yourdbcfile`. The command will create an output file for the CAN trace and one for the decoded messages.

## References:
<https://www.pragmaticlinux.com/2021/10/can-communication-on-the-raspberry-pi-with-socketcan/>
<https://www.waveshare.com/wiki/RS485_CAN_HAT>
<https://wiki.seeedstudio.com/2-Channel-CAN-BUS-FD-Shield-for-Raspberry-Pi/>
<https://www.beyondlogic.org/adding-can-controller-area-network-to-the-raspberry-pi/>
<https://www.waveshare.com/wiki/2-CH_CAN_HAT>
<https://circuitdigest.com/microcontroller-projects/rs485-serial-communication-between-arduino-and-raspberry-pi>
