FROM ros:melodic-robot

COPY magellan-deps /opt/magellan-deps

RUN apt-get update
# Need to install arduino-core because of a ROS dependency
# We'll actually use our Teensyduino version in /opt
RUN apt-get install -y ros-melodic-robot-localization arduino-core python-serial python-pip wget

RUN pip install serial pyserial

COPY arduino-1.8.6 /opt/arduino-1.8.6
# Patch Teensy so it won't try to download
COPY dummy-script.sh /opt/arduino-1.8.6/hardware/tools/teensy_post_compile
RUN chmod +x /opt/arduino-1.8.6/hardware/tools/teensy_post_compile

ENV ARDUINO_PATH /opt/arduino-1.8.6

COPY arduino-libraries /root/Arduino/libraries

WORKDIR /opt/magellan-deps
RUN /opt/magellan-deps/prepare.sh
RUN bash -c "source /opt/ros/melodic/setup.bash && rosdep update && rosdep install --from-paths src --ignore-src -y"
RUN bash -c "source /opt/ros/melodic/setup.bash && /opt/magellan-deps/build.sh"
