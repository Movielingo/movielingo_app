import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<Movie?> get_all_movies() async {
  var id = "1XwWjPK3gBjoaih6X0Dn";
  print('Fetching all movies from db...');

  var snapshot = await db.collection('movies').doc(id).get();
  if (snapshot.exists) {
    var movie = Movie.fromSnapshot(snapshot);
    return movie;
  } else {
    // Handle the case when the document does not exist.
    return null;
  }
  print('finish');
}
