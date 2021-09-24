import 'package:flutter/material.dart';
import 'src/pages/chat_page.dart';
import 'src/pages/loginpage.dart';
import 'src/pages/order_details.dart';
import 'src/pages/register.dart';
import 'src/pages/delivery_location.dart';
import 'src/pages/grocerystore.dart';
import 'src/pages/introscreen.dart';
import 'src/pages/send_package.dart';
import 'src/pages/upload_prescription.dart';
import 'src/pages/map.dart';
import 'src/pages/store_detail.dart';
import 'src/pages/booking_track.dart';
import 'src/pages/checkoutpage.dart';
import 'src/pages/payment.dart';
import 'src/pages/category_product.dart';
import 'src/pages/ProfilePage.dart';
import 'src/pages/apply_coupon.dart';
import 'src/pages/empty_cart.dart';
import 'src/pages/orders.dart';
import 'src/pages/otp_verification.dart';
import 'src/pages/product_list.dart';
import 'src/pages/stores.dart';
import 'src/pages/thankyou.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/languages.dart';
import 'src/pages/pages.dart';
import 'src/pages/settings.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/main_page.dart';
import 'src/pages/shop_rating.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());



      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/orderDetails':
        return MaterialPageRoute(builder: (_) => OrderDetails(orderId: args,));
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/Map':
        return MaterialPageRoute(builder: (_) => MapWidget(orderId: args.toString(),));
      case '/uploadPrescription':
        return MaterialPageRoute(builder: (_) => UploadPrescription());
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutPage());
      case '/EmptyList':
        return MaterialPageRoute(builder: (_) => EmptyList());
      case '/ProductList':
        return MaterialPageRoute(builder: (_) => ProductList(pageType: args?.toString()));
      case '/MainPage':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/OtpVerification':
        return MaterialPageRoute(builder: (_) => OtpVerification());
      case '/Orders':
        return MaterialPageRoute(builder: (_) => OrdersWidget());
      case '/ApplyCoupon':
        return MaterialPageRoute(builder: (_) => ApplyCoupon());
      case '/Store':
        return MaterialPageRoute(builder: (_) => Stores(storeType: args));
      case '/StoreView':
        return MaterialPageRoute(builder: (_) => StoreViewDetails(shopDetails: args));
      case '/GroceryStore':
        return MaterialPageRoute(builder: (_) => GroceryStoreWidget(shopDetails: args));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Thankyou':
        return MaterialPageRoute(builder: (_) => Thankyou(orderId: args,));

      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/ShopRating':
        return MaterialPageRoute(builder: (_) => ShopRating(invoiceDetailsData: args,));
      case '/CategoryProduct':
        return MaterialPageRoute(builder: (_) => CategoryProduct(categoryData: args));


      case '/location':
        return MaterialPageRoute(builder: (_) => DeliveryLocation());
      case '/Chat':
        return MaterialPageRoute(builder: (_) => ChatPage());
      case '/Payment':
        return MaterialPageRoute(builder: (_) => PaymentPage());
      case '/Sendpackage':
        return MaterialPageRoute(builder: (_) => SendPackage());
      case '/introscreen':
        return MaterialPageRoute(builder: (_) => IntroScreen());

      case '/booktracking':
        return MaterialPageRoute(builder: (_) => BookingTrack(productDetails: args));

      case '/register':
        return MaterialPageRoute(builder: (_) => Register());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
