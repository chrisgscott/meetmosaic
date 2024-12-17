Firecrawl Search
The FirecrawlSearchTool is designed to search websites and convert them into clean markdown or structured data.

​
FirecrawlSearchTool
​
Description
Firecrawl is a platform for crawling and convert any website into clean markdown or structured data.

​
Installation
Get an API key from firecrawl.dev and set it in environment variables (FIRECRAWL_API_KEY).
Install the Firecrawl SDK along with crewai[tools] package:

pip install firecrawl-py 'crewai[tools]'
​
Example
Utilize the FirecrawlSearchTool as follows to allow your agent to load websites:

Code

from crewai_tools import FirecrawlSearchTool

tool = FirecrawlSearchTool(query='what is firecrawl?')
​
Arguments
api_key: Optional. Specifies Firecrawl API key. Defaults is the FIRECRAWL_API_KEY environment variable.
query: The search query string to be used for searching.
page_options: Optional. Options for result formatting.
onlyMainContent: Optional. Only return the main content of the page excluding headers, navs, footers, etc.
includeHtml: Optional. Include the raw HTML content of the page. Will output a html key in the response.
fetchPageContent: Optional. Fetch the full content of the page.
search_options: Optional. Options for controlling the crawling behavior.
limit: Optional. Maximum number of pages to crawl.