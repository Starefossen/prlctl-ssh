prlctl-ssh
==========

Parallels Desktop command line utility for open a new SSH connection to a given virtual machine.

If the virtual machine is stopped or suspended the utility will attempt to respawn it before it attemts to SSH into the machine. 

## Preconditions

1. `Paralells tools` has to be installed, this is becuase the utility uses the `prlctl exec` command to find the machine's IP address.
2. The virtual machine must be running SSH server with a working ssh key set up for the `user`.

Tested with Ubuntu Server 10.04 LTS and 12.04 LTS.

## Usage

	$ ./prlctl-ssh <user>@<vm_id|vm_name>
	
### Make a shortcut cmd

Make a shortcut to your favorite virtual machine by adding an alias to you `.bash_profile`

	$ alias mymachine=./prlctl-ssh user@mymachine