FROM ros:melodic-robot

RUN apt-get update
RUN apt-get install -y ros-melodic-robot-localization

COPY arduino-1.8.6 /opt

ENV ARDUINO_LOCATION /opt/arduino-1.8.6

COPY arduino-libraries /root/Arduino/
