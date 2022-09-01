#
# On a farmer, restarts the fullnode for out-of-date blockchain forks twice daily in 
# an attempt to keep their memory usage under control.  Many of these forks are running
# Chia code from 2021, so are missing a many, many optimizations in more recent versions.
#
 

import datetime as dt
import math
import os
import subprocess

from api import app
from common.config import globals
from api.commands import chia_cli

def execute():
    blockchain = globals.enabled_blockchains()[0]
    if not globals.legacy_blockchain(blockchain):
        return # Don't restart Chia and recently-updated blockchains. 
    with app.app_context():
        try:
            app.logger.info("***************** RESTARTING LEGACY BLOCKCHAIN FARMER!!! ******************")
            chia_cli.start_farmer(blockchain)
        except Exception as ex:
            app.logger.info("Skipping legacy blockchain farmer check due to exception: {0}".format(str(ex)))