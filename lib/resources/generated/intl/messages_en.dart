// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(id) => "Param: ${id}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "cancel_button_dialog": MessageLookupByLibrary.simpleMessage("CANCEL"),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Dark"),
    "detail_no_param": MessageLookupByLibrary.simpleMessage("No param"),
    "detail_param": m0,
    "detail_title": MessageLookupByLibrary.simpleMessage("Detail"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_invalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address.",
    ),
    "email_required": MessageLookupByLibrary.simpleMessage(
      "Email is required.",
    ),
    "enter_email": MessageLookupByLibrary.simpleMessage(
      "Enter your email address",
    ),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Enter your password",
    ),
    "home_open_detail": MessageLookupByLibrary.simpleMessage("Open detail"),
    "home_title": MessageLookupByLibrary.simpleMessage("Home"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "language_english": MessageLookupByLibrary.simpleMessage("English"),
    "language_vietnam": MessageLookupByLibrary.simpleMessage("Vietnamese"),
    "light_mode": MessageLookupByLibrary.simpleMessage("Light"),
    "login_button": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "network_error": MessageLookupByLibrary.simpleMessage(
      "Network error. Please check your connection and try again.",
    ),
    "ok_button_dialog": MessageLookupByLibrary.simpleMessage("OK"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "password_invalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid password.",
    ),
    "password_required": MessageLookupByLibrary.simpleMessage(
      "Password is required.",
    ),
    "server_error": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later.",
    ),
    "theme_mode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "timeout_error": MessageLookupByLibrary.simpleMessage(
      "Request timed out. Please try again later.",
    ),
    "unknown_error": MessageLookupByLibrary.simpleMessage(
      "An unknown error occurred. Please try again later.",
    ),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome to our app!"),
  };
}
