## Tip4Serv script for FiveM

This script connects your [Tip4serv.com](https://tip4serv.com/) store to your FiveM server.
It checks if a customer has bought something on your Tip4Serv store and delivers the order (money, rank...) by typing commands in the server console

#### HMAC authentification

Tip4serv adds a layer of security using HMAC authentication to communicate. It is a strong authentication method that is used by banks https://en.wikipedia.org/wiki/HMAC

#### Installation

Open an account on [Tip4serv.com](https://tip4serv.com/), follow the instructions and add a FiveM server.

1) Copy the `tip4serv` directory to your `resources` folder on your FiveM server.
2) Set `Config.key` to your tip4serv API key in `tip4serv/config.lua`
3) To start the script, add this line ***at the end*** of your resources in server.cfg: `ensure tip4serv`
4) Add this line in your `server.cfg` to allow tip4serv to type commands in the console: `add_ace resource.tip4serv command allow`
5) Restart the server and click on connect in your tip4serv.com panel.

You get this message in the console when the server has started: **Server has been successfully connected**

To check if the server is correctly connected type `restart tip4serv` in your server console.

## How to buy and receive your order

1) Player buys a product on Tip4Serv store.
2) Player types `/checkdonate` command on the server chat and receives his order.

#### No dependencie, work with console commands

This script is compatible with all FiveM frameworks just know that you have to use console commands.
Before setting up your commands on Tip4serv.com, you should know that they work in your server's console.

## Console commands

Here are some commands you can use in the products configuration: (https://tip4serv.com/dashboard/my-products).
When the player is connected on the FiveM server, his `{fivem_live_id}` will be retrieved using the `Steam ID` or `Discord ID` that he will have entered during his purchase.

#### t4s_announce [prefix] [text]
Advertise in server chat. (This command is part of Tip4serv script and works natively)

Example: `t4s_announce [STORE] Thanks to {discord_username} for donating to the server on mystore.tip4serv.com`

Example: `t4s_announce [STORE] Thanks to {steam_username} for donating to the server on mystore.tip4serv.com`

***If your framework does not offer any console commands you will have to create them***, for this you can edit this file: `/server/commands.lua` (QBCore example) and set `Config.enable_custom_command` to `true` in `config.lua` file.


## COMMANDS FOR ESX FRAMEWORK

Below commands are part of **es_extended**. ESX framework is required: https://esx-framework.github.io/

#### giveaccountmoney {fivem_live_id} [account-type(money/bank...)] [amount]
Give money to a player on his bank account or pocket money.

Example: `giveaccountmoney {fivem_live_id} bank 5000`

#### giveitem {fivem_live_id} [item] [count]
This command gives an inventory item to the user.

Example: `giveitem {fivem_live_id} milk 1`

#### giveweapon {fivem_live_id} [weapon_name] [ammo]
This command gives a weapon to the user.

Example: `giveweapon {fivem_live_id} WEAPON_STUNGUN 32`

#### setgroup {fivem_live_id} [group_name] [ammo]
This command sets the group of the user.

Example: `setgroup {fivem_live_id} vip`

#### setjob {fivem_live_id} [job_name] [job_grade]
This command sets the users job and job grade.

Example: `setjob {fivem_live_id} police 1`


## COMMANDS FOR QBCORE FRAMEWORK

QBCore framework is required if you want to use commands below: https://github.com/qbcore-framework.

You have to set `Config.enable_custom_command` to `true` in `config.lua` file. This commands are located in this file: `/server/commands.lua`.

#### giveaccountmoney {fivem_live_id} [account-type(money/bank...)] [amount]
Give money to a player on his bank account or pocket money.

Example: `giveaccountmoney {fivem_live_id} bank 5000`

#### giveitem {fivem_live_id} [item] [count]
This command gives an inventory item to the user.

Example: `giveitem {fivem_live_id} milk 1`

#### giveweapon {fivem_live_id} [weapon_name] [ammo]
This command gives a weapon to the user.

Example: `giveweapon {fivem_live_id} WEAPON_STUNGUN 32`

#### setgroup {fivem_live_id} [group_name] [ammo]
This command sets the group of the user.

Example: `setgroup {fivem_live_id} vip`

#### setjob {fivem_live_id} [job_name] [job_grade]
This command sets the users job and job grade.

Example: `setjob {fivem_live_id} police 1`


## Commands also run automatically

Useful if you are creating subscriptions with expiration commands.

Example: if the player unsubscribes, his VIP group will be removed.

To ensure player data is fully loaded, commands with `{fivem_live_id}` will only execute if the player has moved at least once since connecting to the server. This is to ensure that the player is not in the loading screen or in the character choice.

## Contact

If you need help contact us on https://tip4serv.com/contact
