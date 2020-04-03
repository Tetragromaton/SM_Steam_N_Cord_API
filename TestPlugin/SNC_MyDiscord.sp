#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR ""
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <snc>

public Plugin myinfo = 
{
	name = "",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	RegConsoleCmd("mydiscord", MyDiscord);
}

public Action MyDiscord(client,args)
{
	if(SNC_HasDiscordID(client))
	{
		char DID[255];
		SNC_GetDiscordID(client, DID);
		PrintToChat(client, "Your Discord ID is: %s", DID);
		if(SNC_AreServerMember(client))
		{
			PrintToChat(client, "You are member of our server in discord !");
		} else PrintToChat(client, "You aren't in our discord server.");
	} else PrintToChat(client, "You have not linked your account yet, visit www.steamncord.xyz for more info.");
}