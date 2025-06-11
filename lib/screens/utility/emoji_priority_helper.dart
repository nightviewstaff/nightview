class EmojiPriorityHelper {
  static const List<String> moneyEmojis = ['💰️', '💸', '💵'];
  static const List<String> freeEmojis = ['🆓', '🍹'];
  static const List<String> _clubTypeEmojis = [
    '🎛️', // higher in display within category
    '🪩',
    '⭐️',
    '🍷',
    '🍸️',
    '🍺',
    '🎤',
    '🎧',
    '🎱',
    '🎶',
    '🎸',
    '🏖️',
    '🦹',
    '⚽️',
  ];
  static const List<String> _dancingEmojis = ['💃'];
  static const List<String> _beerpongEmojis = ['☄️'];
  static const List<String> _smokingStatusEmojis = ['🚬', '🚭️', '💨'];
  static const List<String> _lgbtqEmojis = ['🏳️‍🌈'];
  static const List<String> _dressCodeEmojis = [
    '👔',
    '👕',
    '👗',
    '💁',
    '🤵',
    '♠️'
  ];

  static final Set<String> _allEmojis = {
    ...moneyEmojis,
    ...freeEmojis,
    ..._clubTypeEmojis,
    ..._dancingEmojis,
    ..._beerpongEmojis,
    ..._smokingStatusEmojis,
    ..._lgbtqEmojis,
    ..._dressCodeEmojis,
    // Add fallback emojis here if needed
  };

  static int getEmojiPriority(String emoji) {
    if (moneyEmojis.contains(emoji)) return 100;
    if (freeEmojis.contains(emoji)) return 99;
    if (_clubTypeEmojis.contains(emoji)) return 95;
    if (_dancingEmojis.contains(emoji)) return 90;
    if (_beerpongEmojis.contains(emoji)) return 89;
    if (_smokingStatusEmojis.contains(emoji)) return 88;
    if (_dressCodeEmojis.contains(emoji)) return 87;
    if (_lgbtqEmojis.contains(emoji)) return 51;
    return 0;
  }

  /// Returns a tuple-like list used for sorting:
  /// [category priority DESC, index within category ASC]
  static List<int> getEmojiSortKey(String emoji) {
    int categoryPriority = getEmojiPriority(emoji);
    int indexInCategory = 999; // large fallback

    if ((indexInCategory = moneyEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = freeEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = _clubTypeEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = _dancingEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = _beerpongEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = _smokingStatusEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = _dressCodeEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];
    if ((indexInCategory = _lgbtqEmojis.indexOf(emoji)) != -1)
      return [categoryPriority, indexInCategory];

    return [0, 999]; // Unknown emoji = lowest priority, last
  }
}
