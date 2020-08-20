__author__ = "Frenzoid"
__version__ = "1.0.0"
__license__ = "GPL"
# Disclaimer: this script was made to work on Windows systems.

import sys
import subprocess
import time
import runpy
import multiprocessing


class Device:
    def __init__(self, owner, ip):
        super().__init__()
        self.owner = owner
        self.ip = ip
        self.is_connected = False

    def get_connected(self):
        return self.is_connected

    def set_connected(self, updated_status):
        self.is_connected = updated_status

    def get_name(self):
        return self.owner

    def get_ip(self):
        return self.ip

    def print_status(self):
        if self.is_connected:
            print(self.owner + "'s device just CONNECTED!")
        else:
            print(self.owner + "'s device just DISCONNECTED!")

    def check_device_ping(self):
        try:
            response = subprocess.check_output(
                ['ping', '-n', '1', '-w', '3000', self.ip],
                stderr=subprocess.STDOUT,
                universal_newlines=True
            )

            if not ('inaccesible' in response) and self.is_connected is False:
                self.is_connected = True
                self.print_status()

            if 'inaccesible' in response and self.is_connected is True:
                self.is_connected = False
                self.print_status()

        # Sometimes the ping command tends to return a non 0 code when the pinged device doesn't reply.
        except subprocess.CalledProcessError:
            if self.is_connected is True:
                self.set_connected(False)
                self.print_status()


# --- Main ---  #
if __name__ == "__main__":
    # List of devices.
    devices = []
    devices.append(Device("Frenzoid", '192.168.1.76'))
    devices.append(Device("Livia", '192.168.1.82'))

    # Ping response.
    response = ''

    while True:
        time.sleep(2)

        for device in devices:
            device.check_device_ping()
