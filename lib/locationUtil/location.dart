//location class

class Location {
  String jakimCode;
  String negeri;
  String daerah;

  Location({
    required this.jakimCode,
    required this.negeri,
    required this.daerah,
  });

  @override
  String toString() {
    return 'Location{jakimCode: $jakimCode, negeri: $negeri, daerah: $daerah}';
  }
}
