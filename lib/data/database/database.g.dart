// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AkunDanaTable extends AkunDana
    with TableInfo<$AkunDanaTable, AkunDanaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AkunDanaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<JenisAkun, String> jenis =
      GeneratedColumn<String>(
        'jenis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<JenisAkun>($AkunDanaTable.$converterjenis);
  static const VerificationMeta _saldoAwalMeta = const VerificationMeta(
    'saldoAwal',
  );
  @override
  late final GeneratedColumn<int> saldoAwal = GeneratedColumn<int>(
    'saldo_awal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ikonMeta = const VerificationMeta('ikon');
  @override
  late final GeneratedColumn<String> ikon = GeneratedColumn<String>(
    'ikon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
    'aktif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diperbaruiPadaMeta = const VerificationMeta(
    'diperbaruiPada',
  );
  @override
  late final GeneratedColumn<DateTime> diperbaruiPada =
      GeneratedColumn<DateTime>(
        'diperbarui_pada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    jenis,
    saldoAwal,
    ikon,
    aktif,
    dibuatPada,
    diperbaruiPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'akun_dana';
  @override
  VerificationContext validateIntegrity(
    Insertable<AkunDanaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('saldo_awal')) {
      context.handle(
        _saldoAwalMeta,
        saldoAwal.isAcceptableOrUnknown(data['saldo_awal']!, _saldoAwalMeta),
      );
    }
    if (data.containsKey('ikon')) {
      context.handle(
        _ikonMeta,
        ikon.isAcceptableOrUnknown(data['ikon']!, _ikonMeta),
      );
    }
    if (data.containsKey('aktif')) {
      context.handle(
        _aktifMeta,
        aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    } else if (isInserting) {
      context.missing(_dibuatPadaMeta);
    }
    if (data.containsKey('diperbarui_pada')) {
      context.handle(
        _diperbaruiPadaMeta,
        diperbaruiPada.isAcceptableOrUnknown(
          data['diperbarui_pada']!,
          _diperbaruiPadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diperbaruiPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AkunDanaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AkunDanaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      jenis: $AkunDanaTable.$converterjenis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}jenis'],
        )!,
      ),
      saldoAwal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_awal'],
      )!,
      ikon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ikon'],
      ),
      aktif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif'],
      )!,
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
      diperbaruiPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diperbarui_pada'],
      )!,
    );
  }

  @override
  $AkunDanaTable createAlias(String alias) {
    return $AkunDanaTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JenisAkun, String, String> $converterjenis =
      const EnumNameConverter<JenisAkun>(JenisAkun.values);
}

class AkunDanaData extends DataClass implements Insertable<AkunDanaData> {
  final String id;
  final String nama;
  final JenisAkun jenis;
  final int saldoAwal;
  final String? ikon;
  final bool aktif;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;
  const AkunDanaData({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.saldoAwal,
    this.ikon,
    required this.aktif,
    required this.dibuatPada,
    required this.diperbaruiPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    {
      map['jenis'] = Variable<String>(
        $AkunDanaTable.$converterjenis.toSql(jenis),
      );
    }
    map['saldo_awal'] = Variable<int>(saldoAwal);
    if (!nullToAbsent || ikon != null) {
      map['ikon'] = Variable<String>(ikon);
    }
    map['aktif'] = Variable<bool>(aktif);
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada);
    return map;
  }

  AkunDanaCompanion toCompanion(bool nullToAbsent) {
    return AkunDanaCompanion(
      id: Value(id),
      nama: Value(nama),
      jenis: Value(jenis),
      saldoAwal: Value(saldoAwal),
      ikon: ikon == null && nullToAbsent ? const Value.absent() : Value(ikon),
      aktif: Value(aktif),
      dibuatPada: Value(dibuatPada),
      diperbaruiPada: Value(diperbaruiPada),
    );
  }

  factory AkunDanaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AkunDanaData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      jenis: $AkunDanaTable.$converterjenis.fromJson(
        serializer.fromJson<String>(json['jenis']),
      ),
      saldoAwal: serializer.fromJson<int>(json['saldoAwal']),
      ikon: serializer.fromJson<String?>(json['ikon']),
      aktif: serializer.fromJson<bool>(json['aktif']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
      diperbaruiPada: serializer.fromJson<DateTime>(json['diperbaruiPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'jenis': serializer.toJson<String>(
        $AkunDanaTable.$converterjenis.toJson(jenis),
      ),
      'saldoAwal': serializer.toJson<int>(saldoAwal),
      'ikon': serializer.toJson<String?>(ikon),
      'aktif': serializer.toJson<bool>(aktif),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
      'diperbaruiPada': serializer.toJson<DateTime>(diperbaruiPada),
    };
  }

  AkunDanaData copyWith({
    String? id,
    String? nama,
    JenisAkun? jenis,
    int? saldoAwal,
    Value<String?> ikon = const Value.absent(),
    bool? aktif,
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
  }) => AkunDanaData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    jenis: jenis ?? this.jenis,
    saldoAwal: saldoAwal ?? this.saldoAwal,
    ikon: ikon.present ? ikon.value : this.ikon,
    aktif: aktif ?? this.aktif,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
  );
  AkunDanaData copyWithCompanion(AkunDanaCompanion data) {
    return AkunDanaData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      jenis: data.jenis.present ? data.jenis.value : this.jenis,
      saldoAwal: data.saldoAwal.present ? data.saldoAwal.value : this.saldoAwal,
      ikon: data.ikon.present ? data.ikon.value : this.ikon,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
      diperbaruiPada: data.diperbaruiPada.present
          ? data.diperbaruiPada.value
          : this.diperbaruiPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AkunDanaData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('jenis: $jenis, ')
          ..write('saldoAwal: $saldoAwal, ')
          ..write('ikon: $ikon, ')
          ..write('aktif: $aktif, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nama,
    jenis,
    saldoAwal,
    ikon,
    aktif,
    dibuatPada,
    diperbaruiPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AkunDanaData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.jenis == this.jenis &&
          other.saldoAwal == this.saldoAwal &&
          other.ikon == this.ikon &&
          other.aktif == this.aktif &&
          other.dibuatPada == this.dibuatPada &&
          other.diperbaruiPada == this.diperbaruiPada);
}

class AkunDanaCompanion extends UpdateCompanion<AkunDanaData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<JenisAkun> jenis;
  final Value<int> saldoAwal;
  final Value<String?> ikon;
  final Value<bool> aktif;
  final Value<DateTime> dibuatPada;
  final Value<DateTime> diperbaruiPada;
  final Value<int> rowid;
  const AkunDanaCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.jenis = const Value.absent(),
    this.saldoAwal = const Value.absent(),
    this.ikon = const Value.absent(),
    this.aktif = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.diperbaruiPada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AkunDanaCompanion.insert({
    required String id,
    required String nama,
    required JenisAkun jenis,
    this.saldoAwal = const Value.absent(),
    this.ikon = const Value.absent(),
    this.aktif = const Value.absent(),
    required DateTime dibuatPada,
    required DateTime diperbaruiPada,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       jenis = Value(jenis),
       dibuatPada = Value(dibuatPada),
       diperbaruiPada = Value(diperbaruiPada);
  static Insertable<AkunDanaData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? jenis,
    Expression<int>? saldoAwal,
    Expression<String>? ikon,
    Expression<bool>? aktif,
    Expression<DateTime>? dibuatPada,
    Expression<DateTime>? diperbaruiPada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (jenis != null) 'jenis': jenis,
      if (saldoAwal != null) 'saldo_awal': saldoAwal,
      if (ikon != null) 'ikon': ikon,
      if (aktif != null) 'aktif': aktif,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (diperbaruiPada != null) 'diperbarui_pada': diperbaruiPada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AkunDanaCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<JenisAkun>? jenis,
    Value<int>? saldoAwal,
    Value<String?>? ikon,
    Value<bool>? aktif,
    Value<DateTime>? dibuatPada,
    Value<DateTime>? diperbaruiPada,
    Value<int>? rowid,
  }) {
    return AkunDanaCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      saldoAwal: saldoAwal ?? this.saldoAwal,
      ikon: ikon ?? this.ikon,
      aktif: aktif ?? this.aktif,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (jenis.present) {
      map['jenis'] = Variable<String>(
        $AkunDanaTable.$converterjenis.toSql(jenis.value),
      );
    }
    if (saldoAwal.present) {
      map['saldo_awal'] = Variable<int>(saldoAwal.value);
    }
    if (ikon.present) {
      map['ikon'] = Variable<String>(ikon.value);
    }
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (diperbaruiPada.present) {
      map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AkunDanaCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('jenis: $jenis, ')
          ..write('saldoAwal: $saldoAwal, ')
          ..write('ikon: $ikon, ')
          ..write('aktif: $aktif, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KategoriTable extends Kategori
    with TableInfo<$KategoriTable, KategoriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KategoriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<JenisTransaksi, String> jenis =
      GeneratedColumn<String>(
        'jenis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<JenisTransaksi>($KategoriTable.$converterjenis);
  static const VerificationMeta _ikonMeta = const VerificationMeta('ikon');
  @override
  late final GeneratedColumn<String> ikon = GeneratedColumn<String>(
    'ikon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
    'aktif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nama, jenis, ikon, aktif];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kategori';
  @override
  VerificationContext validateIntegrity(
    Insertable<KategoriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('ikon')) {
      context.handle(
        _ikonMeta,
        ikon.isAcceptableOrUnknown(data['ikon']!, _ikonMeta),
      );
    }
    if (data.containsKey('aktif')) {
      context.handle(
        _aktifMeta,
        aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KategoriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KategoriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      jenis: $KategoriTable.$converterjenis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}jenis'],
        )!,
      ),
      ikon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ikon'],
      ),
      aktif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif'],
      )!,
    );
  }

  @override
  $KategoriTable createAlias(String alias) {
    return $KategoriTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JenisTransaksi, String, String> $converterjenis =
      const EnumNameConverter<JenisTransaksi>(JenisTransaksi.values);
}

class KategoriData extends DataClass implements Insertable<KategoriData> {
  final String id;
  final String nama;
  final JenisTransaksi jenis;
  final String? ikon;
  final bool aktif;
  const KategoriData({
    required this.id,
    required this.nama,
    required this.jenis,
    this.ikon,
    required this.aktif,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    {
      map['jenis'] = Variable<String>(
        $KategoriTable.$converterjenis.toSql(jenis),
      );
    }
    if (!nullToAbsent || ikon != null) {
      map['ikon'] = Variable<String>(ikon);
    }
    map['aktif'] = Variable<bool>(aktif);
    return map;
  }

  KategoriCompanion toCompanion(bool nullToAbsent) {
    return KategoriCompanion(
      id: Value(id),
      nama: Value(nama),
      jenis: Value(jenis),
      ikon: ikon == null && nullToAbsent ? const Value.absent() : Value(ikon),
      aktif: Value(aktif),
    );
  }

  factory KategoriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KategoriData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      jenis: $KategoriTable.$converterjenis.fromJson(
        serializer.fromJson<String>(json['jenis']),
      ),
      ikon: serializer.fromJson<String?>(json['ikon']),
      aktif: serializer.fromJson<bool>(json['aktif']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'jenis': serializer.toJson<String>(
        $KategoriTable.$converterjenis.toJson(jenis),
      ),
      'ikon': serializer.toJson<String?>(ikon),
      'aktif': serializer.toJson<bool>(aktif),
    };
  }

  KategoriData copyWith({
    String? id,
    String? nama,
    JenisTransaksi? jenis,
    Value<String?> ikon = const Value.absent(),
    bool? aktif,
  }) => KategoriData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    jenis: jenis ?? this.jenis,
    ikon: ikon.present ? ikon.value : this.ikon,
    aktif: aktif ?? this.aktif,
  );
  KategoriData copyWithCompanion(KategoriCompanion data) {
    return KategoriData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      jenis: data.jenis.present ? data.jenis.value : this.jenis,
      ikon: data.ikon.present ? data.ikon.value : this.ikon,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KategoriData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('jenis: $jenis, ')
          ..write('ikon: $ikon, ')
          ..write('aktif: $aktif')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, jenis, ikon, aktif);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KategoriData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.jenis == this.jenis &&
          other.ikon == this.ikon &&
          other.aktif == this.aktif);
}

class KategoriCompanion extends UpdateCompanion<KategoriData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<JenisTransaksi> jenis;
  final Value<String?> ikon;
  final Value<bool> aktif;
  final Value<int> rowid;
  const KategoriCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.jenis = const Value.absent(),
    this.ikon = const Value.absent(),
    this.aktif = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KategoriCompanion.insert({
    required String id,
    required String nama,
    required JenisTransaksi jenis,
    this.ikon = const Value.absent(),
    this.aktif = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       jenis = Value(jenis);
  static Insertable<KategoriData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? jenis,
    Expression<String>? ikon,
    Expression<bool>? aktif,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (jenis != null) 'jenis': jenis,
      if (ikon != null) 'ikon': ikon,
      if (aktif != null) 'aktif': aktif,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KategoriCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<JenisTransaksi>? jenis,
    Value<String?>? ikon,
    Value<bool>? aktif,
    Value<int>? rowid,
  }) {
    return KategoriCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      ikon: ikon ?? this.ikon,
      aktif: aktif ?? this.aktif,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (jenis.present) {
      map['jenis'] = Variable<String>(
        $KategoriTable.$converterjenis.toSql(jenis.value),
      );
    }
    if (ikon.present) {
      map['ikon'] = Variable<String>(ikon.value);
    }
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KategoriCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('jenis: $jenis, ')
          ..write('ikon: $ikon, ')
          ..write('aktif: $aktif, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransaksiTable extends Transaksi
    with TableInfo<$TransaksiTable, TransaksiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaksiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _akunDanaIdMeta = const VerificationMeta(
    'akunDanaId',
  );
  @override
  late final GeneratedColumn<String> akunDanaId = GeneratedColumn<String>(
    'akun_dana_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriIdMeta = const VerificationMeta(
    'kategoriId',
  );
  @override
  late final GeneratedColumn<String> kategoriId = GeneratedColumn<String>(
    'kategori_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<JenisTransaksi, String> jenis =
      GeneratedColumn<String>(
        'jenis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<JenisTransaksi>($TransaksiTable.$converterjenis);
  static const VerificationMeta _nominalMeta = const VerificationMeta(
    'nominal',
  );
  @override
  late final GeneratedColumn<int> nominal = GeneratedColumn<int>(
    'nominal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diperbaruiPadaMeta = const VerificationMeta(
    'diperbaruiPada',
  );
  @override
  late final GeneratedColumn<DateTime> diperbaruiPada =
      GeneratedColumn<DateTime>(
        'diperbarui_pada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    akunDanaId,
    kategoriId,
    jenis,
    nominal,
    tanggal,
    catatan,
    dibuatPada,
    diperbaruiPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaksi';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransaksiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('akun_dana_id')) {
      context.handle(
        _akunDanaIdMeta,
        akunDanaId.isAcceptableOrUnknown(
          data['akun_dana_id']!,
          _akunDanaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_akunDanaIdMeta);
    }
    if (data.containsKey('kategori_id')) {
      context.handle(
        _kategoriIdMeta,
        kategoriId.isAcceptableOrUnknown(data['kategori_id']!, _kategoriIdMeta),
      );
    }
    if (data.containsKey('nominal')) {
      context.handle(
        _nominalMeta,
        nominal.isAcceptableOrUnknown(data['nominal']!, _nominalMeta),
      );
    } else if (isInserting) {
      context.missing(_nominalMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    } else if (isInserting) {
      context.missing(_dibuatPadaMeta);
    }
    if (data.containsKey('diperbarui_pada')) {
      context.handle(
        _diperbaruiPadaMeta,
        diperbaruiPada.isAcceptableOrUnknown(
          data['diperbarui_pada']!,
          _diperbaruiPadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diperbaruiPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {akunDanaId},
    {kategoriId},
  ];
  @override
  TransaksiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransaksiData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      akunDanaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}akun_dana_id'],
      )!,
      kategoriId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori_id'],
      ),
      jenis: $TransaksiTable.$converterjenis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}jenis'],
        )!,
      ),
      nominal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nominal'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
      diperbaruiPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diperbarui_pada'],
      )!,
    );
  }

  @override
  $TransaksiTable createAlias(String alias) {
    return $TransaksiTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JenisTransaksi, String, String> $converterjenis =
      const EnumNameConverter<JenisTransaksi>(JenisTransaksi.values);
}

class TransaksiData extends DataClass implements Insertable<TransaksiData> {
  final String id;
  final String akunDanaId;
  final String? kategoriId;
  final JenisTransaksi jenis;
  final int nominal;
  final DateTime tanggal;
  final String? catatan;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;
  const TransaksiData({
    required this.id,
    required this.akunDanaId,
    this.kategoriId,
    required this.jenis,
    required this.nominal,
    required this.tanggal,
    this.catatan,
    required this.dibuatPada,
    required this.diperbaruiPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['akun_dana_id'] = Variable<String>(akunDanaId);
    if (!nullToAbsent || kategoriId != null) {
      map['kategori_id'] = Variable<String>(kategoriId);
    }
    {
      map['jenis'] = Variable<String>(
        $TransaksiTable.$converterjenis.toSql(jenis),
      );
    }
    map['nominal'] = Variable<int>(nominal);
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada);
    return map;
  }

  TransaksiCompanion toCompanion(bool nullToAbsent) {
    return TransaksiCompanion(
      id: Value(id),
      akunDanaId: Value(akunDanaId),
      kategoriId: kategoriId == null && nullToAbsent
          ? const Value.absent()
          : Value(kategoriId),
      jenis: Value(jenis),
      nominal: Value(nominal),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
      diperbaruiPada: Value(diperbaruiPada),
    );
  }

  factory TransaksiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransaksiData(
      id: serializer.fromJson<String>(json['id']),
      akunDanaId: serializer.fromJson<String>(json['akunDanaId']),
      kategoriId: serializer.fromJson<String?>(json['kategoriId']),
      jenis: $TransaksiTable.$converterjenis.fromJson(
        serializer.fromJson<String>(json['jenis']),
      ),
      nominal: serializer.fromJson<int>(json['nominal']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
      diperbaruiPada: serializer.fromJson<DateTime>(json['diperbaruiPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'akunDanaId': serializer.toJson<String>(akunDanaId),
      'kategoriId': serializer.toJson<String?>(kategoriId),
      'jenis': serializer.toJson<String>(
        $TransaksiTable.$converterjenis.toJson(jenis),
      ),
      'nominal': serializer.toJson<int>(nominal),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
      'diperbaruiPada': serializer.toJson<DateTime>(diperbaruiPada),
    };
  }

  TransaksiData copyWith({
    String? id,
    String? akunDanaId,
    Value<String?> kategoriId = const Value.absent(),
    JenisTransaksi? jenis,
    int? nominal,
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
  }) => TransaksiData(
    id: id ?? this.id,
    akunDanaId: akunDanaId ?? this.akunDanaId,
    kategoriId: kategoriId.present ? kategoriId.value : this.kategoriId,
    jenis: jenis ?? this.jenis,
    nominal: nominal ?? this.nominal,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
  );
  TransaksiData copyWithCompanion(TransaksiCompanion data) {
    return TransaksiData(
      id: data.id.present ? data.id.value : this.id,
      akunDanaId: data.akunDanaId.present
          ? data.akunDanaId.value
          : this.akunDanaId,
      kategoriId: data.kategoriId.present
          ? data.kategoriId.value
          : this.kategoriId,
      jenis: data.jenis.present ? data.jenis.value : this.jenis,
      nominal: data.nominal.present ? data.nominal.value : this.nominal,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
      diperbaruiPada: data.diperbaruiPada.present
          ? data.diperbaruiPada.value
          : this.diperbaruiPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiData(')
          ..write('id: $id, ')
          ..write('akunDanaId: $akunDanaId, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('jenis: $jenis, ')
          ..write('nominal: $nominal, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    akunDanaId,
    kategoriId,
    jenis,
    nominal,
    tanggal,
    catatan,
    dibuatPada,
    diperbaruiPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransaksiData &&
          other.id == this.id &&
          other.akunDanaId == this.akunDanaId &&
          other.kategoriId == this.kategoriId &&
          other.jenis == this.jenis &&
          other.nominal == this.nominal &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada &&
          other.diperbaruiPada == this.diperbaruiPada);
}

class TransaksiCompanion extends UpdateCompanion<TransaksiData> {
  final Value<String> id;
  final Value<String> akunDanaId;
  final Value<String?> kategoriId;
  final Value<JenisTransaksi> jenis;
  final Value<int> nominal;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  final Value<DateTime> diperbaruiPada;
  final Value<int> rowid;
  const TransaksiCompanion({
    this.id = const Value.absent(),
    this.akunDanaId = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.jenis = const Value.absent(),
    this.nominal = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.diperbaruiPada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransaksiCompanion.insert({
    required String id,
    required String akunDanaId,
    this.kategoriId = const Value.absent(),
    required JenisTransaksi jenis,
    required int nominal,
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    required DateTime dibuatPada,
    required DateTime diperbaruiPada,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       akunDanaId = Value(akunDanaId),
       jenis = Value(jenis),
       nominal = Value(nominal),
       tanggal = Value(tanggal),
       dibuatPada = Value(dibuatPada),
       diperbaruiPada = Value(diperbaruiPada);
  static Insertable<TransaksiData> custom({
    Expression<String>? id,
    Expression<String>? akunDanaId,
    Expression<String>? kategoriId,
    Expression<String>? jenis,
    Expression<int>? nominal,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
    Expression<DateTime>? diperbaruiPada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (akunDanaId != null) 'akun_dana_id': akunDanaId,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (jenis != null) 'jenis': jenis,
      if (nominal != null) 'nominal': nominal,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (diperbaruiPada != null) 'diperbarui_pada': diperbaruiPada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransaksiCompanion copyWith({
    Value<String>? id,
    Value<String>? akunDanaId,
    Value<String?>? kategoriId,
    Value<JenisTransaksi>? jenis,
    Value<int>? nominal,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
    Value<DateTime>? diperbaruiPada,
    Value<int>? rowid,
  }) {
    return TransaksiCompanion(
      id: id ?? this.id,
      akunDanaId: akunDanaId ?? this.akunDanaId,
      kategoriId: kategoriId ?? this.kategoriId,
      jenis: jenis ?? this.jenis,
      nominal: nominal ?? this.nominal,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (akunDanaId.present) {
      map['akun_dana_id'] = Variable<String>(akunDanaId.value);
    }
    if (kategoriId.present) {
      map['kategori_id'] = Variable<String>(kategoriId.value);
    }
    if (jenis.present) {
      map['jenis'] = Variable<String>(
        $TransaksiTable.$converterjenis.toSql(jenis.value),
      );
    }
    if (nominal.present) {
      map['nominal'] = Variable<int>(nominal.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (diperbaruiPada.present) {
      map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiCompanion(')
          ..write('id: $id, ')
          ..write('akunDanaId: $akunDanaId, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('jenis: $jenis, ')
          ..write('nominal: $nominal, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransferTable extends Transfer
    with TableInfo<$TransferTable, TransferData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _akunAsalIdMeta = const VerificationMeta(
    'akunAsalId',
  );
  @override
  late final GeneratedColumn<String> akunAsalId = GeneratedColumn<String>(
    'akun_asal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _akunTujuanIdMeta = const VerificationMeta(
    'akunTujuanId',
  );
  @override
  late final GeneratedColumn<String> akunTujuanId = GeneratedColumn<String>(
    'akun_tujuan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nominalMeta = const VerificationMeta(
    'nominal',
  );
  @override
  late final GeneratedColumn<int> nominal = GeneratedColumn<int>(
    'nominal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diperbaruiPadaMeta = const VerificationMeta(
    'diperbaruiPada',
  );
  @override
  late final GeneratedColumn<DateTime> diperbaruiPada =
      GeneratedColumn<DateTime>(
        'diperbarui_pada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    akunAsalId,
    akunTujuanId,
    nominal,
    tanggal,
    catatan,
    dibuatPada,
    diperbaruiPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('akun_asal_id')) {
      context.handle(
        _akunAsalIdMeta,
        akunAsalId.isAcceptableOrUnknown(
          data['akun_asal_id']!,
          _akunAsalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_akunAsalIdMeta);
    }
    if (data.containsKey('akun_tujuan_id')) {
      context.handle(
        _akunTujuanIdMeta,
        akunTujuanId.isAcceptableOrUnknown(
          data['akun_tujuan_id']!,
          _akunTujuanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_akunTujuanIdMeta);
    }
    if (data.containsKey('nominal')) {
      context.handle(
        _nominalMeta,
        nominal.isAcceptableOrUnknown(data['nominal']!, _nominalMeta),
      );
    } else if (isInserting) {
      context.missing(_nominalMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    } else if (isInserting) {
      context.missing(_dibuatPadaMeta);
    }
    if (data.containsKey('diperbarui_pada')) {
      context.handle(
        _diperbaruiPadaMeta,
        diperbaruiPada.isAcceptableOrUnknown(
          data['diperbarui_pada']!,
          _diperbaruiPadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diperbaruiPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {akunAsalId},
    {akunTujuanId},
  ];
  @override
  TransferData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      akunAsalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}akun_asal_id'],
      )!,
      akunTujuanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}akun_tujuan_id'],
      )!,
      nominal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nominal'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
      diperbaruiPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diperbarui_pada'],
      )!,
    );
  }

  @override
  $TransferTable createAlias(String alias) {
    return $TransferTable(attachedDatabase, alias);
  }
}

class TransferData extends DataClass implements Insertable<TransferData> {
  final String id;
  final String akunAsalId;
  final String akunTujuanId;
  final int nominal;
  final DateTime tanggal;
  final String? catatan;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;
  const TransferData({
    required this.id,
    required this.akunAsalId,
    required this.akunTujuanId,
    required this.nominal,
    required this.tanggal,
    this.catatan,
    required this.dibuatPada,
    required this.diperbaruiPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['akun_asal_id'] = Variable<String>(akunAsalId);
    map['akun_tujuan_id'] = Variable<String>(akunTujuanId);
    map['nominal'] = Variable<int>(nominal);
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada);
    return map;
  }

  TransferCompanion toCompanion(bool nullToAbsent) {
    return TransferCompanion(
      id: Value(id),
      akunAsalId: Value(akunAsalId),
      akunTujuanId: Value(akunTujuanId),
      nominal: Value(nominal),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
      diperbaruiPada: Value(diperbaruiPada),
    );
  }

  factory TransferData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferData(
      id: serializer.fromJson<String>(json['id']),
      akunAsalId: serializer.fromJson<String>(json['akunAsalId']),
      akunTujuanId: serializer.fromJson<String>(json['akunTujuanId']),
      nominal: serializer.fromJson<int>(json['nominal']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
      diperbaruiPada: serializer.fromJson<DateTime>(json['diperbaruiPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'akunAsalId': serializer.toJson<String>(akunAsalId),
      'akunTujuanId': serializer.toJson<String>(akunTujuanId),
      'nominal': serializer.toJson<int>(nominal),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
      'diperbaruiPada': serializer.toJson<DateTime>(diperbaruiPada),
    };
  }

  TransferData copyWith({
    String? id,
    String? akunAsalId,
    String? akunTujuanId,
    int? nominal,
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
  }) => TransferData(
    id: id ?? this.id,
    akunAsalId: akunAsalId ?? this.akunAsalId,
    akunTujuanId: akunTujuanId ?? this.akunTujuanId,
    nominal: nominal ?? this.nominal,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
  );
  TransferData copyWithCompanion(TransferCompanion data) {
    return TransferData(
      id: data.id.present ? data.id.value : this.id,
      akunAsalId: data.akunAsalId.present
          ? data.akunAsalId.value
          : this.akunAsalId,
      akunTujuanId: data.akunTujuanId.present
          ? data.akunTujuanId.value
          : this.akunTujuanId,
      nominal: data.nominal.present ? data.nominal.value : this.nominal,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
      diperbaruiPada: data.diperbaruiPada.present
          ? data.diperbaruiPada.value
          : this.diperbaruiPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferData(')
          ..write('id: $id, ')
          ..write('akunAsalId: $akunAsalId, ')
          ..write('akunTujuanId: $akunTujuanId, ')
          ..write('nominal: $nominal, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    akunAsalId,
    akunTujuanId,
    nominal,
    tanggal,
    catatan,
    dibuatPada,
    diperbaruiPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferData &&
          other.id == this.id &&
          other.akunAsalId == this.akunAsalId &&
          other.akunTujuanId == this.akunTujuanId &&
          other.nominal == this.nominal &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada &&
          other.diperbaruiPada == this.diperbaruiPada);
}

class TransferCompanion extends UpdateCompanion<TransferData> {
  final Value<String> id;
  final Value<String> akunAsalId;
  final Value<String> akunTujuanId;
  final Value<int> nominal;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  final Value<DateTime> diperbaruiPada;
  final Value<int> rowid;
  const TransferCompanion({
    this.id = const Value.absent(),
    this.akunAsalId = const Value.absent(),
    this.akunTujuanId = const Value.absent(),
    this.nominal = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.diperbaruiPada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransferCompanion.insert({
    required String id,
    required String akunAsalId,
    required String akunTujuanId,
    required int nominal,
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    required DateTime dibuatPada,
    required DateTime diperbaruiPada,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       akunAsalId = Value(akunAsalId),
       akunTujuanId = Value(akunTujuanId),
       nominal = Value(nominal),
       tanggal = Value(tanggal),
       dibuatPada = Value(dibuatPada),
       diperbaruiPada = Value(diperbaruiPada);
  static Insertable<TransferData> custom({
    Expression<String>? id,
    Expression<String>? akunAsalId,
    Expression<String>? akunTujuanId,
    Expression<int>? nominal,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
    Expression<DateTime>? diperbaruiPada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (akunAsalId != null) 'akun_asal_id': akunAsalId,
      if (akunTujuanId != null) 'akun_tujuan_id': akunTujuanId,
      if (nominal != null) 'nominal': nominal,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (diperbaruiPada != null) 'diperbarui_pada': diperbaruiPada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransferCompanion copyWith({
    Value<String>? id,
    Value<String>? akunAsalId,
    Value<String>? akunTujuanId,
    Value<int>? nominal,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
    Value<DateTime>? diperbaruiPada,
    Value<int>? rowid,
  }) {
    return TransferCompanion(
      id: id ?? this.id,
      akunAsalId: akunAsalId ?? this.akunAsalId,
      akunTujuanId: akunTujuanId ?? this.akunTujuanId,
      nominal: nominal ?? this.nominal,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (akunAsalId.present) {
      map['akun_asal_id'] = Variable<String>(akunAsalId.value);
    }
    if (akunTujuanId.present) {
      map['akun_tujuan_id'] = Variable<String>(akunTujuanId.value);
    }
    if (nominal.present) {
      map['nominal'] = Variable<int>(nominal.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (diperbaruiPada.present) {
      map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferCompanion(')
          ..write('id: $id, ')
          ..write('akunAsalId: $akunAsalId, ')
          ..write('akunTujuanId: $akunTujuanId, ')
          ..write('nominal: $nominal, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PiutangTable extends Piutang with TableInfo<$PiutangTable, PiutangData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PiutangTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diperbaruiPadaMeta = const VerificationMeta(
    'diperbaruiPada',
  );
  @override
  late final GeneratedColumn<DateTime> diperbaruiPada =
      GeneratedColumn<DateTime>(
        'diperbarui_pada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    catatan,
    dibuatPada,
    diperbaruiPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'piutang';
  @override
  VerificationContext validateIntegrity(
    Insertable<PiutangData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    } else if (isInserting) {
      context.missing(_dibuatPadaMeta);
    }
    if (data.containsKey('diperbarui_pada')) {
      context.handle(
        _diperbaruiPadaMeta,
        diperbaruiPada.isAcceptableOrUnknown(
          data['diperbarui_pada']!,
          _diperbaruiPadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diperbaruiPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PiutangData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PiutangData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
      diperbaruiPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diperbarui_pada'],
      )!,
    );
  }

  @override
  $PiutangTable createAlias(String alias) {
    return $PiutangTable(attachedDatabase, alias);
  }
}

class PiutangData extends DataClass implements Insertable<PiutangData> {
  final String id;
  final String nama;
  final String? catatan;
  final DateTime dibuatPada;
  final DateTime diperbaruiPada;
  const PiutangData({
    required this.id,
    required this.nama,
    this.catatan,
    required this.dibuatPada,
    required this.diperbaruiPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada);
    return map;
  }

  PiutangCompanion toCompanion(bool nullToAbsent) {
    return PiutangCompanion(
      id: Value(id),
      nama: Value(nama),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
      diperbaruiPada: Value(diperbaruiPada),
    );
  }

  factory PiutangData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PiutangData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
      diperbaruiPada: serializer.fromJson<DateTime>(json['diperbaruiPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
      'diperbaruiPada': serializer.toJson<DateTime>(diperbaruiPada),
    };
  }

  PiutangData copyWith({
    String? id,
    String? nama,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
  }) => PiutangData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
  );
  PiutangData copyWithCompanion(PiutangCompanion data) {
    return PiutangData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
      diperbaruiPada: data.diperbaruiPada.present
          ? data.diperbaruiPada.value
          : this.diperbaruiPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PiutangData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nama, catatan, dibuatPada, diperbaruiPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PiutangData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada &&
          other.diperbaruiPada == this.diperbaruiPada);
}

class PiutangCompanion extends UpdateCompanion<PiutangData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  final Value<DateTime> diperbaruiPada;
  final Value<int> rowid;
  const PiutangCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.diperbaruiPada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PiutangCompanion.insert({
    required String id,
    required String nama,
    this.catatan = const Value.absent(),
    required DateTime dibuatPada,
    required DateTime diperbaruiPada,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       dibuatPada = Value(dibuatPada),
       diperbaruiPada = Value(diperbaruiPada);
  static Insertable<PiutangData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
    Expression<DateTime>? diperbaruiPada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (diperbaruiPada != null) 'diperbarui_pada': diperbaruiPada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PiutangCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
    Value<DateTime>? diperbaruiPada,
    Value<int>? rowid,
  }) {
    return PiutangCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (diperbaruiPada.present) {
      map['diperbarui_pada'] = Variable<DateTime>(diperbaruiPada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PiutangCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diperbaruiPada: $diperbaruiPada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RiwayatPiutangTable extends RiwayatPiutang
    with TableInfo<$RiwayatPiutangTable, RiwayatPiutangData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiwayatPiutangTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _piutangIdMeta = const VerificationMeta(
    'piutangId',
  );
  @override
  late final GeneratedColumn<String> piutangId = GeneratedColumn<String>(
    'piutang_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<JenisRiwayat, String> jenis =
      GeneratedColumn<String>(
        'jenis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<JenisRiwayat>($RiwayatPiutangTable.$converterjenis);
  static const VerificationMeta _nominalMeta = const VerificationMeta(
    'nominal',
  );
  @override
  late final GeneratedColumn<int> nominal = GeneratedColumn<int>(
    'nominal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _akunDanaIdMeta = const VerificationMeta(
    'akunDanaId',
  );
  @override
  late final GeneratedColumn<String> akunDanaId = GeneratedColumn<String>(
    'akun_dana_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    piutangId,
    jenis,
    nominal,
    akunDanaId,
    tanggal,
    catatan,
    dibuatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'riwayat_piutang';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiwayatPiutangData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('piutang_id')) {
      context.handle(
        _piutangIdMeta,
        piutangId.isAcceptableOrUnknown(data['piutang_id']!, _piutangIdMeta),
      );
    } else if (isInserting) {
      context.missing(_piutangIdMeta);
    }
    if (data.containsKey('nominal')) {
      context.handle(
        _nominalMeta,
        nominal.isAcceptableOrUnknown(data['nominal']!, _nominalMeta),
      );
    } else if (isInserting) {
      context.missing(_nominalMeta);
    }
    if (data.containsKey('akun_dana_id')) {
      context.handle(
        _akunDanaIdMeta,
        akunDanaId.isAcceptableOrUnknown(
          data['akun_dana_id']!,
          _akunDanaIdMeta,
        ),
      );
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    } else if (isInserting) {
      context.missing(_dibuatPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {piutangId},
    {akunDanaId},
  ];
  @override
  RiwayatPiutangData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiwayatPiutangData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      piutangId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}piutang_id'],
      )!,
      jenis: $RiwayatPiutangTable.$converterjenis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}jenis'],
        )!,
      ),
      nominal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nominal'],
      )!,
      akunDanaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}akun_dana_id'],
      ),
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
    );
  }

  @override
  $RiwayatPiutangTable createAlias(String alias) {
    return $RiwayatPiutangTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JenisRiwayat, String, String> $converterjenis =
      const EnumNameConverter<JenisRiwayat>(JenisRiwayat.values);
}

class RiwayatPiutangData extends DataClass
    implements Insertable<RiwayatPiutangData> {
  final String id;
  final String piutangId;
  final JenisRiwayat jenis;
  final int nominal;
  final String? akunDanaId;
  final DateTime tanggal;
  final String? catatan;
  final DateTime dibuatPada;
  const RiwayatPiutangData({
    required this.id,
    required this.piutangId,
    required this.jenis,
    required this.nominal,
    this.akunDanaId,
    required this.tanggal,
    this.catatan,
    required this.dibuatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['piutang_id'] = Variable<String>(piutangId);
    {
      map['jenis'] = Variable<String>(
        $RiwayatPiutangTable.$converterjenis.toSql(jenis),
      );
    }
    map['nominal'] = Variable<int>(nominal);
    if (!nullToAbsent || akunDanaId != null) {
      map['akun_dana_id'] = Variable<String>(akunDanaId);
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    return map;
  }

  RiwayatPiutangCompanion toCompanion(bool nullToAbsent) {
    return RiwayatPiutangCompanion(
      id: Value(id),
      piutangId: Value(piutangId),
      jenis: Value(jenis),
      nominal: Value(nominal),
      akunDanaId: akunDanaId == null && nullToAbsent
          ? const Value.absent()
          : Value(akunDanaId),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
    );
  }

  factory RiwayatPiutangData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiwayatPiutangData(
      id: serializer.fromJson<String>(json['id']),
      piutangId: serializer.fromJson<String>(json['piutangId']),
      jenis: $RiwayatPiutangTable.$converterjenis.fromJson(
        serializer.fromJson<String>(json['jenis']),
      ),
      nominal: serializer.fromJson<int>(json['nominal']),
      akunDanaId: serializer.fromJson<String?>(json['akunDanaId']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'piutangId': serializer.toJson<String>(piutangId),
      'jenis': serializer.toJson<String>(
        $RiwayatPiutangTable.$converterjenis.toJson(jenis),
      ),
      'nominal': serializer.toJson<int>(nominal),
      'akunDanaId': serializer.toJson<String?>(akunDanaId),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
    };
  }

  RiwayatPiutangData copyWith({
    String? id,
    String? piutangId,
    JenisRiwayat? jenis,
    int? nominal,
    Value<String?> akunDanaId = const Value.absent(),
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
  }) => RiwayatPiutangData(
    id: id ?? this.id,
    piutangId: piutangId ?? this.piutangId,
    jenis: jenis ?? this.jenis,
    nominal: nominal ?? this.nominal,
    akunDanaId: akunDanaId.present ? akunDanaId.value : this.akunDanaId,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
  );
  RiwayatPiutangData copyWithCompanion(RiwayatPiutangCompanion data) {
    return RiwayatPiutangData(
      id: data.id.present ? data.id.value : this.id,
      piutangId: data.piutangId.present ? data.piutangId.value : this.piutangId,
      jenis: data.jenis.present ? data.jenis.value : this.jenis,
      nominal: data.nominal.present ? data.nominal.value : this.nominal,
      akunDanaId: data.akunDanaId.present
          ? data.akunDanaId.value
          : this.akunDanaId,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiwayatPiutangData(')
          ..write('id: $id, ')
          ..write('piutangId: $piutangId, ')
          ..write('jenis: $jenis, ')
          ..write('nominal: $nominal, ')
          ..write('akunDanaId: $akunDanaId, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    piutangId,
    jenis,
    nominal,
    akunDanaId,
    tanggal,
    catatan,
    dibuatPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiwayatPiutangData &&
          other.id == this.id &&
          other.piutangId == this.piutangId &&
          other.jenis == this.jenis &&
          other.nominal == this.nominal &&
          other.akunDanaId == this.akunDanaId &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada);
}

class RiwayatPiutangCompanion extends UpdateCompanion<RiwayatPiutangData> {
  final Value<String> id;
  final Value<String> piutangId;
  final Value<JenisRiwayat> jenis;
  final Value<int> nominal;
  final Value<String?> akunDanaId;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  final Value<int> rowid;
  const RiwayatPiutangCompanion({
    this.id = const Value.absent(),
    this.piutangId = const Value.absent(),
    this.jenis = const Value.absent(),
    this.nominal = const Value.absent(),
    this.akunDanaId = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiwayatPiutangCompanion.insert({
    required String id,
    required String piutangId,
    required JenisRiwayat jenis,
    required int nominal,
    this.akunDanaId = const Value.absent(),
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    required DateTime dibuatPada,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       piutangId = Value(piutangId),
       jenis = Value(jenis),
       nominal = Value(nominal),
       tanggal = Value(tanggal),
       dibuatPada = Value(dibuatPada);
  static Insertable<RiwayatPiutangData> custom({
    Expression<String>? id,
    Expression<String>? piutangId,
    Expression<String>? jenis,
    Expression<int>? nominal,
    Expression<String>? akunDanaId,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (piutangId != null) 'piutang_id': piutangId,
      if (jenis != null) 'jenis': jenis,
      if (nominal != null) 'nominal': nominal,
      if (akunDanaId != null) 'akun_dana_id': akunDanaId,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RiwayatPiutangCompanion copyWith({
    Value<String>? id,
    Value<String>? piutangId,
    Value<JenisRiwayat>? jenis,
    Value<int>? nominal,
    Value<String?>? akunDanaId,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
    Value<int>? rowid,
  }) {
    return RiwayatPiutangCompanion(
      id: id ?? this.id,
      piutangId: piutangId ?? this.piutangId,
      jenis: jenis ?? this.jenis,
      nominal: nominal ?? this.nominal,
      akunDanaId: akunDanaId ?? this.akunDanaId,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (piutangId.present) {
      map['piutang_id'] = Variable<String>(piutangId.value);
    }
    if (jenis.present) {
      map['jenis'] = Variable<String>(
        $RiwayatPiutangTable.$converterjenis.toSql(jenis.value),
      );
    }
    if (nominal.present) {
      map['nominal'] = Variable<int>(nominal.value);
    }
    if (akunDanaId.present) {
      map['akun_dana_id'] = Variable<String>(akunDanaId.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RiwayatPiutangCompanion(')
          ..write('id: $id, ')
          ..write('piutangId: $piutangId, ')
          ..write('jenis: $jenis, ')
          ..write('nominal: $nominal, ')
          ..write('akunDanaId: $akunDanaId, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DompetKuDatabase extends GeneratedDatabase {
  _$DompetKuDatabase(QueryExecutor e) : super(e);
  $DompetKuDatabaseManager get managers => $DompetKuDatabaseManager(this);
  late final $AkunDanaTable akunDana = $AkunDanaTable(this);
  late final $KategoriTable kategori = $KategoriTable(this);
  late final $TransaksiTable transaksi = $TransaksiTable(this);
  late final $TransferTable transfer = $TransferTable(this);
  late final $PiutangTable piutang = $PiutangTable(this);
  late final $RiwayatPiutangTable riwayatPiutang = $RiwayatPiutangTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    akunDana,
    kategori,
    transaksi,
    transfer,
    piutang,
    riwayatPiutang,
  ];
}

typedef $$AkunDanaTableCreateCompanionBuilder = AkunDanaCompanion Function({
  required String id,
  required String nama,
  required JenisAkun jenis,
  Value<int> saldoAwal,
  Value<String?> ikon,
  Value<bool> aktif,
  required DateTime dibuatPada,
  required DateTime diperbaruiPada,
  Value<int> rowid,
});
typedef $$AkunDanaTableUpdateCompanionBuilder = AkunDanaCompanion Function({
  Value<String> id,
  Value<String> nama,
  Value<JenisAkun> jenis,
  Value<int> saldoAwal,
  Value<String?> ikon,
  Value<bool> aktif,
  Value<DateTime> dibuatPada,
  Value<DateTime> diperbaruiPada,
  Value<int> rowid,
});

class $$AkunDanaTableFilterComposer
    extends Composer<_$DompetKuDatabase, $AkunDanaTable> {
  $$AkunDanaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JenisAkun, JenisAkun, String> get jenis =>
      $composableBuilder(
        column: $table.jenis,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get saldoAwal => $composableBuilder(
    column: $table.saldoAwal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ikon => $composableBuilder(
    column: $table.ikon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AkunDanaTableOrderingComposer
    extends Composer<_$DompetKuDatabase, $AkunDanaTable> {
  $$AkunDanaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoAwal => $composableBuilder(
    column: $table.saldoAwal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ikon => $composableBuilder(
    column: $table.ikon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AkunDanaTableAnnotationComposer
    extends Composer<_$DompetKuDatabase, $AkunDanaTable> {
  $$AkunDanaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumnWithTypeConverter<JenisAkun, String> get jenis =>
      $composableBuilder(column: $table.jenis, builder: (column) => column);

  GeneratedColumn<int> get saldoAwal =>
      $composableBuilder(column: $table.saldoAwal, builder: (column) => column);

  GeneratedColumn<String> get ikon =>
      $composableBuilder(column: $table.ikon, builder: (column) => column);

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => column,
  );
}

class $$AkunDanaTableTableManager
    extends
        RootTableManager<
          _$DompetKuDatabase,
          $AkunDanaTable,
          AkunDanaData,
          $$AkunDanaTableFilterComposer,
          $$AkunDanaTableOrderingComposer,
          $$AkunDanaTableAnnotationComposer,
          $$AkunDanaTableCreateCompanionBuilder,
          $$AkunDanaTableUpdateCompanionBuilder,
          (
            AkunDanaData,
            BaseReferences<_$DompetKuDatabase, $AkunDanaTable, AkunDanaData>,
          ),
          AkunDanaData,
          PrefetchHooks Function()
        > {
  $$AkunDanaTableTableManager(_$DompetKuDatabase db, $AkunDanaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AkunDanaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AkunDanaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AkunDanaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<JenisAkun> jenis = const Value.absent(),
                Value<int> saldoAwal = const Value.absent(),
                Value<String?> ikon = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime> diperbaruiPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AkunDanaCompanion(
                id: id,
                nama: nama,
                jenis: jenis,
                saldoAwal: saldoAwal,
                ikon: ikon,
                aktif: aktif,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required JenisAkun jenis,
                Value<int> saldoAwal = const Value.absent(),
                Value<String?> ikon = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                required DateTime dibuatPada,
                required DateTime diperbaruiPada,
                Value<int> rowid = const Value.absent(),
              }) => AkunDanaCompanion.insert(
                id: id,
                nama: nama,
                jenis: jenis,
                saldoAwal: saldoAwal,
                ikon: ikon,
                aktif: aktif,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AkunDanaTable, AkunDanaData>(table),
                  BaseReferences<
                    _$DompetKuDatabase,
                    $AkunDanaTable,
                    AkunDanaData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AkunDanaTableProcessedTableManager =
    ProcessedTableManager<
      _$DompetKuDatabase,
      $AkunDanaTable,
      AkunDanaData,
      $$AkunDanaTableFilterComposer,
      $$AkunDanaTableOrderingComposer,
      $$AkunDanaTableAnnotationComposer,
      $$AkunDanaTableCreateCompanionBuilder,
      $$AkunDanaTableUpdateCompanionBuilder,
      (
        AkunDanaData,
        BaseReferences<_$DompetKuDatabase, $AkunDanaTable, AkunDanaData>,
      ),
      AkunDanaData,
      PrefetchHooks Function()
    >;
typedef $$KategoriTableCreateCompanionBuilder = KategoriCompanion Function({
  required String id,
  required String nama,
  required JenisTransaksi jenis,
  Value<String?> ikon,
  Value<bool> aktif,
  Value<int> rowid,
});
typedef $$KategoriTableUpdateCompanionBuilder = KategoriCompanion Function({
  Value<String> id,
  Value<String> nama,
  Value<JenisTransaksi> jenis,
  Value<String?> ikon,
  Value<bool> aktif,
  Value<int> rowid,
});

class $$KategoriTableFilterComposer
    extends Composer<_$DompetKuDatabase, $KategoriTable> {
  $$KategoriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JenisTransaksi, JenisTransaksi, String>
  get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get ikon => $composableBuilder(
    column: $table.ikon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KategoriTableOrderingComposer
    extends Composer<_$DompetKuDatabase, $KategoriTable> {
  $$KategoriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ikon => $composableBuilder(
    column: $table.ikon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KategoriTableAnnotationComposer
    extends Composer<_$DompetKuDatabase, $KategoriTable> {
  $$KategoriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumnWithTypeConverter<JenisTransaksi, String> get jenis =>
      $composableBuilder(column: $table.jenis, builder: (column) => column);

  GeneratedColumn<String> get ikon =>
      $composableBuilder(column: $table.ikon, builder: (column) => column);

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);
}

class $$KategoriTableTableManager
    extends
        RootTableManager<
          _$DompetKuDatabase,
          $KategoriTable,
          KategoriData,
          $$KategoriTableFilterComposer,
          $$KategoriTableOrderingComposer,
          $$KategoriTableAnnotationComposer,
          $$KategoriTableCreateCompanionBuilder,
          $$KategoriTableUpdateCompanionBuilder,
          (
            KategoriData,
            BaseReferences<_$DompetKuDatabase, $KategoriTable, KategoriData>,
          ),
          KategoriData,
          PrefetchHooks Function()
        > {
  $$KategoriTableTableManager(_$DompetKuDatabase db, $KategoriTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KategoriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KategoriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KategoriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<JenisTransaksi> jenis = const Value.absent(),
                Value<String?> ikon = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KategoriCompanion(
                id: id,
                nama: nama,
                jenis: jenis,
                ikon: ikon,
                aktif: aktif,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required JenisTransaksi jenis,
                Value<String?> ikon = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KategoriCompanion.insert(
                id: id,
                nama: nama,
                jenis: jenis,
                ikon: ikon,
                aktif: aktif,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KategoriTable, KategoriData>(table),
                  BaseReferences<
                    _$DompetKuDatabase,
                    $KategoriTable,
                    KategoriData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KategoriTableProcessedTableManager =
    ProcessedTableManager<
      _$DompetKuDatabase,
      $KategoriTable,
      KategoriData,
      $$KategoriTableFilterComposer,
      $$KategoriTableOrderingComposer,
      $$KategoriTableAnnotationComposer,
      $$KategoriTableCreateCompanionBuilder,
      $$KategoriTableUpdateCompanionBuilder,
      (
        KategoriData,
        BaseReferences<_$DompetKuDatabase, $KategoriTable, KategoriData>,
      ),
      KategoriData,
      PrefetchHooks Function()
    >;
typedef $$TransaksiTableCreateCompanionBuilder = TransaksiCompanion Function({
  required String id,
  required String akunDanaId,
  Value<String?> kategoriId,
  required JenisTransaksi jenis,
  required int nominal,
  required DateTime tanggal,
  Value<String?> catatan,
  required DateTime dibuatPada,
  required DateTime diperbaruiPada,
  Value<int> rowid,
});
typedef $$TransaksiTableUpdateCompanionBuilder = TransaksiCompanion Function({
  Value<String> id,
  Value<String> akunDanaId,
  Value<String?> kategoriId,
  Value<JenisTransaksi> jenis,
  Value<int> nominal,
  Value<DateTime> tanggal,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime> diperbaruiPada,
  Value<int> rowid,
});

class $$TransaksiTableFilterComposer
    extends Composer<_$DompetKuDatabase, $TransaksiTable> {
  $$TransaksiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get akunDanaId => $composableBuilder(
    column: $table.akunDanaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JenisTransaksi, JenisTransaksi, String>
  get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get nominal => $composableBuilder(
    column: $table.nominal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransaksiTableOrderingComposer
    extends Composer<_$DompetKuDatabase, $TransaksiTable> {
  $$TransaksiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get akunDanaId => $composableBuilder(
    column: $table.akunDanaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nominal => $composableBuilder(
    column: $table.nominal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransaksiTableAnnotationComposer
    extends Composer<_$DompetKuDatabase, $TransaksiTable> {
  $$TransaksiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get akunDanaId => $composableBuilder(
    column: $table.akunDanaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<JenisTransaksi, String> get jenis =>
      $composableBuilder(column: $table.jenis, builder: (column) => column);

  GeneratedColumn<int> get nominal =>
      $composableBuilder(column: $table.nominal, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => column,
  );
}

class $$TransaksiTableTableManager
    extends
        RootTableManager<
          _$DompetKuDatabase,
          $TransaksiTable,
          TransaksiData,
          $$TransaksiTableFilterComposer,
          $$TransaksiTableOrderingComposer,
          $$TransaksiTableAnnotationComposer,
          $$TransaksiTableCreateCompanionBuilder,
          $$TransaksiTableUpdateCompanionBuilder,
          (
            TransaksiData,
            BaseReferences<_$DompetKuDatabase, $TransaksiTable, TransaksiData>,
          ),
          TransaksiData,
          PrefetchHooks Function()
        > {
  $$TransaksiTableTableManager(_$DompetKuDatabase db, $TransaksiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaksiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaksiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaksiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> akunDanaId = const Value.absent(),
                Value<String?> kategoriId = const Value.absent(),
                Value<JenisTransaksi> jenis = const Value.absent(),
                Value<int> nominal = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime> diperbaruiPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransaksiCompanion(
                id: id,
                akunDanaId: akunDanaId,
                kategoriId: kategoriId,
                jenis: jenis,
                nominal: nominal,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String akunDanaId,
                Value<String?> kategoriId = const Value.absent(),
                required JenisTransaksi jenis,
                required int nominal,
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                required DateTime dibuatPada,
                required DateTime diperbaruiPada,
                Value<int> rowid = const Value.absent(),
              }) => TransaksiCompanion.insert(
                id: id,
                akunDanaId: akunDanaId,
                kategoriId: kategoriId,
                jenis: jenis,
                nominal: nominal,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransaksiTable, TransaksiData>(table),
                  BaseReferences<
                    _$DompetKuDatabase,
                    $TransaksiTable,
                    TransaksiData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransaksiTableProcessedTableManager =
    ProcessedTableManager<
      _$DompetKuDatabase,
      $TransaksiTable,
      TransaksiData,
      $$TransaksiTableFilterComposer,
      $$TransaksiTableOrderingComposer,
      $$TransaksiTableAnnotationComposer,
      $$TransaksiTableCreateCompanionBuilder,
      $$TransaksiTableUpdateCompanionBuilder,
      (
        TransaksiData,
        BaseReferences<_$DompetKuDatabase, $TransaksiTable, TransaksiData>,
      ),
      TransaksiData,
      PrefetchHooks Function()
    >;
typedef $$TransferTableCreateCompanionBuilder = TransferCompanion Function({
  required String id,
  required String akunAsalId,
  required String akunTujuanId,
  required int nominal,
  required DateTime tanggal,
  Value<String?> catatan,
  required DateTime dibuatPada,
  required DateTime diperbaruiPada,
  Value<int> rowid,
});
typedef $$TransferTableUpdateCompanionBuilder = TransferCompanion Function({
  Value<String> id,
  Value<String> akunAsalId,
  Value<String> akunTujuanId,
  Value<int> nominal,
  Value<DateTime> tanggal,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime> diperbaruiPada,
  Value<int> rowid,
});

class $$TransferTableFilterComposer
    extends Composer<_$DompetKuDatabase, $TransferTable> {
  $$TransferTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get akunAsalId => $composableBuilder(
    column: $table.akunAsalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get akunTujuanId => $composableBuilder(
    column: $table.akunTujuanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nominal => $composableBuilder(
    column: $table.nominal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransferTableOrderingComposer
    extends Composer<_$DompetKuDatabase, $TransferTable> {
  $$TransferTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get akunAsalId => $composableBuilder(
    column: $table.akunAsalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get akunTujuanId => $composableBuilder(
    column: $table.akunTujuanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nominal => $composableBuilder(
    column: $table.nominal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransferTableAnnotationComposer
    extends Composer<_$DompetKuDatabase, $TransferTable> {
  $$TransferTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get akunAsalId => $composableBuilder(
    column: $table.akunAsalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get akunTujuanId => $composableBuilder(
    column: $table.akunTujuanId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nominal =>
      $composableBuilder(column: $table.nominal, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => column,
  );
}

class $$TransferTableTableManager
    extends
        RootTableManager<
          _$DompetKuDatabase,
          $TransferTable,
          TransferData,
          $$TransferTableFilterComposer,
          $$TransferTableOrderingComposer,
          $$TransferTableAnnotationComposer,
          $$TransferTableCreateCompanionBuilder,
          $$TransferTableUpdateCompanionBuilder,
          (
            TransferData,
            BaseReferences<_$DompetKuDatabase, $TransferTable, TransferData>,
          ),
          TransferData,
          PrefetchHooks Function()
        > {
  $$TransferTableTableManager(_$DompetKuDatabase db, $TransferTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransferTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransferTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransferTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> akunAsalId = const Value.absent(),
                Value<String> akunTujuanId = const Value.absent(),
                Value<int> nominal = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime> diperbaruiPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransferCompanion(
                id: id,
                akunAsalId: akunAsalId,
                akunTujuanId: akunTujuanId,
                nominal: nominal,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String akunAsalId,
                required String akunTujuanId,
                required int nominal,
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                required DateTime dibuatPada,
                required DateTime diperbaruiPada,
                Value<int> rowid = const Value.absent(),
              }) => TransferCompanion.insert(
                id: id,
                akunAsalId: akunAsalId,
                akunTujuanId: akunTujuanId,
                nominal: nominal,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransferTable, TransferData>(table),
                  BaseReferences<
                    _$DompetKuDatabase,
                    $TransferTable,
                    TransferData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransferTableProcessedTableManager =
    ProcessedTableManager<
      _$DompetKuDatabase,
      $TransferTable,
      TransferData,
      $$TransferTableFilterComposer,
      $$TransferTableOrderingComposer,
      $$TransferTableAnnotationComposer,
      $$TransferTableCreateCompanionBuilder,
      $$TransferTableUpdateCompanionBuilder,
      (
        TransferData,
        BaseReferences<_$DompetKuDatabase, $TransferTable, TransferData>,
      ),
      TransferData,
      PrefetchHooks Function()
    >;
typedef $$PiutangTableCreateCompanionBuilder = PiutangCompanion Function({
  required String id,
  required String nama,
  Value<String?> catatan,
  required DateTime dibuatPada,
  required DateTime diperbaruiPada,
  Value<int> rowid,
});
typedef $$PiutangTableUpdateCompanionBuilder = PiutangCompanion Function({
  Value<String> id,
  Value<String> nama,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime> diperbaruiPada,
  Value<int> rowid,
});

class $$PiutangTableFilterComposer
    extends Composer<_$DompetKuDatabase, $PiutangTable> {
  $$PiutangTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PiutangTableOrderingComposer
    extends Composer<_$DompetKuDatabase, $PiutangTable> {
  $$PiutangTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PiutangTableAnnotationComposer
    extends Composer<_$DompetKuDatabase, $PiutangTable> {
  $$PiutangTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diperbaruiPada => $composableBuilder(
    column: $table.diperbaruiPada,
    builder: (column) => column,
  );
}

class $$PiutangTableTableManager
    extends
        RootTableManager<
          _$DompetKuDatabase,
          $PiutangTable,
          PiutangData,
          $$PiutangTableFilterComposer,
          $$PiutangTableOrderingComposer,
          $$PiutangTableAnnotationComposer,
          $$PiutangTableCreateCompanionBuilder,
          $$PiutangTableUpdateCompanionBuilder,
          (
            PiutangData,
            BaseReferences<_$DompetKuDatabase, $PiutangTable, PiutangData>,
          ),
          PiutangData,
          PrefetchHooks Function()
        > {
  $$PiutangTableTableManager(_$DompetKuDatabase db, $PiutangTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PiutangTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PiutangTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PiutangTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime> diperbaruiPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PiutangCompanion(
                id: id,
                nama: nama,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                Value<String?> catatan = const Value.absent(),
                required DateTime dibuatPada,
                required DateTime diperbaruiPada,
                Value<int> rowid = const Value.absent(),
              }) => PiutangCompanion.insert(
                id: id,
                nama: nama,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diperbaruiPada: diperbaruiPada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PiutangTable, PiutangData>(table),
                  BaseReferences<
                    _$DompetKuDatabase,
                    $PiutangTable,
                    PiutangData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PiutangTableProcessedTableManager =
    ProcessedTableManager<
      _$DompetKuDatabase,
      $PiutangTable,
      PiutangData,
      $$PiutangTableFilterComposer,
      $$PiutangTableOrderingComposer,
      $$PiutangTableAnnotationComposer,
      $$PiutangTableCreateCompanionBuilder,
      $$PiutangTableUpdateCompanionBuilder,
      (
        PiutangData,
        BaseReferences<_$DompetKuDatabase, $PiutangTable, PiutangData>,
      ),
      PiutangData,
      PrefetchHooks Function()
    >;
typedef $$RiwayatPiutangTableCreateCompanionBuilder =
    RiwayatPiutangCompanion Function({
      required String id,
      required String piutangId,
      required JenisRiwayat jenis,
      required int nominal,
      Value<String?> akunDanaId,
      required DateTime tanggal,
      Value<String?> catatan,
      required DateTime dibuatPada,
      Value<int> rowid,
    });
typedef $$RiwayatPiutangTableUpdateCompanionBuilder =
    RiwayatPiutangCompanion Function({
      Value<String> id,
      Value<String> piutangId,
      Value<JenisRiwayat> jenis,
      Value<int> nominal,
      Value<String?> akunDanaId,
      Value<DateTime> tanggal,
      Value<String?> catatan,
      Value<DateTime> dibuatPada,
      Value<int> rowid,
    });

class $$RiwayatPiutangTableFilterComposer
    extends Composer<_$DompetKuDatabase, $RiwayatPiutangTable> {
  $$RiwayatPiutangTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get piutangId => $composableBuilder(
    column: $table.piutangId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JenisRiwayat, JenisRiwayat, String>
  get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get nominal => $composableBuilder(
    column: $table.nominal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get akunDanaId => $composableBuilder(
    column: $table.akunDanaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiwayatPiutangTableOrderingComposer
    extends Composer<_$DompetKuDatabase, $RiwayatPiutangTable> {
  $$RiwayatPiutangTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get piutangId => $composableBuilder(
    column: $table.piutangId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nominal => $composableBuilder(
    column: $table.nominal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get akunDanaId => $composableBuilder(
    column: $table.akunDanaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiwayatPiutangTableAnnotationComposer
    extends Composer<_$DompetKuDatabase, $RiwayatPiutangTable> {
  $$RiwayatPiutangTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get piutangId =>
      $composableBuilder(column: $table.piutangId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<JenisRiwayat, String> get jenis =>
      $composableBuilder(column: $table.jenis, builder: (column) => column);

  GeneratedColumn<int> get nominal =>
      $composableBuilder(column: $table.nominal, builder: (column) => column);

  GeneratedColumn<String> get akunDanaId => $composableBuilder(
    column: $table.akunDanaId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );
}

class $$RiwayatPiutangTableTableManager
    extends
        RootTableManager<
          _$DompetKuDatabase,
          $RiwayatPiutangTable,
          RiwayatPiutangData,
          $$RiwayatPiutangTableFilterComposer,
          $$RiwayatPiutangTableOrderingComposer,
          $$RiwayatPiutangTableAnnotationComposer,
          $$RiwayatPiutangTableCreateCompanionBuilder,
          $$RiwayatPiutangTableUpdateCompanionBuilder,
          (
            RiwayatPiutangData,
            BaseReferences<
              _$DompetKuDatabase,
              $RiwayatPiutangTable,
              RiwayatPiutangData
            >,
          ),
          RiwayatPiutangData,
          PrefetchHooks Function()
        > {
  $$RiwayatPiutangTableTableManager(
    _$DompetKuDatabase db,
    $RiwayatPiutangTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiwayatPiutangTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiwayatPiutangTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiwayatPiutangTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> piutangId = const Value.absent(),
                Value<JenisRiwayat> jenis = const Value.absent(),
                Value<int> nominal = const Value.absent(),
                Value<String?> akunDanaId = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatPiutangCompanion(
                id: id,
                piutangId: piutangId,
                jenis: jenis,
                nominal: nominal,
                akunDanaId: akunDanaId,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String piutangId,
                required JenisRiwayat jenis,
                required int nominal,
                Value<String?> akunDanaId = const Value.absent(),
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                required DateTime dibuatPada,
                Value<int> rowid = const Value.absent(),
              }) => RiwayatPiutangCompanion.insert(
                id: id,
                piutangId: piutangId,
                jenis: jenis,
                nominal: nominal,
                akunDanaId: akunDanaId,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RiwayatPiutangTable, RiwayatPiutangData>(table),
                  BaseReferences<
                    _$DompetKuDatabase,
                    $RiwayatPiutangTable,
                    RiwayatPiutangData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RiwayatPiutangTableProcessedTableManager =
    ProcessedTableManager<
      _$DompetKuDatabase,
      $RiwayatPiutangTable,
      RiwayatPiutangData,
      $$RiwayatPiutangTableFilterComposer,
      $$RiwayatPiutangTableOrderingComposer,
      $$RiwayatPiutangTableAnnotationComposer,
      $$RiwayatPiutangTableCreateCompanionBuilder,
      $$RiwayatPiutangTableUpdateCompanionBuilder,
      (
        RiwayatPiutangData,
        BaseReferences<
          _$DompetKuDatabase,
          $RiwayatPiutangTable,
          RiwayatPiutangData
        >,
      ),
      RiwayatPiutangData,
      PrefetchHooks Function()
    >;

class $DompetKuDatabaseManager {
  final _$DompetKuDatabase _db;
  $DompetKuDatabaseManager(this._db);
  $$AkunDanaTableTableManager get akunDana =>
      $$AkunDanaTableTableManager(_db, _db.akunDana);
  $$KategoriTableTableManager get kategori =>
      $$KategoriTableTableManager(_db, _db.kategori);
  $$TransaksiTableTableManager get transaksi =>
      $$TransaksiTableTableManager(_db, _db.transaksi);
  $$TransferTableTableManager get transfer =>
      $$TransferTableTableManager(_db, _db.transfer);
  $$PiutangTableTableManager get piutang =>
      $$PiutangTableTableManager(_db, _db.piutang);
  $$RiwayatPiutangTableTableManager get riwayatPiutang =>
      $$RiwayatPiutangTableTableManager(_db, _db.riwayatPiutang);
}
