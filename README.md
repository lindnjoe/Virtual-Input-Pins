# Virtual-Input-Pins
Klipper virtual input pins
Create virtual pins with Klipper's `virtual_input_pin` module. Define pin
sections:

```
[virtual_input_pin pin1]
[virtual_input_pin pin2]
...
[virtual_input_pin sensor1]

```

Use these pins like normal endstop pins:

```
[filament_switch_sensor my_sensor]
    switch_pin: virtual_pin:sensor1
```
```
SET_VIRTUAL_PIN PIN=pin1 VALUE=1
QUERY_VIRTUAL_PIN PIN=pin1
```
Change a pin state at runtime with `SET_VIRTUAL_PIN` and query it with
`QUERY_VIRTUAL_PIN`. These pins behave like real endstop inputs, so they
can be used anywhere an input pin is expected.

Note: pins.py must replace original klipper file in klipper/klippy directory and add virtual_input_pin.py to klipper/klippy/extras folder.
