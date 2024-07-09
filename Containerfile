# MIT License

# Copyright (c) 2024 datcuandrei

# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.
FROM quay.io/fedora/fedora-bootc:40

# during setup, we are using root.
USER root

# no password input when running sudo
COPY ./wheel-nopasswd /etc/sudoers.d 

WORKDIR /
RUN dnf update && dnf -y install \
    @base-x \
    sddm \
    fastfetch \
    i3-gaps \
    dmenu \
    picom \
    feh \
    alacritty \
    thunar \
    flatpak \
    vim \
    htop \
    ed \
    nmap\
    python3 \
    python3-pip \
    firefox \
    mpv \
    git \
    ranger \
    btop && \ 
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    echo "root:v3rYsTrong" | chpasswd && \
    useradd -G wheel adatcu && \
    echo "adatcu:v3rYsTrong" | chpasswd
   
# personal dotfiles for i3 and picom
COPY ./dotfiles/config /home/adatcu/.config/i3/config
COPY ./dotfiles/picom.conf /home/adatcu/.config/picom.conf
COPY ./dotfiles/.xinitrc /home/adatcu/.xinitrc

# install starship shell prompt
RUN dnf install 'dnf-command(copr)' -y && \
    dnf copr enable atim/starship -y && \
    dnf install starship -y && \
    echo 'eval "$(starship init bash)"' >> /home/adatcu/.bashrc

# adding ssh public key to adatcu user
RUN mkdir -p /home/adatcu/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZEqzzbR9rngqD+AYtSmY5l+DAoax0/KFT6yrObEN7Y andrei@datcuandrei.com" >> /home/adatcu/.ssh/authorized_keys && \

# setting startup services
RUN systemctl enable sddm && systemctl enable sshd

# writing permissions
RUN chown -R adatcu:adatcu /home/adatcu && chmod 700 /home/adatcu/.ssh && chmod 600 /home/adatcu/.ssh/authorized_keys

# in container space, the user should be adatcu, not root.
USER adatcu
WORKDIR /home/adatcu

CMD ["/bin/bash"]