// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log in`
  String get login {
    return Intl.message('Log in', name: 'login', desc: '', args: []);
  }

  /// `Create NightView profile`
  String get create_nightview_profile {
    return Intl.message(
      'Create NightView profile',
      name: 'create_nightview_profile',
      desc: '',
      args: [],
    );
  }

  /// `Create with Google`
  String get create_with_google {
    return Intl.message(
      'Create with Google',
      name: 'create_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personal_information {
    return Intl.message(
      'Personal Information',
      name: 'personal_information',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message('First Name', name: 'first_name', desc: '', args: []);
  }

  /// `Last Name`
  String get last_name {
    return Intl.message('Last Name', name: 'last_name', desc: '', args: []);
  }

  /// `You must be over 18 to use NightView in Denmark`
  String get age_restriction {
    return Intl.message(
      'You must be over 18 to use NightView in Denmark',
      name: 'age_restriction',
      desc: '',
      args: [],
    );
  }

  /// `Birthdate`
  String get birthdate {
    return Intl.message('Birthdate', name: 'birthdate', desc: '', args: []);
  }

  /// `Choose Password`
  String get choose_password {
    return Intl.message(
      'Choose Password',
      name: 'choose_password',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain both uppercase and lowercase letters, numbers, and be at least 8 characters long.`
  String get password_requirements {
    return Intl.message(
      'The password must contain both uppercase and lowercase letters, numbers, and be at least 8 characters long.',
      name: 'password_requirements',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password is empty`
  String get password_empty {
    return Intl.message(
      'Password is empty',
      name: 'password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Must contain uppercase and lowercase letters`
  String get require_uppercase_lowercase {
    return Intl.message(
      'Must contain uppercase and lowercase letters',
      name: 'require_uppercase_lowercase',
      desc: '',
      args: [],
    );
  }

  /// `Must contain numbers`
  String get require_number {
    return Intl.message(
      'Must contain numbers',
      name: 'require_number',
      desc: '',
      args: [],
    );
  }

  /// `Must be at least 8 characters`
  String get minimum_length {
    return Intl.message(
      'Must be at least 8 characters',
      name: 'minimum_length',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get enter_password {
    return Intl.message(
      'Please enter a password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get password_mismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get generic_error {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'generic_error',
      desc: '',
      args: [],
    );
  }

  /// `This email is already registered.`
  String get email_already_registered {
    return Intl.message(
      'This email is already registered.',
      name: 'email_already_registered',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalid_email {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak. Use at least 8 characters with numbers and letters.`
  String get weak_password {
    return Intl.message(
      'The password is too weak. Use at least 8 characters with numbers and letters.',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Check your network status.`
  String get no_internet {
    return Intl.message(
      'No internet connection. Check your network status.',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get error_occurred {
    return Intl.message(
      'An error occurred',
      name: 'error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Contact Information`
  String get contact_information {
    return Intl.message(
      'Contact Information',
      name: 'contact_information',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `password`
  String get password_field {
    return Intl.message('password', name: 'password_field', desc: '', args: []);
  }

  /// `Invalid email`
  String get invalid_email_address {
    return Intl.message(
      'Invalid email',
      name: 'invalid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `This email is being used by another user.`
  String get email_in_use {
    return Intl.message(
      'This email is being used by another user.',
      name: 'email_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Information`
  String get remaining_information {
    return Intl.message(
      'Remaining Information',
      name: 'remaining_information',
      desc: '',
      args: [],
    );
  }

  /// `You must be over 18 to use NightView in Denmark`
  String get age_restriction_2 {
    return Intl.message(
      'You must be over 18 to use NightView in Denmark',
      name: 'age_restriction_2',
      desc: '',
      args: [],
    );
  }

  /// `Birthdate`
  String get birthdate_2 {
    return Intl.message('Birthdate', name: 'birthdate_2', desc: '', args: []);
  }

  /// `Stay logged in`
  String get stay_logged_in {
    return Intl.message(
      'Stay logged in',
      name: 'stay_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Invalid login`
  String get invalid_login {
    return Intl.message(
      'Invalid login',
      name: 'invalid_login',
      desc: '',
      args: [],
    );
  }

  /// `Information was not entered correctly. Please try again.`
  String get incorrect_information {
    return Intl.message(
      'Information was not entered correctly. Please try again.',
      name: 'incorrect_information',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message('Okay', name: 'okay', desc: '', args: []);
  }

  /// `You have been sent a confirmation code`
  String get confirmation_code_sent {
    return Intl.message(
      'You have been sent a confirmation code',
      name: 'confirmation_code_sent',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code to continue`
  String get enter_code_to_continue {
    return Intl.message(
      'Enter the code to continue',
      name: 'enter_code_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Check your spam folder if it doesn't appear`
  String get check_spam_folder {
    return Intl.message(
      'Check your spam folder if it doesn\'t appear',
      name: 'check_spam_folder',
      desc: '',
      args: [],
    );
  }

  /// `4-digit code`
  String get four_digit_code {
    return Intl.message(
      '4-digit code',
      name: 'four_digit_code',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a confirmation code`
  String get enter_confirmation_code {
    return Intl.message(
      'Please enter a confirmation code',
      name: 'enter_confirmation_code',
      desc: '',
      args: [],
    );
  }

  /// `Invalid confirmation code`
  String get invalid_confirmation_code {
    return Intl.message(
      'Invalid confirmation code',
      name: 'invalid_confirmation_code',
      desc: '',
      args: [],
    );
  }

  /// `Wrong confirmation code`
  String get wrong_confirmation_code {
    return Intl.message(
      'Wrong confirmation code',
      name: 'wrong_confirmation_code',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get login_failed {
    return Intl.message(
      'Login failed',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong during Google login. Please try again.`
  String get google_login_error {
    return Intl.message(
      'Something went wrong during Google login. Please try again.',
      name: 'google_login_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while loading new credentials`
  String get credential_error {
    return Intl.message(
      'An error occurred while loading new credentials',
      name: 'credential_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while updating points`
  String get points_update_error {
    return Intl.message(
      'An error occurred while updating points',
      name: 'points_update_error',
      desc: '',
      args: [],
    );
  }

  /// `You have earned`
  String get points_earned {
    return Intl.message(
      'You have earned',
      name: 'points_earned',
      desc: '',
      args: [],
    );
  }

  /// `points since last time. Well done!`
  String get points_since_last {
    return Intl.message(
      'points since last time. Well done!',
      name: 'points_since_last',
      desc: '',
      args: [],
    );
  }

  /// `Could not load earned points`
  String get points_load_error {
    return Intl.message(
      'Could not load earned points',
      name: 'points_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `You have earned `
  String get you_have_earned {
    return Intl.message(
      'You have earned ',
      name: 'you_have_earned',
      desc: '',
      args: [],
    );
  }

  /// ` points`
  String get points {
    return Intl.message(' points', name: 'points', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Social`
  String get social {
    return Intl.message('Social', name: 'social', desc: '', args: []);
  }

  /// `Send a link to your friends to earn points!`
  String get share_link_message {
    return Intl.message(
      'Send a link to your friends to earn points!',
      name: 'share_link_message',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enter_phone_number {
    return Intl.message(
      'Enter phone number',
      name: 'enter_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a phone number`
  String get phone_number_required {
    return Intl.message(
      'Please enter a phone number',
      name: 'phone_number_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalid_phone_number {
    return Intl.message(
      'Invalid phone number',
      name: 'invalid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Share code was not uploaded to the cloud. Please try again.`
  String get share_code_upload_error {
    return Intl.message(
      'Share code was not uploaded to the cloud. Please try again.',
      name: 'share_code_upload_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while opening the SMS application`
  String get sms_app_error {
    return Intl.message(
      'An error occurred while opening the SMS application',
      name: 'sms_app_error',
      desc: '',
      args: [],
    );
  }

  /// `Earned points:`
  String get earned_points {
    return Intl.message(
      'Earned points:',
      name: 'earned_points',
      desc: '',
      args: [],
    );
  }

  /// `Redeem shots`
  String get redeem_shots {
    return Intl.message(
      'Redeem shots',
      name: 'redeem_shots',
      desc: '',
      args: [],
    );
  }

  /// `1 point = 1 shot\n\n10 points = 1 bottle`
  String get points_conversion {
    return Intl.message(
      '1 point = 1 shot\n\n10 points = 1 bottle',
      name: 'points_conversion',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message('Redeem', name: 'redeem', desc: '', args: []);
  }

  /// `bottle`
  String get bottle {
    return Intl.message('bottle', name: 'bottle', desc: '', args: []);
  }

  /// `shots`
  String get shots {
    return Intl.message('shots', name: 'shots', desc: '', args: []);
  }

  /// `shot`
  String get shot {
    return Intl.message('shot', name: 'shot', desc: '', args: []);
  }

  /// `Redemption successful!`
  String get redemption_successful {
    return Intl.message(
      'Redemption successful!',
      name: 'redemption_successful',
      desc: '',
      args: [],
    );
  }

  /// `You redeemed `
  String get you_redeemed {
    return Intl.message(
      'You redeemed ',
      name: 'you_redeemed',
      desc: '',
      args: [],
    );
  }

  /// `Redemption failed`
  String get redemption_failed {
    return Intl.message(
      'Redemption failed',
      name: 'redemption_failed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while redeeming shots.\nPlease try again later.`
  String get redemption_error {
    return Intl.message(
      'An error occurred while redeeming shots.\nPlease try again later.',
      name: 'redemption_error',
      desc: '',
      args: [],
    );
  }

  /// `            Redeem`
  String get redeem_button {
    return Intl.message(
      '            Redeem',
      name: 'redeem_button',
      desc: '',
      args: [],
    );
  }

  /// `'Shots can be redeemed at`
  String get shot_redemption_info {
    return Intl.message(
      '\'Shots can be redeemed at',
      name: 'shot_redemption_info',
      desc: '',
      args: [],
    );
  }

  /// `IMPORTANT:\nShow the staff that you are redeeming shots.\nOtherwise, the redemption is invalid!`
  String get redemption_warning {
    return Intl.message(
      'IMPORTANT:\nShow the staff that you are redeeming shots.\nOtherwise, the redemption is invalid!',
      name: 'redemption_warning',
      desc: '',
      args: [],
    );
  }

  /// `1 free bottle!`
  String get free_bottle {
    return Intl.message(
      '1 free bottle!',
      name: 'free_bottle',
      desc: '',
      args: [],
    );
  }

  /// `free shots`
  String get free_shots {
    return Intl.message('free shots', name: 'free_shots', desc: '', args: []);
  }

  /// `Would you like to open the privacy policy in your browser?`
  String get privacy_policy_open {
    return Intl.message(
      'Would you like to open the privacy policy in your browser?',
      name: 'privacy_policy_open',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to change your profile picture?`
  String get change_picture_confirmation {
    return Intl.message(
      'Do you want to change your profile picture?',
      name: 'change_picture_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `has no offers right now`
  String get no_current_offer {
    return Intl.message(
      'has no offers right now',
      name: 'no_current_offer',
      desc: '',
      args: [],
    );
  }

  /// `Main Offer`
  String get main_offer {
    return Intl.message('Main Offer', name: 'main_offer', desc: '', args: []);
  }

  /// `App Store`
  String get appStore {
    return Intl.message(
      'App Store',
      name: 'appStore',
      desc: 'Label for App Store',
      args: [],
    );
  }

  /// `Google Play`
  String get googlePlay {
    return Intl.message(
      'Google Play',
      name: 'googlePlay',
      desc: 'Label for Google Play',
      args: [],
    );
  }

  /// `App Store link copied to clipboard!`
  String get appStoreLinkCopied {
    return Intl.message(
      'App Store link copied to clipboard!',
      name: 'appStoreLinkCopied',
      desc: 'Message when App Store link is copied',
      args: [],
    );
  }

  /// `Google Play link copied to clipboard!`
  String get googlePlayLinkCopied {
    return Intl.message(
      'Google Play link copied to clipboard!',
      name: 'googlePlayLinkCopied',
      desc: 'Message when Google Play link is copied',
      args: [],
    );
  }

  /// `Allow location always`
  String get allow_location_always {
    return Intl.message(
      'Allow location always',
      name: 'allow_location_always',
      desc: '',
      args: [],
    );
  }

  /// `To get the best experience on NightView, the app needs to always have access to your location.`
  String get location_permission_description {
    return Intl.message(
      'To get the best experience on NightView, the app needs to always have access to your location.',
      name: 'location_permission_description',
      desc: '',
      args: [],
    );
  }

  /// `Open app settings`
  String get open_app_settings {
    return Intl.message(
      'Open app settings',
      name: 'open_app_settings',
      desc: '',
      args: [],
    );
  }

  /// `INVALID OPERATING SYSTEM`
  String get invalid_os {
    return Intl.message(
      'INVALID OPERATING SYSTEM',
      name: 'invalid_os',
      desc: '',
      args: [],
    );
  }

  /// `> Open app settings\n> Permissions\n> Location\n> Allow always`
  String get android_location_instructions {
    return Intl.message(
      '> Open app settings\n> Permissions\n> Location\n> Allow always',
      name: 'android_location_instructions',
      desc: '',
      args: [],
    );
  }

  /// `> Open app settings\n> Location\n> While using the app`
  String get ios_location_instructions {
    return Intl.message(
      '> Open app settings\n> Location\n> While using the app',
      name: 'ios_location_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Allow precise location`
  String get allow_precise_location {
    return Intl.message(
      'Allow precise location',
      name: 'allow_precise_location',
      desc: '',
      args: [],
    );
  }

  /// `To provide the best experience for NightView users, the app needs access to the phone's precise location.`
  String get precise_location_description {
    return Intl.message(
      'To provide the best experience for NightView users, the app needs access to the phone\'s precise location.',
      name: 'precise_location_description',
      desc: '',
      args: [],
    );
  }

  /// `> Open app settings\n> Permissions\n> Location\n> Use precise location`
  String get android_precise_location {
    return Intl.message(
      '> Open app settings\n> Permissions\n> Location\n> Use precise location',
      name: 'android_precise_location',
      desc: '',
      args: [],
    );
  }

  /// `> Open app settings\n> Location\n> Precise location`
  String get ios_precise_location {
    return Intl.message(
      '> Open app settings\n> Location\n> Precise location',
      name: 'ios_precise_location',
      desc: '',
      args: [],
    );
  }

  /// `Enable location`
  String get enable_location {
    return Intl.message(
      'Enable location',
      name: 'enable_location',
      desc: '',
      args: [],
    );
  }

  /// `To use NightView, you need to enable location services.`
  String get enable_location_description {
    return Intl.message(
      'To use NightView, you need to enable location services.',
      name: 'enable_location_description',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Allow location while using the app`
  String get allow_location_while_using {
    return Intl.message(
      'Allow location while using the app',
      name: 'allow_location_while_using',
      desc: '',
      args: [],
    );
  }

  /// `To get the best experience on NightView, the app needs access to your location while you are using the app (this also applies when the app is open in the background).`
  String get location_while_using_description {
    return Intl.message(
      'To get the best experience on NightView, the app needs access to your location while you are using the app (this also applies when the app is open in the background).',
      name: 'location_while_using_description',
      desc: '',
      args: [],
    );
  }

  /// `> Open app settings\n> Permissions\n> Location\n> Allow only while the app is in use`
  String get android_location_while_using {
    return Intl.message(
      '> Open app settings\n> Permissions\n> Location\n> Allow only while the app is in use',
      name: 'android_location_while_using',
      desc: '',
      args: [],
    );
  }

  /// `> Open app settings\n> Location\n> While using the app`
  String get ios_location_while_using {
    return Intl.message(
      '> Open app settings\n> Location\n> While using the app',
      name: 'ios_location_while_using',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get generic_error_2 {
    return Intl.message(
      'An error occurred',
      name: 'generic_error_2',
      desc: '',
      args: [],
    );
  }

  /// `            Redeem`
  String get redeem_button_2 {
    return Intl.message(
      '            Redeem',
      name: 'redeem_button_2',
      desc: '',
      args: [],
    );
  }

  /// `IMPORTANT:\nShow the staff that you are redeeming the offer.\nOtherwise, the redemption is invalid!`
  String get redemption_warning_2 {
    return Intl.message(
      'IMPORTANT:\nShow the staff that you are redeeming the offer.\nOtherwise, the redemption is invalid!',
      name: 'redemption_warning_2',
      desc: '',
      args: [],
    );
  }

  /// `You have already redeemed this offer today.\nCome back tomorrow!`
  String get daily_redemption_limit {
    return Intl.message(
      'You have already redeemed this offer today.\nCome back tomorrow!',
      name: 'daily_redemption_limit',
      desc: '',
      args: [],
    );
  }

  /// `Redemption successful!`
  String get redemption_successful_2 {
    return Intl.message(
      'Redemption successful!',
      name: 'redemption_successful_2',
      desc: '',
      args: [],
    );
  }

  /// `Redemption of main offer at `
  String get main_offer_redemption {
    return Intl.message(
      'Redemption of main offer at ',
      name: 'main_offer_redemption',
      desc: '',
      args: [],
    );
  }

  /// `was completed.`
  String get redemption_completed {
    return Intl.message(
      'was completed.',
      name: 'redemption_completed',
      desc: '',
      args: [],
    );
  }

  /// `Redemption failed`
  String get redemption_failed_2 {
    return Intl.message(
      'Redemption failed',
      name: 'redemption_failed_2',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while redeeming the main offer.\nPlease try again later.`
  String get main_offer_redemption_error {
    return Intl.message(
      'An error occurred while redeeming the main offer.\nPlease try again later.',
      name: 'main_offer_redemption_error',
      desc: '',
      args: [],
    );
  }

  /// `Users in the city now`
  String get current_users {
    return Intl.message(
      'Users in the city now',
      name: 'current_users',
      desc: '',
      args: [],
    );
  }

  /// `Search for locations, areas, or anything else`
  String get search_locations {
    return Intl.message(
      'Search for locations, areas, or anything else',
      name: 'search_locations',
      desc: '',
      args: [],
    );
  }

  /// `No locations found`
  String get no_locations_found {
    return Intl.message(
      'No locations found',
      name: 'no_locations_found',
      desc: '',
      args: [],
    );
  }

  /// `Fetching locations`
  String get fetching_locations {
    return Intl.message(
      'Fetching locations',
      name: 'fetching_locations',
      desc: '',
      args: [],
    );
  }

  /// `Find new friends`
  String get find_friends {
    return Intl.message(
      'Find new friends',
      name: 'find_friends',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enter_name {
    return Intl.message('Enter name', name: 'enter_name', desc: '', args: []);
  }

  /// `Friend requests`
  String get friend_requests {
    return Intl.message(
      'Friend requests',
      name: 'friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `New chat`
  String get new_chat {
    return Intl.message('New chat', name: 'new_chat', desc: '', args: []);
  }

  /// `Who do you want to chat with?`
  String get chat_prompt {
    return Intl.message(
      'Who do you want to chat with?',
      name: 'chat_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Could not create new chat`
  String get chat_creation_error {
    return Intl.message(
      'Could not create new chat',
      name: 'chat_creation_error',
      desc: '',
      args: [],
    );
  }

  /// `Could not send message`
  String get message_send_error {
    return Intl.message(
      'Could not send message',
      name: 'message_send_error',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `New friend requests`
  String get new_friend_requests {
    return Intl.message(
      'New friend requests',
      name: 'new_friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `Going out tonight`
  String get going_out_tonight {
    return Intl.message(
      'Going out tonight',
      name: 'going_out_tonight',
      desc: '',
      args: [],
    );
  }

  /// `Not going out tonight`
  String get not_going_out_tonight {
    return Intl.message(
      'Not going out tonight',
      name: 'not_going_out_tonight',
      desc: '',
      args: [],
    );
  }

  /// `Unsure`
  String get unsure {
    return Intl.message('Unsure', name: 'unsure', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Change status`
  String get change_status {
    return Intl.message(
      'Change status',
      name: 'change_status',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Delete user`
  String get delete_user {
    return Intl.message('Delete user', name: 'delete_user', desc: '', args: []);
  }

  /// `Delete user`
  String get delete_user_2 {
    return Intl.message(
      'Delete user',
      name: 'delete_user_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your user? All data associated with your user will be removed.`
  String get delete_confirmation {
    return Intl.message(
      'Are you sure you want to delete your user? All data associated with your user will be removed.',
      name: 'delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Error deleting user`
  String get delete_user_error {
    return Intl.message(
      'Error deleting user',
      name: 'delete_user_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while deleting your user. Please try again later. If you experience issues with your user in the future, you can email business@night-view.dk.`
  String get delete_user_error_description {
    return Intl.message(
      'An error occurred while deleting your user. Please try again later. If you experience issues with your user in the future, you can email business@night-view.dk.',
      name: 'delete_user_error_description',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `Write here`
  String get write_here {
    return Intl.message('Write here', name: 'write_here', desc: '', args: []);
  }

  /// `Profile picture updated`
  String get profile_picture_updated {
    return Intl.message(
      'Profile picture updated',
      name: 'profile_picture_updated',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while loading profile picture`
  String get profile_picture_load_error {
    return Intl.message(
      'An error occurred while loading profile picture',
      name: 'profile_picture_load_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while changing profile picture`
  String get profile_picture_change_error {
    return Intl.message(
      'An error occurred while changing profile picture',
      name: 'profile_picture_change_error',
      desc: '',
      args: [],
    );
  }

  /// `Change picture`
  String get change_picture {
    return Intl.message(
      'Change picture',
      name: 'change_picture',
      desc: '',
      args: [],
    );
  }

  /// `Bio updated`
  String get bio_updated {
    return Intl.message('Bio updated', name: 'bio_updated', desc: '', args: []);
  }

  /// `An error occurred while updating bio`
  String get bio_update_error {
    return Intl.message(
      'An error occurred while updating bio',
      name: 'bio_update_error',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Friends`
  String get friends {
    return Intl.message('Friends', name: 'friends', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get logout_confirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Remove friend`
  String get remove_friend {
    return Intl.message(
      'Remove friend',
      name: 'remove_friend',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this friend?`
  String get remove_friend_confirmation {
    return Intl.message(
      'Are you sure you want to remove this friend?',
      name: 'remove_friend_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Add friend`
  String get add_friend {
    return Intl.message('Add friend', name: 'add_friend', desc: '', args: []);
  }

  /// `Der skete en fejl, da vi forsøgte at logge dig ind automatisk. Måske har du ændret din kode siden sidst.`
  String get login_error_occurred {
    return Intl.message(
      'Der skete en fejl, da vi forsøgte at logge dig ind automatisk. Måske har du ændret din kode siden sidst.',
      name: 'login_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `This user has not provided a biography.`
  String get no_bio {
    return Intl.message(
      'This user has not provided a biography.',
      name: 'no_bio',
      desc: '',
      args: [],
    );
  }

  /// `Could not find recent location`
  String get recent_location_error {
    return Intl.message(
      'Could not find recent location',
      name: 'recent_location_error',
      desc: '',
      args: [],
    );
  }

  /// `This person is not sharing their location`
  String get location_sharing_disabled {
    return Intl.message(
      'This person is not sharing their location',
      name: 'location_sharing_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Latest location`
  String get latest_location {
    return Intl.message(
      'Latest location',
      name: 'latest_location',
      desc: '',
      args: [],
    );
  }

  /// `Invalid user`
  String get invalid_user {
    return Intl.message(
      'Invalid user',
      name: 'invalid_user',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio_2 {
    return Intl.message('Bio', name: 'bio_2', desc: '', args: []);
  }

  /// `Find`
  String get find {
    return Intl.message('Find', name: 'find', desc: '', args: []);
  }

  /// `Swipe!`
  String get swipe {
    return Intl.message('Swipe!', name: 'swipe', desc: '', args: []);
  }

  /// `Error logging in`
  String get login_error {
    return Intl.message(
      'Error logging in',
      name: 'login_error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while trying to log you in automatically. You may have changed your password since last time.`
  String get automatic_login_error {
    return Intl.message(
      'An error occurred while trying to log you in automatically. You may have changed your password since last time.',
      name: 'automatic_login_error',
      desc: '',
      args: [],
    );
  }

  /// `Ready for the city?`
  String get ready_for_the_city {
    return Intl.message(
      'Ready for the city?',
      name: 'ready_for_the_city',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to conquer the dance floor tonight?`
  String get ready_to_conquer_dancefloor {
    return Intl.message(
      'Are you ready to conquer the dance floor tonight?',
      name: 'ready_to_conquer_dancefloor',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to go on an adventure in the city tonight?`
  String get plans_for_adventure {
    return Intl.message(
      'Do you have plans to go on an adventure in the city tonight?',
      name: 'plans_for_adventure',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make trouble tonight?`
  String get let_make_trouble {
    return Intl.message(
      'Shall we go out and make trouble tonight?',
      name: 'let_make_trouble',
      desc: '',
      args: [],
    );
  }

  /// `Will it be one of those wild nights in the city tonight?`
  String get wild_night {
    return Intl.message(
      'Will it be one of those wild nights in the city tonight?',
      name: 'wild_night',
      desc: '',
      args: [],
    );
  }

  /// `Is it one of those nights where we let loose?`
  String get let_loose {
    return Intl.message(
      'Is it one of those nights where we let loose?',
      name: 'let_loose',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and show our best moves tonight?`
  String get show_best_moves {
    return Intl.message(
      'Shall we go out and show our best moves tonight?',
      name: 'show_best_moves',
      desc: '',
      args: [],
    );
  }

  /// `Are you heading out to make the city unsafe tonight?`
  String get make_city_safe {
    return Intl.message(
      'Are you heading out to make the city unsafe tonight?',
      name: 'make_city_safe',
      desc: '',
      args: [],
    );
  }

  /// `I know a really good bartender. Shall we go out and have him make some special drinks for us?`
  String get good_bartender {
    return Intl.message(
      'I know a really good bartender. Shall we go out and have him make some special drinks for us?',
      name: 'good_bartender',
      desc: '',
      args: [],
    );
  }

  /// `Will you be my date tonight and let me show you how to have fun?`
  String get be_my_date {
    return Intl.message(
      'Will you be my date tonight and let me show you how to have fun?',
      name: 'be_my_date',
      desc: '',
      args: [],
    );
  }

  /// `What do you say we waste our youth a bit tonight and see where it takes us?`
  String get waste_youth {
    return Intl.message(
      'What do you say we waste our youth a bit tonight and see where it takes us?',
      name: 'waste_youth',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to light up the dance floor tonight?`
  String get light_up_dancefloor {
    return Intl.message(
      'Are you ready to light up the dance floor tonight?',
      name: 'light_up_dancefloor',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to create memories in the city tonight?`
  String get create_memories {
    return Intl.message(
      'Do you have plans to create memories in the city tonight?',
      name: 'create_memories',
      desc: '',
      args: [],
    );
  }

  /// `Is it one of those nights where we go all out?`
  String get max_gas {
    return Intl.message(
      'Is it one of those nights where we go all out?',
      name: 'max_gas',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make the night wild and unforgettable?`
  String get make_night_unforgettable {
    return Intl.message(
      'Shall we go out and make the night wild and unforgettable?',
      name: 'make_night_unforgettable',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take the city in style?`
  String get take_city_with_style {
    return Intl.message(
      'Are you ready to take the city in style?',
      name: 'take_city_with_style',
      desc: '',
      args: [],
    );
  }

  /// `Will it be a night full of laughter and dance?`
  String get night_of_laughter_and_dance {
    return Intl.message(
      'Will it be a night full of laughter and dance?',
      name: 'night_of_laughter_and_dance',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to conquer the city and have fun?`
  String get conquer_city {
    return Intl.message(
      'Are you ready to conquer the city and have fun?',
      name: 'conquer_city',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make the night our own party?`
  String get make_own_party {
    return Intl.message(
      'Shall we go out and make the night our own party?',
      name: 'make_own_party',
      desc: '',
      args: [],
    );
  }

  /// `Is it one of those nights where we let go of all inhibitions?`
  String get let_go_of_inhibitions {
    return Intl.message(
      'Is it one of those nights where we let go of all inhibitions?',
      name: 'let_go_of_inhibitions',
      desc: '',
      args: [],
    );
  }

  /// `Are you planning to go on a night adventure with us tonight?`
  String get night_adventure {
    return Intl.message(
      'Are you planning to go on a night adventure with us tonight?',
      name: 'night_adventure',
      desc: '',
      args: [],
    );
  }

  /// `Is it tonight we make the streets unsafe?`
  String get make_streets_safe {
    return Intl.message(
      'Is it tonight we make the streets unsafe?',
      name: 'make_streets_safe',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and create a party vibe tonight?`
  String get create_party_vibe {
    return Intl.message(
      'Shall we go out and create a party vibe tonight?',
      name: 'create_party_vibe',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the night something special?`
  String get make_night_special {
    return Intl.message(
      'Are you ready to make the night something special?',
      name: 'make_night_special',
      desc: '',
      args: [],
    );
  }

  /// `Will it be one of those nights where we live life to the fullest?`
  String get live_life_to_fullest {
    return Intl.message(
      'Will it be one of those nights where we live life to the fullest?',
      name: 'live_life_to_fullest',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and party like never before tonight?`
  String get party_like_never_before {
    return Intl.message(
      'Shall we go out and party like never before tonight?',
      name: 'party_like_never_before',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take the nightlife by storm with us?`
  String get take_nightlife_by_storm {
    return Intl.message(
      'Are you ready to take the nightlife by storm with us?',
      name: 'take_nightlife_by_storm',
      desc: '',
      args: [],
    );
  }

  /// `Have you thought about making the night wild and unforgettable?`
  String get make_night_unforgettable_4 {
    return Intl.message(
      'Have you thought about making the night wild and unforgettable?',
      name: 'make_night_unforgettable_4',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the dance floor your stage tonight?`
  String get dancefloor_as_stage {
    return Intl.message(
      'Are you ready to make the dance floor your stage tonight?',
      name: 'dancefloor_as_stage',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and light up the city tonight?`
  String get light_up_city {
    return Intl.message(
      'Shall we go out and light up the city tonight?',
      name: 'light_up_city',
      desc: '',
      args: [],
    );
  }

  /// `Is it tonight we go wild on the dance floor?`
  String get go_wild_on_dancefloor {
    return Intl.message(
      'Is it tonight we go wild on the dance floor?',
      name: 'go_wild_on_dancefloor',
      desc: '',
      args: [],
    );
  }

  /// `Are you planning to be the center of the party tonight?`
  String get be_center_of_party {
    return Intl.message(
      'Are you planning to be the center of the party tonight?',
      name: 'be_center_of_party',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready for a night full of fun and good vibes?`
  String get night_full_of_fun {
    return Intl.message(
      'Are you ready for a night full of fun and good vibes?',
      name: 'night_full_of_fun',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take the city by storm tonight?`
  String get take_city_by_storm {
    return Intl.message(
      'Are you ready to take the city by storm tonight?',
      name: 'take_city_by_storm',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to create wild memories tonight?`
  String get create_wild_memories {
    return Intl.message(
      'Are you ready to create wild memories tonight?',
      name: 'create_wild_memories',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the night a party like no other?`
  String get party_without_equal {
    return Intl.message(
      'Are you ready to make the night a party like no other?',
      name: 'party_without_equal',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and fire it up on the dance floor?`
  String get fire_up_dancefloor {
    return Intl.message(
      'Shall we go out and fire it up on the dance floor?',
      name: 'fire_up_dancefloor',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the city unsafe with us tonight?`
  String get make_city_safe_4 {
    return Intl.message(
      'Are you ready to make the city unsafe with us tonight?',
      name: 'make_city_safe_4',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to go on an adventure in the nightlife?`
  String get adventure_in_nightlife {
    return Intl.message(
      'Do you have plans to go on an adventure in the nightlife?',
      name: 'adventure_in_nightlife',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and conquer the nightlife tonight?`
  String get conquer_nightlife {
    return Intl.message(
      'Shall we go out and conquer the nightlife tonight?',
      name: 'conquer_nightlife',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and play rockstars tonight?`
  String get play_rockstars {
    return Intl.message(
      'Shall we go out and play rockstars tonight?',
      name: 'play_rockstars',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to dance like we have two left feet?`
  String get dance_with_two_left_feet {
    return Intl.message(
      'Are you ready to dance like we have two left feet?',
      name: 'dance_with_two_left_feet',
      desc: '',
      args: [],
    );
  }

  /// `Is it tonight we make some epic Snapchat stories?`
  String get epic_snapchat_stories {
    return Intl.message(
      'Is it tonight we make some epic Snapchat stories?',
      name: 'epic_snapchat_stories',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to be the craziest party animal in town tonight?`
  String get crazy_party_animal {
    return Intl.message(
      'Are you ready to be the craziest party animal in town tonight?',
      name: 'crazy_party_animal',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make some legendary missteps on the dance floor?`
  String get legendary_missteps {
    return Intl.message(
      'Shall we go out and make some legendary missteps on the dance floor?',
      name: 'legendary_missteps',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and see how many new friends we can make tonight?`
  String get make_new_friends {
    return Intl.message(
      'Shall we go out and see how many new friends we can make tonight?',
      name: 'make_new_friends',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take a trip to the party league tonight?`
  String get trip_to_party_league {
    return Intl.message(
      'Are you ready to take a trip to the party league tonight?',
      name: 'trip_to_party_league',
      desc: '',
      args: [],
    );
  }

  /// `Going out tonight?`
  String get going_out_tonight_2 {
    return Intl.message(
      'Going out tonight?',
      name: 'going_out_tonight_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we?`
  String get shall_we {
    return Intl.message('Shall we?', name: 'shall_we', desc: '', args: []);
  }

  /// `Go out and fire it up?`
  String get fire_it_up {
    return Intl.message(
      'Go out and fire it up?',
      name: 'fire_it_up',
      desc: '',
      args: [],
    );
  }

  /// `Drinking?`
  String get drinking {
    return Intl.message('Drinking?', name: 'drinking', desc: '', args: []);
  }

  /// `Shall we go out?`
  String get going_out {
    return Intl.message(
      'Shall we go out?',
      name: 'going_out',
      desc: '',
      args: [],
    );
  }

  /// `The club?`
  String get club {
    return Intl.message('The club?', name: 'club', desc: '', args: []);
  }

  /// `Are you ready to create havoc in the city tonight?`
  String get create_ravage {
    return Intl.message(
      'Are you ready to create havoc in the city tonight?',
      name: 'create_ravage',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and create some festive chaos in the city?`
  String get create_festive_chaos {
    return Intl.message(
      'Shall we go out and create some festive chaos in the city?',
      name: 'create_festive_chaos',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and shake up the city?`
  String get shake_up_city {
    return Intl.message(
      'Shall we go out and shake up the city?',
      name: 'shake_up_city',
      desc: '',
      args: [],
    );
  }

  /// `Is it time to make some trouble tonight?`
  String get time_for_trouble {
    return Intl.message(
      'Is it time to make some trouble tonight?',
      name: 'time_for_trouble',
      desc: '',
      args: [],
    );
  }

  /// `Will you be a part of the nightlife today?`
  String get part_of_nightlife {
    return Intl.message(
      'Will you be a part of the nightlife today?',
      name: 'part_of_nightlife',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to go out tonight?`
  String get plans_for_evening {
    return Intl.message(
      'Do you have plans to go out tonight?',
      name: 'plans_for_evening',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready for a city trip today?`
  String get ready_for_city_trip {
    return Intl.message(
      'Are you ready for a city trip today?',
      name: 'ready_for_city_trip',
      desc: '',
      args: [],
    );
  }

  /// `Age limit not specified.`
  String get age_limit_not_specified {
    return Intl.message(
      'Age limit unknown.',
      name: 'age_limit_not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Open until`
  String get open_until {
    return Intl.message('Open until', name: 'open_until', desc: '', args: []);
  }

  /// ` today.`
  String get today {
    return Intl.message(' today.', name: 'today', desc: '', args: []);
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `yet.`
  String get yet {
    return Intl.message('yet.', name: 'yet', desc: '', args: []);
  }

  /// `minute`
  String get minute {
    return Intl.message('minute', name: 'minute', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `nowhere`
  String get nowhere {
    return Intl.message('nowhere', name: 'nowhere', desc: '', args: []);
  }

  /// `Select Image`
  String get select_image {
    return Intl.message(
      'Select Image',
      name: 'select_image',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get error_occurred_2 {
    return Intl.message(
      'An error occurred',
      name: 'error_occurred_2',
      desc: '',
      args: [],
    );
  }

  /// `Add favorite`
  String get add_favorite {
    return Intl.message(
      'Add favorite',
      name: 'add_favorite',
      desc: '',
      args: [],
    );
  }

  /// `By adding a club as a favorite, you allow this club/bar to send you messages about their offers.`
  String get favorite_club_message {
    return Intl.message(
      'By adding a club as a favorite, you allow this club/bar to send you messages about their offers.',
      name: 'favorite_club_message',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `Continue`
  String get continues {
    return Intl.message('Continue', name: 'continues', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Mon`
  String get short_monday {
    return Intl.message('Mon', name: 'short_monday', desc: '', args: []);
  }

  /// `Tue`
  String get short_tuesday {
    return Intl.message('Tue', name: 'short_tuesday', desc: '', args: []);
  }

  /// `Wed`
  String get short_wednesday {
    return Intl.message('Wed', name: 'short_wednesday', desc: '', args: []);
  }

  /// `Thu`
  String get short_thursday {
    return Intl.message('Thu', name: 'short_thursday', desc: '', args: []);
  }

  /// `Fri`
  String get short_friday {
    return Intl.message('Fri', name: 'short_friday', desc: '', args: []);
  }

  /// `Sat`
  String get short_saturday {
    return Intl.message('Sat', name: 'short_saturday', desc: '', args: []);
  }

  /// `Sun`
  String get short_sunday {
    return Intl.message('Sun', name: 'short_sunday', desc: '', args: []);
  }

  /// `Remove favorite`
  String get remove_favorite {
    return Intl.message(
      'Remove favorite',
      name: 'remove_favorite',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this club from your favorites?`
  String get remove_favorite_confirmation {
    return Intl.message(
      'Are you sure you want to remove this club from your favorites?',
      name: 'remove_favorite_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo_2 {
    return Intl.message('Undo', name: 'undo_2', desc: '', args: []);
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `You canceled the Google login.`
  String get google_login_cancelled {
    return Intl.message(
      'You canceled the Google login.',
      name: 'google_login_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Confirm rating`
  String get confirm_rating {
    return Intl.message(
      'Confirm rating',
      name: 'confirm_rating',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to give`
  String get give_rating {
    return Intl.message(
      'Would you like to give',
      name: 'give_rating',
      desc: '',
      args: [],
    );
  }

  /// `a rating of`
  String get rating {
    return Intl.message('a rating of', name: 'rating', desc: '', args: []);
  }

  /// `/5 stars?`
  String get stars {
    return Intl.message('/5 stars?', name: 'stars', desc: '', args: []);
  }

  /// `You have already rated`
  String get already_rated {
    return Intl.message(
      'You have already rated',
      name: 'already_rated',
      desc: '',
      args: [],
    );
  }

  /// `recently.`
  String get recently {
    return Intl.message('recently.', name: 'recently', desc: '', args: []);
  }

  /// `Unknown opening hours`
  String get unknown_opening_hours {
    return Intl.message(
      'Unknown opening hours',
      name: 'unknown_opening_hours',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity {
    return Intl.message('Capacity', name: 'capacity', desc: '', args: []);
  }

  /// `closed today.`
  String get closed_today {
    return Intl.message(
      'closed today.',
      name: 'closed_today',
      desc: '',
      args: [],
    );
  }

  /// `Calculating...`
  String get calculating {
    return Intl.message(
      'Calculating...',
      name: 'calculating',
      desc: '',
      args: [],
    );
  }

  /// `Fetching locations near you`
  String get fetching_nearby_locations {
    return Intl.message(
      'Fetching locations near you',
      name: 'fetching_nearby_locations',
      desc: '',
      args: [],
    );
  }

  /// `Fetching remaining locations in the background ({count})`
  String fetching_remaining_locations(Object count) {
    return Intl.message(
      'Fetching remaining locations in the background ($count)',
      name: 'fetching_remaining_locations',
      desc: '',
      args: [count],
    );
  }

  /// `Not today`
  String get not_today {
    return Intl.message('Not today', name: 'not_today', desc: '', args: []);
  }

  /// `I am fresh!`
  String get i_am_fresh {
    return Intl.message('I am fresh!', name: 'i_am_fresh', desc: '', args: []);
  }

  /// `Are you ready to conquer the dance floor tonight?`
  String get ready_to_conquer_dancefloor_2 {
    return Intl.message(
      'Are you ready to conquer the dance floor tonight?',
      name: 'ready_to_conquer_dancefloor_2',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to go on an adventure in the city tonight?`
  String get plans_for_adventure_2 {
    return Intl.message(
      'Do you have plans to go on an adventure in the city tonight?',
      name: 'plans_for_adventure_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make trouble tonight?`
  String get let_make_trouble_2 {
    return Intl.message(
      'Shall we go out and make trouble tonight?',
      name: 'let_make_trouble_2',
      desc: '',
      args: [],
    );
  }

  /// `Will it be one of those wild nights in the city tonight?`
  String get wild_night_2 {
    return Intl.message(
      'Will it be one of those wild nights in the city tonight?',
      name: 'wild_night_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it one of those nights where we let loose?`
  String get let_loose_2 {
    return Intl.message(
      'Is it one of those nights where we let loose?',
      name: 'let_loose_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and show our best moves tonight?`
  String get show_best_moves_2 {
    return Intl.message(
      'Shall we go out and show our best moves tonight?',
      name: 'show_best_moves_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you heading out to make the city unsafe tonight?`
  String get make_city_safe_2 {
    return Intl.message(
      'Are you heading out to make the city unsafe tonight?',
      name: 'make_city_safe_2',
      desc: '',
      args: [],
    );
  }

  /// `I know a really good bartender. Shall we go out and have him make some special drinks for us?`
  String get good_bartender_2 {
    return Intl.message(
      'I know a really good bartender. Shall we go out and have him make some special drinks for us?',
      name: 'good_bartender_2',
      desc: '',
      args: [],
    );
  }

  /// `Will you be my date tonight and let me show you how to have fun?`
  String get be_my_date_2 {
    return Intl.message(
      'Will you be my date tonight and let me show you how to have fun?',
      name: 'be_my_date_2',
      desc: '',
      args: [],
    );
  }

  /// `What do you say we waste our youth a bit tonight and see where it takes us?`
  String get waste_youth_2 {
    return Intl.message(
      'What do you say we waste our youth a bit tonight and see where it takes us?',
      name: 'waste_youth_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to light up the dance floor tonight?`
  String get light_up_dancefloor_2 {
    return Intl.message(
      'Are you ready to light up the dance floor tonight?',
      name: 'light_up_dancefloor_2',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to create memories in the city tonight?`
  String get create_memories_2 {
    return Intl.message(
      'Do you have plans to create memories in the city tonight?',
      name: 'create_memories_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it one of those nights where we go all out?`
  String get max_gas_2 {
    return Intl.message(
      'Is it one of those nights where we go all out?',
      name: 'max_gas_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make the night wild and unforgettable?`
  String get make_night_unforgettable_2 {
    return Intl.message(
      'Shall we go out and make the night wild and unforgettable?',
      name: 'make_night_unforgettable_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take the city in style?`
  String get take_city_with_style_2 {
    return Intl.message(
      'Are you ready to take the city in style?',
      name: 'take_city_with_style_2',
      desc: '',
      args: [],
    );
  }

  /// `Will it be a night full of laughter and dance?`
  String get night_of_laughter_and_dance_2 {
    return Intl.message(
      'Will it be a night full of laughter and dance?',
      name: 'night_of_laughter_and_dance_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to conquer the city and have fun?`
  String get conquer_city_2 {
    return Intl.message(
      'Are you ready to conquer the city and have fun?',
      name: 'conquer_city_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make the night our own party?`
  String get make_own_party_2 {
    return Intl.message(
      'Shall we go out and make the night our own party?',
      name: 'make_own_party_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it one of those nights where we let go of all inhibitions?`
  String get let_go_of_inhibitions_2 {
    return Intl.message(
      'Is it one of those nights where we let go of all inhibitions?',
      name: 'let_go_of_inhibitions_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you planning to go on a night adventure with us tonight?`
  String get night_adventure_2 {
    return Intl.message(
      'Are you planning to go on a night adventure with us tonight?',
      name: 'night_adventure_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it tonight we make the streets unsafe?`
  String get make_streets_safe_2 {
    return Intl.message(
      'Is it tonight we make the streets unsafe?',
      name: 'make_streets_safe_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and create a party vibe tonight?`
  String get create_party_vibe_2 {
    return Intl.message(
      'Shall we go out and create a party vibe tonight?',
      name: 'create_party_vibe_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the night something special?`
  String get make_night_special_2 {
    return Intl.message(
      'Are you ready to make the night something special?',
      name: 'make_night_special_2',
      desc: '',
      args: [],
    );
  }

  /// `Will it be one of those nights where we live life to the fullest?`
  String get live_life_to_fullest_2 {
    return Intl.message(
      'Will it be one of those nights where we live life to the fullest?',
      name: 'live_life_to_fullest_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and party like never before tonight?`
  String get party_like_never_before_2 {
    return Intl.message(
      'Shall we go out and party like never before tonight?',
      name: 'party_like_never_before_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take the nightlife by storm with us?`
  String get take_nightlife_by_storm_2 {
    return Intl.message(
      'Are you ready to take the nightlife by storm with us?',
      name: 'take_nightlife_by_storm_2',
      desc: '',
      args: [],
    );
  }

  /// `Have you thought about making the night wild and unforgettable?`
  String get make_night_unforgettable_3 {
    return Intl.message(
      'Have you thought about making the night wild and unforgettable?',
      name: 'make_night_unforgettable_3',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the dance floor your stage tonight?`
  String get dancefloor_as_stage_2 {
    return Intl.message(
      'Are you ready to make the dance floor your stage tonight?',
      name: 'dancefloor_as_stage_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and light up the city tonight?`
  String get light_up_city_2 {
    return Intl.message(
      'Shall we go out and light up the city tonight?',
      name: 'light_up_city_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it tonight we go wild on the dance floor?`
  String get go_wild_on_dancefloor_2 {
    return Intl.message(
      'Is it tonight we go wild on the dance floor?',
      name: 'go_wild_on_dancefloor_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you planning to be the center of the party tonight?`
  String get be_center_of_party_2 {
    return Intl.message(
      'Are you planning to be the center of the party tonight?',
      name: 'be_center_of_party_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready for a night full of fun and good vibes?`
  String get night_full_of_fun_2 {
    return Intl.message(
      'Are you ready for a night full of fun and good vibes?',
      name: 'night_full_of_fun_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take the city by storm tonight?`
  String get take_city_by_storm_3 {
    return Intl.message(
      'Are you ready to take the city by storm tonight?',
      name: 'take_city_by_storm_3',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to create wild memories tonight?`
  String get create_wild_memories_2 {
    return Intl.message(
      'Are you ready to create wild memories tonight?',
      name: 'create_wild_memories_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the night a party like no other?`
  String get party_without_equal_2 {
    return Intl.message(
      'Are you ready to make the night a party like no other?',
      name: 'party_without_equal_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and fire it up on the dance floor?`
  String get fire_up_dancefloor_2 {
    return Intl.message(
      'Shall we go out and fire it up on the dance floor?',
      name: 'fire_up_dancefloor_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to make the city unsafe with us tonight?`
  String get make_city_safe_3 {
    return Intl.message(
      'Are you ready to make the city unsafe with us tonight?',
      name: 'make_city_safe_3',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to go on an adventure in the nightlife?`
  String get adventure_in_nightlife_2 {
    return Intl.message(
      'Do you have plans to go on an adventure in the nightlife?',
      name: 'adventure_in_nightlife_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and conquer the nightlife tonight?`
  String get conquer_nightlife_2 {
    return Intl.message(
      'Shall we go out and conquer the nightlife tonight?',
      name: 'conquer_nightlife_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and play rockstars tonight?`
  String get play_rockstars_2 {
    return Intl.message(
      'Shall we go out and play rockstars tonight?',
      name: 'play_rockstars_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to dance like we have two left feet?`
  String get dance_with_two_left_feet_2 {
    return Intl.message(
      'Are you ready to dance like we have two left feet?',
      name: 'dance_with_two_left_feet_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it tonight we make some epic Snapchat stories?`
  String get epic_snapchat_stories_2 {
    return Intl.message(
      'Is it tonight we make some epic Snapchat stories?',
      name: 'epic_snapchat_stories_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to be the craziest party animal in town tonight?`
  String get crazy_party_animal_2 {
    return Intl.message(
      'Are you ready to be the craziest party animal in town tonight?',
      name: 'crazy_party_animal_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and make some legendary missteps on the dance floor?`
  String get legendary_missteps_2 {
    return Intl.message(
      'Shall we go out and make some legendary missteps on the dance floor?',
      name: 'legendary_missteps_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and see how many new friends we can make tonight?`
  String get make_new_friends_2 {
    return Intl.message(
      'Shall we go out and see how many new friends we can make tonight?',
      name: 'make_new_friends_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to take a trip to the party league tonight?`
  String get trip_to_party_league_2 {
    return Intl.message(
      'Are you ready to take a trip to the party league tonight?',
      name: 'trip_to_party_league_2',
      desc: '',
      args: [],
    );
  }

  /// `Going out tonight?`
  String get going_out_tonight_3 {
    return Intl.message(
      'Going out tonight?',
      name: 'going_out_tonight_3',
      desc: '',
      args: [],
    );
  }

  /// `Shall we?`
  String get shall_we_2 {
    return Intl.message('Shall we?', name: 'shall_we_2', desc: '', args: []);
  }

  /// `Go out and fire it up?`
  String get fire_it_up_2 {
    return Intl.message(
      'Go out and fire it up?',
      name: 'fire_it_up_2',
      desc: '',
      args: [],
    );
  }

  /// `Drinking?`
  String get drinking_2 {
    return Intl.message('Drinking?', name: 'drinking_2', desc: '', args: []);
  }

  /// `Shall we go out?`
  String get going_out_2 {
    return Intl.message(
      'Shall we go out?',
      name: 'going_out_2',
      desc: '',
      args: [],
    );
  }

  /// `The club?`
  String get club_2 {
    return Intl.message('The club?', name: 'club_2', desc: '', args: []);
  }

  /// `Are you ready to create havoc in the city tonight?`
  String get create_ravage_2 {
    return Intl.message(
      'Are you ready to create havoc in the city tonight?',
      name: 'create_ravage_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and create some festive chaos in the city?`
  String get create_festive_chaos_2 {
    return Intl.message(
      'Shall we go out and create some festive chaos in the city?',
      name: 'create_festive_chaos_2',
      desc: '',
      args: [],
    );
  }

  /// `Shall we go out and shake up the city?`
  String get shake_up_city_2 {
    return Intl.message(
      'Shall we go out and shake up the city?',
      name: 'shake_up_city_2',
      desc: '',
      args: [],
    );
  }

  /// `Is it time to make some trouble tonight?`
  String get time_for_trouble_2 {
    return Intl.message(
      'Is it time to make some trouble tonight?',
      name: 'time_for_trouble_2',
      desc: '',
      args: [],
    );
  }

  /// `Will you be a part of the nightlife today?`
  String get part_of_nightlife_2 {
    return Intl.message(
      'Will you be a part of the nightlife today?',
      name: 'part_of_nightlife_2',
      desc: '',
      args: [],
    );
  }

  /// `Do you have plans to go out tonight?`
  String get plans_for_evening_2 {
    return Intl.message(
      'Do you have plans to go out tonight?',
      name: 'plans_for_evening_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready for a city trip today?`
  String get ready_for_city_trip_2 {
    return Intl.message(
      'Are you ready for a city trip today?',
      name: 'ready_for_city_trip_2',
      desc: '',
      args: [],
    );
  }

  /// `Age limit not specified.`
  String get age_limit_not_specified_2 {
    return Intl.message(
      'Age limit not specified.',
      name: 'age_limit_not_specified_2',
      desc: '',
      args: [],
    );
  }

  /// `Open until`
  String get open_until_2 {
    return Intl.message('Open until', name: 'open_until_2', desc: '', args: []);
  }

  /// ` today.`
  String get today_2 {
    return Intl.message(' today.', name: 'today_2', desc: '', args: []);
  }

  /// `Open`
  String get open_2 {
    return Intl.message('Open', name: 'open_2', desc: '', args: []);
  }

  /// `yet.`
  String get yet_3 {
    return Intl.message('yet.', name: 'yet_3', desc: '', args: []);
  }

  /// `minute`
  String get minute_2 {
    return Intl.message('minute', name: 'minute_2', desc: '', args: []);
  }

  /// `minutes`
  String get minutes_2 {
    return Intl.message('minutes', name: 'minutes_2', desc: '', args: []);
  }

  /// `yet.`
  String get yet_4 {
    return Intl.message('yet.', name: 'yet_4', desc: '', args: []);
  }

  /// `An error occurred`
  String get error_occurred_3 {
    return Intl.message(
      'An error occurred',
      name: 'error_occurred_3',
      desc: '',
      args: [],
    );
  }

  /// `Add favorite`
  String get add_favorite_2 {
    return Intl.message(
      'Add favorite',
      name: 'add_favorite_2',
      desc: '',
      args: [],
    );
  }

  /// `By adding a club as a favorite, you allow this club/bar to send you messages about their offers.`
  String get favorite_club_message_2 {
    return Intl.message(
      'By adding a club as a favorite, you allow this club/bar to send you messages about their offers.',
      name: 'favorite_club_message_2',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo_3 {
    return Intl.message('Undo', name: 'undo_3', desc: '', args: []);
  }

  /// `Continue`
  String get continue_2 {
    return Intl.message('Continue', name: 'continue_2', desc: '', args: []);
  }

  /// `Remove favorite`
  String get remove_favorite_2 {
    return Intl.message(
      'Remove favorite',
      name: 'remove_favorite_2',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this club from your favorites?`
  String get remove_favorite_confirmation_2 {
    return Intl.message(
      'Are you sure you want to remove this club from your favorites?',
      name: 'remove_favorite_confirmation_2',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo_4 {
    return Intl.message('Undo', name: 'undo_4', desc: '', args: []);
  }

  /// `Remove`
  String get remove_2 {
    return Intl.message('Remove', name: 'remove_2', desc: '', args: []);
  }

  /// `Confirm rating`
  String get confirm_rating_2 {
    return Intl.message(
      'Confirm rating',
      name: 'confirm_rating_2',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to give`
  String get give_rating_2 {
    return Intl.message(
      'Would you like to give',
      name: 'give_rating_2',
      desc: '',
      args: [],
    );
  }

  /// `a rating of`
  String get rating_2 {
    return Intl.message('a rating of', name: 'rating_2', desc: '', args: []);
  }

  /// `/5 stars?`
  String get stars_2 {
    return Intl.message('/5 stars?', name: 'stars_2', desc: '', args: []);
  }

  /// `You have already rated`
  String get already_rated_2 {
    return Intl.message(
      'You have already rated',
      name: 'already_rated_2',
      desc: '',
      args: [],
    );
  }

  /// `recently.`
  String get recently_2 {
    return Intl.message('recently.', name: 'recently_2', desc: '', args: []);
  }

  /// `Unknown opening hours`
  String get unknown_opening_hours_2 {
    return Intl.message(
      'Unknown opening hours',
      name: 'unknown_opening_hours_2',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity_2 {
    return Intl.message('Capacity', name: 'capacity_2', desc: '', args: []);
  }

  /// `closed today.`
  String get closed_today_2 {
    return Intl.message(
      'closed today.',
      name: 'closed_today_2',
      desc: '',
      args: [],
    );
  }

  /// `Calculating...`
  String get calculating_2 {
    return Intl.message(
      'Calculating...',
      name: 'calculating_2',
      desc: '',
      args: [],
    );
  }

  /// `Fetching locations near you`
  String get fetching_nearby_locations_2 {
    return Intl.message(
      'Fetching locations near you',
      name: 'fetching_nearby_locations_2',
      desc: '',
      args: [],
    );
  }

  /// `Fetching remaining locations in the background ({count})`
  String fetching_remaining_locations_2(Object count) {
    return Intl.message(
      'Fetching remaining locations in the background ($count)',
      name: 'fetching_remaining_locations_2',
      desc: '',
      args: [count],
    );
  }

  /// `Not today`
  String get not_today_2 {
    return Intl.message('Not today', name: 'not_today_2', desc: '', args: []);
  }

  /// `I am fresh!`
  String get i_am_fresh_2 {
    return Intl.message(
      'I am fresh!',
      name: 'i_am_fresh_2',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'no'),
      Locale.fromSubtags(languageCode: 'sv'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
