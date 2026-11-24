/// The part of unified diagnostic services (ISO 14229-1) the app uses to read
/// a tachograph: ReadDataByIdentifier and its replies.
library;

import 'dart:typed_data';

import 'package:flutter/foundation.dart' show immutable;

/// Служба ReadDataByIdentifier и её положительный ответ.
const _readDataByIdentifier = 0x22;
const _readDataReply = 0x62;
const _negativeReply = 0x7F;

/// Negative response codes (NRC) the app tells apart.
abstract final class UdsRefusal {
  static const serviceNotSupported = 0x11;
  static const busyRepeatRequest = 0x21;
  static const conditionsNotCorrect = 0x22;
  static const requestOutOfRange = 0x31;
  static const securityAccessDenied = 0x33;
  static const responsePending = 0x78;
}

/// Запрос значения с номером [did] (DID, ISO 16844-7).
Uint8List readDataRequest(int did) =>
    Uint8List.fromList([_readDataByIdentifier, did >> 8, did & 0xFF]);

/// A reply of the tachograph to a diagnostic request.
@immutable
sealed class UdsReply {
  const new();
}

/// The value of data identifier [did].
final class UdsData extends UdsReply {
  const new(this.did, this.data);

  final int did;
  final List<int> data;
}

/// A refusal with negative response [code].
final class UdsRefused extends UdsReply {
  const new(this.serviceId, this.code);

  final int serviceId;
  final int code;

  /// Тахограф этого не умеет: спрашивать снова бессмысленно. Иначе отказ
  /// временный или из-за согласия водителя.
  bool get unsupported =>
      code == UdsRefusal.requestOutOfRange ||
      code == UdsRefusal.serviceNotSupported;
}

/// "Response pending": the real reply comes as the next message.
final class UdsPending extends UdsReply {
  const new();
}

/// A message the app does not understand; its bytes go to the exchange log.
final class UdsUnexpected extends UdsReply {
  const new(this.bytes);

  final List<int> bytes;
}

UdsReply parseUdsReply(List<int> bytes) {
  if (bytes.length >= 3 && bytes[0] == _readDataReply) {
    return UdsData(bytes[1] << 8 | bytes[2], bytes.sublist(3));
  }
  if (bytes.length >= 3 && bytes[0] == _negativeReply) {
    return bytes[2] == UdsRefusal.responsePending
        ? const UdsPending()
        : UdsRefused(bytes[1], bytes[2]);
  }
  return UdsUnexpected(bytes);
}
