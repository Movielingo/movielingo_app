import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movielingo_app/components/square_tile.dart';
import 'package:movielingo_app/services/auth_service.dart';
import 'package:movielingo_app/utils/validation_utils.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';
  bool isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _signUpWithGoogle() async {
    AuthResult result = await _auth.signInWithGoogle();
    if (result.user == null && mounted) {
      Get.snackbar('Error!', result.errorMessage!, backgroundColor: Colors.red);
    } else {
      // Navigate after the async operation completes
      if (!mounted) return;
      Get.toNamed('/information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: const Text('Sign Up to MovieLingo'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            onChanged: _updateButtonState,
            child: Column(children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email*',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password*',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => ValidationUtils.validatePassword(val),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              // TODO: add confirm password field here
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('* Required fields'),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            AuthResult result =
                                await _auth.registerWithEmailAndPassword(
                              email,
                              password,
                              'german',
                              'english',
                              'b1',
                            );
                            if (result.user == null && mounted) {
                              Get.snackbar('Error!', result.errorMessage!,
                                  backgroundColor: Colors.red);
                            } else {
                              // Navigate after the async operation completes
                              if (!mounted) return;
                              Get.toNamed('/information');
                            }
                          }
                        }
                      : null,
                  child: const Text(
                    'Sign Up',
                  ),
                ),
              ),
              const SizedBox(height: 40.0),

              // or continue with
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or continue with',
                              style: TextStyle(color: Colors.white)),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ])),
              const SizedBox(height: 40.0),

              // google sign up
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SquareTile(
                    onTap: _signUpWithGoogle,
                    imagePath: 'assets/images/google.png'),
              ]),

              // error message
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ]),
          )),
    );
  }
}
