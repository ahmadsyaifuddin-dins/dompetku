import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum JenisSnackbar { sukses, informasi, peringatan, galat }

void tampilkanSnackbarDompetku({
  required JenisSnackbar jenis,
  required String judul,
  required String pesan,
}) {
  final contentType = switch (jenis) {
    JenisSnackbar.sukses => ContentType.success,
    JenisSnackbar.informasi => ContentType.help,
    JenisSnackbar.peringatan => ContentType.warning,
    JenisSnackbar.galat => ContentType.failure,
  };

  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      messageText: AwesomeSnackbarContent(
        title: judul,
        message: pesan,
        contentType: contentType,
      ),
    ),
  );
}