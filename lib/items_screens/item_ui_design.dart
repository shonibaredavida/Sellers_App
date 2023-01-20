import 'package:flutter/material.dart';
import 'package:sellers_app/Models/items_models.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/items_screens/item_details_screen.dart';

class ItemsUIDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;
  ItemsUIDesignWidget({this.context, this.model});
  @override
  State<ItemsUIDesignWidget> createState() => _ItemsUIDesignWidgetState();
}

class _ItemsUIDesignWidgetState extends State<ItemsUIDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ItemsDetailsScreen(model: widget.model)),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              sizedbox(),
              Text(
                widget.model!.itemTitle.toString(),
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 3,
                ),
              ),
              sizedbox(),
              Image.network(
                widget.model!.thumbnailUrl.toString(),
                height: 220,
                fit: BoxFit.cover,
              ),
              sizedbox(),
              Text(
                widget.model!.itemInfo.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
