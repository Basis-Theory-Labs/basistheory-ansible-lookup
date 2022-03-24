# Basis Theory Ansible Lookup Plugin
Lightweight lookup plugin to retrieve secrets from [Basis Theory's REST API](https://docs.basistheory.com/#getting-started)

## Requirements
1. Basis Theory Account
1. Localhost SSH Configured with key based authentication.
2. Python3

### TL;DR
The following is how to run the quickstart example.

```bash
make setup
make prep
make run
# Cleanup
make clean
```

## Lab How-To
1. Set up a [Basis Theory Account](https://portal.basistheory.com/register)
2. Set up a [server to server application](https://docs.basistheory.com/#applications-application-types) with token [create and read permissions](https://docs.basistheory.com/#permissions-permission-types).
    - You can follown the Python Quickstart [here](https://developers.basistheory.com/getting-started/quickstart-with-python/) to set up your first application and python environment
3. Export the resulting API Key to your local shell `export BT_API_KEY=${API_KEY}`
4. Clone `git@github.com:Basis-Theory-Labs/basistheory-ansible-lookup.git` and switch to it as your working directory.
5. The general process for many secrets is an engineer signs up for a service and gets back an API Key or Secrets Pair that is used to interact with the service. Another common one is storage and distribution of flat files. These still need to be imported into a location for use from an external source, with this as the starting point we will import those into Basis Theory.
    ```bash
    # Upload API Key String
    curl -X POST \
    -H "BT-API-KEY: ${BT_API_KEY}" \
    -H 'Content-Type: application/json' \
    --data ”{\"data\": \"fake_key_69c788ace229d4d74f84bee6\", \"type\": \"token\"}” \
    https://api.basistheory.com/tokens

    # Upload File as Base64 Encoded
    curl -X POST \
    -H "BT-API-KEY: ${BT_API_KEY}" \
    -H 'Content-Type: application/json' \
    --data “{\"data\": \"$(cat my.properties | base64)\", \"type\": \"token\"}” \
    https://api.basistheory.com/tokens 
    ```
6. Now that we have our values in Basis Theory we need to give ansible the referential IDs so it can perform the lookup. Update the `vars.yml` and set `my_api_key` to the ID of the string token, and set the ID of the base64 encoded file to `my_properties_file`.
7. Run `make setup && source venv/bin/activate` to ensure your local environment is ready to execute ansible.
8. Execute the ansible playbook `ansible-playbook -i inventory lookup_test.yml`
    - For a simple test we are wrting two files to `/tmp`
    - Refer to the [lookup_test.yml](https://github.com/Basis-Theory-Labs/basistheory-ansible-lookup/blob/main/lookup_test.yml) for the ansible playbook code.
9. Executing the ansible playbook will copy the lookup_test.j2 to `/tmp/lookup_test.cfg` with the variable interpolated and it will also write `/tmp/my.properties` which is the file we base64 encoded and uploaded in step 5 out as a plain text properties file.
10. Verfiy the contents against what you uploaded in step 5.