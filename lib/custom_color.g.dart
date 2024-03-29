import 'package:flutter/material.dart';

const yellowishbrown = Color(0xFF745B00);
const pinkishred = Color(0xFF9A3E61);
const greenishblue = Color(0xFF00696C);
const yellowishgreen = Color(0xFF6B8010);
const purple = Color(0xFF694EA7);
const blue = Color(0xFF0060A8);
const red = Color(0xFFB71F27);
const green = Color(0xFF005C2F);

CustomColors lightCustomColors = const CustomColors(
  sourceYellowishbrown: Color(0xFF745B00),
  yellowishbrown: Color(0xFF745B00),
  onYellowishbrown: Color(0xFFFFFFFF),
  yellowishbrownContainer: Color(0xFFFFE08D),
  onYellowishbrownContainer: Color(0xFF241A00),
  sourcePinkishred: Color(0xFF9A3E61),
  pinkishred: Color(0xFF9A3E61),
  onPinkishred: Color(0xFFFFFFFF),
  pinkishredContainer: Color(0xFFFFD9E2),
  onPinkishredContainer: Color(0xFF3E001D),
  sourceGreenishblue: Color(0xFF00696C),
  greenishblue: Color(0xFF00696C),
  onGreenishblue: Color(0xFFFFFFFF),
  greenishblueContainer: Color(0xFF6FF6FB),
  onGreenishblueContainer: Color(0xFF002021),
  sourceYellowishgreen: Color(0xFF6B8010),
  yellowishgreen: Color(0xFF536500),
  onYellowishgreen: Color(0xFFFFFFFF),
  yellowishgreenContainer: Color(0xFFD4EE76),
  onYellowishgreenContainer: Color(0xFF171E00),
  sourcePurple: Color(0xFF694EA7),
  purple: Color(0xFF694EA7),
  onPurple: Color(0xFFFFFFFF),
  purpleContainer: Color(0xFFE9DDFF),
  onPurpleContainer: Color(0xFF24005B),
  sourceBlue: Color(0xFF0060A8),
  blue: Color(0xFF0160A8),
  onBlue: Color(0xFFFFFFFF),
  blueContainer: Color(0xFFD3E4FF),
  onBlueContainer: Color(0xFF001C38),
  sourceRed: Color(0xFFB71F27),
  red: Color(0xFFB71F27),
  onRed: Color(0xFFFFFFFF),
  redContainer: Color(0xFFFFDAD7),
  onRedContainer: Color(0xFF410004),
  sourceGreen: Color(0xFF005C2F),
  green: Color(0xFF006D39),
  onGreen: Color(0xFFFFFFFF),
  greenContainer: Color(0xFF9AF6B3),
  onGreenContainer: Color(0xFF00210D),
);

CustomColors darkCustomColors = const CustomColors(
  sourceYellowishbrown: Color(0xFF745B00),
  yellowishbrown: Color(0xFFEBC248),
  onYellowishbrown: Color(0xFF3D2F00),
  yellowishbrownContainer: Color(0xFF584400),
  onYellowishbrownContainer: Color(0xFFFFE08D),
  sourcePinkishred: Color(0xFF9A3E61),
  pinkishred: Color(0xFFFFB0C8),
  onPinkishred: Color(0xFF5F0E33),
  pinkishredContainer: Color(0xFF7D274A),
  onPinkishredContainer: Color(0xFFFFD9E2),
  sourceGreenishblue: Color(0xFF00696C),
  greenishblue: Color(0xFF4CD9DE),
  onGreenishblue: Color(0xFF003738),
  greenishblueContainer: Color(0xFF004F52),
  onGreenishblueContainer: Color(0xFF6FF6FB),
  sourceYellowishgreen: Color(0xFF6B8010),
  yellowishgreen: Color(0xFFB9D15D),
  onYellowishgreen: Color(0xFF2A3400),
  yellowishgreenContainer: Color(0xFF3E4C00),
  onYellowishgreenContainer: Color(0xFFD4EE76),
  sourcePurple: Color(0xFF694EA7),
  purple: Color(0xFFD1BCFF),
  onPurple: Color(0xFF3A1B75),
  purpleContainer: Color(0xFF51358D),
  onPurpleContainer: Color(0xFFE9DDFF),
  sourceBlue: Color(0xFF0060A8),
  blue: Color(0xFFA2C9FF),
  onBlue: Color(0xFF00315B),
  blueContainer: Color(0xFF004881),
  onBlueContainer: Color(0xFFD3E4FF),
  sourceRed: Color(0xFFB71F27),
  red: Color(0xFFFFB3AE),
  onRed: Color(0xFF68000B),
  redContainer: Color(0xFF930014),
  onRedContainer: Color(0xFFFFDAD7),
  sourceGreen: Color(0xFF005C2F),
  green: Color(0xFF7FDA99),
  onGreen: Color(0xFF00391B),
  greenContainer: Color(0xFF005229),
  onGreenContainer: Color(0xFF9AF6B3),
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
    required this.sourcePurple,
    required this.purple,
    required this.onPurple,
    required this.purpleContainer,
    required this.onPurpleContainer,
    required this.sourceBlue,
    required this.blue,
    required this.onBlue,
    required this.blueContainer,
    required this.onBlueContainer,
    required this.sourceRed,
    required this.red,
    required this.onRed,
    required this.redContainer,
    required this.onRedContainer,
    required this.sourceGreen,
    required this.green,
    required this.onGreen,
    required this.greenContainer,
    required this.onGreenContainer,
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
  final Color? sourcePurple;
  final Color? purple;
  final Color? onPurple;
  final Color? purpleContainer;
  final Color? onPurpleContainer;
  final Color? sourceBlue;
  final Color? blue;
  final Color? onBlue;
  final Color? blueContainer;
  final Color? onBlueContainer;
  final Color? sourceRed;
  final Color? red;
  final Color? onRed;
  final Color? redContainer;
  final Color? onRedContainer;
  final Color? sourceGreen;
  final Color? green;
  final Color? onGreen;
  final Color? greenContainer;
  final Color? onGreenContainer;

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
    Color? sourcePurple,
    Color? purple,
    Color? onPurple,
    Color? purpleContainer,
    Color? onPurpleContainer,
    Color? sourceBlue,
    Color? blue,
    Color? onBlue,
    Color? blueContainer,
    Color? onBlueContainer,
    Color? sourceRed,
    Color? red,
    Color? onRed,
    Color? redContainer,
    Color? onRedContainer,
    Color? sourceGreen,
    Color? green,
    Color? onGreen,
    Color? greenContainer,
    Color? onGreenContainer,
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
      sourcePurple: sourcePurple ?? this.sourcePurple,
      purple: purple ?? this.purple,
      onPurple: onPurple ?? this.onPurple,
      purpleContainer: purpleContainer ?? this.purpleContainer,
      onPurpleContainer: onPurpleContainer ?? this.onPurpleContainer,
      sourceBlue: sourceBlue ?? this.sourceBlue,
      blue: blue ?? this.blue,
      onBlue: onBlue ?? this.onBlue,
      blueContainer: blueContainer ?? this.blueContainer,
      onBlueContainer: onBlueContainer ?? this.onBlueContainer,
      sourceRed: sourceRed ?? this.sourceRed,
      red: red ?? this.red,
      onRed: onRed ?? this.onRed,
      redContainer: redContainer ?? this.redContainer,
      onRedContainer: onRedContainer ?? this.onRedContainer,
      sourceGreen: sourceGreen ?? this.sourceGreen,
      green: green ?? this.green,
      onGreen: onGreen ?? this.onGreen,
      greenContainer: greenContainer ?? this.greenContainer,
      onGreenContainer: onGreenContainer ?? this.onGreenContainer,
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
      sourcePurple: Color.lerp(sourcePurple, other.sourcePurple, t),
      purple: Color.lerp(purple, other.purple, t),
      onPurple: Color.lerp(onPurple, other.onPurple, t),
      purpleContainer: Color.lerp(purpleContainer, other.purpleContainer, t),
      onPurpleContainer: Color.lerp(onPurpleContainer, other.onPurpleContainer, t),
      sourceBlue: Color.lerp(sourceBlue, other.sourceBlue, t),
      blue: Color.lerp(blue, other.blue, t),
      onBlue: Color.lerp(onBlue, other.onBlue, t),
      blueContainer: Color.lerp(blueContainer, other.blueContainer, t),
      onBlueContainer: Color.lerp(onBlueContainer, other.onBlueContainer, t),
      sourceRed: Color.lerp(sourceRed, other.sourceRed, t),
      red: Color.lerp(red, other.red, t),
      onRed: Color.lerp(onRed, other.onRed, t),
      redContainer: Color.lerp(redContainer, other.redContainer, t),
      onRedContainer: Color.lerp(onRedContainer, other.onRedContainer, t),
      sourceGreen: Color.lerp(sourceGreen, other.sourceGreen, t),
      green: Color.lerp(green, other.green, t),
      onGreen: Color.lerp(onGreen, other.onGreen, t),
      greenContainer: Color.lerp(greenContainer, other.greenContainer, t),
      onGreenContainer: Color.lerp(onGreenContainer, other.onGreenContainer, t),
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
