// Радиусы, размеры и отступы из docs/design/tokens.json.

/// Радиусы, dp.
abstract final class AppRadius {
  static const heroCard = 28.0;
  static const card = 24.0;
  static const modeButton = 20.0;
  static const button = 18.0;
  static const badge = 16.0;
  static const icon = 14.0;
  static const chip = 8.0;
}

/// Отступы, dp.
abstract final class AppSpacing {
  static const screenPadding = 16.0;
  static const cardPadding = 16.0;
  static const betweenCardsMin = 8.0;
  static const betweenCardsMax = 16.0;
  static const beforeSectionMin = 24.0;
  static const beforeSectionMax = 28.0;
}

/// Размеры, dp. Кнопки режимов крупные — водитель может быть в перчатках.
abstract final class AppSize {
  static const minTouch = 44.0;
  static const listRow = 56.0;
  static const button = 56.0;
  static const modeButton = 88.0;
  static const progressBar = 6.0;
  static const progressTickWidth = 2.0;
  static const progressTickHeight = 14.0;
}
