// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'l10n/messages_all.dart';
//
// class AppLocalizations {
//   static Future<AppLocalizations> load(Locale locale) async {
//     final String name =
//         locale.countryCode == null ? locale.languageCode : locale.toString();
//     final String localeName = Intl.canonicalizedLocale(name);
//
//     await initializeMessages(localeName);
//     Intl.defaultLocale = localeName;
//     return AppLocalizations();
//   }
//
//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();
//
//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }
//
//   String get selectLanguage => Intl.message(
//         'Select Language',
//         name: 'selectLanguage',
//         desc: 'Dialog title for language selection',
//       );
//
//   String get login => Intl.message(
//         'Log in',
//         name: 'login',
//         desc: 'Label for login button or screen title',
//       );
//
//   String get create_nightview_profile => Intl.message(
//         'Create NightView profile',
//         name: 'create_nightview_profile',
//         desc: 'Label for creating a NightView profile',
//       );
//
//   String get create_with_google => Intl.message(
//         'Create with Google',
//         name: 'create_with_google',
//         desc: 'Label for creating an account with Google',
//       );
//
//   String get continueButton => Intl.message(
//         'Continue',
//         name: 'continueButton',
//         desc: 'Label for a continue button',
//       );
//
//   String get invalidLogin => Intl.message(
//         'Invalid login',
//         name: 'invalidLogin',
//         desc: 'Dialog title for invalid login attempt',
//       );
//
//   String get incorrectInfoTryAgain => Intl.message(
//         'The information is not entered correctly. Try again.',
//         name: 'incorrectInfoTryAgain',
//         desc: 'Dialog message for incorrect login information',
//       );
//
//   String get okay => Intl.message(
//         'Okay',
//         name: 'okay',
//         desc: 'Button label to dismiss a dialog',
//       );
//
//   String get mail => Intl.message(
//         'Email',
//         name: 'mail',
//         desc: 'Hint text for email input field',
//       );
//
//   String get password => Intl.message(
//         'Password',
//         name: 'password',
//         desc: 'Hint text for password input field',
//       );
//
//   String get stayLoggedIn => Intl.message(
//         'Stay logged in',
//         name: 'stayLoggedIn',
//         desc: 'Label for stay logged in checkbox',
//       );
//
//   String get personalInformation => Intl.message(
//         'Personal Information',
//         name: 'personalInformation',
//       );
//
//   String get firstNames => Intl.message(
//         'First name(s)',
//         name: 'firstNames',
//       );
//
//   String get lastNames => Intl.message(
//         'Last name(s)',
//         name: 'lastNames',
//       );
//
//   String get birthdate => Intl.message(
//         'Birthdate',
//         name: 'birthdate',
//       );
//
//   String get mustBeOver18InDenmark => Intl.message(
//         'You must be over 18 to use NightView in Denmark',
//         name: 'mustBeOver18InDenmark',
//       );
//
//   String get choosePassword => Intl.message(
//         'Choose Password',
//         name: 'choosePassword',
//       );
//
//   String get passwordRequirements => Intl.message(
//         'Your password must contain both uppercase and lowercase letters, digits, and be at least 8 characters long.',
//         name: 'passwordRequirements',
//       );
//
//   String get passwordHint => Intl.message('Password', name: 'passwordHint');
//
//   String get passwordEmptyError =>
//       Intl.message('Password is empty', name: 'passwordEmptyError');
//
//   String get passwordUpperLowerError =>
//       Intl.message('Must contain uppercase and lowercase letters',
//           name: 'passwordUpperLowerError');
//
//   String get passwordDigitError =>
//       Intl.message('Must contain digits', name: 'passwordDigitError');
//
//   String get passwordMinLengthError =>
//       Intl.message('Must be at least 8 characters',
//           name: 'passwordMinLengthError');
//
//   String get confirmPasswordHint =>
//       Intl.message('Confirm password', name: 'confirmPasswordHint');
//
//   String get confirmPasswordEmptyError =>
//       Intl.message('Please enter a password',
//           name: 'confirmPasswordEmptyError');
//
//   String get passwordMismatchError =>
//       Intl.message('Passwords do not match', name: 'passwordMismatchError');
//
//   String get somethingWentWrong =>
//       Intl.message('Something went wrong. Please try again.',
//           name: 'somethingWentWrong');
//
//   String get emailAlreadyInUseError =>
//       Intl.message('This email is already registered.',
//           name: 'emailAlreadyInUseError');
//
//   String get invalidEmailError =>
//       Intl.message('Enter a valid email address.', name: 'invalidEmailError');
//
//   String get weakPasswordError => Intl.message(
//       'The password is too weak. Use at least 8 characters with digits and letters.',
//       name: 'weakPasswordError');
//
//   String get noInternetError =>
//       Intl.message('No internet connection. Check your network status.',
//           name: 'noInternetError');
//
//   String get genericErrorOccurred =>
//       Intl.message('An error occurred:', name: 'genericErrorOccurred');
//
//   String get errorTitle => Intl.message('Error', name: 'errorTitle');
//
//   String get contactInformation => Intl.message(
//         'Contact Information',
//         name: 'contactInformation',
//       );
//
//   String get phoneNumber => Intl.message(
//         'Phone number',
//         name: 'phoneNumber',
//       );
//
//   String get invalidEmailTitle => Intl.message(
//         'Invalid Email',
//         name: 'invalidEmailTitle',
//       );
//
//   String get invalidEmailContent => Intl.message(
//         'This email is already used by another user.',
//         name: 'invalidEmailContent',
//       );
//
//   String get remainingInformation =>
//       Intl.message('Remaining Information', name: 'remainingInformation');
//
//   String get confirmationCodeSent =>
//       Intl.message('You have been sent a confirmation code:',
//           name: 'confirmationCodeSent');
//
//   String get enterCodeToContinue =>
//       Intl.message('Enter the code to continue', name: 'enterCodeToContinue');
//
//   String get checkSpamFolder =>
//       Intl.message('Check your spam folder if it does not appear',
//           name: 'checkSpamFolder');
//
//   String get fourDigitCode =>
//       Intl.message('4-digit code', name: 'fourDigitCode');
//
//   String get pleaseEnterConfirmationCode =>
//       Intl.message('Please enter a confirmation code',
//           name: 'pleaseEnterConfirmationCode');
//
//   String get invalidConfirmationCode =>
//       Intl.message('Invalid confirmation code',
//           name: 'invalidConfirmationCode');
//
//   String get incorrectConfirmationCode =>
//       Intl.message('Incorrect confirmation code',
//           name: 'incorrectConfirmationCode');
//   String get appleSignInSuccessful =>
//       Intl.message('Apple Sign-In successful:', name: 'appleSignInSuccessful');
//
//   String get appleSignInFailed =>
//       Intl.message('Apple Sign-In failed:', name: 'appleSignInFailed');
//   String get googleLoginAbortedTitle =>
//       Intl.message('Login Aborted', name: 'googleLoginAbortedTitle');
//
//   String get googleLoginAbortedMessage =>
//       Intl.message('You cancelled the Google login.',
//           name: 'googleLoginAbortedMessage');
//
//   String get googleLoginFailedTitle =>
//       Intl.message('Login Failed', name: 'googleLoginFailedTitle');
//
//   String get googleLoginFailedMessage => Intl.message(
//       'Something went wrong during Google login. Please try again.',
//       name: 'googleLoginFailedMessage');
//
//   String get activeUsersNow => Intl.message(
//         'Users out now',
//         name: 'activeUsersNow',
//         desc: 'Label showing active users in town now',
//       );
//
//   String get error_loading_references => Intl.message(
//         'Der skete en fejl under indlæsning af nye referencer',
//         name: 'error_loading_references',
//         desc: 'Error message when references fail to load',
//       );
//   String get error_loading_points => Intl.message(
//         'Kunne ikke indlæse optjente point',
//         name: 'error_loading_points',
//         desc: 'Error message when points fail to load',
//       );
//   String pointsEarnedMessage(int points) => Intl.message(
//         'Du har tjent $points point siden sidst. Godt gået!',
//         name: 'pointsEarnedMessage',
//         args: [points],
//         desc: 'Success message for earning points',
//       );
//
//   String get profile => Intl.message(
//         'Profil',
//         name: 'profile',
//       );
//   String get shareNightViewPrefix => Intl.message(
//         'Share ',
//         name: 'shareNightViewPrefix',
//         desc: 'Prefix for sharing NightView, e.g., "Share "',
//       );
//
//   String get pointsEarnedPrefix => Intl.message(
//         'You have earned ',
//         name: 'pointsEarnedPrefix',
//         desc: 'Prefix for points earned message',
//       );
//
//   String get pointsEarnedSuffix => Intl.message(
//         ' points',
//         name: 'pointsEarnedSuffix',
//         desc: 'Suffix for points earned message',
//       );
//
//   String get errorUpdatingPoints => Intl.message(
//         'An error occurred while updating points',
//         name: 'errorUpdatingPoints',
//         desc: 'Error message when updating points fails',
//       );
//
//   String get phoneNumberHint => Intl.message(
//         'Enter phone number',
//         name: 'phoneNumberHint',
//         desc: 'Hint text for phone number input',
//       );
//
//   String get phoneNumberEmpty => Intl.message(
//         'Please enter a phone number',
//         name: 'phoneNumberEmpty',
//         desc: 'Error message when phone number is empty',
//       );
//
//   String get invalidPhoneNumber => Intl.message(
//         'Invalid phone number',
//         name: 'invalidPhoneNumber',
//         desc: 'Error message for invalid phone number',
//       );
//
//   String get shareCodeUploadError => Intl.message(
//         'Share code could not be uploaded to the cloud. Please try again.',
//         name: 'shareCodeUploadError',
//         desc: 'Error message when share code upload fails',
//       );
//
//   String get smsLaunchError => Intl.message(
//         'An error occurred while opening the SMS application',
//         name: 'smsLaunchError',
//         desc: 'Error message when SMS launch fails',
//       );
//
//   String get sendLinkForPoints => Intl.message(
//         'Send a link to your friends to earn points!',
//         name: 'sendLinkForPoints',
//         desc: 'Instruction text to send link for earning points',
//       );
//
//   String get appStore => Intl.message(
//         'App Store',
//         name: 'appStore',
//         desc: 'Label for App Store',
//       );
//
//   String get googlePlay => Intl.message(
//         'Google Play',
//         name: 'googlePlay',
//         desc: 'Label for Google Play',
//       );
//
//   String get appStoreLinkCopied => Intl.message(
//         'App Store link copied to clipboard!',
//         name: 'appStoreLinkCopied',
//         desc: 'Message when App Store link is copied',
//       );
//
//   String get googlePlayLinkCopied => Intl.message(
//         'Google Play link copied to clipboard!',
//         name: 'googlePlayLinkCopied',
//         desc: 'Message when Google Play link is copied',
//       );
//
//   String get map => Intl.message(
//         'Map',
//         name: 'map',
//         desc: 'Label for the Map tab in the bottom navigation',
//       );
//   String get searchForLocations => Intl.message(
//         "Søg efter lokationer, områder eller andet",
//         name: 'searchForLocations',
//         desc: 'Hint text for the search input for locations, areas, etc.',
//       );
//
//   String get social => Intl.message(
//         'Social',
//         name: 'social',
//         desc: 'Label for the Social tab in the bottom navigation',
//       );
// }
//
// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) =>
//       ['en', 'da' /*, 'de', 'sv', 'no'*/].contains(locale.languageCode);
//
//   @override
//   Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
//
//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }
