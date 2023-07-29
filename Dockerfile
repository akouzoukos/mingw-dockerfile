# select as base image matching your host to get process isolation

FROM archlinux:latest
LABEL maintainer="kouzapo@gmail.com"

# ENV TZ=Europe/Minsk
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#  && locale-gen "en_US.UTF-8"
# ENV LANG=en_US.UTF-8 \
#     LANGUAGE=en_US:en \
#     LC_ALL=en_US.UTF-8

# RUN apt-get update && \
#     apt-get install -y binutils build-essential && \
#     apt-get install -y wget

# RUN apt-get install -y mingw-w64

# RUN pacman-key --init
# RUN yes | pacman -Syuu

# RUN pacman -S mingw-w64 --noconfirm
# RUN pacman -S base-devel --noconfirm
# RUN pacman -S git --noconfirm
# RUN pacman -S --needed --noconfirm sudo # Install sudo
# RUN useradd builduser -m # Create the builduser
# RUN passwd -d builduser # Delete the buildusers password
# RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers # Allow the builduser passwordless sudo
# RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git some-pkgbuild && cd some-pkgbuild && makepkg -si --noconfirm' # Clone and build a package
#
# makepkg user and workdir
RUN pacman -Syu --needed --noconfirm git sudo base-devel

ARG user=test
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user
# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay

RUN sudo pacman-key --init
RUN sudo pacman -Syyu --noconfirm
RUN yay -S mingw-w64-libmodplug --noconfirm
RUN sudo pacman -S vim unzip wget --noconfirm #install xxd
RUN wget https://www.sfml-dev.org/files/SFML-2.6.0-windows-gcc-13.1.0-mingw-32-bit.zip && \
    sudo unzip SFML-2.6.0-windows-gcc-13.1.0-mingw-32-bit.zip -d ~/temp/ && \
    sudo cp -r ~/temp/SFML-2.6.0/lib /usr/i686-w64-mingw32/ && \
    sudo cp -r ~/temp/SFML-2.6.0/include /usr/i686-w64-mingw32/ && \
    sudo cp -r ~/temp/SFML-2.6.0/bin /usr/i686-w64-mingw32/

RUN sudo setfacl -m u:$user:rwx /home/$user

# RUN cd yay && \
#     yes | makepkg -si
