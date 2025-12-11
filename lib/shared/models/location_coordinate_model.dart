/// DTO for geocoding results
class LocationCoordinateData {
  /// Jakim zone
  String zone;
  String? negeri;
  String? lokasi;
  LocationCoordinateData(
      {required this.zone, required this.negeri, required this.lokasi});

  @override
  String toString() {
    return 'LocationCoordinateData{zone: $zone, negeri: $negeri, lokasi: $lokasi}';
  }
}
