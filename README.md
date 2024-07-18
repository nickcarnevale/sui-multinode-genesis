# sui-multinode-genesis
Special thanks to Stefan @ Mysten Labs for help making this tutorial to run a private multinode sui configuration.


## Create a fleet.yaml File
- Create a file in your working directory titles "fleet.yaml"
- Paste the following text into the fleet.yaml file: 
```
---
validator_config_info:
  - stake: 20000000000000000
    gas_price: 1000
    commission_rate: 0
    network_address: /dns/name_of_your_host/tcp/port_number/http
    narwhal_primary_address: /dns/name_of_your_host/udp/port_number
    narwhal_worker_address: /dns/name_of_your_host/udp/port_number
    p2p_address: /dns/name_of_your_host/udp/port_number
    consensus_address: /ip4/127.0.0.1/tcp/8083/http
parameters:
  allow_insertion_of_extra_objects: false
  epoch_duration_ms: 3600000
accounts:
  - address: "0x47d15f0f01986bc586982509a456131f8aa025fc282e3e3262d67520e92a0d41"
    gas_amounts:
      - 20000000000000000
      - 20000000000000000
      - 20000000000000000
      - 20000000000000000
      - 20000000000000000

```
## Configure your fleet.yaml File
- Update the *network_address*, *narwhal_primary_address*, *narwhal_worker_address*, and *p2p_address* sections (example fleet.yaml file provided)
- *OPTIONAL*: Add more validators, change gas amounts, change epoch duration, etc. 
- Generate a keyfile using ```sui keytool generate ed25519``` and paste the address (will be the name of the file, such as **0x123**.key) under the address section
- Using the generated mnemonic phrase, import the key using the following command: ```sui keytool import "paste the mnemonic phrase here" ed25519``` with the optional --alias flag to give your key an alias

## Make a Config Folder and Initialize Genesis
- Wherever you'd like it, create a folder using ```mkdir cfg```
- Call the genesis command using the fleet.yaml file and set cfg/ to the working directory using ```sui genesis --from-config fleet.yaml --working-dir cfg```
- You should now have all of the necessary files to run your Sui network within the cfg/ directory

## Running a Full Node
- To start a full node from the configuration file, run ```sui-node --config-path fullnode.yaml```
- It is also possible to use ```sui start``` to run the network: ```sui start --network.config cfg --with-faucet```