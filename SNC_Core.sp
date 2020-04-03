//Steam & Cord Core v1.0 | An TETRADEV Service.
//github.com/Tetragromaton.
//Keep in mind that we are running with no sponsors, so the service could not work sometimes.
//мени не бачу, я русске, мне впадлу делать русификацию, сделал сразу на английском, так что хз.
//kiss ya

//This is only a wrapper for my api, so you can use it to auth with DISCORD.

//Has Discord or not.
// Example: http://steamncord.xyz:228/api/getbyid?steamid=<STEAM_ID_64_HERE>
// NOR: SNC_HasDiscord(client) bool true if player authed in site, bool false if player not authed in site.

//Check member ship at your discord server.

//Example: http://steamncord.xyz:228/api/checkmember?steamid=<STEAM_ID_64_HERE>&guildid=<SERVER_ID_HERE>
// NOR: SNC_AreServerMember(client) bool true on yes, false if player are not at server.

//Warning ! URL must be in HTTP format with 228 port for API's, so never use site as usual with 228 port or else you risk your data to be f***ed.

#include <sourcemod>
#include <ripext>
#define foreach(%0) for (int %0 = 1; %0 <= MaxClients; %0++) if (IsClientInGame(%0))
HTTPClient httpClient;

char g_sDiscordID[MAXPLAYERS + 1][255];

bool g_bAreServerMember[MAXPLAYERS + 1] = false;

char g_sDiscordSERVER_ID[255];

ConVar g_sDiscordSERVER;
public APLRes AskPluginLoad2(Handle hMyself, bool bLate, char[] sError, int iErr_max)
{
	CreateNative("SNC_HasDiscordID", Native_HasID);
	CreateNative("SNC_GetDiscordID", Native_GetDiscord);
	CreateNative("SNC_AreServerMember", Native_AreMember);
	RegPluginLibrary("snc");
	return APLRes_Success;
}
public Native_HasID(Handle hPlugin, int iNumParams)
{
	
	int client;
	client = GetNativeCell(1);
	if(StrEqual(g_sDiscordID[client], ""))
	{
		return false;
	}
	return true;
}
public Native_AreMember(Handle hPlugin, int iNumParams)
{
	int client;
	client = GetNativeCell(1);
	if(g_bAreServerMember[client])
	{
		return true;
	}
	return false;
}
public int Native_GetDiscord(Handle hPlugin, int iNumParams)
{
	int client;
	client = GetNativeCell(1);
	char Result[255];
	Result = "";
	Result = g_sDiscordID[client];
	SetNativeString(2, Result, sizeof(Result));
	return 1;
}
public void OnPluginStart()
{
	httpClient = new HTTPClient("http://www.steamncord.xyz:228");
	g_sDiscordSERVER = CreateConVar("SNC_ServerID", "", "ID of your server in Discord.");
	AutoExecConfig(true, "SNC_Core");
	HookConVarChange(g_sDiscordSERVER, OnChange);
}

public OnConfigsExecuted()
{
	char WTF[255];
	GetConVarString(g_sDiscordSERVER, WTF, sizeof(WTF));
	Format(g_sDiscordSERVER_ID, sizeof(g_sDiscordSERVER_ID), WTF);
}
public OnChange(Handle hCvar, const String:sOldValue[], const String:sNewValue[])
{
	if(hCvar == g_sDiscordSERVER){
		Format(g_sDiscordSERVER_ID, sizeof(g_sDiscordSERVER_ID), "%s", sNewValue);
		foreach(X)
		{
			g_bAreServerMember[X] = false;
			PrintToServer("[SNC Core] You have updated Discord server ID, so your players should reconnect to server to affect changes.");
		}
	}
}
public OnClientPutInServer(client)
{
	g_sDiscordID[client] = "";
	g_bAreServerMember[client] = false;
	char FormatBUILDER[255];
	char SID[255];
	GetClientAuthId(client, AuthId_SteamID64, SID, sizeof(SID));
	Format(FormatBUILDER, sizeof(FormatBUILDER), "api/getbyid?steamid=%s", SID);
	httpClient.Get(FormatBUILDER, OnTodoReceived);
}
public OnClientDisconnect(client)
{
	g_sDiscordID[client] = "";
	g_bAreServerMember[client] = false;
}
public void OnTodoReceived(HTTPResponse response, any value)
{
	//PrintToChatAll("%i", response.Status);

	if (response.Data == null) {
		// Invalid JSON response
		return;
	}
	JSONObject todo = view_as<JSONObject>(response.Data);
	
	char todoTitle[256];
	todo.GetString("DiscordID", todoTitle, sizeof(todoTitle));
	char Steamcheek[255];
	todo.GetString("SteamID", Steamcheek, sizeof(Steamcheek));
	if (!StrEqual(todoTitle, "NULL"))
	{
		if (!StrEqual(Steamcheek, "NULL"))
		{
			foreach(X)
			{
					char Auth[255];
					GetClientAuthId(X, AuthId_SteamID64, Auth, sizeof(Auth));
					if (StrEqual(Auth, Steamcheek))
					{
						g_sDiscordID[X] = todoTitle;
						AuthMembership(X);
						break;
					}
			}
		}
	}
} 

AuthMembership(int client)
{
	g_bAreServerMember[client] = false;
	if(!StrEqual(g_sDiscordSERVER_ID, ""))
	{
			char FormatBUILDER[255];
			char SID[255];
			GetClientAuthId(client, AuthId_SteamID64, SID, sizeof(SID));
			Format(FormatBUILDER, sizeof(FormatBUILDER), "api/checkmember?steamid=%s&guildid=%s", SID, g_sDiscordSERVER_ID);
			httpClient.Get(FormatBUILDER, OnGuildAuth);
			//PrintToChatAll("%s", FormatBUILDER);
	}
}

public void OnGuildAuth(HTTPResponse response, any value)
{

	if (response.Data == null) {
		// Invalid JSON response
		return;
	}
	JSONObject todo = view_as<JSONObject>(response.Data);
	
	char Steamcheek[255];
	todo.GetString("SteamID", Steamcheek, sizeof(Steamcheek));
	bool AreIn = todo.GetBool("AreMember");
	if(AreIn)
	{
		if (!StrEqual(Steamcheek, "NULL"))
		{
			foreach(X)
			{
					char Auth[255];
					GetClientAuthId(X, AuthId_SteamID64, Auth, sizeof(Auth));
					if (StrEqual(Auth, Steamcheek))
					{
						g_bAreServerMember[X] = true;
						break;
					}
			}
		}
	}
} 