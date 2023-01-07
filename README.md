# Torrent media library docker-compose file

## Disclaimer

I am not responsible for any malicious or illegal use of this configuration, use it at your own risk.

## Services

This docker-compose can be used to spin up :

- A VPN (using [gluetun](https://github.com/qdm12/gluetun))
- Jackett for torrent indexing
- Sonarr and Radarr for automatic management and download
- Jellyfin to manage the media library
- qBittorrent for torrent downloading
- Jellyseer for easier usage

## Setup

1. Run `make .env` to create the environment files.
2. If you want to use a VPN, you need to set some variables in `vpn.env`, you can see [gluetun's wiki](https://github.com/qdm12/gluetun/wiki/) for reference. For ProtonVPN, for instance :

```bash
VPN_SERVICE_PROVIDER=protonvpn
OPENVPN_USER=<user> # from https://account.proton.me/u/0/vpn/OpenVpnIKEv2>
OPENVPN_PASSWORD=<password>
SERVER_COUNTRIES=Netherland
```

3. Run `make up` (or `docker-compose up`) to spin up the services.
4. The services can then be managed using `docker-compose` normally.

## Usage without a VPN

I would recommend using a VPN to avoid issues, such as with your ISP. However, it is possible to use this without a VPN.

To disable it, simply run `make vpn.disable` then `make up` to start the services again (they will be automatically stopped beforehand). You can then enable it again using `make vpn.enable`.

## Adding services
TODO
