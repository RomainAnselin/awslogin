# AWS script for managing tokens in shell

## Usage
Create an alias in rc or profile based on your shell preference
```
usage() {
  if [ $# -ne 0 ]; then
    echo "Usage: $0 [-l] [-s] [-h]"
    echo "  -l   cleanup and logon"
    echo "  -s   set vars"
    echo "  -h   show this help"
    exit 1
  fi
}
```

## Example
Logon script call (runs once a day based on token validity)
`alias ctaws='~/dev/awslogin/aws.sh -l'`

Enable Python Virtual Env and set AWS environment variables.
This will also display the expiry date/time of the token
`alias myct='. ~/tools/ctool-py39/bin/activate; . ~/dev/awslogin/aws.sh -s'`

