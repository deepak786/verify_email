import 'validations.dart';

class EmailCorrector {
  /// to create a single instance
  factory EmailCorrector() {
    _instance ??= EmailCorrector._();
    return _instance!;
  }

  EmailCorrector._();

  static EmailCorrector? _instance;

  /// List of email domains
  final _emailDomains = [
    'gmail.com',
    'outlook.com',
    'icloud.com',
    'protonmail.com',
    // 'aol.com',
    // 'msn.com',
    'yahoo.com',
    'yahoo.ae',
    'yahoo.at',
    'yahoo.be',
    'yahoo.ca',
    'yahoo.ch',
    'yahoo.cn',
    'yahoo.co',
    'yahoo.cz',
    'yahoo.de',
    'yahoo.dk',
    'yahoo.es',
    'yahoo.fi',
    'yahoo.fr',
    'yahoo.gr',
    'yahoo.hu',
    'yahoo.ie',
    'yahoo.in',
    'yahoo.it',
    'yahoo.jp',
    'yahoo.net',
    'yahoo.nl',
    'yahoo.no',
    'yahoo.pl',
    'yahoo.pt',
    'yahoo.ro',
    'yahoo.ru',
    'yahoo.se',
    'hotmail.com',
    'hotmail.be',
    'hotmail.ca',
    'hotmail.ch',
    'hotmail.co',
    'hotmail.de',
    'hotmail.es',
    'hotmail.fi',
    'hotmail.fr',
    'hotmail.it',
    'hotmail.kg',
    'hotmail.kz',
    'hotmail.my',
    'hotmail.nl',
    'hotmail.ro',
    'hotmail.roor',
    'hotmail.ru',
    'live.com',
    'live.at',
    'live.be',
    'live.ca',
    'live.cl',
    'live.cn',
    'live.de',
    'live.dk',
    'live.fr',
    'live.hk',
    'live.ie',
    'live.in',
    'live.it',
    'live.jp',
    'live.nl',
    'live.no',
    'live.ru',
    'live.se',
  ];

  final _emailSubDomains = [
    'yahoo.co.id',
    'yahoo.co.il',
    'yahoo.co.in',
    'yahoo.co.jp',
    'yahoo.co.kr',
    'yahoo.co.nz',
    'yahoo.co.th',
    'yahoo.co.uk',
    'yahoo.co.za',
    'yahoo.com.ar',
    'yahoo.com.au',
    'yahoo.com.br',
    'yahoo.com.cn',
    'yahoo.com.co',
    'yahoo.com.hk',
    'yahoo.com.is',
    'yahoo.com.mx',
    'yahoo.com.my',
    'yahoo.com.ph',
    'yahoo.com.ru',
    'yahoo.com.sg',
    'yahoo.com.tr',
    'yahoo.com.tw',
    'yahoo.com.vn',
    'hotmail.co.il',
    'hotmail.co.jp',
    'hotmail.co.nz',
    'hotmail.co.uk',
    'hotmail.co.za',
    'hotmail.com.ar',
    'hotmail.com.au',
    'hotmail.com.br',
    'hotmail.com.mx',
    'hotmail.com.tr',
    'live.com.ar',
    'live.com.au',
    'live.com.mx',
    'live.com.my',
    'live.com.pt',
    'live.com.sg',
    'live.co.uk',
    'live.co.za',
  ];

  String? getSuggestion(String email) {
    if (Validations.isEmpty(email) || !Validations.isValidEmail(email)) {
      return null;
    }

    email = email.toLowerCase();
    final split = email.split('@');
    final username = split[0];
    final domain = _normalizeDomain(split[1]);

    // get the best match
    final bestMatch =
        _getBestMatchDomain(domain, [..._emailDomains, ..._emailSubDomains]);
    if (bestMatch != null) {
      final emailSuggestion = "$username@$bestMatch";
      if (emailSuggestion != email) {
        return emailSuggestion;
      }
    }

    return null;
  }

  /// Normalize domain
  String _normalizeDomain(domain) {
    String d = domain;

    // remove leading numbers from domain
    d = d.replaceFirst(RegExp(r'^\d+'), '');

    final parts = d.split('.');
    final lastPart = parts.removeLast();

    // make sure lastPart is of max 5 characters
    final trimmedLastPart =
        lastPart.substring(0, lastPart.length > 5 ? 5 : lastPart.length);
    parts.add(trimmedLastPart);

    return parts.join(".");
  }

  /// Find the best match domain from [domains]
  String? _getBestMatchDomain(String domain, List<String> domains) {
    var bestMatch = _getBestMatchDomainSift3(domain, domains);
    bestMatch ??= _getBestMatchDomainLevenshtein(domain, domains);

    return bestMatch;
  }

  /// Best Match by Sift3
  String? _getBestMatchDomainSift3(
    String domain,
    List<String> domains, {
    int threshold = 2,
  }) {
    String? bestMatch;
    int bestDistance = 999;

    for (final candidate in domains) {
      final distance = _sift3(domain, candidate);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMatch = candidate;
      }
    }

    if (bestDistance <= threshold) {
      return bestMatch;
    }
    return null;
  }

  /// Best Match by Levenshtein
  String? _getBestMatchDomainLevenshtein(
    String inputDomain,
    List<String> knownDomains, {
    int threshold = 2,
  }) {
    String? bestMatch;
    int minDistance = 1000;

    for (final domain in knownDomains) {
      int dist = _levenshtein(inputDomain, domain);

      if (dist < minDistance && dist <= threshold) {
        // you can adjust threshold here
        minDistance = dist;
        bestMatch = domain;
      }
    }

    return bestMatch;
  }

  /// Algorithm Sift3 distance
  int _sift3(String s1, String s2, [int maxOffset = 5]) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    int c = 0; // count of same characters
    int offset1 = 0;
    int offset2 = 0;
    int lcs = 0; // longest common subsequence length

    while ((c + offset1 < s1.length) && (c + offset2 < s2.length)) {
      if (s1[c + offset1] == s2[c + offset2]) {
        lcs++;
      } else {
        bool found = false;
        for (int i = 1; i < maxOffset; i++) {
          if ((c + i < s1.length) && (s1[c + i] == s2[c])) {
            offset1 += i;
            found = true;
            break;
          }
          if ((c + i < s2.length) && (s1[c] == s2[c + i])) {
            offset2 += i;
            found = true;
            break;
          }
        }
        if (!found) break;
      }
      c++;
    }

    return ((s1.length + s2.length) / 2 - lcs).round();
  }

  /// Algorithm Levenshtein distance
  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<List<int>> matrix = List.generate(
      s.length + 1,
      (_) => List.filled(t.length + 1, 0),
    );

    for (int i = 0; i <= s.length; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= t.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        int cost = s[i - 1] == t[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // Deletion
          matrix[i][j - 1] + 1, // Insertion
          matrix[i - 1][j - 1] + cost, // Substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s.length][t.length];
  }
}
