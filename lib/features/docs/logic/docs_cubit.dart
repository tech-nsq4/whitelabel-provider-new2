import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/docs_repo.dart';
import '../data/models/document_record_model.dart';

part 'docs_state.dart';

class DocsCubit extends Cubit<DocsState> {
  DocsCubit(this._repo) : super(const DocsInitial());

  final DocsRepo _repo;

  Future<void> loadDocs() async {
    emit(const DocsLoading());
    try {
      final docs = await _repo.getDocs();
      emit(DocsSuccess(docs));
    } catch (e) {
      emit(DocsError(e.toString()));
    }
  }

  void markIssued(String id) {
    final current = state;
    if (current is! DocsSuccess) return;
    emit(DocsSuccess([
      for (final d in current.docs)
        if (d.id == id)
          DocumentRecordModel(
            id: d.id,
            title: d.title,
            patientName: d.patientName,
            docNumber: d.docNumber,
            extra: d.extra,
            status: DocumentStatus.issued,
          )
        else
          d,
    ]));
  }
}
