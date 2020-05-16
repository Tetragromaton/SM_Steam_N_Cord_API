# SteamNCORD API Core v1.0(Beta)
<h4></b>Please keep in mind, you use this plugin and this service AS IS, withouth any guaranties that everything will be OK.</b></h4><br>
<h4 color=red>Warning ! You should have REST api Extension. You can take it <a href="https://forums.alliedmods.net/showthread.php?t=298024">here</a> </h4>
<h4 color=red>Also because of laziness, an PersonalVars plugin is now need as dependecy plugin on your server, install it <a href="https://github.com/Tetragromaton/SM-pVars">here</a> </h4>
<h5>Natives:</h5><br>
 <b>SNC_HasDiscordID(client)</b> - check if player have account at steamncord.xyz site.<br>
  <b>SNC_GetDiscordID(client, char[] string here)</b> - return player Discord ID as string.<br>
  <b>SNC_AreServerMember(client)</b> - check if player are member of your discord server defined in <b>SNC_Core.cfg</b><br>
  <b>SNC_Has(client, char[] roleid)</b> - check if player has role on your server.<br>
<h5>Config files</h5><br>
<b>AS ONLY as you loaded plugin on server, modify SNC_Core.cfg config file in /cfg/sourcemod/ folder and insert your server discord ID in to it like: <u>SNC_ServerID "563362438154813450"</u><br> Then restart plugin and reconnect to server.
 

