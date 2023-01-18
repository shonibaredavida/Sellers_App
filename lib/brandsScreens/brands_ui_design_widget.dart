import 'package:flutter/material.dart';
import 'package:sellers_app/Models/brands_model.dart';
import 'package:sellers_app/items_screens/items_screen.dart';

class BrandsUIDesignWidget extends StatefulWidget {
  Brands? model;
  BuildContext? context;
  BrandsUIDesignWidget({this.context, this.model});
  @override
  State<BrandsUIDesignWidget> createState() => _BrandsUIDesignWidgetState();
}

class _BrandsUIDesignWidgetState extends State<BrandsUIDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ItemsScreen(model: widget.model)),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            // height: 70,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Image.network(
                widget.model!.thumbnailUrl.toString(),
                height: 220,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.brandTitle.toString(),
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 3,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_sweep),
                    color: Colors.red,
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
