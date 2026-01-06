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

your /var/repos/r-shellfun/_.sh file will import all the scripts. 
So your startup script like ~/.zshrc or ~/.bashrc should have the following lines:

# Set log file path to environment variables
export sf_logs_folder=/var/repos/r-shellfun/ignored_d # Used
export K8S="kubectl". # Used
export HELM_EXEC="helm" # Used 

# For the future
export KUSTOMIZE_EXEC="kustomize" # Not needed yet
export DOTNET_EXEC="dotnet" # Not needed yet
export PYTHON_EXEC="python" # Not needed yet
export BUN_EXEC="bun" # Not needed yet
export NODE_EXEC="node" # Not needed yet

# Finally source the shellfun; This should come as the last line of this setup. 

source /var/repos/r-shellfun/_.sh


```

