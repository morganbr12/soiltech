class AppConstants {
  AppConstants._();

  static const appName = 'SoilTech LBC';
  static const appVersion = '1.0.0';

  static const defaultPadding = 16.0;
  static const largePadding = 24.0;
  static const smallPadding = 8.0;
  static const cardRadius = 20.0;
  static const largeCardRadius = 24.0;
  static const buttonRadius = 14.0;
  static const inputRadius = 14.0;
  static const chipRadius = 10.0;

  static const animationFast = Duration(milliseconds: 200);
  static const animationNormal = Duration(milliseconds: 300);
  static const animationSlow = Duration(milliseconds: 500);
  static const animationXSlow = Duration(milliseconds: 800);
  static const splashDuration = Duration(seconds: 3);

  static const maxUploadImages = 5;
  static const otpLength = 6;
  static const minPasswordLength = 8;

  static const currencySymbol = 'GHS';
  static const weightUnit = 'kg';
  static const areaUnit = 'acres';

  static const qualityGrades = ['Grade A', 'Grade B', 'Grade C', 'Reject'];
  static const cropTypes = ['Cocoa', 'Maize', 'Cassava', 'Yam', 'Rice', 'Plantain', 'Tomato', 'Pepper'];
  static const regions = [
    'Ashanti Region', 'Brong-Ahafo Region', 'Central Region',
    'Eastern Region', 'Greater Accra Region', 'Northern Region',
    'Upper East Region', 'Upper West Region', 'Volta Region', 'Western Region',
  ];
}
