import 'package:flutter/material.dart';
import 'package:stipop_plugin_example/constant/color.dart';
import 'package:stipop_plugin_example/model/user_type_enum.dart';
import 'package:stipop_plugin_example/screen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ContainerWithBackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          SafeArea(
            left: false,
            right: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 120),
                _LogoImage(),
                const SizedBox(height: 124),
                _WelcomeText(),
                Expanded(child: Container()),
                _UserLoginButton(context: context, userTypeEnum: UserTypeEnum.NEW),
                const SizedBox(height: 20),
                _UserLoginButton(context: context, userTypeEnum: UserTypeEnum.COMMON),
                const SizedBox(height: 20),
                _GoToDocsButton(),
                const SizedBox(height: 94),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

Widget _ContainerWithBackgroundImage({required Widget child}) {
  return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('asset/img/ic_main_background.png'),
        ),
      ),
      child: child);
}

Widget _LogoImage() {
  return Image.asset(
    'asset/img/ic_logo.png',
    height: 42,
  );
}

Widget _WelcomeText() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Text(
      'Welcome to\nStipop demo app :)',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}

Widget _UserLoginButton({
  required BuildContext context,
  required UserTypeEnum userTypeEnum}) {

  var textStyle = TextStyle(
    color: Color(PRIMARY_COLOR),
    fontSize: 18,
  );

  return GestureDetector(
    onTap: () {
      switch (userTypeEnum) {
        case UserTypeEnum.NEW:
          String newUserId = const Uuid().v4();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen(newUserId)));
          break;
        case UserTypeEnum.COMMON:
          String commonUserId = 'someone_user_id';
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen(commonUserId)));
          break;
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 54,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 22),
            if (userTypeEnum == UserTypeEnum.NEW)
              Text(
                'New user login',
                style: textStyle,
              )
            else if (userTypeEnum == UserTypeEnum.COMMON)
              Text(
                'Common user login',
                style: textStyle,
              ),
            Expanded(child: Container()),
            Image.asset(
              'asset/img/ic_circle_arrow.png',
              width: 26,
              height: 26,
            ),
            const SizedBox(width: 22),
          ],
        ),
      ),
    ),
  );
}

Widget _GoToDocsButton() {
  return GestureDetector(
    onTap: () {
      launchUrl(
        Uri.parse(
            'https://docs.stipop.io/en/sdk/flutter/get-started/introduction'),
      );
    },
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Go to Docs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Image.asset(
            'asset/img/ic_arrow.png',
            width: 15,
          )
        ]),
  );
}
