include .env

SERVICES := jellyfin qbittorrent radarr jellyseerr jackett sonarr flaresolverr homer
ifeq ($(DISABLE_VPN), false)
	SERVICES += vpn
endif

.PHONY: up down vpn.* permissions api-keys

up: docker-compose.yaml .env
	docker-compose up -d --remove-orphans $(SERVICES)

down:
	docker-compose down

restart: down up

.ONESHELL:
.env: .env.example
	cp .env.example .env
	sed -i "s/PUID=/PUID=$$(id -u)/" .env
	sed -i "s/PGID=/PGID=$$(id -g)/" .env
	for svc in $(SERVICES); do
		[ -f "$$svc.env" ] || touch "$$svc.env"
	done

.ONESHELL:
vpn.disable: down
	cp docker-compose.yaml docker-compose.yaml.bak
	# sed -i "s/vpn:$$/x-vpn:/" docker-compose.yaml
	sed -i 's/^    network_mode: "service:vpn"$$/    # network_mode: "service:vpn"/' docker-compose.yaml
	sed -i 's/^    # ports: \[/    ports: [/' docker-compose.yaml
	sed -i 's/DISABLE_VPN=false/DISABLE_VPN=true/' .env

.ONESHELL:
vpn.enable: down
	cp docker-compose.yaml docker-compose.yaml.bak
	# sed -i "s/vpn:$$/x-vpn:/" docker-compose.yaml
	sed -i 's/^    # network_mode: "service:vpn"$$/    network_mode: "service:vpn"/' docker-compose.yaml
	sed -i 's/^    ports: \[/    # ports: [/' docker-compose.yaml
	sed -i 's/DISABLE_VPN=true/DISABLE_VPN=false/' .env

permissions:
	sudo chmod 777 config -R
	sudo chmod 777 downloads -R

jackett.api-key:
	@sed -n 's/.*APIKey": *"\(.*\)".*/\1/p' config/jackett/Jackett/ServerConfig.json

%.api-key:
	@sed -n 's/<ApiKey>\(.*\)<\/ApiKey>/\1/p' config/$*/config.xml
