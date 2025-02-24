# NAVDatabase.Amx.AMX-CTC-1402

<!-- <div align="center">
 <img src="./" alt="logo" width="200" />
</div> -->

---

[![CI](https://github.com/Norgate-AV/NAVDatabase.Amx.AMX-CTC-1402/actions/workflows/main.yml/badge.svg)](https://github.com/Norgate-AV/NAVDatabase.Amx.AMX-CTC-1402/actions/workflows/main.yml)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

A NetLinx module for interfacing with the AMX CTC-1402 switcher.

## Contents 📖

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

-   [Usage :zap:](#usage-zap)
-   [API :technologist:](#api-technologist)
-   [Team :soccer:](#team-soccer)
-   [Contributors :sparkles:](#contributors-sparkles)
-   [LICENSE :balance_scale:](#license-balance_scale)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Usage :zap:

```c
DEFINE_DEVICE

dvSwitcher      =       6001:1:0
vdvSwitcher     =       33201:1:0


define_module 'mAMX-CTC-1402' SwitcherComm(vdvSwitcher, dvSwitcher)

DEFINE_EVENT

data_event[vdvSwitcher] {
    online: {
        // Switch to Input 1
        send_command data.device, "'SWITCH-1'"

        // Set Volume to 50% (0-255)
        send_command data.device, "'VOLUME-128'"
    }
}
```

## API :technologist:

`SWITCH` - Switch to the specified input. The input number is specified as a string. For example, to switch to input 1, send the command `'SWITCH-1'`

`VOLUME` - Set the volume to the specified level. The volume level is specified as a string. For example, to set the volume to 50%, send the command `'VOLUME-128'`

## Team :soccer:

This project is maintained by the following person(s) and a bunch of [awesome contributors](https://github.com/Norgate-AV/NAVDatabase.Amx.AMX-CTC-1402/graphs/contributors).

<table>
  <tr>
    <td align="center"><a href="https://github.com/damienbutt"><img src="https://avatars.githubusercontent.com/damienbutt?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Damien Butt</b></sub></a><br /></td>
  </tr>
</table>

## Contributors :sparkles:

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

Thanks go to these awesome people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://allcontributors.org) specification.
Contributions of any kind are welcome!

## LICENSE :balance_scale:

[MIT](LICENSE)
