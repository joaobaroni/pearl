enum UsState {
  al('AL', 'Alabama'),
  ak('AK', 'Alaska'),
  az('AZ', 'Arizona'),
  ar('AR', 'Arkansas'),
  ca('CA', 'California'),
  co('CO', 'Colorado'),
  ct('CT', 'Connecticut'),
  de('DE', 'Delaware'),
  fl('FL', 'Florida'),
  ga('GA', 'Georgia'),
  hi('HI', 'Hawaii'),
  id('ID', 'Idaho'),
  il('IL', 'Illinois'),
  in_('IN', 'Indiana'),
  ia('IA', 'Iowa'),
  ks('KS', 'Kansas'),
  ky('KY', 'Kentucky'),
  la('LA', 'Louisiana'),
  me('ME', 'Maine'),
  md('MD', 'Maryland'),
  ma('MA', 'Massachusetts'),
  mi('MI', 'Michigan'),
  mn('MN', 'Minnesota'),
  ms('MS', 'Mississippi'),
  mo('MO', 'Missouri'),
  mt('MT', 'Montana'),
  ne('NE', 'Nebraska'),
  nv('NV', 'Nevada'),
  nh('NH', 'New Hampshire'),
  nj('NJ', 'New Jersey'),
  nm('NM', 'New Mexico'),
  ny('NY', 'New York'),
  nc('NC', 'North Carolina'),
  nd('ND', 'North Dakota'),
  oh('OH', 'Ohio'),
  ok('OK', 'Oklahoma'),
  or_('OR', 'Oregon'),
  pa('PA', 'Pennsylvania'),
  ri('RI', 'Rhode Island'),
  sc('SC', 'South Carolina'),
  sd('SD', 'South Dakota'),
  tn('TN', 'Tennessee'),
  tx('TX', 'Texas'),
  ut('UT', 'Utah'),
  vt('VT', 'Vermont'),
  va('VA', 'Virginia'),
  wa('WA', 'Washington'),
  wv('WV', 'West Virginia'),
  wi('WI', 'Wisconsin'),
  wy('WY', 'Wyoming');

  final String abbreviation;
  final String label;

  const UsState(this.abbreviation, this.label);

  static UsState fromAbbreviation(String abbreviation) {
    return UsState.values.firstWhere(
      (s) => s.abbreviation == abbreviation,
      orElse: () => UsState.ca,
    );
  }
}
