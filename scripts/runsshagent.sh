
rm -f /tmp/agentsocket
ssh-agent -a /tmp/agentsocket > ~/sshagent.sh
. ~/sshagent.sh
ssh-add

