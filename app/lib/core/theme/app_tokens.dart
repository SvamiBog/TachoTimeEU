/// Radii, sizes and spacing from `docs/design/tokens.json`.
library;

/// Corner radii, dp.
abstract final class AppRadius {
  static const heroCard = 28.0;
  static const card = 24.0;
  static const modeButton = 20.0;
  static const button = 18.0;
  static const badge = 16.0;
  static const icon = 14.0;
  static const chip = 8.0;
}

/// Spacing, dp. Layout tokens name a role; the scale `s3`…`s24` is for the
/// gaps between and inside elements. The scale keeps the values the screens
/// are drawn with, the steps off the 4 dp grid (3, 6, 10, 14) included.
abstract final class AppSpacing {
  static const screenPadding = 16.0;
  static const cardPadding = 16.0;
  static const betweenCardsMin = 8.0;
  static const betweenCardsMax = 16.0;
  static const beforeSectionMin = 24.0;
  static const beforeSectionMax = 28.0;

  /// Боковые поля текста без карточки: заголовки, шторки, пояснения под
  /// списком — на 4 dp глубже края карточки.
  static const textInset = 20.0;

  /// Поля строки карточки сверху и снизу.
  static const rowVertical = 10.0;

  /// Поле справа у строки с переключателем или «›»: у них свои поля.
  static const rowTrailing = 12.0;

  /// Поля главной карточки экрана.
  static const heroPadding = 20.0;

  /// Поле у нижнего края: под концом списка, шторки и под кнопкой внизу
  /// экрана.
  static const screenBottom = 24.0;

  // Шкала: промежутки между элементами и поля внутри них.
  static const s3 = 3.0;
  static const s4 = 4.0;
  static const s6 = 6.0;
  static const s8 = 8.0;
  static const s10 = 10.0;
  static const s12 = 12.0;
  static const s14 = 14.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
}

/// Sizes, dp. Activity buttons are large because the driver may wear gloves.
abstract final class AppSize {
  static const minTouch = 44.0;

  /// Шапка экрана: название вкладки или «‹» с заголовком.
  static const header = 64.0;
  static const listRow = 56.0;
  static const button = 56.0;
  static const modeButton = 88.0;
  static const progressBar = 6.0;
  static const progressTickWidth = 2.0;
  static const progressTickHeight = 14.0;
}
