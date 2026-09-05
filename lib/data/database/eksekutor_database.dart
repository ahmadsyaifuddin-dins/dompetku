export 'eksekutor_database_unsupported.dart'
    if (dart.library.ffi) 'eksekutor_database_native.dart'
    if (dart.library.js_interop) 'eksekutor_database_web.dart';