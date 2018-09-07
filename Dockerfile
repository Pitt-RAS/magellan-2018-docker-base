FROM ros:melodic-robot

RUN apt-get update
# Need to install arduino-core because of a ROS dependency
# We'll actually use our Teensyduino version in /opt
RUN apt-get install -y ros-melodic-robot-localization arduino-core python-serial

COPY arduino-1.8.6 /opt/arduino-1.8.6
# Patch Teensy so it won't try to download
COPY dummy-script.sh /opt/arduino-1.8.6/hardware/tools/teensy_post_compile 
RUN chmod +x /opt/arduino-1.8.6/hardware/tools/teensy_post_compile

ENV ARDUINO_PATH /opt/arduino-1.8.6

COPY arduino-libraries /root/Arduino/libraries
