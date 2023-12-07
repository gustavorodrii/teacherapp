// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownCustomWidget extends StatefulWidget {
  final bool validator;
  final double widthDropDown;
  final Widget? title;
  final Widget? subtitle;
  final double itemHeight;
  final String? valueDropdown;
  final void Function(String?) onChanged;
  final List<String> dropOptions;
  final String? errorText;
  final bool useErrorText;
  final Color? backgroundColor;

  const DropDownCustomWidget({
    Key? key,
    this.validator = true,
    this.widthDropDown = 132,
    this.title,
    this.subtitle,
    this.itemHeight = 40,
    this.errorText,
    this.useErrorText = false,
    this.backgroundColor,
    required this.valueDropdown,
    required this.onChanged,
    required this.dropOptions,
  }) : super(key: key);

  @override
  State<DropDownCustomWidget> createState() => _DropDownCustomWidgetState();
}

class _DropDownCustomWidgetState extends State<DropDownCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null) widget.title! else const SizedBox(),
        if (widget.subtitle != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              widget.subtitle!,
            ],
          )
        else
          const SizedBox(),
        if (widget.subtitle != null || widget.title != null)
          const SizedBox(height: 10)
        else
          const SizedBox(),
        DropdownButtonHideUnderline(
          child: Row(
            children: [
              Container(
                width: widget.widthDropDown,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.5,
                      color: Colors.black12,
                      spreadRadius: 0.3,
                      offset: Offset.fromDirection(1, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 1, right: 1),
                child: DropdownButton2(
                  hint: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      "Selecione",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  disabledHint: Container(),
                  items: widget.dropOptions
                      .map(
                        (item) => DropdownMenuItem<String>(
                          key: const Key("btn-DropdownMenuItem"),
                          value: item,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item != widget.dropOptions[0])
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
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Theme.of(context).primaryColor,
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
                  value: widget.valueDropdown,
                  onChanged: widget.onChanged,
                  icon: Container(
                    margin: EdgeInsets.only(
                      right: 16,
                    ),
                    child: Image.asset(
                      "assets/images/arrow_drop_down.png",
                      height: 8,
                      width: 8,
                    ),
                  ),

                  buttonHeight: 30,
                  buttonWidth: widget.widthDropDown,
                  buttonElevation: 0,
                  dropdownElevation: 1,
                  itemHeight: widget.itemHeight,
                  itemPadding: EdgeInsets.zero,
                  dropdownMaxHeight: 200,
                  dropdownWidth: widget.widthDropDown,
                  dropdownPadding: const EdgeInsets.only(right: 1),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  // dropdownElevation: 8,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,

                  scrollbarAlwaysShow: true,
                  offset: const Offset(0, 30),
                ),
              ),
            ],
          ),
        ),
        if (widget.useErrorText) ...[
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ] else ...[
          if (!widget.validator)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Escolha uma opção!",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
