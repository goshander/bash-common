#!/bin/bash

MIJIA_MAC="..."
# sudo apt-get install bluez-tools
# bluetoothctl scan le | grep ${MIJIA_DEVICE}
# ? MIJIA_DEVICE can be found on back side of the device
ENABLE_GNOME_NOTIFY=false

TEMP_MIN=23
TEMP_MAX=25

HUMIDITY_MIN=30
HUMIDITY_MAX=45

bt=$(timeout 25 gatttool -b ${MIJIA_MAC} --char-write-req --handle=0x0038 --value=0100 --listen | grep "Notification handle" --m 1)

# while true; do
if [ -z "$bt" ]; then
  echo "mijia reading failed"
else
  #echo "got data"
  hexa=$(echo $bt | awk '{print $6 " " $7 " " $8 " " $9 " " $10}')

  temphexa=$(echo $bt | awk '{print $7$6}' | tr '[:lower:]' '[:upper:]')
  humhexa=$(echo $bt | awk '{print $8}' | tr '[:lower:]' '[:upper:]')
  batthexa=$(echo $bt | awk '{print $10$9}' | tr '[:lower:]' '[:upper:]')

  temperature100=$(echo "ibase=16; $temphexa" | bc)
  humidity=$(echo "ibase=16; $humhexa" | bc)
  battery1000=$(echo "ibase=16; $batthexa" | bc)

  if [ $temperature100 -gt 32767 ]; then
    temperature100=$($temperature100 – 65536)
  fi

  # add missing leading zero if needed (sed): "-.05" -> "-0.05" and ".05" -> "0.05"
  temperature=$(echo "scale=2; $temperature100 / 100" | bc | sed 's:^\(-\?\)\.\(.*\)$:\10.\2:')

  battery=$(echo "scale=3; $battery1000 / 1000" | bc)

  echo $temperature $humidity $battery "[$hexa]"

  if [ "${ENABLE_GNOME_NOTIFY}" == "true" ]; then
    # TEMP MIN
    if [ $(echo "$temperature < $TEMP_MIN" | bc) = '1' ]; then
      notify-send Mijia "❄ Temperature is very low: ${temperature}℃"
    fi

    # TEMP MAX
    if [ $(echo "$temperature > $TEMP_MAX" | bc) = '1' ]; then
      notify-send Mijia "❄ Temperature is very high: ${temperature}℃"
    fi

    # HUMIDITY MIN
    if [ $(echo "$humidity < $HUMIDITY_MIN" | bc) = '1' ]; then
      notify-send Mijia "❄ Humidity is very low: ${humidity}%"
    fi

    # HUMIDITY MAX
    if [ $(echo "$humidity > $HUMIDITY_MAX" | bc) = '1' ]; then
      notify-send Mijia "❄ Humidity is very high: ${humidity}%"
    fi
  fi
fi
# fi # from while
