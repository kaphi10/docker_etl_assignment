### ETL PIPELINE WITH DOCKER
#### Step by step process of a simple Etl pipeline Running in a docker container.
The docker execution was written in a bash query. .sh file. 
#### Step 1
- Write a Python file that runs the pipeline i.e get a csv file using pandas liberary  
- transform the imported file by formating strings values to lowercase  
- Load the transformed  data to a postgres database
#### Step 2
- Create a docker file that serve as a lone server/ container to run the Etl process  
- In my Docker file I copy the.env file for my postgres credentials
- Copy the requirements.txt file (list of all needed library)  
- Run the requirements.txt file i.e install all needed library to my docker 
- Copy the application folder
- Run the application
####  Step 3
- Write a bash query that help to execute docker commands 
Eg  
- Create a docker postgres container using postgres 13 image  
- Create a Network
- Create an Etl image create Etl container
- Connect the postgres container and Etl container to the created network 
> On the bash terminal   
Run  
chmod +x file.sh (convert the.sh file to executable)  
./file.sh 

> Note  
The bash script always remove existing container and if any before creating new one that can be used for the current process  
