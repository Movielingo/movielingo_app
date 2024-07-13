import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/screens/media_detail.dart';
import 'package:movielingo_app/screens/profile.dart';
import 'package:movielingo_app/screens/endpoints.dart';
import 'package:movielingo_app/services/media_service.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  late Future<List<Movie>?> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = getAllMovies('EnglishMedia', 'german');
  }

  void _onMovieTap(Movie movie) {
    Get.to(MediaDetail(movie: movie));
  }

  Widget _buildMovieItem(Movie movie) {
    return GestureDetector(
      onTap: () => _onMovieTap(movie),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
              'https://firebasestorage.googleapis.com/v0/b/movielingo-717e0.appspot.com/o/media%2Ffriends_english.jpeg?alt=media&token=fad7f988-61f4-4b1e-9aa0-661c7340c32b',
              fit: BoxFit.cover), // Assuming imgRef is the URL
          const SizedBox(height: 8),
          Text(
            movie.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            movie.imgRef,
          ),
        ],
      ),
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
      const Profile(),
      Endpoints(),
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
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Profile'),
          NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Endpoints'),
        ],
      ),
    );
  }
}
