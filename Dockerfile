FROM ros:melodic-robot

ENV IS_DOCKER_BUILD true

RUN apt-get update
RUN apt-get install -y software-properties-common libusb-dev uncrustify

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
RUN add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u

# Need to install arduino-core because of a ROS dependency
# We'll actually use our Teensyduino version in /opt
RUN apt-get install -y arduino-core python-serial python-pip wget libgl1-mesa-dev libglfw3-dev libgtk-3-dev librealsense2-dev
RUN apt-get install -y ros-melodic-rplidar-ros ros-melodic-robot-localization ros-melodic-rosserial ros-melodic-rosserial-arduino ros-melodic-rgbd-launch ros-melodic-map-server ros-melodic-amcl

# Install Arduino
COPY arduino-1.8.6 /opt/arduino-1.8.6
# Patch Teensy so it won't try to download
RUN mv /opt/arduino-1.8.6/hardware/tools/teensy_post_compile /opt/arduino-1.8.6/hardware/tools/teensy_post_compile.old
COPY dummy-script.sh /opt/arduino-1.8.6/hardware/tools/teensy_post_compile
RUN chmod +x /opt/arduino-1.8.6/hardware/tools/teensy_post_compile

ENV ARDUINO_PATH /opt/arduino-1.8.6

COPY arduino-libraries /root/Arduino/libraries

COPY robot-entrypoint.sh /robot-entrypoint.sh

COPY magellan-deps /opt/magellan-deps
WORKDIR /opt/magellan-deps
RUN pip install -r requirements_pip.txt

RUN /opt/magellan-deps/prepare.sh
RUN bash -c "source /opt/ros/melodic/setup.bash && rosdep update && rosdep install --from-paths src --ignore-src -y"
RUN bash -c "source /opt/ros/melodic/setup.bash && /opt/magellan-deps/build.sh"

# Build teensy loader
RUN git clone --depth=1 https://github.com/PaulStoffregen/teensy_loader_cli.git && \
    cd teensy_loader_cli && \
    make && \
    mv teensy_loader_cli /usr/local/bin && \
    cd .. && \
    rm -rf teensy_loader_cli

ENTRYPOINT ["/robot-entrypoint.sh"]
