#include <sourcemod>
#include <json>
#include <system2>

public Plugin:myinfo =
{
	name = "GameCMS.ORG Api Progress",
	author = "Wohaho",
	description = "Progressing all commands from GameCMS.ORG",
	version = "1.1",
	url = "https://gamecms.org"
};


ConVar server_api_key;
ConVar cv_hibernate;


char apiEndpoint[30] = "https://api.gamecms.org/v2";

bool force_api = false;
public void OnPluginStart()
{
	server_api_key = CreateConVar("gcms_server_key", "No server key.", "Server API Key");

	cv_hibernate = FindConVar("sv_hibernate_when_empty");

	FixHibernate();

	RegConsoleCmd("gcms_force_commands", ForceApiCommands, "Force plugin to fetch the commands in queue.");

	CreateTimer(120.0, CheckForCommands, _, TIMER_REPEAT);
}

public Action CheckForCommands(Handle timer)
{
	force_api = false;
	RetrieveData();
}

void FixHibernate()
{
	if (cv_hibernate != null)
	cv_hibernate.IntValue = 0;
}

public Action ForceApiCommands(int client, int args)
{
	force_api = true;
	RetrieveData();
	return Plugin_Handled;
}

public void OnMapStart()
{
	RetrieveData();
	FixHibernate();
}

void RetrieveData()
{
	char request[256];
	Format(request, sizeof(request), "%s/commands/queue/csgo", apiEndpoint);
	System2HTTPRequest httpRequest = new System2HTTPRequest(HttpResponseCallback, request);
	httpRequest.SetHeader("Authorization", "Bearer %s", getServerKey())
	httpRequest.GET();

	delete httpRequest;
}


public int HttpResponseCallback(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method)
{
	if (!success) return 0;

	if (response.StatusCode != 200){
		if (force_api){
			PrintToServer("[GameCMS.ORG] No due commands found.")
		}
		return 0;
	}

	char[] content = new char[response.ContentLength + 1];
	response.GetContent(content, response.ContentLength + 1);

	if (force_api)
	{
		PrintToServer("API Response: %s", content);
	}

	JSON_Object responseObject = view_as<JSON_Object>(json_decode(content));

	JSON_Array dataResult = view_as<JSON_Array>(responseObject.GetHandle("data"));
	if (dataResult == INVALID_HANDLE){
		if (force_api){
			PrintToServer("[GameCMS.ORG] Invalid handle for data!")
		}
		return 0
	}

	int numOfCommands = dataResult.Length;
	for (int i = 0; i < numOfCommands; i++)
	{
		JSON_Object result = view_as<JSON_Object>(dataResult.GetObject(i));

		JSON_Array commands = view_as<JSON_Array>(result.GetHandle("commands"));
		if (commands == INVALID_HANDLE){
			if (force_api){
				PrintToServer("[GameCMS.org] Invalid handle for commands!")
			}
			return 0
		}

		int singleCommandArrayLength = commands.Length;
		for (int j = 0; j < singleCommandArrayLength; j++)
		{
			char command[255];
			commands.GetString(j, command, sizeof(command));
			ServerCommand(command);
		}
	}
	json_cleanup_and_delete(responseObject);
	
	PrintToServer("[GameCMS.ORG] All [%i] commands fetched.", numOfCommands);
	SendCompletedRequest();
	
	return 1;
}


public void SendCompletedRequest(){
	char request[256];
	Format(request, sizeof(request), "%s/commands/complete", apiEndpoint);
	System2HTTPRequest httpRequest = new System2HTTPRequest(HttpResponseCallbackDone, request);
	httpRequest.SetHeader("Authorization", "Bearer %s", getServerKey());
	httpRequest.GET();
	delete httpRequest;
}


public void HttpResponseCallbackDone(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method) {
	if (success) {
		//PrintToServer("[GameCMS.ORG] All commands fetched.");
	}

}

char getServerKey() {
	char key[256];
	GetConVarString(server_api_key, key, sizeof(key));
	return key;
}