import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownCustonEditDelete extends StatelessWidget {
  final List<String> itens;
  final Function(String?) onChanged;
  const DropDownCustonEditDelete({
    Key? key,
    required this.itens,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  color: Colors.red,
      margin: EdgeInsets.only(bottom: 12),
      height: 25,
      width: 25,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownWidth: 60,
          isExpanded: true,
          icon: Container(),
          hint: const Icon(
            Icons.more_vert,
          ),
          onChanged: onChanged,
          items: itens
              .map(
                (item) => DropdownMenuItem<String>(
                  key: const Key("btn-DropdownMenuItem"),
                  value: item,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item != itens[0])
                        Container(
                          height: 1,
                          color: const Color(0xffC7C9CB),
                        )
                      else
                        Container(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          buttonHeight: 30,
          buttonElevation: 0,
          dropdownElevation: 1,
          itemPadding: EdgeInsets.zero,
          dropdownPadding: EdgeInsets.only(right: 1),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          offset: Offset((-40), (25)),
          itemHeight: (28),
        ),
      ),
    );
  }
}
