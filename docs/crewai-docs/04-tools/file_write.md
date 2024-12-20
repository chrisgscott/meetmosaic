File Write
The FileWriterTool is designed to write content to files.

​
FileWriterTool
​
Description
The FileWriterTool is a component of the crewai_tools package, designed to simplify the process of writing content to files. It is particularly useful in scenarios such as generating reports, saving logs, creating configuration files, and more. This tool supports creating new directories if they don’t exist, making it easier to organize your output.

​
Installation
Install the crewai_tools package to use the FileWriterTool in your projects:


pip install 'crewai[tools]'
​
Example
To get started with the FileWriterTool:

Code

from crewai_tools import FileWriterTool

# Initialize the tool
file_writer_tool = FileWriterTool()

# Write content to a file in a specified directory
result = file_writer_tool._run('example.txt', 'This is a test content.', 'test_directory')
print(result)
​
Arguments
filename: The name of the file you want to create or overwrite.
content: The content to write into the file.
directory (optional): The path to the directory where the file will be created. Defaults to the current directory (.). If the directory does not exist, it will be created.
​
Conclusion
By integrating the FileWriterTool into your crews, the agents can execute the process of writing content to files and creating directories. This tool is essential for tasks that require saving output data, creating structured file systems, and more. By adhering to the setup and usage guidelines provided, incorporating this tool into projects is straightforward and efficient.