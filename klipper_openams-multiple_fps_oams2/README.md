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
enable synchronization by adding an `[afc_openams]` section to your
`printer.cfg`, then define your AMS units with `[AFC_AMS]` blocks mapping to
each OpenAMS instance. The `[afc_openams]` section may include an optional
polling `interval` (defaults to `2.0` seconds):

```cfg
[afc_openams]
; interval: 2.0  # optional polling interval in seconds

[AFC_AMS AMS_1]
oams: oams1
```

With `[afc_openams]` configured, hub sensors can be sourced from OpenAMS just
like lane sensors. Only hubs managed by OpenAMS should omit `switch_pin`;
physical units such as BoxTurtles still require their pin definitions:

```cfg
[AFC_hub Hub_1]
# switch_pin omitted when using OpenAMS-provided hub

[AFC_hub Hub_Turtle]
switch_pin: ^turtle_1:PA1  # physical hub still declares its pin
```

Additional options such as the polling `interval` should be set in the
first `[AFC_AMS]` section, while extra OpenAMS units are added with
additional `[AFC_AMS]` sections specifying their `oams` names.

## Credits

This project was made by knight.rad_iant on Discord.

---