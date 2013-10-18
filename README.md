# Forge

Where the hammer hits the metal.

# To run this

- SSH into the box and run `trampoline.sh` on the host to get Babushka in place
- Logout so that locale changes kick in
- SSH into the box again and run `sudo babushka forge:stage1`
- Logout of the box
- SHH into the box as 'ray' and run `babushka forge:bootstrap`
