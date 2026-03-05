import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/features/chat/domain/search_state.dart';
import 'package:kora_chat/providers/api_providers.dart';

part 'search_viewmodel.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  @override
  SearchState build() {
    return const SearchState();
  }

  Future<void> search(String query) async {
    if (query.length < 2) {
      state = state.copyWith(users: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(authRepositoryProvider);
      final users = await repository.searchUsers(query);
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Échec de la recherche d\'utilisateurs',
      );
    }
  }

  void toggleMultiSelectMode() {
    state = state.copyWith(
      isMultiSelectMode: !state.isMultiSelectMode,
      selectedUserIds: {},
    );
  }

  void toggleUserSelection(String userId) {
    final selected = Set<String>.from(state.selectedUserIds);
    if (selected.contains(userId)) {
      selected.remove(userId);
    } else {
      selected.add(userId);
    }
    state = state.copyWith(selectedUserIds: selected);
  }

  Future<String?> createDirectChat(String targetUserId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(chatRepositoryProvider);
      final chat = await repository.createChat({
        'participantIds': [targetUserId],
      });
      state = state.copyWith(isLoading: false);
      return chat.id;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Échec de la création du chat',
      );
      return null;
    }
  }

  Future<String?> createGroupChat(String name) async {
    if (state.selectedUserIds.isEmpty) return null;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(chatRepositoryProvider);
      final chat = await repository.createChat({
        'participantIds': state.selectedUserIds.toList(),
        'name': name,
      });
      state = state.copyWith(
        isLoading: false,
        isMultiSelectMode: false,
        selectedUserIds: {},
      );
      return chat.id;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Échec de la création du groupe',
      );
      return null;
    }
  }
}
