# 🚀 docker-nsenter

The docker-nsenter script allows you to enter various namespaces of a Docker container, simplifying nsenter commands and making it easy to target running containers.

## 📥 Installation

1. Save the docker-nsenter.sh script in a directory within your $PATH. Note: Rename the script to docker-nsenter (without the .sh extension) for optimal compatibility with the ZSH completion script.

```bash
mv docker-nsenter.sh /usr/local/bin/docker-nsenter
chmod +x /usr/local/bin/docker-nsenter
```

2. If you want to use ZSH autocompletion, install the _docker-nsenter.zsh file:

- Move the file to your ZSH completion folder:

```bash
mkdir -p ~/.zsh/completions
mv _docker-nsenter.zsh ~/.zsh/completions/_docker-nsenter
```

- Add the completion folder to your fpath if it’s not already set, and reload your ZSH configuration:

```bash
echo 'fpath+=(~/.zsh/completions)' >> ~/.zshrc
source ~/.zshrc
```

3. Autocompletion is now enabled! You can start using docker-nsenter with autocompletion by pressing [TAB] after the command name to see available options and running containers.

## 🛠 Usage

docker-nsenter Command

The docker-nsenter command provides options to enter specific namespaces (network, pid, etc.) of a Docker container using nsenter.

### 🖥️ Example usage

```bash
docker-nsenter --net <container name or ID>
```

Other example commands:

- To enter the PID namespace:

```bash
docker-nsenter --pid <container name or ID>
```

- To enter multiple namespaces, e.g., network and mount:

```bash
docker-nsenter --net --mount <container name or ID>
```

## ZSH Completion 🎉

The ZSH completion script provides:

- nsenter options with both short and long versions, making typing easier.
- A dynamic list of running Docker container names for quick selection.

> ⚠️ Note on Command Naming
>
> For optimal ZSH completion functionality, the command should be installed without an extension (docker-nsenter). If you choose to keep the .sh extension, you’ll need to modify the completion script accordingly.

## 📜 License

This project is licensed under the MIT License.

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## 🙏 Credits

Created with pride by ZSH [Expert GPT](https://chatgpt.com/g/g-XczdbjXSW-zsh-expert) and GPT-4o, supervised by  [obeone](https://github.com/obeone)
