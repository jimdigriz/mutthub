set from=A9G_EMAIL
set use_envelope_from
set envelope_from_address=A9G_EMAIL_ENVELOPE

alternates ^A9G_EMAIL_ENVELOPE$ 'alex(\+[^@]+)@(.*\.)?a9g\.com$'
