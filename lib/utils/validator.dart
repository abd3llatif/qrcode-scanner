class Validator {
  // check Email address
  static bool isEmail(String? em) {
    if(em == null) return false;
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  static String? isEmailValid(String email) {
    if (email.isEmpty) {
      return "Merci de saisir votre email";
    } else if (!isEmail(email)) {
      return "Merci de vérifier votre email";
    } else {
      return null;
    }
  }

  // check password
  static bool isPasswordValid(String password) {
    if (password.length > 5) {
      return true;
    } else {
      return false;
    }
  }

  // check password matched
  static bool isPasswordMatchValid(String password, String firstPassword) {
    if (password != firstPassword) return false;
    return true;
  }

  static bool isPhoneValid(String? phone) {
    if(phone == null) return false;
    String p = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(phone);
  }

  // check Name
  static bool isNameValid(String? name) {
    if (name == null || name.isEmpty) return false;
    return true;
  }

  // check First Name
  static bool isFirstNameValid(String? firstName) {
    if (firstName == null || firstName.isEmpty) return false;
    return true;
  }

  // check First Name
  static bool isFullNameValid(String? fullName) {
    if (fullName == null || fullName.isEmpty) return false;
    return true;
  }

  static bool isZipCodeValid(String firstName) {
    if (firstName.isEmpty) return false;
    return true;
  }

  static bool isIBANValid(String firstName) {
    if (firstName.isEmpty) return false;
    return true;
  }

  // check Address
  static bool isAddressValid(String address) {
    if (address.isEmpty) return false;
    return true;
  }

  // check Company name
  static bool isCompanyNameValid(String companyName) {
    if (companyName.isEmpty) return false;
    return true;
  }

  // check SIRET
  static bool isNrSIRETValid(String SIRET) {
    if (SIRET.length != 14) return false;
    return true;
  }

  // check day of birth
  static bool isDayOfBirthValid(String dayOfBirth) {
    return isRequiredValid(dayOfBirth);
  }

  // check event title
  static bool isEventTitleValid(String title) {
    return isRequiredValid(title);
  }

  // check event description
  static bool isEventDescriptionValid(String desc) {
    return isRequiredValid(desc);
  }

  // check event description
  static bool isRequiredValid(String text) {
    return text != null && text.isNotEmpty;
  }
}
