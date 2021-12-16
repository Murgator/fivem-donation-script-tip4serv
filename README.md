### Tip4serv

This script connects your [Tip4serv.com](https://tip4serv.com/) store to your FiveM server.
It checks if a customer has bought something on your tip4serv store and delivers the order (money, rank...) by typing commands in the server console

#### HMAC authentification

Tip4serv adds a layer of security using HMAC authentication to communicate. It is a strong authentication method that is used by banks https://en.wikipedia.org/wiki/HMAC

#### Installation

Open an account on [Tip4serv.com](https://tip4serv.com/), follow the instructions and add a FiveM server.

1) Copy the `tip4serv` directory to your `resources` folder on your FiveM server.
2) Set `tip4serv_key` to your tip4serv API key in `tip4serv/server/server.lua`
3) To start the script, add this line at the end of your resources in server.cfg: `ensure tip4serv` (if that doesn't work add this instead: `start tip4serv`)
4) Add this line in server.cfg to allow tip4serv to type commands in the console: `add_ace resource.tip4serv command allow`
5) Restart the server and click on connect in your tip4serv.com panel.

You get this message in the console when the server has started: **Server has been successfully connected**

#### Essential/MySQL add-on: esx_tip4serv

### Tip4serv

This script connects your [Tip4serv.com](https://tip4serv.com/) store to your FiveM server.
It checks if a customer has bought something on your tip4serv store and delivers the order (money, rank...) by typing commands in the server console

#### HMAC authentification

Tip4serv adds a layer of security using HMAC authentication to communicate. It is a strong authentication method that is used by banks https://en.wikipedia.org/wiki/HMAC

#### Installation

Open an account on [Tip4serv.com](https://tip4serv.com/), follow the instructions and add a FiveM server.

1) Download tip4serv and extract it to your `/resources` folder on your FiveM server.
2) Set `tip4serv_key` to your tip4serv API key in `tip4serv/server/server.lua`
3) To start the script, add this line at the end of your resources in server.cfg: `ensure tip4serv` (if that doesn't work add this instead: `start tip4serv`)
4) Add this line in server.cfg to allow tip4serv to type commands in the console: `add_ace resource.tip4serv command allow`
5) Restart the server and click on connect in your tip4serv.com panel.

You get this message in the console when the server has started: **Server has been successfully connected**

#### Essential/MySQL add-on: esx_tip4serv

Adds executable console commands compatible with essential and offline players (works by steam id).

[esx_tip4serv](https://github.com/Murgator/esx-fivem-commands)
[esx2_tip4serv](https://github.com/Murgator/esx2-fivem-commands)
