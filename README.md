# OpenAMS AFC Integration Examples

This repository provides example configuration files and supporting modules for
using [OpenAMS](https://github.com/lindnjoe/OpenAMS) with the
[AFC Klipper Add-On](https://github.com/lindnjoe/AFC-Klipper-Add-On).

## Usage

1. Copy the files in `AFC-Klipper-Add-On-direct_update/extras/` into your
   `klipper/klippy/extras/` directory.
2. Place `AFC_AMS1.cfg` and `AFC_AMS2.cfg` (or your customized versions) in
   `printer_data/config/AFC/`.
3. Enable OpenAMS synchronization by adding an `[afc_openams]` section to your
   `printer.cfg`. An optional `interval` may be specified for the polling
   frequency.
4. Define each AMS using an `[AFC_AMS AMS_X]` section and map it to its
   OpenAMS instance with `oams: oamsX`.
   The first AMS block may include an optional `interval` setting for the
   OpenAMS polling frequency.

The legacy `virtual_input_pin.py` and `auto_ams_update.py` modules are no longer
required and have been removed from this project.
