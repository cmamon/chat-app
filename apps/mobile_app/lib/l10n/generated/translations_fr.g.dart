///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsFr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAuthFr auth = _TranslationsAuthFr._(_root);
	@override late final _TranslationsChatFr chat = _TranslationsChatFr._(_root);
	@override late final _TranslationsErrorFr error = _TranslationsErrorFr._(_root);
	@override late final _TranslationsHomeFr home = _TranslationsHomeFr._(_root);
	@override late final _TranslationsLandingFr landing = _TranslationsLandingFr._(_root);
	@override late final _TranslationsProfileFr profile = _TranslationsProfileFr._(_root);
}

// Path: auth
class _TranslationsAuthFr extends TranslationsAuthEn {
	_TranslationsAuthFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get welcomeBack => 'Content de vous revoir';
	@override String get signInToAccount => 'Connectez-vous à votre compte Kora';
	@override String get emailLabel => 'Adresse Email';
	@override String get emailHint => 'nom@entreprise.com';
	@override String get passwordLabel => 'Mot de passe';
	@override String get passwordHint => 'min. 12 caractères';
	@override String get signIn => 'Se connecter';
	@override String get forgotPassword => 'Mot de passe oublié ?';
	@override String get emailRequired => 'L\'email est requis';
	@override String get invalidEmail => 'Format d\'email invalide';
	@override String get passwordRequired => 'Le mot de passe est requis';
	@override String get passwordTooShort => 'Le mot de passe doit faire au moins 6 caractères';
	@override String get createNewAccount => 'Créer un nouveau compte';
	@override String get joinKoraToday => 'Rejoignez Kora et commencez à discuter';
	@override String get firstNameLabel => 'Prénom';
	@override String get firstNameHint => 'Jane';
	@override String get lastNameLabel => 'Nom';
	@override String get lastNameHint => 'Doe';
	@override String get usernameLabel => 'Nom d\'utilisateur';
	@override String get usernameHint => 'janedoe';
	@override String get signUp => 'S\'inscrire';
	@override String get backToLogin => 'Déjà un compte ? Connectez-vous';
	@override String get firstNameRequired => 'Le prénom est requis';
	@override String get lastNameRequired => 'Le nom est requis';
	@override String get usernameRequired => 'Le nom d\'utilisateur est requis';
}

// Path: chat
class _TranslationsChatFr extends TranslationsChatEn {
	_TranslationsChatFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get onlineStatus => 'En ligne';
	@override String get typeMessage => 'Écrivez un message...';
	@override String get failedToLoadMessages => 'Échec du chargement des messages';
	@override String get failedToSendMessage => 'Échec de l\'envoi du message';
	@override String get noMessagesYet => 'Pas encore de messages';
	@override String get searchConversations => 'Rechercher des conversations...';
	@override String get newMessage => 'Nouveau Message';
	@override String get searchUsersPlaceholder => 'Rechercher par pseudo ou email...';
	@override String get searchEmptyState => 'Recherchez des personnes pour discuter';
	@override String get searchError => 'Erreur de recherche d\'utilisateur';
	@override String get createChatError => 'Échec de création du chat';
	@override String get newGroup => 'Nouveau Groupe';
	@override String get createGroup => 'Créer un groupe';
	@override String get groupName => 'Nom du groupe';
	@override String get cancel => 'Annuler';
}

// Path: error
class _TranslationsErrorFr extends TranslationsErrorEn {
	_TranslationsErrorFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get errorNetwork => 'Pas de connexion internet. Veuillez vérifier votre réseau.';
	@override String get errorUnauthorized => 'Session expirée. Veuillez vous reconnecter.';
	@override String get errorServer => 'Erreur serveur. Veuillez réessayer plus tard.';
	@override String get errorTimeout => 'Le délai d\'attente a expiré.';
	@override String get errorBadRequest => 'Requête invalide.';
	@override String get errorUnknown => 'Une erreur inattendue est survenue.';
	@override String get offlineMessage => 'Vous êtes hors ligne. Certaines fonctionnalités peuvent être limitées.';
	@override String get connectionRestored => 'Connexion rétablie.';
	@override String get retry => 'Réessayer';
}

// Path: home
class _TranslationsHomeFr extends TranslationsHomeEn {
	_TranslationsHomeFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get homeTitle => 'Accueil';
	@override String get welcomeToKora => 'Bienvenue sur Kora !';
	@override String get secureSpaceReady => 'Votre espace de communication sécurisé est prêt.';
	@override String get startChatting => 'Commencer à discuter';
}

// Path: landing
class _TranslationsLandingFr extends TranslationsLandingEn {
	_TranslationsLandingFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get landingTagline => 'Votre espace premium pour une\ncommunication professionnelle fluide.';
	@override String get createAccount => 'Créer un compte';
	@override String get alreadyHaveAccount => 'J\'ai déjà un compte';
}

// Path: profile
class _TranslationsProfileFr extends TranslationsProfileEn {
	_TranslationsProfileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get profileTitle => 'Mon Profil';
	@override String get editProfile => 'Modifier le Profil';
	@override String get personalInfo => 'Informations Personnelles';
	@override String get username => 'Nom d\'utilisateur';
	@override String get email => 'Adresse Email';
	@override String get logout => 'Se déconnecter';
	@override String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';
	@override String get saveChanges => 'Enregistrer les modifications';
	@override String get cancel => 'Annuler';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.welcomeBack' => 'Content de vous revoir',
			'auth.signInToAccount' => 'Connectez-vous à votre compte Kora',
			'auth.emailLabel' => 'Adresse Email',
			'auth.emailHint' => 'nom@entreprise.com',
			'auth.passwordLabel' => 'Mot de passe',
			'auth.passwordHint' => 'min. 12 caractères',
			'auth.signIn' => 'Se connecter',
			'auth.forgotPassword' => 'Mot de passe oublié ?',
			'auth.emailRequired' => 'L\'email est requis',
			'auth.invalidEmail' => 'Format d\'email invalide',
			'auth.passwordRequired' => 'Le mot de passe est requis',
			'auth.passwordTooShort' => 'Le mot de passe doit faire au moins 6 caractères',
			'auth.createNewAccount' => 'Créer un nouveau compte',
			'auth.joinKoraToday' => 'Rejoignez Kora et commencez à discuter',
			'auth.firstNameLabel' => 'Prénom',
			'auth.firstNameHint' => 'Jane',
			'auth.lastNameLabel' => 'Nom',
			'auth.lastNameHint' => 'Doe',
			'auth.usernameLabel' => 'Nom d\'utilisateur',
			'auth.usernameHint' => 'janedoe',
			'auth.signUp' => 'S\'inscrire',
			'auth.backToLogin' => 'Déjà un compte ? Connectez-vous',
			'auth.firstNameRequired' => 'Le prénom est requis',
			'auth.lastNameRequired' => 'Le nom est requis',
			'auth.usernameRequired' => 'Le nom d\'utilisateur est requis',
			'chat.onlineStatus' => 'En ligne',
			'chat.typeMessage' => 'Écrivez un message...',
			'chat.failedToLoadMessages' => 'Échec du chargement des messages',
			'chat.failedToSendMessage' => 'Échec de l\'envoi du message',
			'chat.noMessagesYet' => 'Pas encore de messages',
			'chat.searchConversations' => 'Rechercher des conversations...',
			'chat.newMessage' => 'Nouveau Message',
			'chat.searchUsersPlaceholder' => 'Rechercher par pseudo ou email...',
			'chat.searchEmptyState' => 'Recherchez des personnes pour discuter',
			'chat.searchError' => 'Erreur de recherche d\'utilisateur',
			'chat.createChatError' => 'Échec de création du chat',
			'chat.newGroup' => 'Nouveau Groupe',
			'chat.createGroup' => 'Créer un groupe',
			'chat.groupName' => 'Nom du groupe',
			'chat.cancel' => 'Annuler',
			'error.errorNetwork' => 'Pas de connexion internet. Veuillez vérifier votre réseau.',
			'error.errorUnauthorized' => 'Session expirée. Veuillez vous reconnecter.',
			'error.errorServer' => 'Erreur serveur. Veuillez réessayer plus tard.',
			'error.errorTimeout' => 'Le délai d\'attente a expiré.',
			'error.errorBadRequest' => 'Requête invalide.',
			'error.errorUnknown' => 'Une erreur inattendue est survenue.',
			'error.offlineMessage' => 'Vous êtes hors ligne. Certaines fonctionnalités peuvent être limitées.',
			'error.connectionRestored' => 'Connexion rétablie.',
			'error.retry' => 'Réessayer',
			'home.homeTitle' => 'Accueil',
			'home.welcomeToKora' => 'Bienvenue sur Kora !',
			'home.secureSpaceReady' => 'Votre espace de communication sécurisé est prêt.',
			'home.startChatting' => 'Commencer à discuter',
			'landing.landingTagline' => 'Votre espace premium pour une\ncommunication professionnelle fluide.',
			'landing.createAccount' => 'Créer un compte',
			'landing.alreadyHaveAccount' => 'J\'ai déjà un compte',
			'profile.profileTitle' => 'Mon Profil',
			'profile.editProfile' => 'Modifier le Profil',
			'profile.personalInfo' => 'Informations Personnelles',
			'profile.username' => 'Nom d\'utilisateur',
			'profile.email' => 'Adresse Email',
			'profile.logout' => 'Se déconnecter',
			'profile.logoutConfirm' => 'Êtes-vous sûr de vouloir vous déconnecter ?',
			'profile.saveChanges' => 'Enregistrer les modifications',
			'profile.cancel' => 'Annuler',
			_ => null,
		};
	}
}
