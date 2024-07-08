FROM quay.io/fedora/fedora-bootc:40

USER root

COPY ./wheel-nopasswd /etc/sudoers.d

WORKDIR /
RUN dnf update && dnf -y install neofetch \
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
    python3 \
    firefox \
    btop && \ 
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    echo "root:v3rYsTrong" | chpasswd && \
    useradd -G wheel adminusr && \
    echo "adminusr:v3rYsTrong" | chpasswd
    
COPY ./dotfiles/config /home/adminusr/.config/i3/config
COPY ./dotfiles/picom.conf /home/adminusr/.config/picom.conf
    
CMD ["/bin/bash"]