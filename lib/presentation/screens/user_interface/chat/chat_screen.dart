import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import '../../../../core/helper/constants/images-resources.dart';
import '../../../../core/helper/constants/strings-resource.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../widgets/app_bar_widget.dart';
import '../../../../widgets/chat_input_widget.dart';
import '../../../../widgets/message_widget.dart';
import '../../../bloc/call/call_bloc.dart';
import '../../../bloc/call/call_event.dart';
import '../../../bloc/chat/chat_bloc.dart';
import '../../../bloc/chat/chat_event.dart';
import '../../../bloc/chat/chat_state.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatScreen({super.key}); // Added Key and fixed constructor

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the theme for consistent text styling
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: StringResources.chatUserDefault,
              showBackButton: true,
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<CallBloc>().add(StartCall(StringResources.chatUserDefault));
                    Navigator.pushNamed(context, AppRoutes.call);
                  },
                  icon: SvgPicture.asset(
                    ImageResource.CALL_ICON,
                    width: DimensionsResources.D_20.w,
                    colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  // Scroll to bottom whenever a new message is added
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                },
                builder: (context, state) {
                  if (state.status == ChatStatus.error && state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'Error: ${state.errorMessage}',
                        style: textTheme.bodyMedium?.copyWith(color: AppColors.red),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_10.h),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return MessageWidget(message: state.messages[index]);
                          },
                        ),
                      ),

                      // Typing Indicator
                      if (state.status == ChatStatus.loading)
                        Padding(
                          padding: const EdgeInsets.all(DimensionsResources.D_8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              StringResources.typing,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            ChatInputWidget(
                controller: _messageController,
                onSendMessage: (message) {
                  if (message.trim().isNotEmpty) {
                    context.read<ChatBloc>().add(SendMessage(message));
                    _messageController.clear();
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}