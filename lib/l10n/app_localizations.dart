import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('en')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @create_nightview_profile.
  ///
  /// In en, this message translates to:
  /// **'Create NightView profile'**
  String get create_nightview_profile;

  /// No description provided for @create_with_google.
  ///
  /// In en, this message translates to:
  /// **'Create with Google'**
  String get create_with_google;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @age_restriction.
  ///
  /// In en, this message translates to:
  /// **'You must be over 18 to use NightView in Denmark'**
  String get age_restriction;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdate;

  /// No description provided for @choose_password.
  ///
  /// In en, this message translates to:
  /// **'Choose Password'**
  String get choose_password;

  /// No description provided for @password_requirements.
  ///
  /// In en, this message translates to:
  /// **'The password must contain both uppercase and lowercase letters, numbers, and be at least 8 characters long.'**
  String get password_requirements;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_empty.
  ///
  /// In en, this message translates to:
  /// **'Password is empty'**
  String get password_empty;

  /// No description provided for @require_uppercase_lowercase.
  ///
  /// In en, this message translates to:
  /// **'Must contain uppercase and lowercase letters'**
  String get require_uppercase_lowercase;

  /// No description provided for @require_number.
  ///
  /// In en, this message translates to:
  /// **'Must contain numbers'**
  String get require_number;

  /// No description provided for @minimum_length.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get minimum_length;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get enter_password;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_mismatch;

  /// No description provided for @generic_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get generic_error;

  /// No description provided for @email_already_registered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get email_already_registered;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalid_email;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak. Use at least 8 characters with numbers and letters.'**
  String get weak_password;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network status.'**
  String get no_internet;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_occurred;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_information;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password_field.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password_field;

  /// No description provided for @invalid_email_address.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email_address;

  /// No description provided for @email_in_use.
  ///
  /// In en, this message translates to:
  /// **'This email is being used by another user.'**
  String get email_in_use;

  /// No description provided for @remaining_information.
  ///
  /// In en, this message translates to:
  /// **'Remaining Information'**
  String get remaining_information;

  /// No description provided for @age_restriction_2.
  ///
  /// In en, this message translates to:
  /// **'You must be over 18 to use NightView in Denmark'**
  String get age_restriction_2;

  /// No description provided for @birthdate_2.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdate_2;

  /// No description provided for @stay_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Stay logged in'**
  String get stay_logged_in;

  /// No description provided for @invalid_login.
  ///
  /// In en, this message translates to:
  /// **'Invalid login'**
  String get invalid_login;

  /// No description provided for @incorrect_information.
  ///
  /// In en, this message translates to:
  /// **'Information was not entered correctly. Please try again.'**
  String get incorrect_information;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @confirmation_code_sent.
  ///
  /// In en, this message translates to:
  /// **'You have been sent a confirmation code'**
  String get confirmation_code_sent;

  /// No description provided for @enter_code_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Enter the code to continue'**
  String get enter_code_to_continue;

  /// No description provided for @check_spam_folder.
  ///
  /// In en, this message translates to:
  /// **'Check your spam folder if it doesn\'t appear'**
  String get check_spam_folder;

  /// No description provided for @four_digit_code.
  ///
  /// In en, this message translates to:
  /// **'4-digit code'**
  String get four_digit_code;

  /// No description provided for @enter_confirmation_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter a confirmation code'**
  String get enter_confirmation_code;

  /// No description provided for @invalid_confirmation_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid confirmation code'**
  String get invalid_confirmation_code;

  /// No description provided for @wrong_confirmation_code.
  ///
  /// In en, this message translates to:
  /// **'Wrong confirmation code'**
  String get wrong_confirmation_code;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed;

  /// No description provided for @google_login_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during Google login. Please try again.'**
  String get google_login_error;

  /// No description provided for @credential_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading new credentials'**
  String get credential_error;

  /// No description provided for @points_update_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating points'**
  String get points_update_error;

  /// No description provided for @points_earned.
  ///
  /// In en, this message translates to:
  /// **'You have earned'**
  String get points_earned;

  /// No description provided for @points_since_last.
  ///
  /// In en, this message translates to:
  /// **'points since last time. Well done!'**
  String get points_since_last;

  /// No description provided for @points_load_error.
  ///
  /// In en, this message translates to:
  /// **'Could not load earned points'**
  String get points_load_error;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @you_have_earned.
  ///
  /// In en, this message translates to:
  /// **'You have earned '**
  String get you_have_earned;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **' points'**
  String get points;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @share_link_message.
  ///
  /// In en, this message translates to:
  /// **'Send a link to your friends to earn points!'**
  String get share_link_message;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enter_phone_number;

  /// No description provided for @phone_number_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get phone_number_required;

  /// No description provided for @invalid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalid_phone_number;

  /// No description provided for @share_code_upload_error.
  ///
  /// In en, this message translates to:
  /// **'Share code was not uploaded to the cloud. Please try again.'**
  String get share_code_upload_error;

  /// No description provided for @sms_app_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while opening the SMS application'**
  String get sms_app_error;

  /// No description provided for @earned_points.
  ///
  /// In en, this message translates to:
  /// **'Earned points:'**
  String get earned_points;

  /// No description provided for @redeem_shots.
  ///
  /// In en, this message translates to:
  /// **'Redeem shots'**
  String get redeem_shots;

  /// No description provided for @points_conversion.
  ///
  /// In en, this message translates to:
  /// **'1 point = 1 shot\n\n10 points = 1 bottle'**
  String get points_conversion;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @bottle.
  ///
  /// In en, this message translates to:
  /// **'bottle'**
  String get bottle;

  /// No description provided for @shots.
  ///
  /// In en, this message translates to:
  /// **'shots'**
  String get shots;

  /// No description provided for @shot.
  ///
  /// In en, this message translates to:
  /// **'shot'**
  String get shot;

  /// No description provided for @redemption_successful.
  ///
  /// In en, this message translates to:
  /// **'Redemption successful!'**
  String get redemption_successful;

  /// No description provided for @you_redeemed.
  ///
  /// In en, this message translates to:
  /// **'You redeemed '**
  String get you_redeemed;

  /// No description provided for @redemption_failed.
  ///
  /// In en, this message translates to:
  /// **'Redemption failed'**
  String get redemption_failed;

  /// No description provided for @redemption_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while redeeming shots.\nPlease try again later.'**
  String get redemption_error;

  /// No description provided for @redeem_button.
  ///
  /// In en, this message translates to:
  /// **'            Redeem'**
  String get redeem_button;

  /// No description provided for @shot_redemption_info.
  ///
  /// In en, this message translates to:
  /// **'\'Shots can be redeemed at'**
  String get shot_redemption_info;

  /// No description provided for @redemption_warning.
  ///
  /// In en, this message translates to:
  /// **'IMPORTANT:\nShow the staff that you are redeeming shots.\nOtherwise, the redemption is invalid!'**
  String get redemption_warning;

  /// No description provided for @free_bottle.
  ///
  /// In en, this message translates to:
  /// **'1 free bottle!'**
  String get free_bottle;

  /// No description provided for @free_shots.
  ///
  /// In en, this message translates to:
  /// **'free shots'**
  String get free_shots;

  /// No description provided for @privacy_policy_open.
  ///
  /// In en, this message translates to:
  /// **'Would you like to open the privacy policy in your browser?'**
  String get privacy_policy_open;

  /// No description provided for @change_picture_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change your profile picture?'**
  String get change_picture_confirmation;

  /// No description provided for @no_current_offer.
  ///
  /// In en, this message translates to:
  /// **'has no offers right now'**
  String get no_current_offer;

  /// No description provided for @main_offer.
  ///
  /// In en, this message translates to:
  /// **'Main Offer'**
  String get main_offer;

  /// Label for App Store
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get appStore;

  /// Label for Google Play
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get googlePlay;

  /// Message when App Store link is copied
  ///
  /// In en, this message translates to:
  /// **'App Store link copied to clipboard!'**
  String get appStoreLinkCopied;

  /// Message when Google Play link is copied
  ///
  /// In en, this message translates to:
  /// **'Google Play link copied to clipboard!'**
  String get googlePlayLinkCopied;

  /// No description provided for @allow_location_always.
  ///
  /// In en, this message translates to:
  /// **'Allow location always'**
  String get allow_location_always;

  /// No description provided for @location_permission_description.
  ///
  /// In en, this message translates to:
  /// **'To get the best experience on NightView, the app needs to always have access to your location.'**
  String get location_permission_description;

  /// No description provided for @open_app_settings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get open_app_settings;

  /// No description provided for @invalid_os.
  ///
  /// In en, this message translates to:
  /// **'INVALID OPERATING SYSTEM'**
  String get invalid_os;

  /// No description provided for @android_location_instructions.
  ///
  /// In en, this message translates to:
  /// **'> Open app settings\n> Permissions\n> Location\n> Allow always'**
  String get android_location_instructions;

  /// No description provided for @ios_location_instructions.
  ///
  /// In en, this message translates to:
  /// **'> Open app settings\n> Location\n> While using the app'**
  String get ios_location_instructions;

  /// No description provided for @allow_precise_location.
  ///
  /// In en, this message translates to:
  /// **'Allow precise location'**
  String get allow_precise_location;

  /// No description provided for @precise_location_description.
  ///
  /// In en, this message translates to:
  /// **'To provide the best experience for NightView users, the app needs access to the phone\'s precise location.'**
  String get precise_location_description;

  /// No description provided for @android_precise_location.
  ///
  /// In en, this message translates to:
  /// **'> Open app settings\n> Permissions\n> Location\n> Use precise location'**
  String get android_precise_location;

  /// No description provided for @ios_precise_location.
  ///
  /// In en, this message translates to:
  /// **'> Open app settings\n> Location\n> Precise location'**
  String get ios_precise_location;

  /// No description provided for @enable_location.
  ///
  /// In en, this message translates to:
  /// **'Enable location'**
  String get enable_location;

  /// No description provided for @enable_location_description.
  ///
  /// In en, this message translates to:
  /// **'To use NightView, you need to enable location services.'**
  String get enable_location_description;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @allow_location_while_using.
  ///
  /// In en, this message translates to:
  /// **'Allow location while using the app'**
  String get allow_location_while_using;

  /// No description provided for @location_while_using_description.
  ///
  /// In en, this message translates to:
  /// **'To get the best experience on NightView, the app needs access to your location while you are using the app (this also applies when the app is open in the background).'**
  String get location_while_using_description;

  /// No description provided for @android_location_while_using.
  ///
  /// In en, this message translates to:
  /// **'> Open app settings\n> Permissions\n> Location\n> Allow only while the app is in use'**
  String get android_location_while_using;

  /// No description provided for @ios_location_while_using.
  ///
  /// In en, this message translates to:
  /// **'> Open app settings\n> Location\n> While using the app'**
  String get ios_location_while_using;

  /// No description provided for @generic_error_2.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get generic_error_2;

  /// No description provided for @redeem_button_2.
  ///
  /// In en, this message translates to:
  /// **'            Redeem'**
  String get redeem_button_2;

  /// No description provided for @redemption_warning_2.
  ///
  /// In en, this message translates to:
  /// **'IMPORTANT:\nShow the staff that you are redeeming the offer.\nOtherwise, the redemption is invalid!'**
  String get redemption_warning_2;

  /// No description provided for @daily_redemption_limit.
  ///
  /// In en, this message translates to:
  /// **'You have already redeemed this offer today.\nCome back tomorrow!'**
  String get daily_redemption_limit;

  /// No description provided for @redemption_successful_2.
  ///
  /// In en, this message translates to:
  /// **'Redemption successful!'**
  String get redemption_successful_2;

  /// No description provided for @main_offer_redemption.
  ///
  /// In en, this message translates to:
  /// **'Redemption of main offer at '**
  String get main_offer_redemption;

  /// No description provided for @redemption_completed.
  ///
  /// In en, this message translates to:
  /// **'was completed.'**
  String get redemption_completed;

  /// No description provided for @redemption_failed_2.
  ///
  /// In en, this message translates to:
  /// **'Redemption failed'**
  String get redemption_failed_2;

  /// No description provided for @main_offer_redemption_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while redeeming the main offer.\nPlease try again later.'**
  String get main_offer_redemption_error;

  /// No description provided for @current_users.
  ///
  /// In en, this message translates to:
  /// **'Users in the city now'**
  String get current_users;

  /// No description provided for @search_locations.
  ///
  /// In en, this message translates to:
  /// **'Search for locations, areas, or anything else'**
  String get search_locations;

  /// No description provided for @no_locations_found.
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get no_locations_found;

  /// No description provided for @fetching_locations.
  ///
  /// In en, this message translates to:
  /// **'Fetching locations'**
  String get fetching_locations;

  /// No description provided for @find_friends.
  ///
  /// In en, this message translates to:
  /// **'Find new friends'**
  String get find_friends;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enter_name;

  /// No description provided for @friend_requests.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friend_requests;

  /// No description provided for @new_chat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get new_chat;

  /// No description provided for @chat_prompt.
  ///
  /// In en, this message translates to:
  /// **'Who do you want to chat with?'**
  String get chat_prompt;

  /// No description provided for @chat_creation_error.
  ///
  /// In en, this message translates to:
  /// **'Could not create new chat'**
  String get chat_creation_error;

  /// No description provided for @message_send_error.
  ///
  /// In en, this message translates to:
  /// **'Could not send message'**
  String get message_send_error;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @new_friend_requests.
  ///
  /// In en, this message translates to:
  /// **'New friend requests'**
  String get new_friend_requests;

  /// No description provided for @going_out_tonight.
  ///
  /// In en, this message translates to:
  /// **'Going out tonight'**
  String get going_out_tonight;

  /// No description provided for @not_going_out_tonight.
  ///
  /// In en, this message translates to:
  /// **'Not going out tonight'**
  String get not_going_out_tonight;

  /// No description provided for @unsure.
  ///
  /// In en, this message translates to:
  /// **'Unsure'**
  String get unsure;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @change_status.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get change_status;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @delete_user.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get delete_user;

  /// No description provided for @delete_user_2.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get delete_user_2;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your user? All data associated with your user will be removed.'**
  String get delete_confirmation;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @delete_user_error.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user'**
  String get delete_user_error;

  /// No description provided for @delete_user_error_description.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting your user. Please try again later. If you experience issues with your user in the future, you can email business@night-view.dk.'**
  String get delete_user_error_description;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @write_here.
  ///
  /// In en, this message translates to:
  /// **'Write here'**
  String get write_here;

  /// No description provided for @profile_picture_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated'**
  String get profile_picture_updated;

  /// No description provided for @profile_picture_load_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading profile picture'**
  String get profile_picture_load_error;

  /// No description provided for @profile_picture_change_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while changing profile picture'**
  String get profile_picture_change_error;

  /// No description provided for @change_picture.
  ///
  /// In en, this message translates to:
  /// **'Change picture'**
  String get change_picture;

  /// No description provided for @bio_updated.
  ///
  /// In en, this message translates to:
  /// **'Bio updated'**
  String get bio_updated;

  /// No description provided for @bio_update_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating bio'**
  String get bio_update_error;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_confirmation;

  /// No description provided for @remove_friend.
  ///
  /// In en, this message translates to:
  /// **'Remove friend'**
  String get remove_friend;

  /// No description provided for @remove_friend_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this friend?'**
  String get remove_friend_confirmation;

  /// No description provided for @add_friend.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get add_friend;

  /// No description provided for @login_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Der skete en fejl, da vi forsøgte at logge dig ind automatisk. Måske har du ændret din kode siden sidst.'**
  String get login_error_occurred;

  /// No description provided for @no_bio.
  ///
  /// In en, this message translates to:
  /// **'This user has not provided a biography.'**
  String get no_bio;

  /// No description provided for @recent_location_error.
  ///
  /// In en, this message translates to:
  /// **'Could not find recent location'**
  String get recent_location_error;

  /// No description provided for @location_sharing_disabled.
  ///
  /// In en, this message translates to:
  /// **'This person is not sharing their location'**
  String get location_sharing_disabled;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @latest_location.
  ///
  /// In en, this message translates to:
  /// **'Latest location'**
  String get latest_location;

  /// No description provided for @invalid_user.
  ///
  /// In en, this message translates to:
  /// **'Invalid user'**
  String get invalid_user;

  /// No description provided for @bio_2.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio_2;

  /// No description provided for @find.
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get find;

  /// No description provided for @swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe!'**
  String get swipe;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Error logging in'**
  String get login_error;

  /// No description provided for @automatic_login_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while trying to log you in automatically. You may have changed your password since last time.'**
  String get automatic_login_error;

  /// No description provided for @ready_for_the_city.
  ///
  /// In en, this message translates to:
  /// **'Ready for the city?'**
  String get ready_for_the_city;

  /// No description provided for @ready_to_conquer_dancefloor.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to conquer the dance floor tonight?'**
  String get ready_to_conquer_dancefloor;

  /// No description provided for @plans_for_adventure.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to go on an adventure in the city tonight?'**
  String get plans_for_adventure;

  /// No description provided for @let_make_trouble.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make trouble tonight?'**
  String get let_make_trouble;

  /// No description provided for @wild_night.
  ///
  /// In en, this message translates to:
  /// **'Will it be one of those wild nights in the city tonight?'**
  String get wild_night;

  /// No description provided for @let_loose.
  ///
  /// In en, this message translates to:
  /// **'Is it one of those nights where we let loose?'**
  String get let_loose;

  /// No description provided for @show_best_moves.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and show our best moves tonight?'**
  String get show_best_moves;

  /// No description provided for @make_city_safe.
  ///
  /// In en, this message translates to:
  /// **'Are you heading out to make the city unsafe tonight?'**
  String get make_city_safe;

  /// No description provided for @good_bartender.
  ///
  /// In en, this message translates to:
  /// **'I know a really good bartender. Shall we go out and have him make some special drinks for us?'**
  String get good_bartender;

  /// No description provided for @be_my_date.
  ///
  /// In en, this message translates to:
  /// **'Will you be my date tonight and let me show you how to have fun?'**
  String get be_my_date;

  /// No description provided for @waste_youth.
  ///
  /// In en, this message translates to:
  /// **'What do you say we waste our youth a bit tonight and see where it takes us?'**
  String get waste_youth;

  /// No description provided for @light_up_dancefloor.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to light up the dance floor tonight?'**
  String get light_up_dancefloor;

  /// No description provided for @create_memories.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to create memories in the city tonight?'**
  String get create_memories;

  /// No description provided for @max_gas.
  ///
  /// In en, this message translates to:
  /// **'Is it one of those nights where we go all out?'**
  String get max_gas;

  /// No description provided for @make_night_unforgettable.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make the night wild and unforgettable?'**
  String get make_night_unforgettable;

  /// No description provided for @take_city_with_style.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take the city in style?'**
  String get take_city_with_style;

  /// No description provided for @night_of_laughter_and_dance.
  ///
  /// In en, this message translates to:
  /// **'Will it be a night full of laughter and dance?'**
  String get night_of_laughter_and_dance;

  /// No description provided for @conquer_city.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to conquer the city and have fun?'**
  String get conquer_city;

  /// No description provided for @make_own_party.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make the night our own party?'**
  String get make_own_party;

  /// No description provided for @let_go_of_inhibitions.
  ///
  /// In en, this message translates to:
  /// **'Is it one of those nights where we let go of all inhibitions?'**
  String get let_go_of_inhibitions;

  /// No description provided for @night_adventure.
  ///
  /// In en, this message translates to:
  /// **'Are you planning to go on a night adventure with us tonight?'**
  String get night_adventure;

  /// No description provided for @make_streets_safe.
  ///
  /// In en, this message translates to:
  /// **'Is it tonight we make the streets unsafe?'**
  String get make_streets_safe;

  /// No description provided for @create_party_vibe.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and create a party vibe tonight?'**
  String get create_party_vibe;

  /// No description provided for @make_night_special.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the night something special?'**
  String get make_night_special;

  /// No description provided for @live_life_to_fullest.
  ///
  /// In en, this message translates to:
  /// **'Will it be one of those nights where we live life to the fullest?'**
  String get live_life_to_fullest;

  /// No description provided for @party_like_never_before.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and party like never before tonight?'**
  String get party_like_never_before;

  /// No description provided for @take_nightlife_by_storm.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take the nightlife by storm with us?'**
  String get take_nightlife_by_storm;

  /// No description provided for @make_night_unforgettable_4.
  ///
  /// In en, this message translates to:
  /// **'Have you thought about making the night wild and unforgettable?'**
  String get make_night_unforgettable_4;

  /// No description provided for @dancefloor_as_stage.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the dance floor your stage tonight?'**
  String get dancefloor_as_stage;

  /// No description provided for @light_up_city.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and light up the city tonight?'**
  String get light_up_city;

  /// No description provided for @go_wild_on_dancefloor.
  ///
  /// In en, this message translates to:
  /// **'Is it tonight we go wild on the dance floor?'**
  String get go_wild_on_dancefloor;

  /// No description provided for @be_center_of_party.
  ///
  /// In en, this message translates to:
  /// **'Are you planning to be the center of the party tonight?'**
  String get be_center_of_party;

  /// No description provided for @night_full_of_fun.
  ///
  /// In en, this message translates to:
  /// **'Are you ready for a night full of fun and good vibes?'**
  String get night_full_of_fun;

  /// No description provided for @take_city_by_storm.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take the city by storm tonight?'**
  String get take_city_by_storm;

  /// No description provided for @create_wild_memories.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to create wild memories tonight?'**
  String get create_wild_memories;

  /// No description provided for @party_without_equal.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the night a party like no other?'**
  String get party_without_equal;

  /// No description provided for @fire_up_dancefloor.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and fire it up on the dance floor?'**
  String get fire_up_dancefloor;

  /// No description provided for @make_city_safe_4.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the city unsafe with us tonight?'**
  String get make_city_safe_4;

  /// No description provided for @adventure_in_nightlife.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to go on an adventure in the nightlife?'**
  String get adventure_in_nightlife;

  /// No description provided for @conquer_nightlife.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and conquer the nightlife tonight?'**
  String get conquer_nightlife;

  /// No description provided for @play_rockstars.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and play rockstars tonight?'**
  String get play_rockstars;

  /// No description provided for @dance_with_two_left_feet.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to dance like we have two left feet?'**
  String get dance_with_two_left_feet;

  /// No description provided for @epic_snapchat_stories.
  ///
  /// In en, this message translates to:
  /// **'Is it tonight we make some epic Snapchat stories?'**
  String get epic_snapchat_stories;

  /// No description provided for @crazy_party_animal.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to be the craziest party animal in town tonight?'**
  String get crazy_party_animal;

  /// No description provided for @legendary_missteps.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make some legendary missteps on the dance floor?'**
  String get legendary_missteps;

  /// No description provided for @make_new_friends.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and see how many new friends we can make tonight?'**
  String get make_new_friends;

  /// No description provided for @trip_to_party_league.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take a trip to the party league tonight?'**
  String get trip_to_party_league;

  /// No description provided for @going_out_tonight_2.
  ///
  /// In en, this message translates to:
  /// **'Going out tonight?'**
  String get going_out_tonight_2;

  /// No description provided for @shall_we.
  ///
  /// In en, this message translates to:
  /// **'Shall we?'**
  String get shall_we;

  /// No description provided for @fire_it_up.
  ///
  /// In en, this message translates to:
  /// **'Go out and fire it up?'**
  String get fire_it_up;

  /// No description provided for @drinking.
  ///
  /// In en, this message translates to:
  /// **'Drinking?'**
  String get drinking;

  /// No description provided for @going_out.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out?'**
  String get going_out;

  /// No description provided for @club.
  ///
  /// In en, this message translates to:
  /// **'The club?'**
  String get club;

  /// No description provided for @create_ravage.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to create havoc in the city tonight?'**
  String get create_ravage;

  /// No description provided for @create_festive_chaos.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and create some festive chaos in the city?'**
  String get create_festive_chaos;

  /// No description provided for @shake_up_city.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and shake up the city?'**
  String get shake_up_city;

  /// No description provided for @time_for_trouble.
  ///
  /// In en, this message translates to:
  /// **'Is it time to make some trouble tonight?'**
  String get time_for_trouble;

  /// No description provided for @part_of_nightlife.
  ///
  /// In en, this message translates to:
  /// **'Will you be a part of the nightlife today?'**
  String get part_of_nightlife;

  /// No description provided for @plans_for_evening.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to go out tonight?'**
  String get plans_for_evening;

  /// No description provided for @ready_for_city_trip.
  ///
  /// In en, this message translates to:
  /// **'Are you ready for a city trip today?'**
  String get ready_for_city_trip;

  /// No description provided for @age_limit_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Age limit not specified.'**
  String get age_limit_not_specified;

  /// No description provided for @open_until.
  ///
  /// In en, this message translates to:
  /// **'Open until'**
  String get open_until;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **' today.'**
  String get today;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @yet.
  ///
  /// In en, this message translates to:
  /// **'yet.'**
  String get yet;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @nowhere.
  ///
  /// In en, this message translates to:
  /// **'nowhere'**
  String get nowhere;

  /// No description provided for @select_image.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get select_image;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @error_occurred_2.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_occurred_2;

  /// No description provided for @add_favorite.
  ///
  /// In en, this message translates to:
  /// **'Add favorite'**
  String get add_favorite;

  /// No description provided for @favorite_club_message.
  ///
  /// In en, this message translates to:
  /// **'By adding a club as a favorite, you allow this club/bar to send you messages about their offers.'**
  String get favorite_club_message;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @continues.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continues;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @short_monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get short_monday;

  /// No description provided for @short_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get short_tuesday;

  /// No description provided for @short_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get short_wednesday;

  /// No description provided for @short_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get short_thursday;

  /// No description provided for @short_friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get short_friday;

  /// No description provided for @short_saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get short_saturday;

  /// No description provided for @short_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get short_sunday;

  /// No description provided for @remove_favorite.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get remove_favorite;

  /// No description provided for @remove_favorite_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this club from your favorites?'**
  String get remove_favorite_confirmation;

  /// No description provided for @undo_2.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo_2;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @google_login_cancelled.
  ///
  /// In en, this message translates to:
  /// **'You canceled the Google login.'**
  String get google_login_cancelled;

  /// No description provided for @confirm_rating.
  ///
  /// In en, this message translates to:
  /// **'Confirm rating'**
  String get confirm_rating;

  /// No description provided for @give_rating.
  ///
  /// In en, this message translates to:
  /// **'Would you like to give'**
  String get give_rating;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'a rating of'**
  String get rating;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'/5 stars?'**
  String get stars;

  /// No description provided for @already_rated.
  ///
  /// In en, this message translates to:
  /// **'You have already rated'**
  String get already_rated;

  /// No description provided for @recently.
  ///
  /// In en, this message translates to:
  /// **'recently.'**
  String get recently;

  /// No description provided for @unknown_opening_hours.
  ///
  /// In en, this message translates to:
  /// **'Unknown opening hours'**
  String get unknown_opening_hours;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @closed_today.
  ///
  /// In en, this message translates to:
  /// **'closed today.'**
  String get closed_today;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @fetching_nearby_locations.
  ///
  /// In en, this message translates to:
  /// **'Fetching locations near you'**
  String get fetching_nearby_locations;

  /// No description provided for @fetching_remaining_locations.
  ///
  /// In en, this message translates to:
  /// **'Fetching remaining locations in the background ({count})'**
  String fetching_remaining_locations(Object count);

  /// No description provided for @not_today.
  ///
  /// In en, this message translates to:
  /// **'Not today'**
  String get not_today;

  /// No description provided for @i_am_fresh.
  ///
  /// In en, this message translates to:
  /// **'I am fresh!'**
  String get i_am_fresh;

  /// No description provided for @ready_to_conquer_dancefloor_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to conquer the dance floor tonight?'**
  String get ready_to_conquer_dancefloor_2;

  /// No description provided for @plans_for_adventure_2.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to go on an adventure in the city tonight?'**
  String get plans_for_adventure_2;

  /// No description provided for @let_make_trouble_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make trouble tonight?'**
  String get let_make_trouble_2;

  /// No description provided for @wild_night_2.
  ///
  /// In en, this message translates to:
  /// **'Will it be one of those wild nights in the city tonight?'**
  String get wild_night_2;

  /// No description provided for @let_loose_2.
  ///
  /// In en, this message translates to:
  /// **'Is it one of those nights where we let loose?'**
  String get let_loose_2;

  /// No description provided for @show_best_moves_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and show our best moves tonight?'**
  String get show_best_moves_2;

  /// No description provided for @make_city_safe_2.
  ///
  /// In en, this message translates to:
  /// **'Are you heading out to make the city unsafe tonight?'**
  String get make_city_safe_2;

  /// No description provided for @good_bartender_2.
  ///
  /// In en, this message translates to:
  /// **'I know a really good bartender. Shall we go out and have him make some special drinks for us?'**
  String get good_bartender_2;

  /// No description provided for @be_my_date_2.
  ///
  /// In en, this message translates to:
  /// **'Will you be my date tonight and let me show you how to have fun?'**
  String get be_my_date_2;

  /// No description provided for @waste_youth_2.
  ///
  /// In en, this message translates to:
  /// **'What do you say we waste our youth a bit tonight and see where it takes us?'**
  String get waste_youth_2;

  /// No description provided for @light_up_dancefloor_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to light up the dance floor tonight?'**
  String get light_up_dancefloor_2;

  /// No description provided for @create_memories_2.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to create memories in the city tonight?'**
  String get create_memories_2;

  /// No description provided for @max_gas_2.
  ///
  /// In en, this message translates to:
  /// **'Is it one of those nights where we go all out?'**
  String get max_gas_2;

  /// No description provided for @make_night_unforgettable_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make the night wild and unforgettable?'**
  String get make_night_unforgettable_2;

  /// No description provided for @take_city_with_style_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take the city in style?'**
  String get take_city_with_style_2;

  /// No description provided for @night_of_laughter_and_dance_2.
  ///
  /// In en, this message translates to:
  /// **'Will it be a night full of laughter and dance?'**
  String get night_of_laughter_and_dance_2;

  /// No description provided for @conquer_city_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to conquer the city and have fun?'**
  String get conquer_city_2;

  /// No description provided for @make_own_party_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make the night our own party?'**
  String get make_own_party_2;

  /// No description provided for @let_go_of_inhibitions_2.
  ///
  /// In en, this message translates to:
  /// **'Is it one of those nights where we let go of all inhibitions?'**
  String get let_go_of_inhibitions_2;

  /// No description provided for @night_adventure_2.
  ///
  /// In en, this message translates to:
  /// **'Are you planning to go on a night adventure with us tonight?'**
  String get night_adventure_2;

  /// No description provided for @make_streets_safe_2.
  ///
  /// In en, this message translates to:
  /// **'Is it tonight we make the streets unsafe?'**
  String get make_streets_safe_2;

  /// No description provided for @create_party_vibe_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and create a party vibe tonight?'**
  String get create_party_vibe_2;

  /// No description provided for @make_night_special_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the night something special?'**
  String get make_night_special_2;

  /// No description provided for @live_life_to_fullest_2.
  ///
  /// In en, this message translates to:
  /// **'Will it be one of those nights where we live life to the fullest?'**
  String get live_life_to_fullest_2;

  /// No description provided for @party_like_never_before_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and party like never before tonight?'**
  String get party_like_never_before_2;

  /// No description provided for @take_nightlife_by_storm_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take the nightlife by storm with us?'**
  String get take_nightlife_by_storm_2;

  /// No description provided for @make_night_unforgettable_3.
  ///
  /// In en, this message translates to:
  /// **'Have you thought about making the night wild and unforgettable?'**
  String get make_night_unforgettable_3;

  /// No description provided for @dancefloor_as_stage_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the dance floor your stage tonight?'**
  String get dancefloor_as_stage_2;

  /// No description provided for @light_up_city_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and light up the city tonight?'**
  String get light_up_city_2;

  /// No description provided for @go_wild_on_dancefloor_2.
  ///
  /// In en, this message translates to:
  /// **'Is it tonight we go wild on the dance floor?'**
  String get go_wild_on_dancefloor_2;

  /// No description provided for @be_center_of_party_2.
  ///
  /// In en, this message translates to:
  /// **'Are you planning to be the center of the party tonight?'**
  String get be_center_of_party_2;

  /// No description provided for @night_full_of_fun_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready for a night full of fun and good vibes?'**
  String get night_full_of_fun_2;

  /// No description provided for @take_city_by_storm_3.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take the city by storm tonight?'**
  String get take_city_by_storm_3;

  /// No description provided for @create_wild_memories_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to create wild memories tonight?'**
  String get create_wild_memories_2;

  /// No description provided for @party_without_equal_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the night a party like no other?'**
  String get party_without_equal_2;

  /// No description provided for @fire_up_dancefloor_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and fire it up on the dance floor?'**
  String get fire_up_dancefloor_2;

  /// No description provided for @make_city_safe_3.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to make the city unsafe with us tonight?'**
  String get make_city_safe_3;

  /// No description provided for @adventure_in_nightlife_2.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to go on an adventure in the nightlife?'**
  String get adventure_in_nightlife_2;

  /// No description provided for @conquer_nightlife_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and conquer the nightlife tonight?'**
  String get conquer_nightlife_2;

  /// No description provided for @play_rockstars_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and play rockstars tonight?'**
  String get play_rockstars_2;

  /// No description provided for @dance_with_two_left_feet_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to dance like we have two left feet?'**
  String get dance_with_two_left_feet_2;

  /// No description provided for @epic_snapchat_stories_2.
  ///
  /// In en, this message translates to:
  /// **'Is it tonight we make some epic Snapchat stories?'**
  String get epic_snapchat_stories_2;

  /// No description provided for @crazy_party_animal_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to be the craziest party animal in town tonight?'**
  String get crazy_party_animal_2;

  /// No description provided for @legendary_missteps_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and make some legendary missteps on the dance floor?'**
  String get legendary_missteps_2;

  /// No description provided for @make_new_friends_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and see how many new friends we can make tonight?'**
  String get make_new_friends_2;

  /// No description provided for @trip_to_party_league_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to take a trip to the party league tonight?'**
  String get trip_to_party_league_2;

  /// No description provided for @going_out_tonight_3.
  ///
  /// In en, this message translates to:
  /// **'Going out tonight?'**
  String get going_out_tonight_3;

  /// No description provided for @shall_we_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we?'**
  String get shall_we_2;

  /// No description provided for @fire_it_up_2.
  ///
  /// In en, this message translates to:
  /// **'Go out and fire it up?'**
  String get fire_it_up_2;

  /// No description provided for @drinking_2.
  ///
  /// In en, this message translates to:
  /// **'Drinking?'**
  String get drinking_2;

  /// No description provided for @going_out_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out?'**
  String get going_out_2;

  /// No description provided for @club_2.
  ///
  /// In en, this message translates to:
  /// **'The club?'**
  String get club_2;

  /// No description provided for @create_ravage_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to create havoc in the city tonight?'**
  String get create_ravage_2;

  /// No description provided for @create_festive_chaos_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and create some festive chaos in the city?'**
  String get create_festive_chaos_2;

  /// No description provided for @shake_up_city_2.
  ///
  /// In en, this message translates to:
  /// **'Shall we go out and shake up the city?'**
  String get shake_up_city_2;

  /// No description provided for @time_for_trouble_2.
  ///
  /// In en, this message translates to:
  /// **'Is it time to make some trouble tonight?'**
  String get time_for_trouble_2;

  /// No description provided for @part_of_nightlife_2.
  ///
  /// In en, this message translates to:
  /// **'Will you be a part of the nightlife today?'**
  String get part_of_nightlife_2;

  /// No description provided for @plans_for_evening_2.
  ///
  /// In en, this message translates to:
  /// **'Do you have plans to go out tonight?'**
  String get plans_for_evening_2;

  /// No description provided for @ready_for_city_trip_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready for a city trip today?'**
  String get ready_for_city_trip_2;

  /// No description provided for @age_limit_not_specified_2.
  ///
  /// In en, this message translates to:
  /// **'Age limit not specified.'**
  String get age_limit_not_specified_2;

  /// No description provided for @open_until_2.
  ///
  /// In en, this message translates to:
  /// **'Open until'**
  String get open_until_2;

  /// No description provided for @today_2.
  ///
  /// In en, this message translates to:
  /// **' today.'**
  String get today_2;

  /// No description provided for @open_2.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open_2;

  /// No description provided for @yet_3.
  ///
  /// In en, this message translates to:
  /// **'yet.'**
  String get yet_3;

  /// No description provided for @minute_2.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute_2;

  /// No description provided for @minutes_2.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes_2;

  /// No description provided for @yet_4.
  ///
  /// In en, this message translates to:
  /// **'yet.'**
  String get yet_4;

  /// No description provided for @error_occurred_3.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_occurred_3;

  /// No description provided for @add_favorite_2.
  ///
  /// In en, this message translates to:
  /// **'Add favorite'**
  String get add_favorite_2;

  /// No description provided for @favorite_club_message_2.
  ///
  /// In en, this message translates to:
  /// **'By adding a club as a favorite, you allow this club/bar to send you messages about their offers.'**
  String get favorite_club_message_2;

  /// No description provided for @undo_3.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo_3;

  /// No description provided for @continue_2.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_2;

  /// No description provided for @remove_favorite_2.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get remove_favorite_2;

  /// No description provided for @remove_favorite_confirmation_2.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this club from your favorites?'**
  String get remove_favorite_confirmation_2;

  /// No description provided for @undo_4.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo_4;

  /// No description provided for @remove_2.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove_2;

  /// No description provided for @confirm_rating_2.
  ///
  /// In en, this message translates to:
  /// **'Confirm rating'**
  String get confirm_rating_2;

  /// No description provided for @give_rating_2.
  ///
  /// In en, this message translates to:
  /// **'Would you like to give'**
  String get give_rating_2;

  /// No description provided for @rating_2.
  ///
  /// In en, this message translates to:
  /// **'a rating of'**
  String get rating_2;

  /// No description provided for @stars_2.
  ///
  /// In en, this message translates to:
  /// **'/5 stars?'**
  String get stars_2;

  /// No description provided for @already_rated_2.
  ///
  /// In en, this message translates to:
  /// **'You have already rated'**
  String get already_rated_2;

  /// No description provided for @recently_2.
  ///
  /// In en, this message translates to:
  /// **'recently.'**
  String get recently_2;

  /// No description provided for @unknown_opening_hours_2.
  ///
  /// In en, this message translates to:
  /// **'Unknown opening hours'**
  String get unknown_opening_hours_2;

  /// No description provided for @capacity_2.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity_2;

  /// No description provided for @closed_today_2.
  ///
  /// In en, this message translates to:
  /// **'closed today.'**
  String get closed_today_2;

  /// No description provided for @calculating_2.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating_2;

  /// No description provided for @fetching_nearby_locations_2.
  ///
  /// In en, this message translates to:
  /// **'Fetching locations near you'**
  String get fetching_nearby_locations_2;

  /// No description provided for @fetching_remaining_locations_2.
  ///
  /// In en, this message translates to:
  /// **'Fetching remaining locations in the background ({count})'**
  String fetching_remaining_locations_2(Object count);

  /// No description provided for @not_today_2.
  ///
  /// In en, this message translates to:
  /// **'Not today'**
  String get not_today_2;

  /// No description provided for @i_am_fresh_2.
  ///
  /// In en, this message translates to:
  /// **'I am fresh!'**
  String get i_am_fresh_2;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['da', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da': return AppLocalizationsDa();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
