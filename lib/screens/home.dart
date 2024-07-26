import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/screens/media_detail.dart';
import 'package:movielingo_app/screens/profile.dart';
// import 'package:movielingo_app/screens/endpoints.dart';
import 'package:movielingo_app/screens/vocabulary_box.dart';
import 'package:movielingo_app/services/media_service.dart';
import 'package:movielingo_app/services/firebase_storage_service.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorageService _firebaseStorageService =
      Get.find<FirebaseStorageService>();
  int _selectedIndex = 0;
  late Future<List<Movie>?> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = getAllMovies('EnglishMedia', 'german');
  }

  void _onMovieTap(Movie movie) {
    Get.to(() => MediaDetail(movie: movie));
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
                Flexible(
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    movie.imgRef,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
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
                  childAspectRatio: 0.7,
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
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
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
/*           NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Endpoints'), */
        ],
      ),
    );
  }
}
