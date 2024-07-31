import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text('Continue'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'No account? ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Register here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final String usernameOrEmail = _usernameController.text;
    final String password = _passwordController.text;
    String email;
    String username;

    // Regular expression for validating email
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (emailRegExp.hasMatch(usernameOrEmail)) {
      email = usernameOrEmail;
      username = '';
    } else {
      email = '';
      username = usernameOrEmail;
    }

    final response = await http.post(
      Uri.parse('http://techtest.youapp.ai/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, navigate to the Home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      // If the server did not return a 200 OK response, show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed'),
      ));
    }
  }
}

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter Email'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Create Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Create Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: Text('Register'),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Have an account? ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Login here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(
                            context); // Navigate back to the Login screen
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    final String email = _emailController.text;
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      // Show error if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
      ));
      return;
    }

    final response = await http.post(
      Uri.parse('http://techtest.youapp.ai/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, navigate to the Home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      // If the server did not return a 200 OK response, show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed'),
      ));
    }
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _zodiac = '';
  String _horoscope = '';

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    final response = await http.get(
      Uri.parse('http://techtest.youapp.ai/api/getProfile'),
      headers: <String, String>{
        'x-access-token': 'test-access-token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> profile = json.decode(response.body);
      final String birthday = profile['birthday'];
      _getHoroscope(birthday);
      _getZodiac(birthday);
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //  content: Text('Failed to load profile'),
      //));
    }
  }

  Future<void> _getHoroscope(String birthday) async {
    final response = await http.post(
      //mock api in index.js
      Uri.parse('http://techtest.youapp.ai/api/getHoroscope'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'birthday': birthday,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _horoscope = data['horoscope'];
      });
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //  content: Text('Failed to load horoscope'),
      //));
    }
  }

  Future<void> _getZodiac(String birthday) async {
    final response = await http.post(
      //mock api in index.js
      Uri.parse('http://techtest.youapp.ai/api/getZodiac'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'birthday': birthday,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _zodiac = data['zodiac'];
      });
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //  content: Text('Failed to load zodiac'),
      //));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_zodiac.isNotEmpty && _horoscope.isNotEmpty) ...[
              Text('Zodiac: $_zodiac'),
              Text('Horoscope: $_horoscope'),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              child: Text('About'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterestScreen()),
                );
              },
              child: Text('Interest'),
            ),
          ],
        ),
      ),
    );
  }
}

class Home2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              child: Text('About'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterestScreen()),
                );
              },
              child: Text('Interest'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height'),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveAndUpdate(context);
              },
              child: Text('Save & Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future _saveAndUpdate(BuildContext context) async {
    final String name = _nameController.text;
    final String birthday = _birthdayController.text;
    final String height = _heightController.text;
    final String weight = _weightController.text;
    final response = await http.get(
      Uri.parse('http://techtest.youapp.ai/api/getProfile'),
      headers: <String, String>{
        'x-access-token': 'test-access-token',
      },
    );

    if (response.statusCode == 200) {
      final updateResponse = await http.put(
        Uri.parse('http://techtest.youapp.ai/api/updateProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': 'test-access-token',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'birthday': birthday,
          'height': height,
          'weight': weight,
        }),
      );

      if (updateResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile'),
        ));
      }
    } else {
      final createResponse = await http.post(
        Uri.parse('http://techtest.youapp.ai/api/createProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': 'test-access-token',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'birthday': birthday,
          'height': height,
          'weight': weight,
        }),
      );

      if (createResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile created successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create profile'),
        ));
      }
    }
  }
}

class InterestScreen extends StatefulWidget {
  @override
  _InterestScreenState createState() => _InterestScreenState();
}

class _InterestScreenState extends State {
  final TextEditingController _interestController = TextEditingController();
  List _interests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _interestController,
              decoration: InputDecoration(labelText: 'Enter interest'),
            ),
            ElevatedButton(
              onPressed: () {
                _addInterest();
              },
              child: Text('Add'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _interests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_interests[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveAndUpdate(context);
              },
              child: Text('Save & Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _addInterest() {
    setState(() {
      if (_interestController.text.isNotEmpty) {
        _interests.add(_interestController.text);
        _interestController.clear();
      }
    });
  }

  Future _saveAndUpdate(BuildContext context) async {
    final response = await http.put(
      Uri.parse('http://techtest.youapp.ai/api/updateProfile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': 'test-access-token',
      },
      body: jsonEncode(<String, dynamic>{
        'interests': _interests,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Interests updated successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update interests'),
      ));
    }
  }
}
