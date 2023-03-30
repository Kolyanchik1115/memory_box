import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/pages/audio_recording_page/audio_recording_page.dart';
import 'package:memory_box/pages/collection_page/collection_card_page/collection_card_page.dart';
import 'package:memory_box/pages/collection_page/collection_card_page/collection_management_page.dart';
import 'package:memory_box/pages/collection_page/create_new_collection_page/create_new_collection_page.dart';
import 'package:memory_box/pages/collection_page/main_collection_page/collection_page.dart';
import 'package:memory_box/pages/collection_page/select_audio_page/select_audio_page.dart';
import 'package:memory_box/pages/deleted_page/deleted_page.dart';
import 'package:memory_box/pages/deleted_page/select_to_delete_page.dart';
import 'package:memory_box/pages/home_page/home_page.dart';
import 'package:memory_box/pages/main_page.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/profile_edit_page.dart';
import 'package:memory_box/pages/profile_pages/profile_page/profile_page.dart';
import 'package:memory_box/pages/recorder_pages/record_page.dart';
import 'package:memory_box/pages/registration_pages/hello_new_user.dart';
import 'package:memory_box/pages/registration_pages/phone_registration_page.dart';
import 'package:memory_box/pages/registration_pages/sms_registration_page.dart';
import 'package:memory_box/pages/registration_pages/splash_authorization_page.dart';
import 'package:memory_box/pages/registration_pages/splash_registation_page.dart';
import 'package:memory_box/pages/save_record_page/save_record_page.dart';
import 'package:memory_box/pages/save_to_collection_page/save_to_collection_page.dart';
import 'package:memory_box/pages/search_page/search_page.dart';
import 'package:memory_box/pages/select_audio_to_collection/select_audio_to_collection.dart';
import 'package:memory_box/pages/splash_page/splash_page.dart';
import 'package:memory_box/pages/subscribe_page/subscribe_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    WidgetBuilder builder;
    if (kDebugMode) {
      print(settings.name);
    }
    switch (settings.name) {
      case HelloNewUserPage.routeName:
        builder = (_) => const HelloNewUserPage();
        break;
      case SearchPage.routeName:
        builder = (_) => const SearchPage();
        break;

      case HomePage.routeName:
        builder = (_) => const HomePage();
        break;

      case MainPage.routeName:
        builder = (_) => MainPage();
        break;
      case ProfilePage.routeName:
        builder = (_) => const ProfilePage();
        break;
      case RecordPage.routeName:
        builder = (_) => const RecordPage();
        break;
      case SaveRecordPage.routeName:
        builder = (_) => SaveRecordPage(uuid: arguments as String);
        break;
      case SaveToCollectionPage.routeName:
        builder = (_) => SaveToCollectionPage(uuid: arguments as String);
        break;
      case DeletedPage.routeName:
        builder = (_) => const DeletedPage();
        break;

      case ProfileEditPage.routeName:
        builder = (_) => ProfileEditPage();
        break;
      case PhoneRegistrationPage.routeName:
        builder = (_) => const PhoneRegistrationPage();
        break;
      case SmsRegistrationPage.routeName:
        builder = (_) => const SmsRegistrationPage();
        break;
      case SplashAuthorizationPage.routeName:
        builder = (_) => const SplashAuthorizationPage();
        break;
      case SplashRegistrationPage.routeName:
        builder = (_) => const SplashRegistrationPage();
        break;
      case AudioRecordingsPage.routeName:
        builder = (_) => const AudioRecordingsPage();
        break;
      case SubscribePage.routeName:
        builder = (_) => const SubscribePage();
        break;

      case SplashScreen.routeName:
        builder = (_) => const SplashScreen();
        break;

      case SelectToDeletePage.routeName:
        builder = (_) => const SelectToDeletePage();
        break;
      case CollectionCardPage.routeName:
        builder = (_) => const CollectionCardPage();
        break;
      case CollectionManagementPage.routeName:
        builder = (_) => const CollectionManagementPage();
        break;

      case CollectionPage.routeName:
        builder = (_) => const CollectionPage();
        break;
      case CreateNewCollectionPage.routeName:
        builder = (_) => const CreateNewCollectionPage();
        break;
      case SaveAudioToCollection.routeName:
        builder = (_) => const SaveAudioToCollection();
        break;
      case SelectAudioPage.routeName:
        builder = (_) => SelectAudioPage();
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
