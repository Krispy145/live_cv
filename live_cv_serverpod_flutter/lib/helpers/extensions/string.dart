import 'package:live_cv_serverpod_flutter/helpers/tuples.dart';

extension StringExtension on String {
  //Capitalise String
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  //Title Capitalise String
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  //Checks if string is or isn't a number
  bool get isNumeric => double.tryParse(this) != null;
  bool get isNotNumeric => double.tryParse(this) == null;

  /// Returns the string with the first character capitalized
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  /// Returns the the string, using the camelCase format rather than snake_case
  String convertSnakeCaseToCamelCase() {
    final partsArray = split("_");
    for (var i = 0; i < partsArray.length; i++) {
      if (i != 0) {
        partsArray[i] = partsArray[i].toLowerCase().capitalizeFirst();
      } else {
        partsArray[i] = partsArray[i].toLowerCase();
      }
    }
    final enumName = partsArray.join("");
    return enumName;
  }

  String camelCaseToCapitalizedEachWord() {
    if (isEmpty) return '';
    final words = split(RegExp('(?=[A-Z])|_'));
    return words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String get separateWords {
    final result = StringBuffer();
    for (var i = 0; i < length; i++) {
      final char = this[i];
      if (char.toUpperCase() == char) {
        result.write(' ');
      }
      result.write(char.toLowerCase());
    }
    return result.toString().trim();
  }

  /// Returns the string with the content between [start] and [end] replaced with [replacement]
  String replaceTextBetween(String start, String end, String replacement) {
    final startString = replaceAll("\n", "\\n");
    // ignore: prefer_interpolation_to_compose_strings
    var result = startString.replaceAllMapped(RegExp(r'(' + start + ')(.*?)(' + end + ')'), (m) {
      return '${m[1]}$replacement${m[3]}';
    });
    result = result.replaceAll("\\n", "\n");
    return result;
  }

  /// Returns the [String] with the [toInsert] string before the [insertBefore] string, if found.
  String insertBeforeSubstring({required String toInsert, required String insertBefore}) {
    final position = indexOf(insertBefore);

    if (position == -1) return this;

    if (length < position) {
      return this;
    }
    var before = substring(0, position);
    var after = substring(position, length);
    return before + toInsert + after;
  }

  /// Returns the word containing the provided [index] and the index the word starts at
  Pair<String, int>? getWordAtIndexAndStart(int index) {
    int startLetter = 0;
    int spaceIndexAfter = length;

    for (int i = 0; i < length; i++) {
      if (i > 0 && (this[i - 1] == " " || this[i - 1] == "\n") && i == index) {
        return null;
      }
      if (this[i] == " " || this[i] == "\n") {
        if (i < index) {
          startLetter = i + 1;
        }
        if (i >= index) {
          spaceIndexAfter = i;
          break;
        }
      }
    }

    final word = substring(startLetter, spaceIndexAfter);
    return Pair(word, startLetter);
  }
}
