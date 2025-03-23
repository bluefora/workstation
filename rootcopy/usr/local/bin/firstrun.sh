#!/bin/bash

if [ ! -f $HOME/.local/.firstrun ]; then
	/usr/bin/yafti
	touch $HOME/.local/.firstrun
fi

