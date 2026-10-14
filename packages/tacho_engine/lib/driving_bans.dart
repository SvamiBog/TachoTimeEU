/// Truck driving bans in European countries: the rules of each country, ban
/// windows converted to UTC and the state "now".
///
/// Pure Dart. The built-in data is `src/bans/countries.dart`, the signed file
/// that updates it over the network is parsed by `src/bans/ban_json.dart`, the
/// research behind the data is `docs/domain/driving-bans.md`.
library;

export 'src/bans/ban_calendar.dart';
export 'src/bans/ban_json.dart';
export 'src/bans/ban_rule.dart';
export 'src/bans/countries.dart';
export 'src/bans/holidays.dart';
export 'src/bans/vehicle_mass.dart';
export 'src/bans/zone_time.dart';
