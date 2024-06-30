import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movielingo_app/services/auth.dart';
import 'package:movielingo_app/utils/snackbar_helper.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: const Text('Sign Up to MovieLingo'),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ]),
      body: Container(
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
                              showErrorSnackBar(context, result.errorMessage!);
                            } else {
                              // Navigate after the async operation completes
                              if (!mounted) return;
                              context.go('/information');
                            }
                          }
                        }
                      : null,
                  child: const Text(
                    'Sign Up',
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ]),
          )),
    );
  }
}
