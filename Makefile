# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yhsu <yhsu@student.hive.fi>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/16 10:54:00 by yhsu              #+#    #+#              #
#    Updated: 2025/04/17 17:50:37 by yhsu             ###   ########.fr        #
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
	@echo "$(BLUE)creating MariaDb directory$(RESET)"
	@mkdir -p $(MARIADB_DIR) 
	@echo "$(BLUE)creating Wordpress directory$(RESET)"
	@mkdir -p $(WORDPRESS_DIR) 
	@echo "$(BLUE)building images and activating containers$(RESET)"
	@$(MAKE) images 
	@$(MAKE) up
	@echo "DONE~~~"



images:
	@docker compose -f $(COMPOSE_FILE) build	


# Start all containers in detached mode
up:
	@docker compose -f $(COMPOSE_FILE) up -d


# Stop and remove containers, networks, volumes, and images 
down:
	@docker compose -f $(COMPOSE_FILE)  down



#follow logs for all services
logs:
	docker compose -f $(COMPOSE_FILE)  logs -f

clean: 
	@echo "$(BLUE)clean containers, images, and volumes.$(RESET)"
#--rmi remove all images
	@docker-compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@echo "$(BLUE)remove data directories.$(RESET)"
	@sudo rm -rf $(DATA_DIR)
	@docker system prune -f --volumes

re: fclean all

.PHONY: all clean fclean re up down mariadb_data wordpress_data image