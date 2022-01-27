import 'package:au10tix_classes/models/au10tix_class.dart';
import 'package:au10tix_classes/widgets/details/class_details_content.dart';
import 'package:flutter/material.dart';

class ClassDetailsScreen extends StatelessWidget {
  static const routeName = '/class_details';
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    final Au10tixClass au10tixClass =
        ModalRoute.of(context)!.settings.arguments as Au10tixClass;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  au10tixClass.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              background: Hero(
                tag: au10tixClass.id,
                child: Image.network(
                  au10tixClass.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ClassDetailsContent(au10tixClass),
                const SizedBox(
                    height:
                        700), //placeholder to fill the page and make it scrollable
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
