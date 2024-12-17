Tools
Browserbase Web Loader
Browserbase is a developer platform to reliably run, manage, and monitor headless browsers.

​
BrowserbaseLoadTool
​
Description
Browserbase is a developer platform to reliably run, manage, and monitor headless browsers.

Power your AI data retrievals with:

Serverless Infrastructure providing reliable browsers to extract data from complex UIs
Stealth Mode with included fingerprinting tactics and automatic captcha solving
Session Debugger to inspect your Browser Session with networks timeline and logs
Live Debug to quickly debug your automation
​
Installation
Get an API key and Project ID from browserbase.com and set it in environment variables (BROWSERBASE_API_KEY, BROWSERBASE_PROJECT_ID).
Install the Browserbase SDK along with crewai[tools] package:

pip install browserbase 'crewai[tools]'
​
Example
Utilize the BrowserbaseLoadTool as follows to allow your agent to load websites:

Code

from crewai_tools import BrowserbaseLoadTool

# Initialize the tool with the Browserbase API key and Project ID
tool = BrowserbaseLoadTool()
​
Arguments
The following parameters can be used to customize the BrowserbaseLoadTool’s behavior:

Argument	Type	Description
api_key	string	Optional. Browserbase API key. Default is BROWSERBASE_API_KEY env variable.
project_id	string	Optional. Browserbase Project ID. Default is BROWSERBASE_PROJECT_ID env variable.
text_content	bool	Optional. Retrieve only text content. Default is False.
session_id	string	Optional. Provide an existing Session ID.
proxy	bool	Optional. Enable/Disable Proxies. Default is False.