#!/bin/bash

PFM_GET_SIGNAL_VALUE="/home/pfm/get_signal_value.py"
wifi_mode=`su pfm - -c "${PFM_GET_SIGNAL_VALUE} 'SIG_UPDATE_WIFI_MODE'"`
logger "Captive Portal check: PFM_SIGNAL Wifi Mode is ${wifi_mode}"

current_wifi_mode=`grep "WiFi Device Current Mode" /home/pfm/pfm_conf/pfm_working.ini`
logger "Captive Portal check: pfm_working.ini Wifi Current Mode is ${current_wifi_mode}"

set_captive_portal="no"
if [ -f /home/pfm/pfm_conf/dnsmasq.CAPTIVE_PORTAL ]
then
    logger "captive portal config file detected"
    # if pfm_signals is not up yet
    if test "${wifi_mode}" = ""
    then
        logger "captive portal script detects no pfm_signals"
        # check initial settings in pfm_working.ini
        if [[ ${current_wifi_mode} == *"ACCESS POINT"* ]]
        then
            logger "captive portal script detects AP mode in ini file"
            set_captive_portal="yes"
        else
            logger "captive portal script detects non-compatible mode in ini file"
        fi
    else
        # pfm signals is up, check for AP mode
        logger "captive portal script detects pfm_signals is up"
        if test "${wifi_mode}" = "ACCESS POINT"
        then
            logger "captive portal script pfm_signals reports AP mode active"
            set_captive_portal="yes"
        else
            logger "captive portal script pfm_signals reports non-compatible mode active"
        fi
    fi
fi

if test "${set_captive_portal}" = "yes"
then
    cp_params="--address=/#/10.42.0.1 --dhcp-option=114,\"http://10.42.0.1/\" --dhcp-option=103,\"http://10.42.0.1/\""
    logger "captive portal mode activated params: $* ${cp_params}"
    /usr/sbin/dnsmasq.bin $* ${cp_params}
else
    logger "access point mode activated params: $*"
    /usr/sbin/dnsmasq.bin $*
fi
