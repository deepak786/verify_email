/// A util class for validations.
class Validations {
  /// Returns `true` if it is a valid [email].
  static bool isValidEmail(String? email) {
    if (email == null) return false;
    return RegExp(
            r"^[a-zA-Z0-9\+\.\_\%\-]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,64})+$")
        .hasMatch(email.trim());
  }

  /// Returns `true` if it is a valid [password].
  static bool isValidPassword(String? password) {
    return password != null && password.length >= 6 ? true : false;
  }

  // child path is invalid if it contains . $ # [ ]
  static bool isValidFirebaseChildPath(String? child) {
    if (child == null) return false;

    return !RegExp(r"[\[\].#$]").hasMatch(child);
  }

  // check if string is has value or not
  static bool isEmpty(String? value) {
    return value == null || value.isEmpty || value.trim().isEmpty;
  }

  // check if the name is valid
  static bool isValidName(String? name) {
    return name != null &&
        name.isNotEmpty &&
        name.trim().isNotEmpty &&
        RegExp(r"^[\p{L} ]+$", unicode: true).hasMatch(name);
  }

  // check if the url is valid
  static bool isValidUrl(String? url) {
    return url != null &&
        url.isNotEmpty &&
        RegExp(r'\b((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*))\b')
            .hasMatch(url);
  }
}
