import 'package:get/get.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CBTextInput extends StatefulWidget {
  final String? title;
  final String? hint;
  final double? width;
  final FocusNode? node;
  //
  final VoidCallback? onTap;
  final VoidCallback? onFocus;
  final VoidCallback? onUnfocus;
  final ValueChanged<String>? onQuery;
  final ValueChanged<String>? onSubmitted;
  //
  final bool readOnly;
  final bool openFocused;
  final Duration? delayedFocused;
  //
  final Color? backgroundColor;
  final TextInputAction? inputAction;
  final bool obscureText;
  //
  final RxnString? error;
  final int? maxLines;

  const CBTextInput({
    Key? key,
    this.title,
    this.hint,
    this.width,
    this.node,
    //
    this.onTap,
    this.onFocus,
    this.onUnfocus,
    this.onQuery,
    this.onSubmitted,
    //
    this.readOnly = false,
    this.openFocused = false,
    //
    this.backgroundColor,
    this.delayedFocused,
    this.inputAction,
    this.obscureText = false,
    //
    this.error,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<CBTextInput> createState() => _CBTextInputState();
}

class _CBTextInputState extends State<CBTextInput> {
  late TextEditingController _textEditingController;
  FocusNode? focusNode;
  //
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    if (widget.node == null) focusNode = FocusNode();
    _textEditingController = TextEditingController();

    _setupFocusListeneres();
    _setupListeneres();

    if (widget.openFocused) {
      if (widget.delayedFocused != null) {
        Future.delayed(widget.delayedFocused!, () {
          _requestFocus();
        });
      } else {
        _requestFocus();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _requestUnfocus();
    focusNode?.dispose();
    _textEditingController.dispose();
  }

  _requestFocus() {
    focusNode?.requestFocus();
    widget.node?.requestFocus();
  }

  _requestUnfocus() {
    focusNode?.unfocus();
    widget.node?.unfocus();
  }

  _setupFocusListeneres() {
    if (widget.onFocus == null && widget.onUnfocus == null) return;

    if (focusNode != null) {
      focusNode?.addListener(() {
        if (focusNode!.hasFocus) {
          widget.onFocus?.call();
        } else {
          widget.onUnfocus?.call();
        }
      });
    }

    if (widget.node != null) {
      widget.node?.addListener(() {
        if (widget.node!.hasFocus) {
          widget.onFocus?.call();
        } else {
          widget.onUnfocus?.call();
        }
      });
    }
  }

  _setupListeneres() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.trim().isNotEmpty) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          if (!mounted) return;
          setState(() => isTyping = true);
        });
      } else if (isTyping) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          if (!mounted) return;
          setState(() => isTyping = false);
        });
      }
    });
  }

  _onTap() {
    widget.onTap?.call();
    _requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return PSizeConfig.hMContainer(
      child: GestureDetector(
        onTap: _onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: PSizeConfig.height(57),
                maxWidth: widget.width ?? double.maxFinite,
              ),
              padding: EdgeInsets.symmetric(
                vertical: PSizeConfig.height(8.5),
                horizontal: PSizeConfig.width(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor('F0F0F0'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: widget.title != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: HexColor('AEAEB2'),
                      ),
                    ),
                  if (widget.title != null) PSizeConfig.heightSpace(5),
                  Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            focusNode: widget.node ?? focusNode,
                            onChanged: widget.onQuery,
                            onSubmitted: widget.onSubmitted,
                            controller: _textEditingController,
                            readOnly: widget.readOnly,
                            maxLines: widget.maxLines,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: HexColor('2B2B2B'),
                            ),
                            obscureText: widget.obscureText,
                            cursorColor: Colors.orange,
                            textInputAction: widget.inputAction,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              isDense: true,
                              hintText: widget.hint,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: HexColor('2B2B2B').withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.error != null)
              ObxValue<RxnString>(
                (_e) {
                  if (_e.value?.isEmpty ?? true) {}

                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      _e.value!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
                widget.error!,
              )
          ],
        ),
      ),
    );
  }
}
