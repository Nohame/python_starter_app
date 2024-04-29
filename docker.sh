#!/usr/bin/env sh

DIRNAME="$(dirname "$0")"

# COLORS
# 0    black     BLACK     0,0,0
# 1    red       RED       1,0,0
# 2    green     GREEN     0,1,0
# 3    yellow    YELLOW    1,1,0
# 4    blue      BLUE      0,0,1
# 5    magenta   MAGENTA   1,0,1
# 6    cyan      CYAN      0,1,1
# 7    white     WHITE     1,1,1
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
RESET_COLOR=`tput sgr0`

action=$1

# Load specific env file
if [ -e .env ]; then
    source ".env"
else
    echo "Please set up your .env file before starting your environment."
    exit 1
fi

# Display a message on the standard output.
display()
{
    echo ">> $@"
}

# Displays an error message on the standard output.
display_error()
{
    echo ">>${RED} $@${RESET_COLOR}"
}

# Display a success message on the standard output.
display_success()
{
    echo ">>${GREEN} $@${RESET_COLOR}"
}

get_base_docker_app_path()
{
  echo "/usr/src/app/$APP_NAME"
}

# Execute command.
execute_command()
{
  path=$(get_base_docker_app_path)
  echo ">>${GREEN} $@${RESET_COLOR}"
  docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" --workdir "$path" -ti "$APP_NAME" $@ || echo "`tput setab 1`Error: Bad destination => $path `tput sgr0`"
}

ssh_connect()
{
  path=$(get_base_docker_app_path)
  printf "Connect ssh to $path in $APP_NAME container \n"
  docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" --workdir $path -ti $APP_NAME bash || echo "`tput setab 1`Error: Bad destination => $path `tput sgr0`"
}

    echo ""
    echo "***************************************************************************************************************"
    echo "***************************************************************************************************************"
    echo "                                    ONLY [${GREEN}$APP_ENV${RESET_COLOR}] ENVIRONMENT                          "
    echo "***************************************************************************************************************"
    echo "***************************************************************************************************************"
    echo ""

docker_start() {

    # Check if variables exist
    if [ -z ${APP_NAME+x} ]; then display_error "var APP_NAME is unset"; exit; fi
    if [ -z ${NETWORK+x} ]; then display_error "var NETWORK is unset"; exit; fi
    if [ -z ${PYTHON_VERSION+x} ]; then display_error "var PYTHON_VERSION is unset"; exit; fi
    if [ -z ${APP_HOST+x} ]; then display_error "var APP_HOST is unset"; exit; fi
    if [ -z ${APP_PORT+x} ]; then display_error "var APP_PORT is unset"; exit; fi

    display 'Create network'
    docker network create $NETWORK
    display "Up docker-compose"
    docker-compose -f docker-compose.yml --env-file .env up -d
    ssh_connect

    if [ -z $1 ]
    then
        echo 'Display terminal log'
        echo '*******************************************************************'
        echo '*******************************************************************'
        echo "* ${GREEN}Running Docker on http://${APP_HOST}:${APP_PORT} (Press CTRL+C to quit) ${RESET_COLOR}*"
        echo '*******************************************************************'
        echo '*******************************************************************'
    fi
}

# Display the available commands
usage()
{
    command_base="docker.sh"

    echo ""
    echo "################ ${YELLOW}AVAILABLE COMMANDS${RESET_COLOR} ################"
    echo ""
	  grep -E '# [a-zA-Z_-]+:.*?## .*$$' $command_base | cut -c3- | sort | awk -F/ -v command_base=$command_base 'BEGIN {FS = ":.*?## "}; {printf command_base " \033[36m%-30s\033[0m %s\n", $1, $2}'
    echo ""
    exit
}

if [ -z $action ] || ([ $action != 'stop' ] && [ $action != 'start' ]  && [ $action != 'restart' ] && [ $action != 'ssh' ])
then
  display_error "Invalid action target ..."
  usage
  exit 1
fi

# stop: ## Stop docker-compose
if [ $action = 'stop' ]
then
    #
    # Stop app
    #
    docker-compose stop
fi

if [ -z $action ]
then
    echo 'No argument specified'

# start: ## Start docker-compose
elif [ $action = 'start' ]
then
    #
    # Start up app
    #
    docker_start

# restart: ## Restart docker-compose
elif [ $action = 'restart' ]
then
    #
    # Restart app
    #
    docker-compose stop
    docker_start

# ssh: ## Connect ssh to app container
elif [ $action = 'ssh' ]
then
   ssh_connect

fi