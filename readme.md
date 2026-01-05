# Clone repository

For example We cloned the repository in /Users/rcarrion/data/r-shellfun

by this command:

git clone https://github.com/dorymall/shellfun.git r-shellfun

# symlink of ../shellfun (Parent of shellfun)

Wherever your parent directory of shellfun is 

create symlink /var/repos

```bash

# Create symlink if not exists

# Example for an m3-mac

if [ ! -d "/var/repos" ]; then
    sudo ln -s /Users/rcarrion/data /var/repos
fi

```

your /var/repos/r-shellfun/_.sh file now imports all the scripts. 
So your startup script like ~/.zshrc or ~/.bashrc should have the following line:

```bash
source /var/repos/r-shellfun/_.sh
```

