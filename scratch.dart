void main() {
  var millis = 1640356232000; //bulan 12

  print(isTheSameMonth(millis));
}

bool isTheSameMonth(int savedMillis) {
  var savedMonth = DateTime.fromMillisecondsSinceEpoch(savedMillis).month;

  var currentMonth = DateTime.now().month;
  return savedMonth == currentMonth;
}
