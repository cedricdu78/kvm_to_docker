## VM to Docker

### Command
docker run --rm -ti --name vm01 --hostname vm01  --network mymacvlan --ip 192.168.1.200 --privileged noble-qcow2:test1 bash -c '/sbin/init text'

#### Not work
docker run --rm -ti --name vm01 --hostname vm01  --network mymacvlan --ip 192.168.1.200 --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup/vm01.scope:/sys/fs/cgroup:rw  jammy-qcow2:test2 bash -c '/sbin/init text'

### patchs
#### all
chroot xxxx passwd root
chroot xxxx ssh-keygen -A
find -L */etc/ssh/sshd_config.d -delete
sed -Ei 's/^(#|)PermitRootLogin .*/PermitRootLogin yes/g' */etc/ssh/sshd_config
sed -Ei 's/^(#|)PasswordAuthentication .*/PasswordAuthentication yes/g' */etc/ssh/sshd_config

find -L */etc */lib -name 'cloud-init*\.service' -delete
find -L */etc */lib -name 'cloud-init*\.socket' -delete

rm -rf */lib/cloud-init
find -L */etc */lib -xtype l -name '*cloud*' -delete
find -L */etc */lib -name 'cloud-init*' -delete

find -L */etc */lib -name 'snapd\.*service' -delete
find -L */etc */lib -name 'snap\.*service' -delete
find -L */etc */lib -name 'snapd\.*socket' -delete
find -L */etc */lib -name 'snap\.*socket' -delete

#### noble
find -L */etc */lib -name 'systemd-networkd-wait-online.service' -delete

#### focal bionic
rm bionic/lib/modules-load.d/open-iscsi.conf
rm focal/lib/modules-load.d/fwupd-msr.conf

#### focal
find -L focal/etc focal/lib -name 'multipath*.service' -delete
find -L focal/etc focal/lib -name 'multipath*.socket'  -delete

### A voir
- Attribution des Mac & des ip et affectation des conteneurs sur les « hyp » -> opennebula / plugin
- Visualisation de la mémoire côté container -> sudo cat /sys/fs/cgroup/memory.max
- Visualisation de l'espace disk -> quota xfs
