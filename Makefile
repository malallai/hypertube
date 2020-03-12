MAKEFLAGS += --no-print-directory
ECHO=echo

# Colors
C_INFO		= \033[0;36m
C_PENDING	= \033[0;33m
C_SUCCESS	= \033[0;32m
C_RESET		= \033[0m

all: up open


# ---- MISC ----#

open:
	@open http://localhost:5000/
	@open http://localhost:6880/

mysql:
	@docker-compose exec db mysql -uroot -phypertube

# -- RAILS -- #

routes:
	@docker-compose exec web rails routes


# -- COMPOSE -- #

pull:
	@$(ECHO) "$(C_PENDING)\nPulling images...$(C_RESET)"
	@docker-compose pull
	@$(ECHO) "$(C_SUCCESS)Pulled images successfully.$(C_RESET)"

build:
	@$(ECHO) "$(C_PENDING)\nBuilding images...$(C_RESET)"
	@docker-compose build
	@$(ECHO) "$(C_SUCCESS)Built images successfully.$(C_RESET)"

up:
	@$(ECHO) "$(C_PENDING)\nStarting compose project...$(C_RESET)"
	@docker-compose up -d
	@$(ECHO) "$(C_SUCCESS)Started compose project.$(C_RESET)"
	@$(ECHO) "$(C_INFO)Run \`make logs\` to see (and follow) logs.$(C_RESET)"
	-@$(MAKE) ps

down:
	@$(ECHO) "$(C_PENDING)\nStoping compose project...$(C_RESET)"
	@docker-compose down
	@$(ECHO) "$(C_SUCCESS)Stopped compose project.$(C_RESET)"

restart:
	@$(ECHO) "$(C_PENDING)\nRestarting compose project...$(C_RESET)"
	@docker-compose restart
	@$(ECHO) "$(C_SUCCESS)Restarted compose project.$(C_RESET)"

re:
	@$(ECHO) "$(C_PENDING)\nRestarting web service...$(C_RESET)"
	@docker-compose restart web
	@$(ECHO) "$(C_SUCCESS)Restarted web service.$(C_RESET)"

ps:
	@docker-compose ps
#	@echo '------------'
#	@dockerps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"

logs:
	@docker-compose logs --tail 500 -f web

log: logs
