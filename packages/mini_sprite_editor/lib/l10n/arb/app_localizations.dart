import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
/// import 'arb/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Zoom In tooltip
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// Zoom Out tooltip
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;

  /// Copy to clipboard label
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// Message of data copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Data copied to clipboard'**
  String get copiedWithSuccess;

  /// Import from clipboard label
  ///
  /// In en, this message translates to:
  /// **'Import from clipboard'**
  String get importFromClipBoard;

  /// Message of data imported to clipboard
  ///
  /// In en, this message translates to:
  /// **'Data imported from clipboard'**
  String get importSuccess;

  /// Cursor label
  ///
  /// In en, this message translates to:
  /// **'Cursor'**
  String get cursor;

  /// Brush label
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get brush;

  /// Eraser label
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get eraser;

  /// Fill label
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get bucket;

  /// Unfill label
  ///
  /// In en, this message translates to:
  /// **'Unfill'**
  String get bucketEraser;

  /// Label for width
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// Label for height
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Error message for values that must be greated than zero.
  ///
  /// In en, this message translates to:
  /// **'Must be greater than zero'**
  String get greaterThanZero;

  /// Confirm label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Close label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Cancel label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Title for the sprite size dialog
  ///
  /// In en, this message translates to:
  /// **'Edit sprite size'**
  String get spriteSizeTitle;

  /// Title used on confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// Message used on confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmationMessage;

  /// Label for clearing the sprite
  ///
  /// In en, this message translates to:
  /// **'Clear sprite'**
  String get clearSprite;

  /// Label for the grid toogling
  ///
  /// In en, this message translates to:
  /// **'Toogle grid'**
  String get toogleGrid;

  /// Label for configurations
  ///
  /// In en, this message translates to:
  /// **'Configurations'**
  String get configurations;

  /// Label for system
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Label for light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Label for dark
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Label for the filled pixel color
  ///
  /// In en, this message translates to:
  /// **'Filled pixel color'**
  String get filledPixelColor;

  /// Label for the unfilled pixel color
  ///
  /// In en, this message translates to:
  /// **'Unfilled pixel color'**
  String get unfilledPixelColor;

  /// Label for the background color
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get backgroundColor;

  /// Label for the choose color label
  ///
  /// In en, this message translates to:
  /// **'Choose color'**
  String get chooseColor;

  /// Label for the image export button
  ///
  /// In en, this message translates to:
  /// **'Export current sprite to image'**
  String get exportToImage;

  /// Label for the image export button
  ///
  /// In en, this message translates to:
  /// **'Sprite successfully exported'**
  String get spriteExported;

  /// Label for the start collection button
  ///
  /// In en, this message translates to:
  /// **'Start a collection'**
  String get startCollection;

  /// Label for the add sprite button
  ///
  /// In en, this message translates to:
  /// **'Add a sprite'**
  String get addSprite;

  /// Title for the rename sprite
  ///
  /// In en, this message translates to:
  /// **'Rename sprite'**
  String get renameSprite;

  /// Label for the rename sprite
  ///
  /// In en, this message translates to:
  /// **'Choose the new name'**
  String get renameSpriteMessage;

  /// Label for the remove sprite button
  ///
  /// In en, this message translates to:
  /// **'Remove selected sprite'**
  String get removeSprite;

  /// Label for the sprite editor
  ///
  /// In en, this message translates to:
  /// **'Open sprite editor'**
  String get openSpriteEditor;

  /// Label for the sprite editor
  ///
  /// In en, this message translates to:
  /// **'Open map editor'**
  String get openMapEditor;

  /// Label for the map size
  ///
  /// In en, this message translates to:
  /// **'Edit map size'**
  String get mapSizeTitle;

  /// Label for the clear map
  ///
  /// In en, this message translates to:
  /// **'Clear map'**
  String get clearMap;

  /// Label for the map grid size
  ///
  /// In en, this message translates to:
  /// **'Map grid size'**
  String get mapGridSize;

  /// Label for the properties
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// Label for the remove property
  ///
  /// In en, this message translates to:
  /// **'Remove property'**
  String get removeProperty;

  /// Label for the new property
  ///
  /// In en, this message translates to:
  /// **'New property'**
  String get newPropery;

  /// Label for the name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for the theme settings
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme settings'**
  String get themeSettings;

  /// Label for the color settings
  ///
  /// In en, this message translates to:
  /// **'Color settings'**
  String get colorSettings;

  /// Label for the map settings
  ///
  /// In en, this message translates to:
  /// **'Map settings'**
  String get mapSettings;

  /// Label Palette
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get palette;

  /// Label for add color
  ///
  /// In en, this message translates to:
  /// **'Add color'**
  String get addColor;

  /// Label for flipping the sprite vertically
  ///
  /// In en, this message translates to:
  /// **'Flip vertically'**
  String get flipVertically;

  /// Label for flipping the sprite horizontally
  ///
  /// In en, this message translates to:
  /// **'Flip horizontally'**
  String get flipHorizontally;

  /// Label for rotating the sprite clockwise
  ///
  /// In en, this message translates to:
  /// **'Rotate clockwise'**
  String get rotateClockwise;

  /// Label for rotating the sprite counter clockwise
  ///
  /// In en, this message translates to:
  /// **'Rotate counter clockwise'**
  String get rotateCounterClockwise;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
