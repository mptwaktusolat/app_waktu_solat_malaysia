class LocationCoordinateData {
  /// Jakim zone
  String zone;
  String? negeri;
  String? lokasi;
  double? lat;
  double? lng;
  LocationCoordinateData(
      {required this.zone,
      required this.negeri,
      required this.lokasi,
      required this.lat,
      required this.lng});

  @override
  String toString() {
    return 'LocationCoordinateData{zone: $zone, negeri: $negeri, lokasi: $lokasi, lat: $lat, lng: $lng}';
  }
}
