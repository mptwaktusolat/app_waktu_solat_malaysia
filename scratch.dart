//ignore_for_file: avoid_print, unused_import, unused_local_variable, no_leading_underscores_for_local_identifiers

void main() {
  var numbers = [
    1686597900000,
    1686684300000,
    1686770700000,
    1686857100000,
    1686943560000,
    1687029960000,
    1687116360000,
    1687202760000,
    1687289220000,
  ];

  var result =
      numbers.map((e) => e.toString().replaceAll(RegExp(r'0+$'), "")).toList();
  print(result);

  var closeToEnd = result.map((e) => ((2 ^ 32) - 1) - int.parse(e)).toList();
  print(closeToEnd);
}
