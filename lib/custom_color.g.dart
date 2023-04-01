import 'package:flutter/material.dart';

const yellowishbrown = Color(0xFF695100);
const pinkishred = Color(0xFF930074);
const greenishblue = Color(0xFF005B65);
const yellowishgreen = Color(0xFF6B8010);

CustomColors lightCustomColors = const CustomColors(
  sourceYellowishbrown: Color(0xFF695100),
  yellowishbrown: Color(0xFF755B00),
  onYellowishbrown: Color(0xFFFFFFFF),
  yellowishbrownContainer: Color(0xFFFFDF91),
  onYellowishbrownContainer: Color(0xFF241A00),
  sourcePinkishred: Color(0xFF930074),
  pinkishred: Color(0xFFA92187),
  onPinkishred: Color(0xFFFFFFFF),
  pinkishredContainer: Color(0xFFFFD8EC),
  onPinkishredContainer: Color(0xFF3B002D),
  sourceGreenishblue: Color(0xFF005B65),
  greenishblue: Color(0xFF006874),
  onGreenishblue: Color(0xFFFFFFFF),
  greenishblueContainer: Color(0xFF96F0FF),
  onGreenishblueContainer: Color(0xFF001F24),
  sourceYellowishgreen: Color(0xFF6B8010),
  yellowishgreen: Color(0xFF536500),
  onYellowishgreen: Color(0xFFFFFFFF),
  yellowishgreenContainer: Color(0xFFD4EE76),
  onYellowishgreenContainer: Color(0xFF171E00),
);

CustomColors darkCustomColors = const CustomColors(
  sourceYellowishbrown: Color(0xFF695100),
  yellowishbrown: Color(0xFFECC148),
  onYellowishbrown: Color(0xFF3E2E00),
  yellowishbrownContainer: Color(0xFF594400),
  onYellowishbrownContainer: Color(0xFFFFDF91),
  sourcePinkishred: Color(0xFF930074),
  pinkishred: Color(0xFFFFAEDE),
  onPinkishred: Color(0xFF60004B),
  pinkishredContainer: Color(0xFF87006B),
  onPinkishredContainer: Color(0xFFFFD8EC),
  sourceGreenishblue: Color(0xFF005B65),
  greenishblue: Color(0xFF4FD8EB),
  onGreenishblue: Color(0xFF00363D),
  greenishblueContainer: Color(0xFF004F57),
  onGreenishblueContainer: Color(0xFF96F0FF),
  sourceYellowishgreen: Color(0xFF6B8010),
  yellowishgreen: Color(0xFFB9D15D),
  onYellowishgreen: Color(0xFF2A3400),
  yellowishgreenContainer: Color(0xFF3E4C00),
  onYellowishgreenContainer: Color(0xFFD4EE76),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceYellowishbrown,
    required this.yellowishbrown,
    required this.onYellowishbrown,
    required this.yellowishbrownContainer,
    required this.onYellowishbrownContainer,
    required this.sourcePinkishred,
    required this.pinkishred,
    required this.onPinkishred,
    required this.pinkishredContainer,
    required this.onPinkishredContainer,
    required this.sourceGreenishblue,
    required this.greenishblue,
    required this.onGreenishblue,
    required this.greenishblueContainer,
    required this.onGreenishblueContainer,
    required this.sourceYellowishgreen,
    required this.yellowishgreen,
    required this.onYellowishgreen,
    required this.yellowishgreenContainer,
    required this.onYellowishgreenContainer,
  });

  final Color? sourceYellowishbrown;
  final Color? yellowishbrown;
  final Color? onYellowishbrown;
  final Color? yellowishbrownContainer;
  final Color? onYellowishbrownContainer;
  final Color? sourcePinkishred;
  final Color? pinkishred;
  final Color? onPinkishred;
  final Color? pinkishredContainer;
  final Color? onPinkishredContainer;
  final Color? sourceGreenishblue;
  final Color? greenishblue;
  final Color? onGreenishblue;
  final Color? greenishblueContainer;
  final Color? onGreenishblueContainer;
  final Color? sourceYellowishgreen;
  final Color? yellowishgreen;
  final Color? onYellowishgreen;
  final Color? yellowishgreenContainer;
  final Color? onYellowishgreenContainer;

  @override
  CustomColors copyWith({
    Color? sourceYellowishbrown,
    Color? yellowishbrown,
    Color? onYellowishbrown,
    Color? yellowishbrownContainer,
    Color? onYellowishbrownContainer,
    Color? sourcePinkishred,
    Color? pinkishred,
    Color? onPinkishred,
    Color? pinkishredContainer,
    Color? onPinkishredContainer,
    Color? sourceGreenishblue,
    Color? greenishblue,
    Color? onGreenishblue,
    Color? greenishblueContainer,
    Color? onGreenishblueContainer,
    Color? sourceYellowishgreen,
    Color? yellowishgreen,
    Color? onYellowishgreen,
    Color? yellowishgreenContainer,
    Color? onYellowishgreenContainer,
  }) {
    return CustomColors(
      sourceYellowishbrown: sourceYellowishbrown ?? this.sourceYellowishbrown,
      yellowishbrown: yellowishbrown ?? this.yellowishbrown,
      onYellowishbrown: onYellowishbrown ?? this.onYellowishbrown,
      yellowishbrownContainer: yellowishbrownContainer ?? this.yellowishbrownContainer,
      onYellowishbrownContainer: onYellowishbrownContainer ?? this.onYellowishbrownContainer,
      sourcePinkishred: sourcePinkishred ?? this.sourcePinkishred,
      pinkishred: pinkishred ?? this.pinkishred,
      onPinkishred: onPinkishred ?? this.onPinkishred,
      pinkishredContainer: pinkishredContainer ?? this.pinkishredContainer,
      onPinkishredContainer: onPinkishredContainer ?? this.onPinkishredContainer,
      sourceGreenishblue: sourceGreenishblue ?? this.sourceGreenishblue,
      greenishblue: greenishblue ?? this.greenishblue,
      onGreenishblue: onGreenishblue ?? this.onGreenishblue,
      greenishblueContainer: greenishblueContainer ?? this.greenishblueContainer,
      onGreenishblueContainer: onGreenishblueContainer ?? this.onGreenishblueContainer,
      sourceYellowishgreen: sourceYellowishgreen ?? this.sourceYellowishgreen,
      yellowishgreen: yellowishgreen ?? this.yellowishgreen,
      onYellowishgreen: onYellowishgreen ?? this.onYellowishgreen,
      yellowishgreenContainer: yellowishgreenContainer ?? this.yellowishgreenContainer,
      onYellowishgreenContainer: onYellowishgreenContainer ?? this.onYellowishgreenContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceYellowishbrown: Color.lerp(sourceYellowishbrown, other.sourceYellowishbrown, t),
      yellowishbrown: Color.lerp(yellowishbrown, other.yellowishbrown, t),
      onYellowishbrown: Color.lerp(onYellowishbrown, other.onYellowishbrown, t),
      yellowishbrownContainer: Color.lerp(yellowishbrownContainer, other.yellowishbrownContainer, t),
      onYellowishbrownContainer: Color.lerp(onYellowishbrownContainer, other.onYellowishbrownContainer, t),
      sourcePinkishred: Color.lerp(sourcePinkishred, other.sourcePinkishred, t),
      pinkishred: Color.lerp(pinkishred, other.pinkishred, t),
      onPinkishred: Color.lerp(onPinkishred, other.onPinkishred, t),
      pinkishredContainer: Color.lerp(pinkishredContainer, other.pinkishredContainer, t),
      onPinkishredContainer: Color.lerp(onPinkishredContainer, other.onPinkishredContainer, t),
      sourceGreenishblue: Color.lerp(sourceGreenishblue, other.sourceGreenishblue, t),
      greenishblue: Color.lerp(greenishblue, other.greenishblue, t),
      onGreenishblue: Color.lerp(onGreenishblue, other.onGreenishblue, t),
      greenishblueContainer: Color.lerp(greenishblueContainer, other.greenishblueContainer, t),
      onGreenishblueContainer: Color.lerp(onGreenishblueContainer, other.onGreenishblueContainer, t),
      sourceYellowishgreen: Color.lerp(sourceYellowishgreen, other.sourceYellowishgreen, t),
      yellowishgreen: Color.lerp(yellowishgreen, other.yellowishgreen, t),
      onYellowishgreen: Color.lerp(onYellowishgreen, other.onYellowishgreen, t),
      yellowishgreenContainer: Color.lerp(yellowishgreenContainer, other.yellowishgreenContainer, t),
      onYellowishgreenContainer: Color.lerp(onYellowishgreenContainer, other.onYellowishgreenContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
