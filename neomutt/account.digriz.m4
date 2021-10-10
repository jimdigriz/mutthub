set from=DIGRIZ_EMAIL
set use_envelope_from
set envelope_from_address=DIGRIZ_EMAIL_ENVELOPE

alternates ^DIGRIZ_EMAIL_ENVELOPE$ '@(.*\.)?digriz\.org\.uk$'
