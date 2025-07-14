// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PaymentCardsTable extends PaymentCards
    with TableInfo<$PaymentCardsTable, PaymentCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardholderNameMeta = const VerificationMeta(
    'cardholderName',
  );
  @override
  late final GeneratedColumn<String> cardholderName = GeneratedColumn<String>(
    'cardholder_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardNameMeta = const VerificationMeta(
    'cardName',
  );
  @override
  late final GeneratedColumn<String> cardName = GeneratedColumn<String>(
    'card_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardNumberMeta = const VerificationMeta(
    'cardNumber',
  );
  @override
  late final GeneratedColumn<String> cardNumber = GeneratedColumn<String>(
    'card_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 16,
      maxTextLength: 19,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<String> expiryDate = GeneratedColumn<String>(
    'expiry_date',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cvvMeta = const VerificationMeta('cvv');
  @override
  late final GeneratedColumn<String> cvv = GeneratedColumn<String>(
    'cvv',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frontImageMeta = const VerificationMeta(
    'frontImage',
  );
  @override
  late final GeneratedColumn<Uint8List> frontImage = GeneratedColumn<Uint8List>(
    'front_image',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backImageMeta = const VerificationMeta(
    'backImage',
  );
  @override
  late final GeneratedColumn<Uint8List> backImage = GeneratedColumn<Uint8List>(
    'back_image',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardholderName,
    cardName,
    cardNumber,
    expiryDate,
    cvv,
    cardType,
    frontImage,
    backImage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cardholder_name')) {
      context.handle(
        _cardholderNameMeta,
        cardholderName.isAcceptableOrUnknown(
          data['cardholder_name']!,
          _cardholderNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cardholderNameMeta);
    }
    if (data.containsKey('card_name')) {
      context.handle(
        _cardNameMeta,
        cardName.isAcceptableOrUnknown(data['card_name']!, _cardNameMeta),
      );
    }
    if (data.containsKey('card_number')) {
      context.handle(
        _cardNumberMeta,
        cardNumber.isAcceptableOrUnknown(data['card_number']!, _cardNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_cardNumberMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('cvv')) {
      context.handle(
        _cvvMeta,
        cvv.isAcceptableOrUnknown(data['cvv']!, _cvvMeta),
      );
    } else if (isInserting) {
      context.missing(_cvvMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    }
    if (data.containsKey('front_image')) {
      context.handle(
        _frontImageMeta,
        frontImage.isAcceptableOrUnknown(data['front_image']!, _frontImageMeta),
      );
    }
    if (data.containsKey('back_image')) {
      context.handle(
        _backImageMeta,
        backImage.isAcceptableOrUnknown(data['back_image']!, _backImageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentCard(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      cardholderName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cardholder_name'],
          )!,
      cardName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_name'],
      ),
      cardNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}card_number'],
          )!,
      expiryDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}expiry_date'],
          )!,
      cvv:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cvv'],
          )!,
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      ),
      frontImage: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}front_image'],
      ),
      backImage: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}back_image'],
      ),
    );
  }

  @override
  $PaymentCardsTable createAlias(String alias) {
    return $PaymentCardsTable(attachedDatabase, alias);
  }
}

class PaymentCard extends DataClass implements Insertable<PaymentCard> {
  final int id;
  final String cardholderName;
  final String? cardName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String? cardType;
  final Uint8List? frontImage;
  final Uint8List? backImage;
  const PaymentCard({
    required this.id,
    required this.cardholderName,
    this.cardName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    this.cardType,
    this.frontImage,
    this.backImage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cardholder_name'] = Variable<String>(cardholderName);
    if (!nullToAbsent || cardName != null) {
      map['card_name'] = Variable<String>(cardName);
    }
    map['card_number'] = Variable<String>(cardNumber);
    map['expiry_date'] = Variable<String>(expiryDate);
    map['cvv'] = Variable<String>(cvv);
    if (!nullToAbsent || cardType != null) {
      map['card_type'] = Variable<String>(cardType);
    }
    if (!nullToAbsent || frontImage != null) {
      map['front_image'] = Variable<Uint8List>(frontImage);
    }
    if (!nullToAbsent || backImage != null) {
      map['back_image'] = Variable<Uint8List>(backImage);
    }
    return map;
  }

  PaymentCardsCompanion toCompanion(bool nullToAbsent) {
    return PaymentCardsCompanion(
      id: Value(id),
      cardholderName: Value(cardholderName),
      cardName:
          cardName == null && nullToAbsent
              ? const Value.absent()
              : Value(cardName),
      cardNumber: Value(cardNumber),
      expiryDate: Value(expiryDate),
      cvv: Value(cvv),
      cardType:
          cardType == null && nullToAbsent
              ? const Value.absent()
              : Value(cardType),
      frontImage:
          frontImage == null && nullToAbsent
              ? const Value.absent()
              : Value(frontImage),
      backImage:
          backImage == null && nullToAbsent
              ? const Value.absent()
              : Value(backImage),
    );
  }

  factory PaymentCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentCard(
      id: serializer.fromJson<int>(json['id']),
      cardholderName: serializer.fromJson<String>(json['cardholderName']),
      cardName: serializer.fromJson<String?>(json['cardName']),
      cardNumber: serializer.fromJson<String>(json['cardNumber']),
      expiryDate: serializer.fromJson<String>(json['expiryDate']),
      cvv: serializer.fromJson<String>(json['cvv']),
      cardType: serializer.fromJson<String?>(json['cardType']),
      frontImage: serializer.fromJson<Uint8List?>(json['frontImage']),
      backImage: serializer.fromJson<Uint8List?>(json['backImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardholderName': serializer.toJson<String>(cardholderName),
      'cardName': serializer.toJson<String?>(cardName),
      'cardNumber': serializer.toJson<String>(cardNumber),
      'expiryDate': serializer.toJson<String>(expiryDate),
      'cvv': serializer.toJson<String>(cvv),
      'cardType': serializer.toJson<String?>(cardType),
      'frontImage': serializer.toJson<Uint8List?>(frontImage),
      'backImage': serializer.toJson<Uint8List?>(backImage),
    };
  }

  PaymentCard copyWith({
    int? id,
    String? cardholderName,
    Value<String?> cardName = const Value.absent(),
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    Value<String?> cardType = const Value.absent(),
    Value<Uint8List?> frontImage = const Value.absent(),
    Value<Uint8List?> backImage = const Value.absent(),
  }) => PaymentCard(
    id: id ?? this.id,
    cardholderName: cardholderName ?? this.cardholderName,
    cardName: cardName.present ? cardName.value : this.cardName,
    cardNumber: cardNumber ?? this.cardNumber,
    expiryDate: expiryDate ?? this.expiryDate,
    cvv: cvv ?? this.cvv,
    cardType: cardType.present ? cardType.value : this.cardType,
    frontImage: frontImage.present ? frontImage.value : this.frontImage,
    backImage: backImage.present ? backImage.value : this.backImage,
  );
  PaymentCard copyWithCompanion(PaymentCardsCompanion data) {
    return PaymentCard(
      id: data.id.present ? data.id.value : this.id,
      cardholderName:
          data.cardholderName.present
              ? data.cardholderName.value
              : this.cardholderName,
      cardName: data.cardName.present ? data.cardName.value : this.cardName,
      cardNumber:
          data.cardNumber.present ? data.cardNumber.value : this.cardNumber,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      cvv: data.cvv.present ? data.cvv.value : this.cvv,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      frontImage:
          data.frontImage.present ? data.frontImage.value : this.frontImage,
      backImage: data.backImage.present ? data.backImage.value : this.backImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentCard(')
          ..write('id: $id, ')
          ..write('cardholderName: $cardholderName, ')
          ..write('cardName: $cardName, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('cvv: $cvv, ')
          ..write('cardType: $cardType, ')
          ..write('frontImage: $frontImage, ')
          ..write('backImage: $backImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardholderName,
    cardName,
    cardNumber,
    expiryDate,
    cvv,
    cardType,
    $driftBlobEquality.hash(frontImage),
    $driftBlobEquality.hash(backImage),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentCard &&
          other.id == this.id &&
          other.cardholderName == this.cardholderName &&
          other.cardName == this.cardName &&
          other.cardNumber == this.cardNumber &&
          other.expiryDate == this.expiryDate &&
          other.cvv == this.cvv &&
          other.cardType == this.cardType &&
          $driftBlobEquality.equals(other.frontImage, this.frontImage) &&
          $driftBlobEquality.equals(other.backImage, this.backImage));
}

class PaymentCardsCompanion extends UpdateCompanion<PaymentCard> {
  final Value<int> id;
  final Value<String> cardholderName;
  final Value<String?> cardName;
  final Value<String> cardNumber;
  final Value<String> expiryDate;
  final Value<String> cvv;
  final Value<String?> cardType;
  final Value<Uint8List?> frontImage;
  final Value<Uint8List?> backImage;
  const PaymentCardsCompanion({
    this.id = const Value.absent(),
    this.cardholderName = const Value.absent(),
    this.cardName = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.cvv = const Value.absent(),
    this.cardType = const Value.absent(),
    this.frontImage = const Value.absent(),
    this.backImage = const Value.absent(),
  });
  PaymentCardsCompanion.insert({
    this.id = const Value.absent(),
    required String cardholderName,
    this.cardName = const Value.absent(),
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    this.cardType = const Value.absent(),
    this.frontImage = const Value.absent(),
    this.backImage = const Value.absent(),
  }) : cardholderName = Value(cardholderName),
       cardNumber = Value(cardNumber),
       expiryDate = Value(expiryDate),
       cvv = Value(cvv);
  static Insertable<PaymentCard> custom({
    Expression<int>? id,
    Expression<String>? cardholderName,
    Expression<String>? cardName,
    Expression<String>? cardNumber,
    Expression<String>? expiryDate,
    Expression<String>? cvv,
    Expression<String>? cardType,
    Expression<Uint8List>? frontImage,
    Expression<Uint8List>? backImage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardholderName != null) 'cardholder_name': cardholderName,
      if (cardName != null) 'card_name': cardName,
      if (cardNumber != null) 'card_number': cardNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (cvv != null) 'cvv': cvv,
      if (cardType != null) 'card_type': cardType,
      if (frontImage != null) 'front_image': frontImage,
      if (backImage != null) 'back_image': backImage,
    });
  }

  PaymentCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? cardholderName,
    Value<String?>? cardName,
    Value<String>? cardNumber,
    Value<String>? expiryDate,
    Value<String>? cvv,
    Value<String?>? cardType,
    Value<Uint8List?>? frontImage,
    Value<Uint8List?>? backImage,
  }) {
    return PaymentCardsCompanion(
      id: id ?? this.id,
      cardholderName: cardholderName ?? this.cardholderName,
      cardName: cardName ?? this.cardName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardType: cardType ?? this.cardType,
      frontImage: frontImage ?? this.frontImage,
      backImage: backImage ?? this.backImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardholderName.present) {
      map['cardholder_name'] = Variable<String>(cardholderName.value);
    }
    if (cardName.present) {
      map['card_name'] = Variable<String>(cardName.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String>(cardNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (cvv.present) {
      map['cvv'] = Variable<String>(cvv.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (frontImage.present) {
      map['front_image'] = Variable<Uint8List>(frontImage.value);
    }
    if (backImage.present) {
      map['back_image'] = Variable<Uint8List>(backImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentCardsCompanion(')
          ..write('id: $id, ')
          ..write('cardholderName: $cardholderName, ')
          ..write('cardName: $cardName, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('cvv: $cvv, ')
          ..write('cardType: $cardType, ')
          ..write('frontImage: $frontImage, ')
          ..write('backImage: $backImage')
          ..write(')'))
        .toString();
  }
}

class $LibraryCardsTable extends LibraryCards
    with TableInfo<$LibraryCardsTable, LibraryCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>(
        'registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  @override
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionMeta = const VerificationMeta(
    'session',
  );
  @override
  late final GeneratedColumn<String> session = GeneratedColumn<String>(
    'session',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImageMeta = const VerificationMeta(
    'profileImage',
  );
  @override
  late final GeneratedColumn<Uint8List> profileImage =
      GeneratedColumn<Uint8List>(
        'profile_image',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    idNumber,
    registrationNumber,
    course,
    session,
    school,
    profileImage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_idNumberMeta);
    }
    if (data.containsKey('registration_number')) {
      context.handle(
        _registrationNumberMeta,
        registrationNumber.isAcceptableOrUnknown(
          data['registration_number']!,
          _registrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    }
    if (data.containsKey('session')) {
      context.handle(
        _sessionMeta,
        session.isAcceptableOrUnknown(data['session']!, _sessionMeta),
      );
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    }
    if (data.containsKey('profile_image')) {
      context.handle(
        _profileImageMeta,
        profileImage.isAcceptableOrUnknown(
          data['profile_image']!,
          _profileImageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryCard(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      idNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id_number'],
          )!,
      registrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_number'],
      ),
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      ),
      session: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session'],
      ),
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      ),
      profileImage: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}profile_image'],
      ),
    );
  }

  @override
  $LibraryCardsTable createAlias(String alias) {
    return $LibraryCardsTable(attachedDatabase, alias);
  }
}

class LibraryCard extends DataClass implements Insertable<LibraryCard> {
  final int id;
  final String name;
  final String idNumber;
  final String? registrationNumber;
  final String? course;
  final String? session;
  final String? school;
  final Uint8List? profileImage;
  const LibraryCard({
    required this.id,
    required this.name,
    required this.idNumber,
    this.registrationNumber,
    this.course,
    this.session,
    this.school,
    this.profileImage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['id_number'] = Variable<String>(idNumber);
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String>(registrationNumber);
    }
    if (!nullToAbsent || course != null) {
      map['course'] = Variable<String>(course);
    }
    if (!nullToAbsent || session != null) {
      map['session'] = Variable<String>(session);
    }
    if (!nullToAbsent || school != null) {
      map['school'] = Variable<String>(school);
    }
    if (!nullToAbsent || profileImage != null) {
      map['profile_image'] = Variable<Uint8List>(profileImage);
    }
    return map;
  }

  LibraryCardsCompanion toCompanion(bool nullToAbsent) {
    return LibraryCardsCompanion(
      id: Value(id),
      name: Value(name),
      idNumber: Value(idNumber),
      registrationNumber:
          registrationNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(registrationNumber),
      course:
          course == null && nullToAbsent ? const Value.absent() : Value(course),
      session:
          session == null && nullToAbsent
              ? const Value.absent()
              : Value(session),
      school:
          school == null && nullToAbsent ? const Value.absent() : Value(school),
      profileImage:
          profileImage == null && nullToAbsent
              ? const Value.absent()
              : Value(profileImage),
    );
  }

  factory LibraryCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryCard(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      idNumber: serializer.fromJson<String>(json['idNumber']),
      registrationNumber: serializer.fromJson<String?>(
        json['registrationNumber'],
      ),
      course: serializer.fromJson<String?>(json['course']),
      session: serializer.fromJson<String?>(json['session']),
      school: serializer.fromJson<String?>(json['school']),
      profileImage: serializer.fromJson<Uint8List?>(json['profileImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'idNumber': serializer.toJson<String>(idNumber),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'course': serializer.toJson<String?>(course),
      'session': serializer.toJson<String?>(session),
      'school': serializer.toJson<String?>(school),
      'profileImage': serializer.toJson<Uint8List?>(profileImage),
    };
  }

  LibraryCard copyWith({
    int? id,
    String? name,
    String? idNumber,
    Value<String?> registrationNumber = const Value.absent(),
    Value<String?> course = const Value.absent(),
    Value<String?> session = const Value.absent(),
    Value<String?> school = const Value.absent(),
    Value<Uint8List?> profileImage = const Value.absent(),
  }) => LibraryCard(
    id: id ?? this.id,
    name: name ?? this.name,
    idNumber: idNumber ?? this.idNumber,
    registrationNumber:
        registrationNumber.present
            ? registrationNumber.value
            : this.registrationNumber,
    course: course.present ? course.value : this.course,
    session: session.present ? session.value : this.session,
    school: school.present ? school.value : this.school,
    profileImage: profileImage.present ? profileImage.value : this.profileImage,
  );
  LibraryCard copyWithCompanion(LibraryCardsCompanion data) {
    return LibraryCard(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      registrationNumber:
          data.registrationNumber.present
              ? data.registrationNumber.value
              : this.registrationNumber,
      course: data.course.present ? data.course.value : this.course,
      session: data.session.present ? data.session.value : this.session,
      school: data.school.present ? data.school.value : this.school,
      profileImage:
          data.profileImage.present
              ? data.profileImage.value
              : this.profileImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryCard(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('idNumber: $idNumber, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('course: $course, ')
          ..write('session: $session, ')
          ..write('school: $school, ')
          ..write('profileImage: $profileImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    idNumber,
    registrationNumber,
    course,
    session,
    school,
    $driftBlobEquality.hash(profileImage),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryCard &&
          other.id == this.id &&
          other.name == this.name &&
          other.idNumber == this.idNumber &&
          other.registrationNumber == this.registrationNumber &&
          other.course == this.course &&
          other.session == this.session &&
          other.school == this.school &&
          $driftBlobEquality.equals(other.profileImage, this.profileImage));
}

class LibraryCardsCompanion extends UpdateCompanion<LibraryCard> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> idNumber;
  final Value<String?> registrationNumber;
  final Value<String?> course;
  final Value<String?> session;
  final Value<String?> school;
  final Value<Uint8List?> profileImage;
  const LibraryCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.course = const Value.absent(),
    this.session = const Value.absent(),
    this.school = const Value.absent(),
    this.profileImage = const Value.absent(),
  });
  LibraryCardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String idNumber,
    this.registrationNumber = const Value.absent(),
    this.course = const Value.absent(),
    this.session = const Value.absent(),
    this.school = const Value.absent(),
    this.profileImage = const Value.absent(),
  }) : name = Value(name),
       idNumber = Value(idNumber);
  static Insertable<LibraryCard> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? idNumber,
    Expression<String>? registrationNumber,
    Expression<String>? course,
    Expression<String>? session,
    Expression<String>? school,
    Expression<Uint8List>? profileImage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (idNumber != null) 'id_number': idNumber,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (course != null) 'course': course,
      if (session != null) 'session': session,
      if (school != null) 'school': school,
      if (profileImage != null) 'profile_image': profileImage,
    });
  }

  LibraryCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? idNumber,
    Value<String?>? registrationNumber,
    Value<String?>? course,
    Value<String?>? session,
    Value<String?>? school,
    Value<Uint8List?>? profileImage,
  }) {
    return LibraryCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      idNumber: idNumber ?? this.idNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      course: course ?? this.course,
      session: session ?? this.session,
      school: school ?? this.school,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (session.present) {
      map['session'] = Variable<String>(session.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<Uint8List>(profileImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('idNumber: $idNumber, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('course: $course, ')
          ..write('session: $session, ')
          ..write('school: $school, ')
          ..write('profileImage: $profileImage')
          ..write(')'))
        .toString();
  }
}

class $CustomCardsTable extends CustomCards
    with TableInfo<$CustomCardsTable, CustomCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardNameMeta = const VerificationMeta(
    'cardName',
  );
  @override
  late final GeneratedColumn<String> cardName = GeneratedColumn<String>(
    'card_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frontImageMeta = const VerificationMeta(
    'frontImage',
  );
  @override
  late final GeneratedColumn<Uint8List> frontImage = GeneratedColumn<Uint8List>(
    'front_image',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backImageMeta = const VerificationMeta(
    'backImage',
  );
  @override
  late final GeneratedColumn<Uint8List> backImage = GeneratedColumn<Uint8List>(
    'back_image',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cardName, frontImage, backImage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_name')) {
      context.handle(
        _cardNameMeta,
        cardName.isAcceptableOrUnknown(data['card_name']!, _cardNameMeta),
      );
    } else if (isInserting) {
      context.missing(_cardNameMeta);
    }
    if (data.containsKey('front_image')) {
      context.handle(
        _frontImageMeta,
        frontImage.isAcceptableOrUnknown(data['front_image']!, _frontImageMeta),
      );
    }
    if (data.containsKey('back_image')) {
      context.handle(
        _backImageMeta,
        backImage.isAcceptableOrUnknown(data['back_image']!, _backImageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCard(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      cardName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}card_name'],
          )!,
      frontImage: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}front_image'],
      ),
      backImage: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}back_image'],
      ),
    );
  }

  @override
  $CustomCardsTable createAlias(String alias) {
    return $CustomCardsTable(attachedDatabase, alias);
  }
}

class CustomCard extends DataClass implements Insertable<CustomCard> {
  final int id;
  final String cardName;
  final Uint8List? frontImage;
  final Uint8List? backImage;
  const CustomCard({
    required this.id,
    required this.cardName,
    this.frontImage,
    this.backImage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_name'] = Variable<String>(cardName);
    if (!nullToAbsent || frontImage != null) {
      map['front_image'] = Variable<Uint8List>(frontImage);
    }
    if (!nullToAbsent || backImage != null) {
      map['back_image'] = Variable<Uint8List>(backImage);
    }
    return map;
  }

  CustomCardsCompanion toCompanion(bool nullToAbsent) {
    return CustomCardsCompanion(
      id: Value(id),
      cardName: Value(cardName),
      frontImage:
          frontImage == null && nullToAbsent
              ? const Value.absent()
              : Value(frontImage),
      backImage:
          backImage == null && nullToAbsent
              ? const Value.absent()
              : Value(backImage),
    );
  }

  factory CustomCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCard(
      id: serializer.fromJson<int>(json['id']),
      cardName: serializer.fromJson<String>(json['cardName']),
      frontImage: serializer.fromJson<Uint8List?>(json['frontImage']),
      backImage: serializer.fromJson<Uint8List?>(json['backImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardName': serializer.toJson<String>(cardName),
      'frontImage': serializer.toJson<Uint8List?>(frontImage),
      'backImage': serializer.toJson<Uint8List?>(backImage),
    };
  }

  CustomCard copyWith({
    int? id,
    String? cardName,
    Value<Uint8List?> frontImage = const Value.absent(),
    Value<Uint8List?> backImage = const Value.absent(),
  }) => CustomCard(
    id: id ?? this.id,
    cardName: cardName ?? this.cardName,
    frontImage: frontImage.present ? frontImage.value : this.frontImage,
    backImage: backImage.present ? backImage.value : this.backImage,
  );
  CustomCard copyWithCompanion(CustomCardsCompanion data) {
    return CustomCard(
      id: data.id.present ? data.id.value : this.id,
      cardName: data.cardName.present ? data.cardName.value : this.cardName,
      frontImage:
          data.frontImage.present ? data.frontImage.value : this.frontImage,
      backImage: data.backImage.present ? data.backImage.value : this.backImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCard(')
          ..write('id: $id, ')
          ..write('cardName: $cardName, ')
          ..write('frontImage: $frontImage, ')
          ..write('backImage: $backImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardName,
    $driftBlobEquality.hash(frontImage),
    $driftBlobEquality.hash(backImage),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCard &&
          other.id == this.id &&
          other.cardName == this.cardName &&
          $driftBlobEquality.equals(other.frontImage, this.frontImage) &&
          $driftBlobEquality.equals(other.backImage, this.backImage));
}

class CustomCardsCompanion extends UpdateCompanion<CustomCard> {
  final Value<int> id;
  final Value<String> cardName;
  final Value<Uint8List?> frontImage;
  final Value<Uint8List?> backImage;
  const CustomCardsCompanion({
    this.id = const Value.absent(),
    this.cardName = const Value.absent(),
    this.frontImage = const Value.absent(),
    this.backImage = const Value.absent(),
  });
  CustomCardsCompanion.insert({
    this.id = const Value.absent(),
    required String cardName,
    this.frontImage = const Value.absent(),
    this.backImage = const Value.absent(),
  }) : cardName = Value(cardName);
  static Insertable<CustomCard> custom({
    Expression<int>? id,
    Expression<String>? cardName,
    Expression<Uint8List>? frontImage,
    Expression<Uint8List>? backImage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardName != null) 'card_name': cardName,
      if (frontImage != null) 'front_image': frontImage,
      if (backImage != null) 'back_image': backImage,
    });
  }

  CustomCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? cardName,
    Value<Uint8List?>? frontImage,
    Value<Uint8List?>? backImage,
  }) {
    return CustomCardsCompanion(
      id: id ?? this.id,
      cardName: cardName ?? this.cardName,
      frontImage: frontImage ?? this.frontImage,
      backImage: backImage ?? this.backImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardName.present) {
      map['card_name'] = Variable<String>(cardName.value);
    }
    if (frontImage.present) {
      map['front_image'] = Variable<Uint8List>(frontImage.value);
    }
    if (backImage.present) {
      map['back_image'] = Variable<Uint8List>(backImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCardsCompanion(')
          ..write('id: $id, ')
          ..write('cardName: $cardName, ')
          ..write('frontImage: $frontImage, ')
          ..write('backImage: $backImage')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> images =
      GeneratedColumn<String>(
        'images',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant('[]'),
      ).withConverter<List<String>>($NotesTable.$converterimages);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    createdAt,
    theme,
    images,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      ),
      images: $NotesTable.$converterimages.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}images'],
        )!,
      ),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterimages =
      const ImageListConverter();
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? theme;
  final List<String> images;
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.theme,
    required this.images,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || theme != null) {
      map['theme'] = Variable<String>(theme);
    }
    {
      map['images'] = Variable<String>(
        $NotesTable.$converterimages.toSql(images),
      );
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      theme:
          theme == null && nullToAbsent ? const Value.absent() : Value(theme),
      images: Value(images),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      theme: serializer.fromJson<String?>(json['theme']),
      images: serializer.fromJson<List<String>>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'theme': serializer.toJson<String?>(theme),
      'images': serializer.toJson<List<String>>(images),
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    Value<String?> theme = const Value.absent(),
    List<String>? images,
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    theme: theme.present ? theme.value : this.theme,
    images: images ?? this.images,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      theme: data.theme.present ? data.theme.value : this.theme,
      images: data.images.present ? data.images.value : this.images,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('theme: $theme, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, createdAt, theme, images);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.theme == this.theme &&
          other.images == this.images);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<String?> theme;
  final Value<List<String>> images;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.theme = const Value.absent(),
    this.images = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    this.createdAt = const Value.absent(),
    this.theme = const Value.absent(),
    this.images = const Value.absent(),
  }) : title = Value(title),
       content = Value(content);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<String>? theme,
    Expression<String>? images,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (theme != null) 'theme': theme,
      if (images != null) 'images': images,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<String?>? theme,
    Value<List<String>>? images,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      theme: theme ?? this.theme,
      images: images ?? this.images,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(
        $NotesTable.$converterimages.toSql(images.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('theme: $theme, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }
}

class $VerificationCodesTable extends VerificationCodes
    with TableInfo<$VerificationCodesTable, VerificationCode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerificationCodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _issuerMeta = const VerificationMeta('issuer');
  @override
  late final GeneratedColumn<String> issuer = GeneratedColumn<String>(
    'issuer',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secretKeyMeta = const VerificationMeta(
    'secretKey',
  );
  @override
  late final GeneratedColumn<String> secretKey = GeneratedColumn<String>(
    'secret_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    issuer,
    accountName,
    secretKey,
    logoUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verification_codes';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerificationCode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('issuer')) {
      context.handle(
        _issuerMeta,
        issuer.isAcceptableOrUnknown(data['issuer']!, _issuerMeta),
      );
    } else if (isInserting) {
      context.missing(_issuerMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('secret_key')) {
      context.handle(
        _secretKeyMeta,
        secretKey.isAcceptableOrUnknown(data['secret_key']!, _secretKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_secretKeyMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerificationCode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerificationCode(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      issuer:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}issuer'],
          )!,
      accountName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}account_name'],
          )!,
      secretKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}secret_key'],
          )!,
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
    );
  }

  @override
  $VerificationCodesTable createAlias(String alias) {
    return $VerificationCodesTable(attachedDatabase, alias);
  }
}

class VerificationCode extends DataClass
    implements Insertable<VerificationCode> {
  final int id;
  final String issuer;
  final String accountName;
  final String secretKey;
  final String? logoUrl;
  const VerificationCode({
    required this.id,
    required this.issuer,
    required this.accountName,
    required this.secretKey,
    this.logoUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['issuer'] = Variable<String>(issuer);
    map['account_name'] = Variable<String>(accountName);
    map['secret_key'] = Variable<String>(secretKey);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    return map;
  }

  VerificationCodesCompanion toCompanion(bool nullToAbsent) {
    return VerificationCodesCompanion(
      id: Value(id),
      issuer: Value(issuer),
      accountName: Value(accountName),
      secretKey: Value(secretKey),
      logoUrl:
          logoUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(logoUrl),
    );
  }

  factory VerificationCode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerificationCode(
      id: serializer.fromJson<int>(json['id']),
      issuer: serializer.fromJson<String>(json['issuer']),
      accountName: serializer.fromJson<String>(json['accountName']),
      secretKey: serializer.fromJson<String>(json['secretKey']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'issuer': serializer.toJson<String>(issuer),
      'accountName': serializer.toJson<String>(accountName),
      'secretKey': serializer.toJson<String>(secretKey),
      'logoUrl': serializer.toJson<String?>(logoUrl),
    };
  }

  VerificationCode copyWith({
    int? id,
    String? issuer,
    String? accountName,
    String? secretKey,
    Value<String?> logoUrl = const Value.absent(),
  }) => VerificationCode(
    id: id ?? this.id,
    issuer: issuer ?? this.issuer,
    accountName: accountName ?? this.accountName,
    secretKey: secretKey ?? this.secretKey,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
  );
  VerificationCode copyWithCompanion(VerificationCodesCompanion data) {
    return VerificationCode(
      id: data.id.present ? data.id.value : this.id,
      issuer: data.issuer.present ? data.issuer.value : this.issuer,
      accountName:
          data.accountName.present ? data.accountName.value : this.accountName,
      secretKey: data.secretKey.present ? data.secretKey.value : this.secretKey,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerificationCode(')
          ..write('id: $id, ')
          ..write('issuer: $issuer, ')
          ..write('accountName: $accountName, ')
          ..write('secretKey: $secretKey, ')
          ..write('logoUrl: $logoUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, issuer, accountName, secretKey, logoUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerificationCode &&
          other.id == this.id &&
          other.issuer == this.issuer &&
          other.accountName == this.accountName &&
          other.secretKey == this.secretKey &&
          other.logoUrl == this.logoUrl);
}

class VerificationCodesCompanion extends UpdateCompanion<VerificationCode> {
  final Value<int> id;
  final Value<String> issuer;
  final Value<String> accountName;
  final Value<String> secretKey;
  final Value<String?> logoUrl;
  const VerificationCodesCompanion({
    this.id = const Value.absent(),
    this.issuer = const Value.absent(),
    this.accountName = const Value.absent(),
    this.secretKey = const Value.absent(),
    this.logoUrl = const Value.absent(),
  });
  VerificationCodesCompanion.insert({
    this.id = const Value.absent(),
    required String issuer,
    required String accountName,
    required String secretKey,
    this.logoUrl = const Value.absent(),
  }) : issuer = Value(issuer),
       accountName = Value(accountName),
       secretKey = Value(secretKey);
  static Insertable<VerificationCode> custom({
    Expression<int>? id,
    Expression<String>? issuer,
    Expression<String>? accountName,
    Expression<String>? secretKey,
    Expression<String>? logoUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (issuer != null) 'issuer': issuer,
      if (accountName != null) 'account_name': accountName,
      if (secretKey != null) 'secret_key': secretKey,
      if (logoUrl != null) 'logo_url': logoUrl,
    });
  }

  VerificationCodesCompanion copyWith({
    Value<int>? id,
    Value<String>? issuer,
    Value<String>? accountName,
    Value<String>? secretKey,
    Value<String?>? logoUrl,
  }) {
    return VerificationCodesCompanion(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      accountName: accountName ?? this.accountName,
      secretKey: secretKey ?? this.secretKey,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (issuer.present) {
      map['issuer'] = Variable<String>(issuer.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (secretKey.present) {
      map['secret_key'] = Variable<String>(secretKey.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerificationCodesCompanion(')
          ..write('id: $id, ')
          ..write('issuer: $issuer, ')
          ..write('accountName: $accountName, ')
          ..write('secretKey: $secretKey, ')
          ..write('logoUrl: $logoUrl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PaymentCardsTable paymentCards = $PaymentCardsTable(this);
  late final $LibraryCardsTable libraryCards = $LibraryCardsTable(this);
  late final $CustomCardsTable customCards = $CustomCardsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $VerificationCodesTable verificationCodes =
      $VerificationCodesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    paymentCards,
    libraryCards,
    customCards,
    notes,
    verificationCodes,
  ];
}

typedef $$PaymentCardsTableCreateCompanionBuilder =
    PaymentCardsCompanion Function({
      Value<int> id,
      required String cardholderName,
      Value<String?> cardName,
      required String cardNumber,
      required String expiryDate,
      required String cvv,
      Value<String?> cardType,
      Value<Uint8List?> frontImage,
      Value<Uint8List?> backImage,
    });
typedef $$PaymentCardsTableUpdateCompanionBuilder =
    PaymentCardsCompanion Function({
      Value<int> id,
      Value<String> cardholderName,
      Value<String?> cardName,
      Value<String> cardNumber,
      Value<String> expiryDate,
      Value<String> cvv,
      Value<String?> cardType,
      Value<Uint8List?> frontImage,
      Value<Uint8List?> backImage,
    });

class $$PaymentCardsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardName => $composableBuilder(
    column: $table.cardName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cvv => $composableBuilder(
    column: $table.cvv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get frontImage => $composableBuilder(
    column: $table.frontImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get backImage => $composableBuilder(
    column: $table.backImage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardName => $composableBuilder(
    column: $table.cardName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cvv => $composableBuilder(
    column: $table.cvv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get frontImage => $composableBuilder(
    column: $table.frontImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get backImage => $composableBuilder(
    column: $table.backImage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardName =>
      $composableBuilder(column: $table.cardName, builder: (column) => column);

  GeneratedColumn<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cvv =>
      $composableBuilder(column: $table.cvv, builder: (column) => column);

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<Uint8List> get frontImage => $composableBuilder(
    column: $table.frontImage,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get backImage =>
      $composableBuilder(column: $table.backImage, builder: (column) => column);
}

class $$PaymentCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentCardsTable,
          PaymentCard,
          $$PaymentCardsTableFilterComposer,
          $$PaymentCardsTableOrderingComposer,
          $$PaymentCardsTableAnnotationComposer,
          $$PaymentCardsTableCreateCompanionBuilder,
          $$PaymentCardsTableUpdateCompanionBuilder,
          (
            PaymentCard,
            BaseReferences<_$AppDatabase, $PaymentCardsTable, PaymentCard>,
          ),
          PaymentCard,
          PrefetchHooks Function()
        > {
  $$PaymentCardsTableTableManager(_$AppDatabase db, $PaymentCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PaymentCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PaymentCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$PaymentCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardholderName = const Value.absent(),
                Value<String?> cardName = const Value.absent(),
                Value<String> cardNumber = const Value.absent(),
                Value<String> expiryDate = const Value.absent(),
                Value<String> cvv = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<Uint8List?> frontImage = const Value.absent(),
                Value<Uint8List?> backImage = const Value.absent(),
              }) => PaymentCardsCompanion(
                id: id,
                cardholderName: cardholderName,
                cardName: cardName,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cvv: cvv,
                cardType: cardType,
                frontImage: frontImage,
                backImage: backImage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardholderName,
                Value<String?> cardName = const Value.absent(),
                required String cardNumber,
                required String expiryDate,
                required String cvv,
                Value<String?> cardType = const Value.absent(),
                Value<Uint8List?> frontImage = const Value.absent(),
                Value<Uint8List?> backImage = const Value.absent(),
              }) => PaymentCardsCompanion.insert(
                id: id,
                cardholderName: cardholderName,
                cardName: cardName,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cvv: cvv,
                cardType: cardType,
                frontImage: frontImage,
                backImage: backImage,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentCardsTable,
      PaymentCard,
      $$PaymentCardsTableFilterComposer,
      $$PaymentCardsTableOrderingComposer,
      $$PaymentCardsTableAnnotationComposer,
      $$PaymentCardsTableCreateCompanionBuilder,
      $$PaymentCardsTableUpdateCompanionBuilder,
      (
        PaymentCard,
        BaseReferences<_$AppDatabase, $PaymentCardsTable, PaymentCard>,
      ),
      PaymentCard,
      PrefetchHooks Function()
    >;
typedef $$LibraryCardsTableCreateCompanionBuilder =
    LibraryCardsCompanion Function({
      Value<int> id,
      required String name,
      required String idNumber,
      Value<String?> registrationNumber,
      Value<String?> course,
      Value<String?> session,
      Value<String?> school,
      Value<Uint8List?> profileImage,
    });
typedef $$LibraryCardsTableUpdateCompanionBuilder =
    LibraryCardsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> idNumber,
      Value<String?> registrationNumber,
      Value<String?> course,
      Value<String?> session,
      Value<String?> school,
      Value<Uint8List?> profileImage,
    });

class $$LibraryCardsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryCardsTable> {
  $$LibraryCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get session => $composableBuilder(
    column: $table.session,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryCardsTable> {
  $$LibraryCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get session => $composableBuilder(
    column: $table.session,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryCardsTable> {
  $$LibraryCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get course =>
      $composableBuilder(column: $table.course, builder: (column) => column);

  GeneratedColumn<String> get session =>
      $composableBuilder(column: $table.session, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<Uint8List> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => column,
  );
}

class $$LibraryCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryCardsTable,
          LibraryCard,
          $$LibraryCardsTableFilterComposer,
          $$LibraryCardsTableOrderingComposer,
          $$LibraryCardsTableAnnotationComposer,
          $$LibraryCardsTableCreateCompanionBuilder,
          $$LibraryCardsTableUpdateCompanionBuilder,
          (
            LibraryCard,
            BaseReferences<_$AppDatabase, $LibraryCardsTable, LibraryCard>,
          ),
          LibraryCard,
          PrefetchHooks Function()
        > {
  $$LibraryCardsTableTableManager(_$AppDatabase db, $LibraryCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LibraryCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LibraryCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$LibraryCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> idNumber = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                Value<String?> course = const Value.absent(),
                Value<String?> session = const Value.absent(),
                Value<String?> school = const Value.absent(),
                Value<Uint8List?> profileImage = const Value.absent(),
              }) => LibraryCardsCompanion(
                id: id,
                name: name,
                idNumber: idNumber,
                registrationNumber: registrationNumber,
                course: course,
                session: session,
                school: school,
                profileImage: profileImage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String idNumber,
                Value<String?> registrationNumber = const Value.absent(),
                Value<String?> course = const Value.absent(),
                Value<String?> session = const Value.absent(),
                Value<String?> school = const Value.absent(),
                Value<Uint8List?> profileImage = const Value.absent(),
              }) => LibraryCardsCompanion.insert(
                id: id,
                name: name,
                idNumber: idNumber,
                registrationNumber: registrationNumber,
                course: course,
                session: session,
                school: school,
                profileImage: profileImage,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryCardsTable,
      LibraryCard,
      $$LibraryCardsTableFilterComposer,
      $$LibraryCardsTableOrderingComposer,
      $$LibraryCardsTableAnnotationComposer,
      $$LibraryCardsTableCreateCompanionBuilder,
      $$LibraryCardsTableUpdateCompanionBuilder,
      (
        LibraryCard,
        BaseReferences<_$AppDatabase, $LibraryCardsTable, LibraryCard>,
      ),
      LibraryCard,
      PrefetchHooks Function()
    >;
typedef $$CustomCardsTableCreateCompanionBuilder =
    CustomCardsCompanion Function({
      Value<int> id,
      required String cardName,
      Value<Uint8List?> frontImage,
      Value<Uint8List?> backImage,
    });
typedef $$CustomCardsTableUpdateCompanionBuilder =
    CustomCardsCompanion Function({
      Value<int> id,
      Value<String> cardName,
      Value<Uint8List?> frontImage,
      Value<Uint8List?> backImage,
    });

class $$CustomCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardName => $composableBuilder(
    column: $table.cardName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get frontImage => $composableBuilder(
    column: $table.frontImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get backImage => $composableBuilder(
    column: $table.backImage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardName => $composableBuilder(
    column: $table.cardName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get frontImage => $composableBuilder(
    column: $table.frontImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get backImage => $composableBuilder(
    column: $table.backImage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardName =>
      $composableBuilder(column: $table.cardName, builder: (column) => column);

  GeneratedColumn<Uint8List> get frontImage => $composableBuilder(
    column: $table.frontImage,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get backImage =>
      $composableBuilder(column: $table.backImage, builder: (column) => column);
}

class $$CustomCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomCardsTable,
          CustomCard,
          $$CustomCardsTableFilterComposer,
          $$CustomCardsTableOrderingComposer,
          $$CustomCardsTableAnnotationComposer,
          $$CustomCardsTableCreateCompanionBuilder,
          $$CustomCardsTableUpdateCompanionBuilder,
          (
            CustomCard,
            BaseReferences<_$AppDatabase, $CustomCardsTable, CustomCard>,
          ),
          CustomCard,
          PrefetchHooks Function()
        > {
  $$CustomCardsTableTableManager(_$AppDatabase db, $CustomCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CustomCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CustomCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$CustomCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardName = const Value.absent(),
                Value<Uint8List?> frontImage = const Value.absent(),
                Value<Uint8List?> backImage = const Value.absent(),
              }) => CustomCardsCompanion(
                id: id,
                cardName: cardName,
                frontImage: frontImage,
                backImage: backImage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardName,
                Value<Uint8List?> frontImage = const Value.absent(),
                Value<Uint8List?> backImage = const Value.absent(),
              }) => CustomCardsCompanion.insert(
                id: id,
                cardName: cardName,
                frontImage: frontImage,
                backImage: backImage,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomCardsTable,
      CustomCard,
      $$CustomCardsTableFilterComposer,
      $$CustomCardsTableOrderingComposer,
      $$CustomCardsTableAnnotationComposer,
      $$CustomCardsTableCreateCompanionBuilder,
      $$CustomCardsTableUpdateCompanionBuilder,
      (
        CustomCard,
        BaseReferences<_$AppDatabase, $CustomCardsTable, CustomCard>,
      ),
      CustomCard,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required String title,
      required String content,
      Value<DateTime> createdAt,
      Value<String?> theme,
      Value<List<String>> images,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<String?> theme,
      Value<List<String>> images,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> theme = const Value.absent(),
                Value<List<String>> images = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                theme: theme,
                images: images,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> theme = const Value.absent(),
                Value<List<String>> images = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                title: title,
                content: content,
                createdAt: createdAt,
                theme: theme,
                images: images,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$VerificationCodesTableCreateCompanionBuilder =
    VerificationCodesCompanion Function({
      Value<int> id,
      required String issuer,
      required String accountName,
      required String secretKey,
      Value<String?> logoUrl,
    });
typedef $$VerificationCodesTableUpdateCompanionBuilder =
    VerificationCodesCompanion Function({
      Value<int> id,
      Value<String> issuer,
      Value<String> accountName,
      Value<String> secretKey,
      Value<String?> logoUrl,
    });

class $$VerificationCodesTableFilterComposer
    extends Composer<_$AppDatabase, $VerificationCodesTable> {
  $$VerificationCodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issuer => $composableBuilder(
    column: $table.issuer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secretKey => $composableBuilder(
    column: $table.secretKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VerificationCodesTableOrderingComposer
    extends Composer<_$AppDatabase, $VerificationCodesTable> {
  $$VerificationCodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issuer => $composableBuilder(
    column: $table.issuer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secretKey => $composableBuilder(
    column: $table.secretKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VerificationCodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerificationCodesTable> {
  $$VerificationCodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secretKey =>
      $composableBuilder(column: $table.secretKey, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);
}

class $$VerificationCodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerificationCodesTable,
          VerificationCode,
          $$VerificationCodesTableFilterComposer,
          $$VerificationCodesTableOrderingComposer,
          $$VerificationCodesTableAnnotationComposer,
          $$VerificationCodesTableCreateCompanionBuilder,
          $$VerificationCodesTableUpdateCompanionBuilder,
          (
            VerificationCode,
            BaseReferences<
              _$AppDatabase,
              $VerificationCodesTable,
              VerificationCode
            >,
          ),
          VerificationCode,
          PrefetchHooks Function()
        > {
  $$VerificationCodesTableTableManager(
    _$AppDatabase db,
    $VerificationCodesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VerificationCodesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$VerificationCodesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$VerificationCodesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> issuer = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<String> secretKey = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
              }) => VerificationCodesCompanion(
                id: id,
                issuer: issuer,
                accountName: accountName,
                secretKey: secretKey,
                logoUrl: logoUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String issuer,
                required String accountName,
                required String secretKey,
                Value<String?> logoUrl = const Value.absent(),
              }) => VerificationCodesCompanion.insert(
                id: id,
                issuer: issuer,
                accountName: accountName,
                secretKey: secretKey,
                logoUrl: logoUrl,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VerificationCodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerificationCodesTable,
      VerificationCode,
      $$VerificationCodesTableFilterComposer,
      $$VerificationCodesTableOrderingComposer,
      $$VerificationCodesTableAnnotationComposer,
      $$VerificationCodesTableCreateCompanionBuilder,
      $$VerificationCodesTableUpdateCompanionBuilder,
      (
        VerificationCode,
        BaseReferences<
          _$AppDatabase,
          $VerificationCodesTable,
          VerificationCode
        >,
      ),
      VerificationCode,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PaymentCardsTableTableManager get paymentCards =>
      $$PaymentCardsTableTableManager(_db, _db.paymentCards);
  $$LibraryCardsTableTableManager get libraryCards =>
      $$LibraryCardsTableTableManager(_db, _db.libraryCards);
  $$CustomCardsTableTableManager get customCards =>
      $$CustomCardsTableTableManager(_db, _db.customCards);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$VerificationCodesTableTableManager get verificationCodes =>
      $$VerificationCodesTableTableManager(_db, _db.verificationCodes);
}
