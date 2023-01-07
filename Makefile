SERVICES := jellyfin qbittorrent radarr jellyseerr jackett sonarr flaresolverr vpn

.PHONY: up down

up: docker-compose.yaml .env
	docker-compose up -d --remove-orphans $(SERVICES)

.ONESHELL:
.env: .env.example
	cp .env.example .env
	sed -i "s/PUID=/PUID=$$(id -u)/" .env
	sed -i "s/PGID=/PGID=$$(id -g)/" .env
	for svc in $(SERVICES); do
		[ -f "$$svc.env" ] || touch "$$svc.env"
	done
