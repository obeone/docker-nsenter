#compdef docker-nsenter

# ------------------------------------------------------------------------------
# ZSH Completion Script for `docker-nsenter`
# Created with pride by ZSH Expert GPT (https://chatgpt.com/g/g-XczdbjXSW-zsh-expert)
# 
# This script enhances the `docker-nsenter` command by providing intelligent 
# autocompletion for `nsenter` options and dynamically suggesting Docker container 
# names. Simplifying your workflow, one tab at a time!
#
# Usage:
# - Tab through `nsenter` options, both short and long versions.
# - Dynamically list running Docker containers for quick selection.
#
# Installation:
# 1. Save this script to `~/.zsh/completions/_docker-nsenter`.
# 2. Ensure `~/.zsh/completions` is in your `fpath`:
#      ```zsh
#      mkdir -p ~/.zsh/completions
#      echo 'fpath+=(~/.zsh/completions)' >> ~/.zshrc
#      ```
# 3. Reload your ZSH configuration:
#      ```zsh
#      source ~/.zshrc
#      ```
# 4. Start typing `docker-nsenter` and use [TAB] to see completions!
#
# MIT License
# 
# Copyright (c) 2024 ZSH Expert GPT
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------

_docker_nsenter() {
    local -a options
    local -a containers
    local ret=1

    # Define nsenter options with long versions
    options=(
        '-a[enter all namespaces]' '--all[enter all namespaces]'
        '-t+[target process to get namespaces from]:pid' '--target+[target process to get namespaces from]:pid'
        '-m[enter mount namespace]' '--mount[enter mount namespace]:file:_files'
        '-u[enter UTS namespace]' '--uts[enter UTS namespace]:file:_files'
        '-i[enter System V IPC namespace]' '--ipc[enter System V IPC namespace]:file:_files'
        '-n[enter network namespace]' '--net[enter network namespace]:file:_files'
        '-p[enter pid namespace]' '--pid[enter pid namespace]:file:_files'
        '-C[enter cgroup namespace]' '--cgroup[enter cgroup namespace]:file:_files'
        '-U[enter user namespace]' '--user[enter user namespace]:file:_files'
        '-T[enter time namespace]' '--time[enter time namespace]:file:_files'
        '-S[set uid in entered namespace]:uid' '--setuid[set uid in entered namespace]:uid'
        '-G[set gid in entered namespace]:gid' '--setgid[set gid in entered namespace]:gid'
        '--preserve-credentials[do not touch uids or gids]'
        '-r[set the root directory]:dir:_directories' '--root[set the root directory]:dir:_directories'
        '-w[set the working directory]:dir:_directories' '--wd[set the working directory]:dir:_directories'
        '-F[do not fork before exec]' '--no-fork[do not fork before exec]'
        '-Z[set SELinux context according to --target PID]' '--follow-context[set SELinux context according to --target PID]'
        '-h[display help]' '--help[display help]'
        '-V[display version]' '--version[display version]'
    )

    # Fetch list of running container names or IDs
    containers=(${(f)"$(docker ps --format '{{.Names}}')"})
    
    # Add completions for container names
    _arguments -s -S : \
        "${options[@]}" \
        ':container name or ID:(${containers[@]})' \
        && ret=0

    return ret
}

compdef _docker_nsenter docker-nsenter