#!/bin/bash

sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
chsh -s /usr/bin/fish
fish_config theme choose 'Old School'
fish_config prompt choose disco
