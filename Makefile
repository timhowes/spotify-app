include Makefile.config

all: test
	rm -rf spotify
	flatpak-builder --repo=repo spotify --gpg-sign=E565802D84594CE336CB1E086A7C5D4482170E3D com.spotify.Client.json
	flatpak build-update-repo --gpg-sign=E565802D84594CE336CB1E086A7C5D4482170E3D repo

test: repo com.spotify.Client.json
	flatpak-builder --force-clean --repo=repo --ccache --require-changes spotify com.spotify.Client.json
	flatpak build-update-repo repo

release: release-repo com.spotify.Client.json
	if [ "x${RELEASE_GPG_KEY}" == "x" ]; then echo Must set RELEASE_GPG_KEY in Makefile.config, try \'make gpg-key\'; exit 1; fi
	flatpak-builder --force-clean --repo=release-repo  --ccache --require-changes --gpg-homedir=gpg --gpg-sign=${RELEASE_GPG_KEY} spotify  com.spotify.Client.json
	flatpak build-update-repo --gpg-homedir=gpg --gpg-sign=${RELEASE_GPG_KEY} release-repo

repo:
	ostree init --mode=archive-z2 --repo=repo

release-repo:
	ostree init --mode=archive-z2 --repo=release-repo

gpg-key:
	if [ "x${KEY_USER}" == "x" ]; then echo Must set KEY_USER in Makefile.config; exit 1; fi
	mkdir -p gpg
	gpg2 --homedir gpg --quick-gen-key ${KEY_USER}
	echo Enter the above gpg key id as RELEASE_GPG_KEY in Makefile.config
