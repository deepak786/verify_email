import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';

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
    'aol.com',
    'msn.com',
    'yahoo.ae',
    'yahoo.at',
    'yahoo.be',
    'yahoo.ca',
    'yahoo.ch',
    'yahoo.cn',
    'yahoo.co',
    'yahoo.com',
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
    'hotmail.be',
    'hotmail.ca',
    'hotmail.ch',
    'hotmail.co',
    'hotmail.com',
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
    'live.at',
    'live.be',
    'live.ca',
    'live.cl',
    'live.cn',
    'live.com',
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

  List<String> getSuggestions(String email) {
    if (Validations.isEmpty(email) || !Validations.isValidEmail(email)) {
      return [];
    }

    // email has valid format
    Set<String> domains = <String>{};

    email = email.toLowerCase();
    final split = email.split('@');
    final username = split[0];
    final domain = split[1];

    // get the best match
    final bestMatch =
        _getBestMatchDomain(domain, [..._emailDomains, ..._emailSubDomains]);
    if (bestMatch != null) {
      domains.add("$username@$bestMatch");
    }

    // check if the domain has more than 2 dots
    final parts = domain.split(".");
    if (parts.length > 2) {
      // get best match for first dot
      final bestMatch =
          _getBestMatchDomain(parts.take(2).join('.'), _emailDomains);
      if (bestMatch != null) {
        domains.add("$username@$bestMatch");
      }
    }

    return domains.toList();
  }

  String? _getBestMatchDomain(String domain, List<String> domains) {
    final bestMatch = domain.bestMatch(domains);
    final ratings = bestMatch.ratings;
    final rating = bestMatch.bestMatch;
    final threshold = rating.rating ?? 0;

    debugPrint(ratings.toString());

    if (threshold >= 0.5 && threshold < 1.0) {
      return rating.target;
    }
    return null;
  }
}
