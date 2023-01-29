// ignore_for_file: avoid_types_as_parameter_names, file_names

class DataUtil {
  String generator(num) {
    if (num >= 0 && num < 10000) {
      return num.toString();
    } else if (num >= 10000 && num < 100000000) {
      return "${(num / 10000).toStringAsFixed(1)}万";
    } else {
      return "${(num / 100000000).toStringAsFixed(1)}亿";
    }
  }
}
