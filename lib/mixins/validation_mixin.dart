import 'dart:async';

class ValidateMixing {
  String validateEmail(String email) {
    if (/* !email.contains('@') || */ email.length < 6)
      return 'Please enter a valid email';

    return null;
  }

  String validatePassword(String password) {
    if (password.length < 4) return 'Password less than 4 character';

    return null;
  }

  String validateTitle(String title) {
    if (title == '' || title == null) return 'title should not be empty';
    return null;
  }

  String validateDescription(String desc) {
    if (desc == '' || desc == null) return 'description should not be empty';
    return null;
  }
}

class ValidatorBloc {
  final StreamTransformer<String, String> validateEmail =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid Email');
    }
  });

  final StreamTransformer<String, String> validatePassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String password, sink) {
    if (password.length >= 4) {
      sink.add(password);
    } else {
      sink.addError('Should contain atleast 4 characters');
    }
  });
}
