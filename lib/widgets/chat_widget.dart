import 'package:ai_assistant/theme/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false,
      required this.question});

  final String question;
  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: ColorPack.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: shouldAnimate
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                              child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  repeatForever: false,
                                  displayFullTextOnTap: true,
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      question.trim(),
                                    ),
                                  ]),
                            )
                          : Text(
                              question.trim(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                    ),
                    chatIndex == 0
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: shouldAnimate
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                              child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  repeatForever: false,
                                  displayFullTextOnTap: true,
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      msg.trim(),
                                    ),
                                  ]),
                            )
                          : Text(
                              msg.trim(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.thumb_down_alt_outlined,
                                  color: Colors.white,
                                  size: 16,
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
