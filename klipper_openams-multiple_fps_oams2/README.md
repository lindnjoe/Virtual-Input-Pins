# OpenAMS for Klipper  
OpenAMS Klipper Plugin

## Installation

### Automatic Installation  

Install OpenAMS using the provided script:  

```bash  
cd ~  
git clone https://github.com/OpenAMSOrg/klipper_openams.git  
cd klipper_openams  
./install-openams.sh
```

If your directory structure differs, you can configure the installation script with additional parameters:

```bash  
./install-openams.sh [-k <klipper path>] [-s <klipper service name>] [-c <configuration path>]
```

## AFC Integration

To relay OpenAMS sensor states into the [AFC Klipper Add-On](../AFC-Klipper-Add-On-direct_update),
define each AMS as an `AFC_AMS` unit:

```cfg
[AFC_AMS AMS_1]
# interval: 1.0  # optional polling interval in seconds
# oams1: oams1   # add additional OAMS instances as oams2, oams3, etc.
```

The first `AFC_AMS` section configures OpenAMS synchronization. With at least
one unit defined, hub sensors can be sourced from OpenAMS just like lane sensors.
Only hubs managed by OpenAMS should omit `switch_pin`; physical units such as
BoxTurtles still require their pin definitions:

```cfg
[AFC_hub Hub_1]
# switch_pin omitted when using OpenAMS-provided hub

[AFC_hub Hub_Turtle]
switch_pin: ^turtle_1:PA1  # physical hub still declares its pin
```

Additional options such as the polling `interval` or extra `oams` instances can
be specified if required.

## Credits

This project was made by knight.rad_iant on Discord.

---