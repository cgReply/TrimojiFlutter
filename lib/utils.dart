import 'package:collection/collection.dart';
import 'package:html_unescape/html_unescape.dart';

List<T> getList<T>(int n, List<T> ts) {
  // Do some initial work or error checking, then...
  return ts.sample(n);
}

String decodeHtml(String input) {
  final unescape = HtmlUnescape();
  return unescape.convert(input);
}
