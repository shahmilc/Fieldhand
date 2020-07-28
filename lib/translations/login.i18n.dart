import "package:i18n_extension/i18n_extension.dart";

extension Localization on String {
  static var _t = Translations("en") +
      {
        "en": "Sign In",
        "fr": "Se connecter",
        "es": "Registrarse",
        "pt": "Assinar em",
        "ru": "Войти в систему",
        "de": "Anmelden",
        "ar": "تسجيل الدخول",
        "hi": "साइन इन करें",
        "bn": "সাইন ইন করুন",
      } +
      {
        "en": "Email",
        "fr": "Email",
        "es": "Email",
        "pt": "O email",
        "ru": "Эл. адрес",
        "de": "Email",
        "ar": "البريد الإلكتروني",
        "hi": "ईमेल",
        "bn": "ইমেইল",
      } +
      {
        "en": "Enter your email",
        "fr": "Entrer votre Email",
        "es": "Introduce tu correo electrónico",
        "pt": "Digite seu e-mail",
        "ru": "Введите адрес электронной почты",
        "de": "Geben sie ihre E-Mail Adresse ein",
        "ar": "أدخل بريدك الإلكتروني",
        "hi": "अपना ईमेल दर्ज करें",
        "bn": "তুমার ইমেইল প্রবেশ করাও",
      } +
      {
        "en": "Password",
        "fr": "Mot de passe",
        "es": "Contraseña",
        "pt": "Senha",
        "ru": "пароль",
        "de": "Passwort",
        "ar": "كلمه السر",
        "hi": "कुंजिका",
        "bn": "পাসওয়ার্ড",
      } +
      {
        "en": "Enter your password",
        "fr": "Tapez votre mot de passe",
        "es": "Ingresa tu contraseña",
        "pt": "Coloque sua senha",
        "ru": "Введите ваш пароль",
        "de": "Geben Sie Ihr Passwort ein",
        "ar": "ادخل رقمك السري",
        "hi": "अपना पासवर्ड डालें",
        "bn": "আপনার পাসওয়ার্ড লিখুন",
      } +
      {
        "en": "Forgot Password?",
        "fr": "mot de passe oublié?",
        "es": "¿Se te olvidó tu contraseña?",
        "pt": "Esqueceu a senha?",
        "ru": "Забыли пароль?",
        "de": "Passwort vergessen?",
        "ar": "هل نسيت كلمة المرور؟",
        "hi": "पासवर्ड भूल गए?",
        "bn": "পাসওয়ার্ড ভুলে গেছেন?",
      } +
      {
        "en": "OR",
        "fr": "OU",
        "es": "O",
        "pt": "OU",
        "ru": "ИЛИ",
        "de": "ODER",
        "ar": "أو",
        "hi": "या",
        "bn": "অথবা",
      } +
      {
        "en": "SIGN IN WITH",
        "fr": "SE CONNECTER AVEC",
        "es": "INICIA SESIÓN CON",
        "pt": "ENTRAR COM",
        "ru": "ВОЙТИ В СИСТЕМУ С",
        "de": "ANMELDEN MIT",
        "ar": "تسجيل الدخول ب",
        "hi": "के साथ साइन इन करें",
        "bn": "দিয়ে সাইন ইন",
      } +
      {
        "en": "Don't have an account?",
        "fr": "Vous n'avez pas de compte?",
        "es": "¿No tienes una cuenta?",
        "pt": "Não possui uma conta?",
        "ru": "У вас нет аккаунта?",
        "de": "Sie haben noch keinen Account?",
        "ar": "لا تملك حساب؟",
        "hi": "खाता नहीं है?",
        "bn": "কোন অ্যাকাউন্ট নেই?",
      } +
      {
        "en": "Sign Up",
        "fr": "S'inscrire",
        "es": "Registrarse",
        "pt": "Registro",
        "ru": "регистр",
        "de": "Registrieren",
        "ar": "تسجيل",
        "hi": "रजिस्टर करें",
        "bn": "নিবন্ধন",
      } +
      {
        "en": "",
        "fr": "",
        "es": "",
        "pt": "",
        "ru": "",
        "de": "",
        "ar": "",
        "hi": "",
        "bn": "",
      } +
      {
        "en": "",
        "fr": "",
        "es": "",
        "pt": "",
        "ru": "",
        "de": "",
        "ar": "",
        "hi": "",
        "bn": "",
      };
  String get i18n => localize(this, _t);
}
