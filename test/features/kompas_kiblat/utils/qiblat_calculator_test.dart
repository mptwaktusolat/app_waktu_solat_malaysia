import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/features/kompas_kiblat/utils/qiblat_calculator.dart';

void main() {
  group('Qiblat Calculator', () {
    test('Check calculation', () {
      // Value taken from https://oarep.usim.edu.my/jspui/bitstream/123456789/19549/1/Mathematical%20Application%20In%20Determining%20Qibla%20Direction%20Of%20Tamhidi%20Centre%20Universiti%20Sains%20Islam%20Malaysia%20%28USIM%29%20By%20Using%20Spherical%20Trigonometry.pdf
      const usimLocation = (2.98946944, 101.78385000);

      final res =
          QiblatCalculator.angleToQiblat(usimLocation.$1, usimLocation.$2);

      expect(res, closeTo(292.5, .1));
    });
  });
}
