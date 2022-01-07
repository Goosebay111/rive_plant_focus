String intToTimeLeft(int value) {
  int h, m, s;

  h = value ~/ 3600;
  m = (value - h * 3600) ~/ 60;
  s = value - (h * 3600) - (m * 60);

  String hh = h.toString().length < 2 ? '0' + h.toString() : h.toString();
  String mm = m.toString().length < 2 ? '0' + m.toString() : m.toString();
  String ss = s.toString().length < 2 ? '0' + s.toString() : s.toString();

  String result = '$hh:$mm:$ss';
  return result;
}
