/// Barrel file OCR -> parser -> draft.
///
/// Semua import lama ke `draft_transaksi_ocr.dart` tetap berfungsi.
/// Implementasi dipecah ke folder `ocr/`.
library;

export 'ocr/contoh_ocr.dart';
export 'ocr/draft_transaksi_ocr_model.dart';
export 'ocr/ekstrak_draft_ocr.dart';
export 'ocr/parser_nominal_ocr.dart' show parseNominalOCR;
