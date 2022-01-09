## TIP4SERV SCRIPT

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


## ESX FRAMEWORK COMMANDS

Here are some commands if you are using the ESX framework: https://esx-framework.github.io/

#### giveaccountmoney {fivem_liveid} [account-type(money/bank...)] [amount]
Give money to a player on his bank account or pocket money.

Example: `giveaccountmoney {fivem_liveid} bank 5000`

#### giveitem {fivem_liveid} [item] [count]
This command gives an inventory item to the user.

Example: `giveitem {fivem_liveid} milk 1`

#### giveweapon {fivem_liveid} [weapon_name] [ammo]
This command gives a weapon to the user.

Example: `giveweapon {fivem_liveid} weapon_heavyrifle 32`

#### setgroup {fivem_liveid} [group_name] [ammo]
This command sets the group of the user.

Example: `setgroup {fivem_liveid} vip`

#### setjob {fivem_liveid} [job_name] [job_grade]
This command sets the users job and job grade.

Example: `setjob {fivem_liveid} police 1`
