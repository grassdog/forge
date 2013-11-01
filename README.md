# Forge

Where the hammer hits the metal.

- SSH into the box and run `source <(curl -s https://raw.github.com/grassdog/forge/master/bootstrap.sh)` to get Babushka in place
- Logout so that locale changes kick in
- SSH into the box again and run `stage2.sh`
- Logout of the box
- SHH into the box as 'deploy' and run `stage3.sh`

