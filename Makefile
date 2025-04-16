BLUE=$(shell echo -e "\033[1;34m")
BLUE=$(shell echo -e "\033[1;34m")

MARIADB_DIR=/home/yhsu/data/mariadb
WORDPRESS_DIR=/home/yhsu/data/wordpress
COMPOSE_FILE=srcs/docker-compose.yml

# Build all Docker images defined in docker-compose.yml
build:
	./srcs/docker-compose.yml build


# Start all containers in detached mode
up:
	docker-compose up -d


# Stop and remove containers, networks, volumes, and images 
down:
	docker-compose down

restart: down up

#follow logs for all services
logs:
	docker-compose logs -f

clean: 
	docker-compose down -v

fclean: clean


re: fclean all

.PHONY: all clean fclean re up down mariadb_data wordpress_data image