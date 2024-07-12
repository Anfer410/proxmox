#!/bin/python3
import os
import glob
from datetime import datetime
import json

location = os.path.dirname(os.path.realpath(__file__))
inventory_dir = "inventory/"


def check_inventory_store():
    if not os.path.isdir(inventory_dir):
        print(f"Creating {inventory_dir}")
        os.makedirs(inventory_dir)


def populate_inventory():
    for filename in glob.glob(os.path.join(os.getcwd(), "inventory-raw", '*.json')):
        with open(filename, 'r') as f:
            file = f.read()
            decoded_file = json.loads(file)

            try:
                cluster_prefix = f"{filename.split('/')[-1].split('.')[0].split('-')[0]}-"
            except Exception:
                cluster_prefix = ""

            with open(f"{inventory_dir}{cluster_prefix}inventory.ini", "w") as f:
                f.write(f"; Created an managed by script, last update {datetime.now()}\n")

            with open(f"{inventory_dir}{cluster_prefix}inventory.ini", "a") as i:
                # Controller
                i.write("[controller]\n")
                i.write(f"{decoded_file['controller']}")
                i.write("\n")
                # Agent
                i.write("[agent]\n")
                for agent in json.loads(decoded_file["agent"]):
                    i.write(f"{agent}\n")

                # Group
                i.write("[k3s:children]\n")
                i.write("controller\n")
                i.write("agent\n")

                # Vars
                i.write("[k3s:vars]\n")
                i.write(f"ansible_ssh_private_key_file={location}/../keys/{decoded_file['ssh']}\n")
                i.write("ansible_user=root")

    print("Sucess!")


def main():
    check_inventory_store()
    populate_inventory()


if __name__ == "__main__":
    main()
