#!/bin/sh
# This is a workaround because of a bug in version 0.43

export LIBGL_KOPPER_DISABLE=true

if [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then
	exec "$HOME/.local/kitty.app/bin/kitty" "$@"
fi

exec /usr/bin/kitty "$@"