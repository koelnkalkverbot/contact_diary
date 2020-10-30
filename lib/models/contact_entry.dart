class ContactEntry {
  static const LOCATION_INSIDE = 'Drinnen';
  static const LOCATION_OUTSIDE = 'Draußen';

  final String id;
  String description;
  DateTime startDate;
  DateTime endDate;
  bool maskWorn;
  bool distanceKept;
  int amountOfPeople;
  String location;

  ContactEntry({
    this.id,
    this.description,
    this.startDate,
    this.endDate,
    this.maskWorn,
    this.distanceKept,
    this.amountOfPeople,
    this.location,
  });
}
