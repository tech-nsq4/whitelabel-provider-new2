import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/chat_repo.dart';
import '../data/models/chat_message_model.dart';
import '../logic/chat_cubit.dart';
import 'widgets/chat_header.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  final int userId;
  final String userName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatCubit _cubit = getIt<ChatCubit>();
  late final String _chatId;
  late final int _doctorId;
  late final String _doctorName;
  late final String? _doctorImage;
  String? _lastMarkedReadMessageId;

  @override
  void initState() {
    super.initState();
    _doctorId = kUserModel!.id;
    _doctorName = kUserModel!.name;
    _doctorImage = kUserModel!.doctor?.image;
    _chatId = getIt<ChatRepo>().chatId(doctorId: _doctorId, userId: widget.userId);
    _cubit.watch(_chatId);
    getIt<ChatRepo>().markRead(chatId: _chatId, role: ChatSenderRole.doctor);
  }

  void _markReadIfNeeded(List<ChatMessageModel> messages) {
    if (messages.isEmpty) return;
    final latest = messages.first;
    if (latest.senderRole == ChatSenderRole.doctor) return;
    if (latest.id == _lastMarkedReadMessageId) return;
    _lastMarkedReadMessageId = latest.id;
    getIt<ChatRepo>().markRead(chatId: _chatId, role: ChatSenderRole.doctor);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _sendText(String text) {
    _cubit.sendText(
      chatId: _chatId,
      doctorId: _doctorId,
      userId: widget.userId,
      doctorName: _doctorName,
      doctorImage: _doctorImage,
      userName: widget.userName,
      userImage: null,
      senderRole: ChatSenderRole.doctor,
      text: text,
    );
  }

  void _sendImage(File file) {
    _cubit.sendImage(
      chatId: _chatId,
      doctorId: _doctorId,
      userId: widget.userId,
      doctorName: _doctorName,
      doctorImage: _doctorImage,
      userName: widget.userName,
      userImage: null,
      senderRole: ChatSenderRole.doctor,
      file: file,
    );
  }

  void _sendLocation(double lat, double lng) {
    _cubit.sendLocation(
      chatId: _chatId,
      doctorId: _doctorId,
      userId: widget.userId,
      doctorName: _doctorName,
      doctorImage: _doctorImage,
      userName: widget.userName,
      userImage: null,
      senderRole: ChatSenderRole.doctor,
      lat: lat,
      lng: lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: Column(
          children: [
            ChatHeader(
              name: widget.userName,
              presenceRole: ChatSenderRole.user,
              presenceId: widget.userId,
            ),
            Expanded(
              child: StreamBuilder<ChatReadStateModel>(
                stream: getIt<ChatRepo>().watchReadState(_chatId),
                builder: (context, readSnapshot) {
                  final otherLastReadAt = (readSnapshot.data ?? const ChatReadStateModel())
                      .lastReadAtFor(ChatSenderRole.user);

                  return BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is ChatSuccess) _markReadIfNeeded(state.messages);
                    },
                    builder: (context, state) {
                      final messages = state is ChatSuccess ? state.messages : const <ChatMessageModel>[];

                      return CustomScreenStateLayout(
                        isLoading: state is ChatLoading || state is ChatInitial,
                        error: state is ChatError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.watch(_chatId),
                        isEmpty: state is ChatSuccess && messages.isEmpty,
                        noDataBuilder: (_) => CustomNoDataView(
                          title: LocaleKeys.chat_emptyTitle.tr(),
                          desc: LocaleKeys.chat_emptyDescription.tr(),
                        ),
                        builder: (context) => ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMine = message.senderRole == ChatSenderRole.doctor;
                            final isRead = isMine &&
                                message.createdAt != null &&
                                otherLastReadAt != null &&
                                !message.createdAt!.isAfter(otherLastReadAt);
                            return ChatMessageBubble(message: message, isMine: isMine, isRead: isRead);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ChatInputBar(
              onSendText: _sendText,
              onSendImage: _sendImage,
              onSendLocation: _sendLocation,
            ),
          ],
        ),
      ),
    );
  }
}
