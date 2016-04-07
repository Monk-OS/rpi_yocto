# Monk OS

This is a [Yocto](http://www.yoctoproject.org) based build repository for MonkOS. We intend to run [Kodi](https://kodi.tv/) with some extra features that make a rich entertainment experience for the user. 


## How to build

* Clone [this](https://github.com/Monk-OS/rpi_yocto)
  ``` git clone https://github.com/Monk-OS/rpi_yocto.git . ```

* Source the script setup-raspberrypi-monkos-environment
  ``` source meta-monkos/setup-raspberrypi-monkos-environment ```

* bitbake the build you require
  ``` bitbake monkos-hwup-image ```


## Our Vision
  Our vision is to create a complete Home Entertainment and Automation solution.

 - [ ] Basic hardware-up Build
 - [ ] Integrate UI Components
 - [ ] Integrate Kodi
 - [ ] Customize Kodi with our custom UI
 - [ ] Expand the device portfolio (**beagle bone**, **Odroid**, etc)
 - [ ] IoT framework integration
 - [ ] IoT Application over Kodi
 - [ ] Add Additional features that fits suitable for the device or application
