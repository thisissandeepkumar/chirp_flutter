import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:comms_flutter/widgets/snackbar.dart';
import 'package:comms_flutter/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double width;
  late double height;

  late AuthProvider _authProvider;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: AuthProvider.instance,
          ),
        ],
        child: _mainUI(),
      ),
    );
  }

  Widget _mainUI() {
    return Builder(builder: (BuildContext innerContext) {
      _authProvider = Provider.of<AuthProvider>(innerContext);
      SnackBarService.instance.context = innerContext;

      return Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            width: width * 0.7,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                commsTextField(
                  controller: emailController,
                  label: "Email",
                ),
                commsTextField(
                  controller: passwordController,
                  label: "Password",
                  isObscure: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      await _authProvider.login(
                        emailController.text,
                        passwordController.text,
                      );
                      if (_authProvider.authStatus ==
                          AuthStatus.isAuthenticated) {
                        NavigationService.instance
                            .navigateToReplacement("home");
                      } else {}
                    } else {
                      SnackBarService.instance.showFailureSnackBar(
                        "Please fill all the fields",
                      );
                    }
                  },
                  child: AuthProvider.instance.authStatus ==
                          AuthStatus.isAuthenticating
                      ? const CircularProgressIndicator()
                      : const Text("Login"),
                ),
                Text(
                  "Built with ❤️ by Sandeep Kumar",
                  style: GoogleFonts.caveat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
