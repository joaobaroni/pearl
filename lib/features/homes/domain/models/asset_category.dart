enum AssetCategory {
  hvac('HVAC'),
  solar('Solar'),
  appliances('Appliance'),
  electrical('Electrical'),
  plumbing('Plumbing');

  final String label;
  const AssetCategory(this.label);
}
