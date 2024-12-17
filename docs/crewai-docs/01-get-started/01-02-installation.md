Get Started
Installation
Get started with CrewAI - Install, configure, and build your first AI crew

Python Version Requirements

CrewAI requires Python >=3.10 and <=3.13. Here’s how to check your version:


python3 --version
If you need to update Python, visit python.org/downloads

​
Installing CrewAI
CrewAI is a flexible and powerful AI framework that enables you to create and manage AI agents, tools, and tasks efficiently. Let’s get you set up! 🚀

1
Install CrewAI

Install CrewAI with all recommended tools using either method:

Terminal

pip install 'crewai[tools]'
or

Terminal

pip install crewai crewai-tools
Both methods install the core package and additional tools needed for most use cases.

2
Upgrade CrewAI (Existing Installations Only)

If you have an older version of CrewAI installed, you can upgrade it:

Terminal

pip install --upgrade crewai crewai-tools
If you see a Poetry-related warning, you’ll need to migrate to our new dependency manager:

Terminal

crewai update
This will update your project to use UV, our new faster dependency manager.

Skip this step if you’re doing a fresh installation.

3
Verify Installation

Check your installed versions:

Terminal

pip freeze | grep crewai
You should see something like:

Output

crewai==X.X.X
crewai-tools==X.X.X
Installation successful! You’re ready to create your first crew.
​
Creating a New Project
We recommend using the YAML Template scaffolding for a structured approach to defining agents and tasks.

1
Generate Project Structure

Run the CrewAI CLI command:

Terminal

crewai create crew <project_name>
This creates a new project with the following structure:


my_project/
├── .gitignore
├── pyproject.toml
├── README.md
├── .env
└── src/
    └── my_project/
        ├── __init__.py
        ├── main.py
        ├── crew.py
        ├── tools/
        │   ├── custom_tool.py
        │   └── __init__.py
        └── config/
            ├── agents.yaml
            └── tasks.yaml
2
Customize Your Project

Your project will contain these essential files:

File	Purpose
agents.yaml	Define your AI agents and their roles
tasks.yaml	Set up agent tasks and workflows
.env	Store API keys and environment variables
main.py	Project entry point and execution flow
crew.py	Crew orchestration and coordination
tools/	Directory for custom agent tools
Start by editing agents.yaml and tasks.yaml to define your crew’s behavior. Keep sensitive information like API keys in .env.