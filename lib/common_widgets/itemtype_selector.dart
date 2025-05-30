import 'package:flutter/material.dart';

class ItemTypeSelector extends StatelessWidget {
  const ItemTypeSelector({
    Key? key,
    required this.itemtypes,
    required this.selectedIndex,
    required this.onChanged,
  }) : super(key: key);
  final List<String> itemtypes;
  final int selectedIndex;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select itemtype',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.0),
        Container(
          height: 40.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemtypes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onChanged(index),
                child: Container(
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  margin: const EdgeInsets.only(right: 12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 3.0,
                      color:
                          selectedIndex == index ? Colors.teal : Colors.black,
                    ),
                  ),
                  child: Text(itemtypes[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
