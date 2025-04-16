# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yhsu <yhsu@student.hive.fi>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/16 10:54:00 by yhsu              #+#    #+#              #
#    Updated: 2025/04/16 12:07:53 by yhsu             ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

BLUE=$(shell echo -e "\033[1;34m")
RESET=$(shell echo -e "\033[00m")

MARIADB_DIR=/home/yhsu/data/mariadb
WORDPRESS_DIR=/home/yhsu/data/wordpress
DATA_DIR = /home/yhsu/data
COMPOSE_FILE=srcs/docker-compose.yml



#targets 

# Build all direcotries, activate Docker  images defined in docker-compose.yml

all: mariadb_data wordpress_data
	@echo "creating MariaDb directory"
	@mkdir -p $(MARIADB_DIR) 
	@echo "creating Wordpress directory"
	@mkdir -p $(WORDPRESS_DIR) 
	@echo "building images and activating containers"
	@$(MAKE) images 
	@$(MAKE) up
	@echo "DONE~~~"



images:
	@docker-compose -f srcs/docker -compose.yml build	


# Start all containers in detached mode
up:
	@docker-compose -f $(COMPOSE_FILE) up -d


# Stop and remove containers, networks, volumes, and images 
down:
	@docker-compose -f $(COMPOSE_FILE)  down



#follow logs for all services
logs:
	docker-compose -f $(COMPOSE_FILE)  logs -f

clean: 
	@echo "clean containers, images, and volumes."
#--rmi remove all images
	@docker-compose -f $(COMPOSE_FILE) --rmi down -v

fclean: clean
	@echo "remove data directories."


re: fclean all

.PHONY: all clean fclean re up down mariadb_data wordpress_data image