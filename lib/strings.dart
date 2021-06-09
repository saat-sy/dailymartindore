import 'dart:io' show Platform;
class Strings {

  static final HEADERS = {
    'authorization': 'DMIB',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': Platform.isAndroid ? '2' : '1',
    'store_id': '14'
  };

  //// REVIEWS AND RATING

  // rateapp.dart
  static const String RATEAPP_APPBAR = 'Write Review';
  static const String RATEAPP_TITLE = 'What do you think?';
  static const String RATEAPP_DESCRIPTION =
      'Please give your rating by clicking on the stars below.';
  static const String RATEAPP_TEXTFIELD_PLACEHOLDER =
      'Tell us about your experience';
  static const String RATEAPP_SUBMIT_BUTTON = 'Submit';

  // reviews.dart
  static const String REVIEWS_APPBAR = 'Reviews';
  static const String REVIEWS_NO_REVIEWS_FOUND = 'No Reviews found';

  //// PROFILE & NOTIFICATIONS

  // notifications.dart
  static const String NOTIFICATIONS_APPBAR = 'Notifications';

  // notifications_settings.dart
  static const String NOTIFICATIONS_SETTINGS_APPBAR = 'Notifications';
  static const String NOTIFICATIONS_SETTINGS_SUBMIT = 'Save Settings';

  // profile_page.dart
  static const String PROFILE_PAGE_APPBAR = 'About Me';
  static const String PROFILE_PAGE_NAME = 'Name:';
  static const String PROFILE_PAGE_NAME_ON_ERROR = 'Enter your name';
  static const String PROFILE_PAGE_NAME_PLACEHOLDER = 'Name';
  static const String PROFILE_PAGE_EMAIL = 'Email:';
  static const String PROFILE_PAGE_EMAIL_PLACEHOLDER = 'Email';
  static const String PROFILE_PAGE_PHONE = 'Phone:';
  static const String PROFILE_PAGE_PHONE_ON_ERROR = 'Enter your Phone number';
  static const String PROFILE_PAGE_PHONE_INVALID_PHONE =
      'Enter your Phone number';
  static const String PROFILE_PAGE_PHONE_PLACEHOLDER = 'Phone';
  static const String PROFILE_PAGE_CHANGE_PASSWORD = 'Change your password';
  static const String PROFILE_PAGE_SUBMIT = 'Update Profile';

  /// PRODUCT_PAGES

  // all_categories.dart
  static const String ALL_CATEGORIES_APPBAR = 'Categories';

  // allScreen.dart
  static const String ALL_PRODUCTS_SCREEN_APPBAR = 'More Deals';

  // featuredScreen.dart
  static const String FEATURED_PRODUCTS_SCREEN_APPBAR = 'Featured Products';

  // topScreen.dart
  static const String TOP_PRODUCTS_SCREEN_APPBAR = 'Top Deals';

  ///ORDERS

  // trackorder.dart
  static const String TRACK_ORDER_APPBAR = 'Track Order';
  static const String TRACK_ORDER_ORDER_PLACED = 'Order Placed';
  static const String TRACK_ORDER_PENDING = ' Pending';
  static const String TRACK_ORDER_ORDER_CONFIRMED = 'Order Confirmed';
  static const String TRACK_ORDER_ORDER_PACKED = 'Order Packed';
  static const String TRACK_ORDER_ORDER_SHIPPED = 'Order Shipped';
  static const String TRACK_ORDER_OUT_FOR_DELIVERY = 'Out for Delivery';
  static const String TRACK_ORDER_ORDER_DELIVERED = 'Order Delivered';

  //placeOrder.dart
  static const String PLACE_ORDER_APPBAR = 'Order';
  static const String PLACE_ORDER_SUCCESS_HEADING = 'Order Success';
  static const String PLACE_ORDER_SUCCESS_MESSAGE = 'Your order is being processed by the system, you can see the progress at';
  static const String PLACE_ORDER_SUCCESS_GO_BACK = 'Go back';
  static const String PLACE_ORDER_COUPON_APPLIED = 'Coupon applied successfully';
  static const String PLACE_ORDER_ADDRESS = 'Select your Address';
  static const String PLACE_ORDER_PAYMENT = 'Select your Payment Method';
  static const String PLACE_ORDER_ADD_COUPON = 'Add a coupon';
  static const String PLACE_ORDER_ADD_COUPON_PLACEHOLDER = 'Enter code';
  static const String PLACE_ORDER_SUBMIT_BUTTON = 'Place your order';
  static const String PLACE_ORDER_SUMMARY_HEADING = 'Order Summary';
  

  //myOrder.dart
  static const String MY_ORDER_APPBAR = 'My Orders';
}
