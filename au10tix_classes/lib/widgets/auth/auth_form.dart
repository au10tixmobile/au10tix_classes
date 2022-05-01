import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/shield.png',
              fit: BoxFit.cover,
            ),
            Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            key: const ValueKey('email'),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a vlid email';
                              }
                              if (!value.contains('au10tix')) {
                                return 'Please use your Au10tix email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                                labelText: 'Email address'),
                            onSaved: (newValue) {
                              _userEmail = newValue!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              key: const ValueKey('username'),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return 'Please enter at least 4 charecters';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              onSaved: (newValue) {
                                _userName = newValue!;
                              },
                            ),
                          TextFormField(
                            key: const ValueKey('password'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 charecters long';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            onSaved: (newValue) {
                              _userPassword = newValue!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (widget.isLoading)
                            const CircularProgressIndicator(),
                          if (!widget.isLoading)
                            ElevatedButton(
                              onPressed: _trySubmit,
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (!widget.isLoading)
                            TextButton(
                              onPressed: () => setState(() {
                                _isLogin = !_isLogin;
                              }),
                              child: Text(
                                _isLogin
                                    ? 'Create new account'
                                    : 'I already have an account',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
