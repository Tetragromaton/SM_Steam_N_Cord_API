/*
**
*/
#if defined _SNC_included
 #endinput
#endif
#define _SNC_included


//Check, does player have Discord ID or not. False if empty, True if he has it.
native bool SNC_HasDiscordID(int client);
//Store Discord ID of player in to CHAR string. String must be 255 symbols, because we dont need 2 much.
native int SNC_GetDiscordID(int client, char[] variable);
//Check, are user member of your Discord server, define your server ID before using. True - on yes, False - otherwise..
native bool SNC_AreServerMember(int client);