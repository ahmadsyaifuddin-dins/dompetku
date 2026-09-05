import 'package:get/get.dart';

class KontrolInduk extends GetxController {
  final indeks = 0.obs;

  void ubahIndeks(int nilai) => indeks.value = nilai;
}