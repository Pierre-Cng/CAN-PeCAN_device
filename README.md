# CAN Hardware Decoder

## Description:
Build of a CAN decoder with a raspberry pi zero w and a CANHat.

## List of material:
* [RS485 CAN HAT for Raspberry Pi](https://www.amazon.com/RS485-CAN-HAT-Long-Distance-Communication/dp/B07VMB1ZKH/ref=sr_1_2?crid=2VKVGQISVE8EN&keywords=waveshare+rs485+canhat&qid=1704312361&sprefix=canhat+%2Caps%2C129&sr=8-2)
* [Raspberry Pi Zero WH](https://www.amazon.com/Raspberry-Bluetooth-Compatible-Connector-headers/dp/B0CG99MR5W/ref=sr_1_4?crid=24FPUDKHENO8M&keywords=raspberry+pi+zero+wh&qid=1704312449&sprefix=raspberry+pi+zero+wh%2Caps%2C116&sr=8-4)
* [DB9 connector RS232](https://www.amazon.com/Jienk-Serial-Solder-Connectors-Couplers/dp/B08JLFJJNT/ref=sr_1_13?crid=31WMACKUU3T3U&keywords=db9%2Bconnector&qid=1704312518&sprefix=db9%2B%2Caps%2C138&sr=8-13&th=1)
  
## Steps:

### 1) Set up the raspberry pi:
* Install Raspbian lite OS on the micro SD card thanks to the [Raspberry Pi imager](https://www.raspberrypi.com/software/).
* Set up the wifi and ssh connection parameters to be able to access the raspberry without monitor from your computer ([see here](https://www.learnrobotics.org/blog/raspberry-pi-without-a-monitor/#:~:text=Second%20Method%3A%20Raspberry%20Pi%20Without%20Monitor))

**Tips**: Set up a hotspot from your computer to have a private subnet where you can connect your raspberry.

### 2) Set up the CANHat:
* You can follow [this tutorial](https://www.pragmaticlinux.com/2021/10/can-communication-on-the-raspberry-pi-with-socketcan/)
Or in a nutshell:
* Plug the Hat on your Raspberry
* Modify config.txt:  
  * Open config.txt file with `sudo nano /boot/config.txt` and allow SPI protocole by uncommenting the line 'dtparam=spi=on'
  * Add this line to the file `dtoverlay=mcp2515-can0,oscillator=12000000,interrupt=25,spimaxfrequency=2000000` to load the mcp2515 (CANHat controller) driver and set communication parameters




ip addr | grep "can"
T

Load the SocketCAN kernel modules
Before our Raspberry PI can bring the can0 SocketCAN network interface in the UP state, we need to first load the SocketCAN related kernel modules. Open up the terminal again and run these commands:
sudo modprobe can
sudo modprobe can_raw
To verify that the SocketCAN related kernel modules loaded properly, run:

lsmod | grep "can"
Terminal screenshot showing the output of the "lsmod" command, used to verify that the can and can_raw kernel modules were properly loaded using "modprobe".
Configure and bring up the SocketCAN network interface
After loading the CAN related kernel modules, we continue with the final step: Bring the can0 SocketCAN network interface in the UP state. It is a two step process:


sudo ip link set can0 type can bitrate 500000 restart-ms 100
sudo ip link set up can0


sudo apt install can-utils

candump -tz can0

cansend can0 456#00FFAA5501020304

Loading the kernel modules:
sudo modprobe can
sudo modprobe can_raw
Configuring the SocketCAN network interface:
sudo ip link set can0 type can bitrate 500000 restart-ms 100
Bringing the SocketCAN network interface in the UP state:
sudo ip link set up can0

## References:
<https://www.pragmaticlinux.com/2021/10/can-communication-on-the-raspberry-pi-with-socketcan/>
<https://www.waveshare.com/wiki/RS485_CAN_HAT>
<https://wiki.seeedstudio.com/2-Channel-CAN-BUS-FD-Shield-for-Raspberry-Pi/>
<https://www.beyondlogic.org/adding-can-controller-area-network-to-the-raspberry-pi/>
<https://www.waveshare.com/wiki/2-CH_CAN_HAT>
<https://circuitdigest.com/microcontroller-projects/rs485-serial-communication-between-arduino-and-raspberry-pi>
