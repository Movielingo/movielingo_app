import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/screens/media_detail.dart';
import 'package:movielingo_app/screens/profile.dart';
import 'package:movielingo_app/screens/vocabulary_box.dart';
import 'package:movielingo_app/services/media_service.dart';
import 'package:movielingo_app/services/firebase_storage_service.dart';
import 'package:movielingo_app/services/user_service.dart';
import 'package:get/get.dart';
import 'package:movielingo_app/controllers/accelerometer_controller.dart';
import 'dart:ui';
import 'package:movielingo_app/controllers/app_lifecycle_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorageService _firebaseStorageService =
      Get.find<FirebaseStorageService>();
  final UserService userService = UserService();
  int _selectedIndex = 0;
  late Future<List<Movie>?> _moviesFuture;
  MyUserData? user;

  final AccelerometerController _accelerometerController =
      Get.put(AccelerometerController());
  final AppLifecycleController _appLifecycleController =
      Get.find<AppLifecycleController>();

  bool _isMessageVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _moviesFuture = getAllMovies('EnglishMedia', 'german');
    _loadCurrentUser();

    _accelerometerController.isStationary.listen((isStationary) {
      if (isStationary) {
        setState(() {
          _isMessageVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      user = await userService.getUser(userId);
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _appLifecycleController.setBackground(false);
      _refreshData();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _appLifecycleController.setBackground(true);
      _saveData();
      _pauseMediaPlayback();
    } else if (state == AppLifecycleState.detached) {
      _cleanupResources();
    }
  }

  void _refreshData() {
    setState(() {
      _moviesFuture = getAllMovies('EnglishMedia', 'german');
    });
  }

  void _saveData() {
    // TODO: Add logic to save data
  }

  void _pauseMediaPlayback() {
    // TODO: add some functionality to pause media playback once I implemented it...
  }

  void _cleanupResources() {
    // TODO: add some methods to clean up resources e.g. close streams or something like that...
  }

  void _onMovieTap(Movie movie) {
    if (user != null) {
      Get.to(() => MediaDetail(movie: movie, user: user!));
    }
  }

  Widget _buildMovieItem(Movie movie) {
    return FutureBuilder<String?>(
      future: _firebaseStorageService.getImage(movie.imgRef),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error loading image'));
        } else {
          return GestureDetector(
            onTap: () => _onMovieTap(movie),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Image.network(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Center(
        child: FutureBuilder<List<Movie>?>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error fetching movies');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No movies available');
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.6,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildMovieItem(snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
      const VocabularyBox(),
      const Profile(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movielingo'),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text(''),
            onPressed: () async {
              await _auth.signOut();
              if (!mounted) return;
              Get.toNamed('/');
              Get.snackbar('Sign Out!', 'You have been signed out');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          Obx(() {
            if (_accelerometerController.isStationary.value &&
                _isMessageVisible) {
              return Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Perhaps now is the right time to learn some vocabulary?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isMessageVisible = false;
                          });
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          Obx(() {
            if (_appLifecycleController.isBackground.value) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home'),
          NavigationDestination(
              selectedIcon: Icon(Icons.book),
              icon: Icon(Icons.book_outlined),
              label: 'Your Box'),
          NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Profile'),
        ],
      ),
    );
  }
}
