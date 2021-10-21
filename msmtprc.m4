defaults
logfile ~/.msmtp.log
auth on
tls on
tls_starttls off
timeout 30

account digriz
from DIGRIZ_EMAIL_ENVELOPE
host DIGRIZ_SERVER_SMTP
user DIGRIZ_SERVER_SMTP_USERNAME
password DIGRIZ_SERVER_SMTP_PASSWORD

account coremem
from COREMEM_EMAIL_ENVELOPE
host COREMEM_SERVER_SMTP
user COREMEM_SERVER_SMTP_USERNAME
password COREMEM_SERVER_SMTP_PASSWORD

account soas
from SOAS_EMAIL_ENVELOPE
host SOAS_SERVER_SMTP
user SOAS_SERVER_SMTP_USERNAME
password SOAS_SERVER_SMTP_PASSWORD

account a9g
from A9G_EMAIL_ENVELOPE
host A9G_SERVER_SMTP
user A9G_SERVER_SMTP_USERNAME
password A9G_SERVER_SMTP_PASSWORD

account networkradius
from NETWORKRADIUS_EMAIL_ENVELOPE
host NETWORKRADIUS_SERVER_SMTP
tls_starttls on
user NETWORKRADIUS_SERVER_SMTP_USERNAME
password NETWORKRADIUS_SERVER_SMTP_PASSWORD
