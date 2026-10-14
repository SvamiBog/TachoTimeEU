/// Vehicle mass classes used by driving bans.
library;

/// Maximum permitted mass of the vehicle for driving bans: bans apply to
/// vehicles heavier than the country's threshold — 3.5, 7.5 or 12 t.
enum VehicleMass {
  /// До 3,5 т: фургон.
  upTo3_5(3.5),

  /// 3,5–7,5 т.
  upTo7_5(7.5),

  /// 7,5–12 т.
  upTo12(12),

  /// Больше 12 т.
  over12(double.infinity);

  new(this.maxTonnes);

  /// Верхняя граница класса, т.
  final double maxTonnes;

  /// Машина этого класса тяжелее [tonnes]: класс целиком выше порога.
  bool heavierThan(double tonnes) => maxTonnes > tonnes;
}
