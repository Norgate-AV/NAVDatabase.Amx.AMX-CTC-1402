MODULE_NAME='mAMX-CTC-1402Volume' 	(
                                        dev vdvObject,
                                        dev dvPort
                                    )

(***********************************************************)
#include 'NAVFoundation.ModuleBase.axi'

/*
 _   _                       _          ___     __
| \ | | ___  _ __ __ _  __ _| |_ ___   / \ \   / /
|  \| |/ _ \| '__/ _` |/ _` | __/ _ \ / _ \ \ / /
| |\  | (_) | | | (_| | (_| | ||  __// ___ \ V /
|_| \_|\___/|_|  \__, |\__,_|\__\___/_/   \_\_/
                 |___/

MIT License

Copyright (c) 2023 Norgate AV Services Limited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer currentVolume

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
define_function Send(char payload[]) {
    NAVErrorLog(NAV_LOG_LEVEL_DEBUG, NAVFormatStandardLogMessage(NAV_STANDARD_LOG_MESSAGE_TYPE_COMMAND_TO, dvPort, payload))
    NAVCommand(dvPort, "payload")
}


define_function char[NAV_MAX_CHARS] Build(char attribute[], char value[]) {
    if (!length_array(value)) {
        return "attribute"
    }

    return "attribute, '-', value"
}


define_function SetVolume(integer value) {
    stack_var integer volume
    volume = value * 100 / 255
    Send(Build('AUDOUT_VOLUME', itoa(volume)))
}


define_function Process(char param[]) {
    stack_var char cmdHeader[NAV_MAX_CHARS]
    stack_var char cmdParam[3][NAV_MAX_CHARS]

    cmdHeader = DuetParseCmdHeader(param)
    cmdParam[1] = DuetParseCmdParam(param)
    cmdParam[2] = DuetParseCmdParam(param)
    cmdParam[3] = DuetParseCmdParam(param)

    switch (cmdHeader) {
        case 'AUDOUT_VOLUME': {
            currentVolume = atoi(cmdParam[1])
            send_level vdvObject, VOL_LVL, currentVolume * 255 / 100
        }
    }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START {

}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

data_event[dvPort] {
    online: {
        Send(Build('?AUDOUT_VOLUME', ''))
        Send(Build('?AUDOUT_MUTE', ''))
    }
    string: {
        [vdvObject, DEVICE_COMMUNICATING] = true
        [vdvObject, DATA_INITIALIZED] = true
        NAVErrorLog(NAV_LOG_LEVEL_DEBUG, NAVFormatStandardLogMessage(NAV_STANDARD_LOG_MESSAGE_TYPE_STRING_FROM, data.device, data.text))
        Process(data.text)
    }
    command: {
        [vdvObject, DEVICE_COMMUNICATING] = true
        [vdvObject, DATA_INITIALIZED] = true
        NAVErrorLog(NAV_LOG_LEVEL_DEBUG, NAVFormatStandardLogMessage(NAV_STANDARD_LOG_MESSAGE_TYPE_COMMAND_FROM, data.device, data.text))
        Process(data.text)
    }
}


data_event[vdvObject] {
    online: {
        NAVCommand(data.device, "'PROPERTY-RMS_MONITOR_ASSET_PROPERTY,MONITOR_ASSET_DESCRIPTION,Switcher'")
        NAVCommand(data.device, "'PROPERTY-RMS_MONITOR_ASSET_PROPERTY,MONITOR_ASSET_MANUFACTURER_URL,www.amx.com'")
        NAVCommand(data.device, "'PROPERTY-RMS_MONITOR_ASSET_PROPERTY,MONITOR_ASSET_MANUFACTURER_NAME,AMX'")
    }
    command: {
        stack_var char cmdHeader[NAV_MAX_CHARS]
        stack_var char cmdParam[3][NAV_MAX_CHARS]

        NAVErrorLog(NAV_LOG_LEVEL_DEBUG, NAVFormatStandardLogMessage(NAV_STANDARD_LOG_MESSAGE_TYPE_COMMAND_FROM, data.device, data.text))

        cmdHeader = DuetParseCmdHeader(data.text)
        cmdParam[1] = DuetParseCmdParam(data.text)
        cmdParam[2] = DuetParseCmdParam(data.text)
        cmdParam[3] = DuetParseCmdParam(data.text)

        switch (cmdHeader) {
            case 'PASSTHRU': { Send(cmdParam[1]) }
            case 'VOLUME': {
                SetVolume(atoi(cmdParam[1]))
            }
        }
    }
}


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
