alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CFltrha'

alias s="source ~/.bashrc"
alias se="vi ~/.bashrc"

alias u="sudo apt update && sudo apt upgrade"
alias sysupdate="sudo tail -f /var/log/system-auto-update.log & sudo systemctl start system-update.boot.service"

alias shut="sudo /usr/sbin/shutdown -h now"

alias ssd.cmd="iostat -xmd 1"

alias process-bw="sudo iftop -i wlxe4fac4521b92"
alias wifi.bw="bmon -p wlxe4fac4521b92"
alias gpu.bw="nvidia-smi dmon -s t"
alias gpu.driver-persist.mask="sudo systemctl mask nvidia-persistenced"
alias gpu.driver-persist.unmask="sudo systemctl unmask nvidia-persistenced"

alias mig.placement="sudo nvidia-smi mig -lgipp"
alias mig.profiles="sudo nvidia-smi mig -lgip"
alias mig.destroy="sudo nvidia-smi mig -dci && sudo nvidia-smi mig -dgi"
alias mig.list="sudo nvidia-smi mig -lci && sudo nvidia-smi mig -lgi"
alias mig.uuid="nvidia-smi -L | grep 'MIG-'"
alias mig.4="sudo nvidia-smi mig -cgi 14,14,14,14 -C -i 1"
alias mig.2="sudo nvidia-smi mig -cgi 5,5 -C -i 1"
alias mig.start="sudo systemctl start mig-autostart.service"
alias mig.autostart="sudo systemctl enable mig-autostart.service"
alias mig.disableAutoStart="sudo systemctl disable mig-autostart.service"

alias power="sudo $SYSTEM_TOOLS_PATH/gpu-power-limiter/simple-gpu-power-limit.sh"

alias space="du -h . 2>/dev/null | grep '[0-9\.]\+G'"

alias download='wget -c -t 0'
alias rd='f() { wget -c -t 0 "$1"; }; f'
