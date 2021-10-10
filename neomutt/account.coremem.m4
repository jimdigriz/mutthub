set from=COREMEM_EMAIL
set use_envelope_from
set envelope_from_address=COREMEM_EMAIL_ENVELOPE

alternates ^COREMEM_EMAIL_ENVELOPE$ '@(.*\.)?coremem\.com$'
