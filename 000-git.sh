function git_push(){

    # Get commit message from first argument
    message="$1"

    # Check if commit message is provided
    if [ -z "$message" ]; then
        echo "Git commit message is empty"
        exit 1
    else

        git add . | add_log
        git commit -m "$message" | add_log
        git pull | add_log
        git push | add_log
    fi
}

function git_remote(){

    git remote -v | add_log
}


function git_status(){

    git status | add_log
}

function git_pull(){

    git pull | add_log
}

function git_diff(){

    git diff | add_log
}

function git_log(){

    git log | add_log
}

function git_log_oneline(){

    git log --oneline | add_log
}


    
