#!/bin/bash
helper ()
{
	echo -e '\nUsage: '$0' [Options...]'
	echo 'start   - Run agent as an active process'
	echo 'startbg - Run agent as a background process [Please fill all the required details in application.properties file]'
	echo 'stop    - Stop the running process'
	echo 'help    - Show help'
	exit
}

check_properties ()
{
	seeker_token=$(echo `cat application.properties | grep "seeker.api.token" | cut -d'=' -f2`)
	if [ "$seeker_token" != "" ]; then
		return 1
	else
		return 2
	fi
}

if [ "$#" -ne 1 ]
then
	helper
fi

SERVICE_NAME=$(echo `cat application.properties | grep "agent.name" | cut -d'=' -f2`)
PID_PATH_NAME=./${SERVICE_NAME//[[:blank:]]/}

java -version 2>./java-info.tmp

if [ $? -eq 1 ]; then
	echo "Unable to find java command, Please install java version Oracle 11 (https://www.oracle.com/technetwork/java/javase/downloads/index.html) or OpenJDK 11.0.2 (https://jdk.java.net/archive/)"
	exit 1
else
	if [ ! -f Seeker_Agent.jar ]; then
		echo "Unable to locate Seeker_Agent.jar file under $PWD"
		exit 1
	fi
	if [ ! -f application.properties ]; then
		echo "Unable to locate application.properties file under $PWD"
		exit 1
	fi
	version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
	if [[ $version == *"11.0"* ]]; then
		case $1 in
			start)
				if [ -f $PID_PATH_NAME ]; then
				    PID=$(cat $PID_PATH_NAME);
				    ps -p $PID > /dev/null;
				    if [ $? -eq 0 ];then
    					echo -e "\nSeeker agent with name '$SERVICE_NAME' is already running ..."
    				else
    					exec java -Xmx1024M -jar Seeker_Agent.jar --spring.config.additional-location=./application.properties
    				fi
    			else
    				exec java -Xmx1024M -jar Seeker_Agent.jar --spring.config.additional-location=./application.properties
    			fi
			;;
			startbg)
				if [ ! -f $PID_PATH_NAME ]; then
					check_properties
	     	    	if [ $? -eq 2 ]; then
	     	    		echo "Please fill all the required details in 'application.properties' file to run as background process"
	     	    	else
						exec java -Xmx1024M -jar Seeker_Agent.jar --spring.config.additional-location=./application.properties &
						echo $! > $PID_PATH_NAME
					fi
				elif [ -f $PID_PATH_NAME ]; then
				    PID=$(cat $PID_PATH_NAME);
				    ps -p $PID > /dev/null;
				    if [ $? -eq 0 ];then
    					echo -e "\nSeeker agent with name '$SERVICE_NAME' is already running ..."
    				else
    					rm $PID_PATH_NAME
    					check_properties
			 	    	if [ $? -eq 2 ]; then
			 	    		echo "Please fill all the required details in 'application.properties' file to run as background process"
			 	    	else
							exec java -Xmx1024M -jar Seeker_Agent.jar --spring.config.additional-location=./application.properties &
							echo $! > $PID_PATH_NAME
						fi
					fi

				fi
			;;
			stop)
				if [ -f $PID_PATH_NAME ]; then
				    PID=$(cat $PID_PATH_NAME);
				    ps -p $PID > /dev/null;
				    if [ $? -eq 0 ];then
				    	echo "$SERVICE_NAME stopping ..."
				    	kill -9 $PID;
				    	echo "$SERVICE_NAME stopped ..."
				    	rm $PID_PATH_NAME
				    else
						echo -e "\nSeeker agent with name '$SERVICE_NAME' is not running ..."
						rm $PID_PATH_NAME
				    fi
				else
				    echo -e "\nSeeker agent with name '$SERVICE_NAME' is not running ..."
				fi
			;;
			help)
				helper
			;;
			*)
				echo "Invalid Option"
				helper
		esac
	else
		echo "Java version Oracle 11 or OpenJDK 11.0.2 is required to run the agent. Please check your java version..."
		rm ./java-info.tmp
		exit 1
	fi
fi