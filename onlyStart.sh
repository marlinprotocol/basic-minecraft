nitro-cli run-enclave --cpu-count 2 --memory 6500 --eif-path nitro-enclave.eif --enclave-cid 88 --debug-mode
nitro-cli console --enclave-id $(nitro-cli describe-enclaves | jq -r ".[0].EnclaveID")
