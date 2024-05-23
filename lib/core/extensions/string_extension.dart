extension StringExtension on String {
  String capitalize() {
    return toLowerCase().split(' ').map((word) {
      if (word.length > 1) {
        String leftText = word.substring(1, word.length);
        return word[0].toUpperCase() + leftText;
      } else {
        return word.toUpperCase();
      }
    }).join(' ');
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidMobile() {
    return RegExp(r'^05[0-9]{8}$').hasMatch(this);
  }
}
