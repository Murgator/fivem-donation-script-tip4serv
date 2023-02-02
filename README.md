## Donation script for FiveM (Tip4Serv)

This script connects your [Tip4serv.com](https://tip4serv.com/) store to your FiveM server.
It checks if a player has made a donation on your Tip4Serv store and delivers the order (money, rank, vehicle, item...) by typing commands in the server console

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

1) Player make a donation on Tip4Serv store.
2) The player receives his order in the game.

The player can also type `/checkdonate` on the server chat to receive his order faster.

## Setting up commands on Tip4Serv

***Before setting up your commands on Tip4serv.com, you should know that command work in your server's console (not ingame as an admin).***

***If your framework does not offer any console commands you will have to create them see bottom of page.***

Here are some commands you can use in the [products configuration](https://tip4serv.com/dashboard/my-products).

When the player is connected on the FiveM server, his `{fivem_live_id}` will be retrieved using the `Steam ID` or `Discord ID` that he will have entered during his purchase.

##### t4s_announce [prefix] [text]

Advertise in server chat. (This command is part of Tip4serv script and works natively)

Examples: 

`t4s_announce [STORE] Thanks to {discord_username} for donating to the server on mystore.tip4serv.com`

`t4s_announce [STORE] Thanks to {steam_username} for donating to the server on mystore.tip4serv.com`

## COMMANDS FOR ESX FRAMEWORK

[ESX framework](https://esx-framework.github.io/) and [es_extended](https://github.com/esx-framework/esx-legacy/tree/main/%5Besx%5D/es_extended) are required

##### giveaccountmoney {fivem_live_id} [account-type(money/bank...)] [amount]

Give money to a player on his bank account or pocket money.

Example: `giveaccountmoney {fivem_live_id} bank 5000`

##### giveitem {fivem_live_id} [item] [count]

This command gives an inventory item to the user.

Example: `giveitem {fivem_live_id} milk 1`

##### giveweapon {fivem_live_id} [weapon_name] [ammo]

This command gives a weapon to the user.

Example: `giveweapon {fivem_live_id} WEAPON_STUNGUN 32`

##### setgroup {fivem_live_id} [group_name] [ammo]

This command sets the group of the user.

Example: `setgroup {fivem_live_id} vip`

##### setjob {fivem_live_id} [job_name] [job_grade]

This command sets the users job and job grade.

Example: `setjob {fivem_live_id} police 1`

##### _givecar {fivem_live_id} [model] [ESX Vehicle is required](https://github.com/minobear/esx_givevehicle)

This command give a vehicle to a player.

Use the console command, the prefix must be "_" : 

Example: `_givecar {fivem_live_id} t20`


## COMMANDS FOR QBCORE FRAMEWORK

***You have to set `Config.enable_custom_command` to `true` in `config.lua` file.*** 

[QBCore framework is required](https://github.com/qbcore-framework)

This commands are located in this file: `/server/commands.lua`.

##### giveaccountmoney {fivem_live_id} [account-type(money/bank...)] [amount]

Give money to a player on his bank account or pocket money.

Example: `giveaccountmoney {fivem_live_id} bank 5000`

##### setplayergang {fivem_live_id} [Name of a gang] [Grade]

This command set player gang and grade.

Example: `setplayergang {fivem_live_id} ballas 1`

##### setplayerjob {fivem_live_id} [Name of a job] [Grade]

This command set player job and grade.

Example: `setplayerjob {fivem_live_id} police 1`

##### setplayerpermission {fivem_live_id} [Permission name]

This command set player permissions.

Example: `setplayerpermission {fivem_live_id} vip`

##### removeplayerpermission {fivem_live_id}

This command remove all player permissions.

Example: `removeplayerpermission {fivem_live_id}`

##### giveinventoryitem {fivem_live_id} [Item name] [Amount]

This command give an item to a player inventory

Example: `giveinventoryitem {fivem_live_id} WEAPON_KNIFE 1`

##### givevehicletoplayer {fivem_live_id} [Model]

[HH Vehextras is required](https://github.com/hhfw1/hh_vehextras)

This command give a vehicle to a player

Example: `givevehicletoplayer {fivem_live_id} t20`

## Quantity multiplier

You can also multiply the quantity choosen by the customer like this: {quantity*64}

Example:

Use this command on Tip4serv if you want to sell bundles of $100: 
`giveaccountmoney {fivem_live_id} bank {quantity*100}`

This will run in your server console after a purchase if the player buys product 4 times:
`giveaccountmoney 14 bank 400`

## Commands also run automatically

Useful if you are creating subscriptions with expiration commands.

Example: if the player unsubscribes, his VIP group will be removed.

To ensure player data is fully loaded, commands with `{fivem_live_id}` will only execute if the player has moved at least once since connecting to the server. This is to ensure that the player is not in the loading screen or in the character choice.

## Create commands compatible with console & Tip4Serv

If you want to create commands make sure they are console compatible !

Use "RegisterCommand" method: https://docs.fivem.net/docs/scripting-manual/migrating-from-deprecated/creating-commands/

Follow the same example as giveaccountmoney line 10: https://github.com/Murgator/Tip4Serv/blob/master/tip4serv/server/commands.lua

## Need help creating new commands ?

If you are using another framework or want to create custom commands [contact us](https://tip4serv.com/contact)
