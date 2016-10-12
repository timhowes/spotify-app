all: repo com.spotify.Client.json
	rm -rf spotify
	flatpak-builder --repo=repo spotify com.spotify.Client.json

repo:
	ostree init --mode=archive-z2 --repo=repo
