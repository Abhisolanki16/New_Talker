import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkr_demo/models/user.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  // ignore: prefer_typing_uninitialized_variables
  var userDocs;

  buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Form(
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Search for a user...'),
          onFieldSubmitted: submit,
        ),
      ),
    );
  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<UserSearchItem> userSearchItems = [];

    for (var doc in docs) {
      User user = User.fromDocument(doc);
      UserSearchItem searchItem = UserSearchItem(user);
      userSearchItems.add(searchItem);
    }

    return ListView(
      children: userSearchItems,
    );
  }

  void submit(String searchValue) async {
    Future<QuerySnapshot> users = Firestore.instance
        .where('name', isGreaterThanOrEqualTo: searchValue)
        .getDocuments();

    setState(() {
      userDocs = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: buildSearchField(),
      // ignore: unnecessary_null_comparison
      body: userDocs == null
          ? const Text("")
          : FutureBuilder<QuerySnapshot>(
              future: userDocs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildSearchResults(snapshot.data!.docs);
                } else {
                  return Container(
                      alignment: FractionalOffset.center,
                      child: const CircularProgressIndicator());
                }
              }),
    );
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

class Firestore {
  // ignore: prefer_typing_uninitialized_variables
  static var instance;
}

class UserSearchItem extends StatelessWidget {
  final User user;

  // ignore: use_key_in_widget_constructors
  const UserSearchItem(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return GestureDetector(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
        ),
        title: Text(user.username, style: boldStyle),
        subtitle: Text(user.username),
      ),
    );
  }

  void openProfile(BuildContext context, id) {}
}


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkr_demo/models/user.dart';
import 'package:talkr_demo/widgets/progress.dart';
import 'feed_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot>? searchResultsFuture;
  handleSearchScreen(String query) {
    Future<QuerySnapshot> users = usersRef.where("name").get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearchScreen() {
    searchController.clear();
  }

  AppBar buildSearchScreenField() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search User",
          filled: true,
          prefixIcon: const Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearSearchScreen,
          ),
        ),
        onFieldSubmitted: handleSearchScreen,
      ),
    );
  }

  Container buildNoContent() {
    // ignore: avoid_unnecessary_containers
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: const <Widget>[
            Text(
              "Find Users ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchScreenResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // ignore: non_constant_identifier_names
        List<UserResult> SearchScreenResults = [];
        // ignore: avoid_function_literals_in_foreach_calls
        snapshot.data?.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          // ignore: non_constant_identifier_names
          UserResult SearchScreenResult = UserResult(user);
          SearchScreenResults.add(SearchScreenResult);
        });
        return ListView(
          children: SearchScreenResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchScreenField(),
      body:
          // ignore: unnecessary_null_comparison
          searchResultsFuture == null
              ? buildNoContent()
              : buildSearchScreenResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  // ignore: use_key_in_widget_constructors
  const UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            // ignore: avoid_print
            onTap: () => print('tapped'),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text(
                user.username,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
*/