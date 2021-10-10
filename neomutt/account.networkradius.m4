set from=NETWORKRADIUS_EMAIL
set use_envelope_from
set envelope_from_address=NETWORKRADIUS_EMAIL_ENVELOPE

alternates ^NETWORKRADIUS_EMAIL_ENVELOPE$ 'aclouter(\+[^@]+)@networkradius\.com$'
