class ProfanityFilter {
  // Common offensive words (Indonesian & English)
  static final List<String> _badWords = [
    // --- INDONESIAN ---
    // General / Animals
    'anjing', 'babi', 'monyet', 'kunyuk', 'asu', 'asu', 'bajingan', 'brengsek', 'tai', 'bangsat', 'kampret',
    'kecoak', 'kecoak', 'lintah', 'buaya', 'kadrun', 'cebong', 'onta',
    
    // Slang / Insults / Local
    'goblok', 'tolol', 'idiot', 'bego', 'picek', 'budeg', 'bolot', 'koplo', 'bencong', 'maho', 'gay', 'lesbi',
    'perek', 'lonte', 'jablay', 'lontia', 'ayam', 'gigolo', 'mucikari', 'germu',
    'anjay', 'anjir', 'anjrit', 'anying', 'anjim', 'ansoy', 'anjay', 'plenger', 'pler', 'plerr',
    
    // Body Parts / Sex (Highly Offensive)
    'kontol', 'memek', 'jembut', 'itil', 'ngentot', 'entot', 'ewe', 'pantek', 'peli', 'peler', 'peju', 'coli',
    'ancuk', 'cuk', 'jancuk', 'jancok', 'damput', 'modar', 'puki', 'pukimak', 'ngewe', 'tempik', 'ngaceng',
    
    // Religious / Ethical
    'setan', 'iblis', 'biadab', 'kurang ajar', 'dajal', 'dajjal', 'kafir', 'murtad', 'haram',
    
    // --- ENGLISH ---
    // General / Animals (when used as insults)
    'pig', 'dog', 'monkey', 'ape', 'rat', 'snake', 'vermin', 'beast',
    
    // Insults
    'shit', 'fuck', 'bitch', 'asshole', 'damn', 'crap', 'bastard', 'dick', 'pussy', 'slut', 'whore',
    'jerk', 'stupid', 'dumb', 'retard', 'moron', 'idiot', 'loser', 'suck', 'sucks', 'crap',
    
    // Highly Offensive
    'nigger', 'negro', 'cunt', 'faggot', 'cocksucker', 'motherfucker', 'prick', 'twat', 'wanker', 'tosser',
    'bollocks', 'arse', 'arsehole', 'piss', 'shithead', 'douche', 'douchebag',
  ];

  // Map for common leetspeak substitutions
  static final Map<String, String> _leetspeakMap = {
    '4': 'a',
    '3': 'e',
    '1': 'i',
    '0': 'o',
    '5': 's',
    '7': 't',
    '8': 'b',
    '9': 'g',
    '@': 'a',
    '\$': 's',
    '!': 'i',
  };

  /// Normalizes text by converting leetspeak and removing obfuscation characters.
  static String _normalize(String text) {
    String normalized = text.toLowerCase();
    
    // 1. Replace leetspeak characters
    _leetspeakMap.forEach((key, value) {
      normalized = normalized.replaceAll(key, value);
    });

    // 2. Remove common obfuscation characters (e.g., "f.u.c.k" -> "fuck")
    // Note: We keep spaces because \b (word boundary) depends on them.
    normalized = normalized.replaceAll(RegExp(r'[^a-z\s]'), '');

    return normalized;
  }

  /// Checks if the provided text contains any prohibited words.
  /// Returns a List of found bad words, or an empty list if clean.
  static List<String> check(String text) {
    if (text.isEmpty) return [];

    final String normalized = _normalize(text);
    final List<String> foundWords = [];

    // Also check the raw text just in case normalization missed something
    final String rawLower = text.toLowerCase();

    for (var word in _badWords) {
      final RegExp regExp = RegExp('\\b${RegExp.escape(word)}\\b', caseSensitive: false);
      
      if (regExp.hasMatch(normalized) || regExp.hasMatch(rawLower)) {
        foundWords.add(word);
      }
    }

    return foundWords;
  }

  /// Returns true if the text is clean, false otherwise.
  static bool isClean(String text) {
    return check(text).isEmpty;
  }
}
