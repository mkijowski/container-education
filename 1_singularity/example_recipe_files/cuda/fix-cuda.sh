#!/bin/bash
depmod
nvidia-modprobe
modprobe nvidia
modprobe nvidia-uvm
