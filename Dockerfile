FROM ros:melodic-robot

RUN apt-get update
# Need to install arduino-core because of a ROS dependency
# We'll actually use our Teensyduino version in /opt
RUN apt-get install -y ros-melodic-robot-localization arduino-core python-serial

COPY arduino-1.8.6 /opt/arduino-1.8.6

ENV ARDUINO_PATH /opt/arduino-1.8.6

COPY arduino-libraries /root/Arduino/libraries
