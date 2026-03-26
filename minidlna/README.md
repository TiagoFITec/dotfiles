# MiniDLNA

Saved MiniDLNA setup for restoring the server on Debian with GNU Stow.

## What is stored here

- `etc/minidlna.conf`: MiniDLNA configuration
- `etc/systemd/system/minidlna.service`: custom systemd unit
- `usr/lib/sysusers.d/minidlna.conf`: declarative `minidlna` user/group creation
- `setup-debian.sh`: restore helper for Debian

## Why the user setup matters

The service runs as the dedicated `minidlna` user. The painful part was giving that user enough access to read `/home/tiago/Videos` without making the whole home directory broadly readable.

This setup keeps it reproducible by:

1. declaring the `minidlna` user with `sysusers.d`
2. restoring the service and config with `stow`
3. re-applying the ACLs needed for `/home/tiago` and `/home/tiago/Videos`

## Restore on Debian

From the dotfiles repository root:

1. run `chmod +x minidlna/setup-debian.sh`
2. run `./minidlna/setup-debian.sh`

The script will:

- install `minidlna`, `acl`, `stow`, and `systemd`
- stow this package into `/`
- create the `minidlna` user and group
- restore ACLs so the service can read the video library
- enable and start `minidlna.service`

## Things to review after reinstalling

- `network_interface=enp3s0` in `etc/minidlna.conf`
- `media_dir=V,/home/tiago/Videos` in `etc/minidlna.conf`
- `friendly_name=Giuseppe DLNA Server` in `etc/minidlna.conf`

If Debian gives your NIC a different name, update `network_interface` before running the service.