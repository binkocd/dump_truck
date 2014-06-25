useraccount=testuser
funcarea=xray
cwticket=123456

cat << EO1FF >> "sshd_config"

#$useraccount ($funcarea) $cwticket
    Match User $useraccount
    ChrootDirectory /jail/$useraccount
    ForceCommand internal-sftp
    AllowTcpForwarding no
EO1FF