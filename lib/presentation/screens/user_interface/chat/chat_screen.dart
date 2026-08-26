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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInit = true;

  late String conversationId;
  late String receiverId;
  late String receiverName;
  late String currentUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      conversationId = args['conversationId'];
      receiverId = args['receiverId'];
      receiverName = args['receiverName'];
      currentUserId = args['currentUserId'];

      // Start fetching history over repository architecture
      context.read<ChatBloc>().add(
        FetchMessages(conversationId: conversationId, currentUserId: currentUserId),
      );
      _isInit = false;
    }
  }

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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: receiverName,
              showBackButton: true,
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    // Trigger active RTC signaling across stream channels
                    Navigator.pushNamed(
                      context,
                      '/call',
                      arguments: {
                        'conversationId': conversationId,
                        'receiverId': receiverId,
                        'currentUserId': currentUserId,
                        'receiverName': receiverName,
                      },
                    );
                  },
                  icon: SvgPicture.asset(
                    ImageResource.CALL_ICON,
                    width: DimensionsResources.D_20.w,
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                },
                builder: (context, state) {
                  if (state.status == ChatStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_10.h),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return MessageWidget(message: state.messages[index]);
                    },
                  );
                },
              ),
            ),
            ChatInputWidget(
              controller: _messageController,
              onSendMessage: (message) {
                if (message.trim().isNotEmpty) {
                  context.read<ChatBloc>().add(SendMessage(
                    conversationId: conversationId,
                    senderId: currentUserId,
                    receiverId: receiverId,
                    message: message,
                  ));
                  _messageController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}