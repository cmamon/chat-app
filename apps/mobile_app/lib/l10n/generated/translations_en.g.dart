///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsChatEn chat = TranslationsChatEn.internal(_root);
	late final TranslationsErrorEn error = TranslationsErrorEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsLandingEn landing = TranslationsLandingEn.internal(_root);
	late final TranslationsProfileEn profile = TranslationsProfileEn.internal(_root);
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Sign in to your Kora account'
	String get signInToAccount => 'Sign in to your Kora account';

	/// en: 'Email Address'
	String get emailLabel => 'Email Address';

	/// en: 'name@company.com'
	String get emailHint => 'name@company.com';

	/// en: 'Password'
	String get passwordLabel => 'Password';

	/// en: 'min. 12 characters'
	String get passwordHint => 'min. 12 characters';

	/// en: 'Sign In'
	String get signIn => 'Sign In';

	/// en: 'Forgot password?'
	String get forgotPassword => 'Forgot password?';

	/// en: 'Email is required'
	String get emailRequired => 'Email is required';

	/// en: 'Invalid email format'
	String get invalidEmail => 'Invalid email format';

	/// en: 'Password is required'
	String get passwordRequired => 'Password is required';

	/// en: 'Password must be at least 6 characters'
	String get passwordTooShort => 'Password must be at least 6 characters';

	/// en: 'Create New Account'
	String get createNewAccount => 'Create New Account';

	/// en: 'Join Kora and start chatting'
	String get joinKoraToday => 'Join Kora and start chatting';

	/// en: 'First Name'
	String get firstNameLabel => 'First Name';

	/// en: 'Jane'
	String get firstNameHint => 'Jane';

	/// en: 'Last Name'
	String get lastNameLabel => 'Last Name';

	/// en: 'Doe'
	String get lastNameHint => 'Doe';

	/// en: 'Username'
	String get usernameLabel => 'Username';

	/// en: 'janedoe'
	String get usernameHint => 'janedoe';

	/// en: 'Sign Up'
	String get signUp => 'Sign Up';

	/// en: 'Already have an account? Sign in'
	String get backToLogin => 'Already have an account? Sign in';

	/// en: 'First name is required'
	String get firstNameRequired => 'First name is required';

	/// en: 'Last name is required'
	String get lastNameRequired => 'Last name is required';

	/// en: 'Username is required'
	String get usernameRequired => 'Username is required';
}

// Path: chat
class TranslationsChatEn {
	TranslationsChatEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Online'
	String get onlineStatus => 'Online';

	/// en: 'Type a message...'
	String get typeMessage => 'Type a message...';

	/// en: 'Failed to load messages'
	String get failedToLoadMessages => 'Failed to load messages';

	/// en: 'Failed to send message'
	String get failedToSendMessage => 'Failed to send message';

	/// en: 'No messages yet'
	String get noMessagesYet => 'No messages yet';

	/// en: 'Search conversations...'
	String get searchConversations => 'Search conversations...';

	/// en: 'New Message'
	String get newMessage => 'New Message';

	/// en: 'Search by username or email...'
	String get searchUsersPlaceholder => 'Search by username or email...';

	/// en: 'Search for people to start a chat'
	String get searchEmptyState => 'Search for people to start a chat';

	/// en: 'User search failed'
	String get searchError => 'User search failed';

	/// en: 'Failed to create chat'
	String get createChatError => 'Failed to create chat';

	/// en: 'New Group'
	String get newGroup => 'New Group';

	/// en: 'Create Group'
	String get createGroup => 'Create Group';

	/// en: 'Group Name'
	String get groupName => 'Group Name';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: error
class TranslationsErrorEn {
	TranslationsErrorEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No internet connection. Please check your network.'
	String get errorNetwork => 'No internet connection. Please check your network.';

	/// en: 'Session expired. Please sign in again.'
	String get errorUnauthorized => 'Session expired. Please sign in again.';

	/// en: 'Server error. Please try again later.'
	String get errorServer => 'Server error. Please try again later.';

	/// en: 'The request timed out.'
	String get errorTimeout => 'The request timed out.';

	/// en: 'Invalid request.'
	String get errorBadRequest => 'Invalid request.';

	/// en: 'An unexpected error occurred.'
	String get errorUnknown => 'An unexpected error occurred.';

	/// en: 'You are offline. Some features may be limited.'
	String get offlineMessage => 'You are offline. Some features may be limited.';

	/// en: 'Connection restored.'
	String get connectionRestored => 'Connection restored.';

	/// en: 'Retry'
	String get retry => 'Retry';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get homeTitle => 'Home';

	/// en: 'Welcome to Kora!'
	String get welcomeToKora => 'Welcome to Kora!';

	/// en: 'Your secure communication space is ready.'
	String get secureSpaceReady => 'Your secure communication space is ready.';

	/// en: 'Start Chatting'
	String get startChatting => 'Start Chatting';
}

// Path: landing
class TranslationsLandingEn {
	TranslationsLandingEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// The title of the application
	///
	/// en: 'Kora Chat'
	String get appTitle => 'Kora Chat';

	/// en: 'Your premium space for seamless professional communication.'
	String get landingTagline => 'Your premium space for seamless\nprofessional communication.';

	/// en: 'Create Account'
	String get createAccount => 'Create Account';

	/// en: 'I already have an account'
	String get alreadyHaveAccount => 'I already have an account';
}

// Path: profile
class TranslationsProfileEn {
	TranslationsProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Profile'
	String get profileTitle => 'My Profile';

	/// en: 'Edit Profile'
	String get editProfile => 'Edit Profile';

	/// en: 'Personal Information'
	String get personalInfo => 'Personal Information';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Email Address'
	String get email => 'Email Address';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Are you sure you want to logout?'
	String get logoutConfirm => 'Are you sure you want to logout?';

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.welcomeBack' => 'Welcome Back',
			'auth.signInToAccount' => 'Sign in to your Kora account',
			'auth.emailLabel' => 'Email Address',
			'auth.emailHint' => 'name@company.com',
			'auth.passwordLabel' => 'Password',
			'auth.passwordHint' => 'min. 12 characters',
			'auth.signIn' => 'Sign In',
			'auth.forgotPassword' => 'Forgot password?',
			'auth.emailRequired' => 'Email is required',
			'auth.invalidEmail' => 'Invalid email format',
			'auth.passwordRequired' => 'Password is required',
			'auth.passwordTooShort' => 'Password must be at least 6 characters',
			'auth.createNewAccount' => 'Create New Account',
			'auth.joinKoraToday' => 'Join Kora and start chatting',
			'auth.firstNameLabel' => 'First Name',
			'auth.firstNameHint' => 'Jane',
			'auth.lastNameLabel' => 'Last Name',
			'auth.lastNameHint' => 'Doe',
			'auth.usernameLabel' => 'Username',
			'auth.usernameHint' => 'janedoe',
			'auth.signUp' => 'Sign Up',
			'auth.backToLogin' => 'Already have an account? Sign in',
			'auth.firstNameRequired' => 'First name is required',
			'auth.lastNameRequired' => 'Last name is required',
			'auth.usernameRequired' => 'Username is required',
			'chat.onlineStatus' => 'Online',
			'chat.typeMessage' => 'Type a message...',
			'chat.failedToLoadMessages' => 'Failed to load messages',
			'chat.failedToSendMessage' => 'Failed to send message',
			'chat.noMessagesYet' => 'No messages yet',
			'chat.searchConversations' => 'Search conversations...',
			'chat.newMessage' => 'New Message',
			'chat.searchUsersPlaceholder' => 'Search by username or email...',
			'chat.searchEmptyState' => 'Search for people to start a chat',
			'chat.searchError' => 'User search failed',
			'chat.createChatError' => 'Failed to create chat',
			'chat.newGroup' => 'New Group',
			'chat.createGroup' => 'Create Group',
			'chat.groupName' => 'Group Name',
			'chat.cancel' => 'Cancel',
			'error.errorNetwork' => 'No internet connection. Please check your network.',
			'error.errorUnauthorized' => 'Session expired. Please sign in again.',
			'error.errorServer' => 'Server error. Please try again later.',
			'error.errorTimeout' => 'The request timed out.',
			'error.errorBadRequest' => 'Invalid request.',
			'error.errorUnknown' => 'An unexpected error occurred.',
			'error.offlineMessage' => 'You are offline. Some features may be limited.',
			'error.connectionRestored' => 'Connection restored.',
			'error.retry' => 'Retry',
			'home.homeTitle' => 'Home',
			'home.welcomeToKora' => 'Welcome to Kora!',
			'home.secureSpaceReady' => 'Your secure communication space is ready.',
			'home.startChatting' => 'Start Chatting',
			'landing.appTitle' => 'Kora Chat',
			'landing.landingTagline' => 'Your premium space for seamless\nprofessional communication.',
			'landing.createAccount' => 'Create Account',
			'landing.alreadyHaveAccount' => 'I already have an account',
			'profile.profileTitle' => 'My Profile',
			'profile.editProfile' => 'Edit Profile',
			'profile.personalInfo' => 'Personal Information',
			'profile.username' => 'Username',
			'profile.email' => 'Email Address',
			'profile.logout' => 'Logout',
			'profile.logoutConfirm' => 'Are you sure you want to logout?',
			'profile.saveChanges' => 'Save Changes',
			'profile.cancel' => 'Cancel',
			_ => null,
		};
	}
}
