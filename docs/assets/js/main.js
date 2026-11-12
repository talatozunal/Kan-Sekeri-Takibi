/* =========================================================
   Kan Şekeri Takibi — site betiği
   - İki dilli arayüz (Türkçe, İngilizce)
   - Mobil menü, dil menüsü, kaydırma efektleri, SSS akordeonu
   ========================================================= */

(function () {
  "use strict";

  var I18N = {
    tr: {
      "meta.title": "Kan Şekeri Takibi — Altı ölçüm, tek ekran",
      "meta.description": "Kahvaltı, öğle ve akşam için aç/tok kan şekeri ölçümlerini tek ekranda kaydedin. Veriler cihazda kalır; hesap yok, sunucu yok, reklam yok.",
      "a11y.skip": "İçeriğe geç",
      "nav.features": "Özellikler",
      "nav.screens": "Ekranlar",
      "nav.privacy": "Gizlilik",
      "nav.faq": "S.S.S.",
      "nav.cta": "GitHub",
      "hero.badge": "Tek ekran · Tamamen cihazda",
      "hero.title": "Altı ölçüm,",
      "hero.titleAccent": "tek ekranda.",
      "hero.lead": "Kahvaltı, öğle ve akşam için aç ve tok değerlerini girin. Uygulama günlük kaydınızı cihazda tutar, dilediğinizde hekiminizin okuyabileceği düz metin raporu oluşturur.",
      "hero.cta1": "Kaynak kodu gör",
      "hero.cta2": "Özellikleri gör",
      "hero.chip1": "Reklamsız",
      "hero.chip2": "Çevrimdışı çalışır",
      "hero.chip3": "Veriler cihazda",
      "hero.note": "iOS 16+ · iPhone ve iPad · Beş dilde",
      "float.group": "6 ölçüm",
      "float.groupSub": "3 öğün × aç / tok",
      "float.badge": "mg/dL",
      "float.badgeSub": "Uluslararası birim",
      "float.lang": "5 dil",
      "stats.1": "ölçüm alanı",
      "stats.2": "öğün",
      "stats.3": "ekran",
      "stats.4": "dil",
      "stats.5": "sunucu",
      "features.eyebrow": "Özellikler",
      "features.title": "Günlük takip için sade bir ekran",
      "features.lead": "Sekme yok, kurulum yok: açın, bugünün değerlerini yazın, kaydedin.",
      "f1.title": "Günlük Ölçüm Formu",
      "f1.text": "Tarih seçici ve kahvaltı, öğle, akşam için aç/tok alanları (mg/dL).",
      "f2.title": "“Bugün” Kısayolu",
      "f2.text": "Başka bir güne bakarken tarihi tek dokunuşla bugüne döndürün.",
      "f3.title": "Güvenli Kaydetme",
      "f3.text": "En az bir değer girilene kadar kaydet düğmesi pasif kalır; boş kayıt oluşmaz.",
      "f4.title": "Geçmiş ve Silme",
      "f4.text": "En yeni kayıt üstte, kayıt sayısı ve boş durum ipucu; sola kaydırarak silin.",
      "f5.title": "Tek Dokunuşla Rapor",
      "f5.text": "SekerTakip.txt oluşturulur ve paylaşım sayfası açılır; e-posta, mesaj veya Dosyalar'a aktarın.",
      "f6.title": "Yerel Saklama",
      "f6.text": "Tüm geçmiş JSON olarak AppStorage içinde tutulur ve uygulama açılışında geri yüklenir.",
      "screens.eyebrow": "Ekranlar",
      "screens.title": "Uygulamanın içinden",
      "screens.lead": "Ölçüm formu ve tüm bilgileri tek yerde toplayan bilgi paneli.",
      "s1": "Ana ekran",
      "s2": "Bilgi paneli",
      "how.eyebrow": "Nasıl çalışır",
      "how.title": "Üç adımda kayıt",
      "how.1t": "Değerleri girin",
      "how.1d": "Tarih bugün olarak seçilidir. Altı alanın tamamını doldurmak zorunda değilsiniz.",
      "how.2t": "Listeye kaydedin",
      "how.2d": "Kayıt geçmişin en üstünde görünür; silmek için sola kaydırın.",
      "how.3t": "Raporu paylaşın",
      "how.3d": "Paylaş düğmesi metin dosyasını oluşturur ve iOS paylaşım sayfasını açar.",
      "privacy.eyebrow": "Gizlilik",
      "privacy.title": "Kayıtlarınız yalnızca bu cihazda.",
      "privacy.lead": "Veriler UserDefaults içinde yerel olarak saklanır; uygulama hiçbir ağ isteği yapmaz.",
      "privacy.1": "Tüm kayıtlar cihazda, AppStorage (seker_takip_verileri) içinde JSON olarak tutulur.",
      "privacy.2": "Hesap, sunucu, analitik veya reklam SDK'sı yok.",
      "privacy.3": "Oluşturulan rapor geçici bir .txt dosyasıdır; yalnızca paylaşım hedefi seçtiğinizde uygulamadan ayrılır.",
      "privacy.link": "Kaynak kodunu inceleyin",
      "privacy.badge": "Ağ isteği yok",
      "faq.eyebrow": "S.S.S.",
      "faq.title": "Sık sorulan sorular",
      "faq.1q": "Uygulama ücretli mi?",
      "faq.1a": "Hayır. Uygulama herhangi bir ücret talep etmiyor, geliştirme aşamasında ve kaynak kodu GitHub'da açık.",
      "faq.2q": "Bu bir tıbbi cihaz mı?",
      "faq.2a": "Hayır. Kişisel bir kayıt aracıdır; teşhis veya tedavi etmez, tıbbi tavsiyenin yerini tutmaz. Sağlık kararlarınız için hekiminize danışın.",
      "faq.3q": "Verilerim nerede saklanıyor?",
      "faq.3a": "Yalnızca bu cihazda, UserDefaults içinde JSON olarak. Bulut yedeği veya senkronizasyon yoktur; uygulamayı silmek verileri de siler.",
      "faq.4q": "Raporu nasıl oluşturuyorum?",
      "faq.4a": "Rapor kartındaki Paylaş düğmesine dokunun. Uygulama SekerTakip.txt dosyasını oluşturur ve sistem paylaşım sayfasını açar.",
      "faq.5q": "Kaydedilmiş bir kaydı düzenleyebilir miyim?",
      "faq.5a": "Henüz hayır. Bir değer yanlışsa kaydı sola kaydırarak silip yeniden girin.",
      "faq.6q": "Dili nasıl değiştiririm?",
      "faq.6a": "Alttaki bilgi barına dokunun, Dil bölümünden bir dil seçin. Tüm arayüz yeniden başlatmadan güncellenir.",
      "dl.title": "Kaynak kodu GitHub'da",
      "dl.lead": "Xcode 16 ile derleyip iPhone veya iPad'inizde çalıştırın.",
      "dl.github": "GitHub'da görüntüle",
      "dl.docs": "Kullanım kılavuzu",
      "dl.note": "Uygulama geliştirme aşamasındadır; App Store sürümü henüz yayınlanmadı.",
      "footer.tagline": "Günlük ölçümleriniz tek ekranda, düzenli ve yanınızda.",
      "footer.by": "Talat Özünal"
    },
    en: {
      "meta.title": "Blood Sugar Tracking — Six readings, one screen",
      "meta.description": "Log fasting and post-meal blood sugar readings for breakfast, lunch and dinner on a single screen. Data stays on your device; no account, no server, no ads.",
      "a11y.skip": "Skip to content",
      "nav.features": "Features",
      "nav.screens": "Screens",
      "nav.privacy": "Privacy",
      "nav.faq": "FAQ",
      "nav.cta": "GitHub",
      "hero.badge": "Single screen · Fully on device",
      "hero.title": "Six readings,",
      "hero.titleAccent": "one screen.",
      "hero.lead": "Enter fasting and post-meal values for breakfast, lunch and dinner. The app keeps your daily log on device and builds a plain-text report your doctor can read whenever you need it.",
      "hero.cta1": "View source code",
      "hero.cta2": "See features",
      "hero.chip1": "No ads",
      "hero.chip2": "Works offline",
      "hero.chip3": "Data stays on device",
      "hero.note": "iOS 16+ · iPhone and iPad · Five languages",
      "float.group": "6 readings",
      "float.groupSub": "3 meals × fasting / post-meal",
      "float.badge": "mg/dL",
      "float.badgeSub": "International unit",
      "float.lang": "5 languages",
      "stats.1": "measurement fields",
      "stats.2": "meals",
      "stats.3": "screen",
      "stats.4": "languages",
      "stats.5": "servers",
      "features.eyebrow": "Features",
      "features.title": "A simple screen for daily tracking",
      "features.lead": "No tabs, no setup: open it, write today's values, save.",
      "f1.title": "Daily Measurement Form",
      "f1.text": "Date picker plus fasting/post-meal fields for breakfast, lunch and dinner (mg/dL).",
      "f2.title": "“Today” Shortcut",
      "f2.text": "Return the date to today with a single tap while browsing another day.",
      "f3.title": "Safe Saving",
      "f3.text": "The save button stays disabled until at least one value is entered, so no empty record is created.",
      "f4.title": "History and Delete",
      "f4.text": "Newest record first, record count and an empty-state hint; swipe left to delete.",
      "f5.title": "One-Tap Report",
      "f5.text": "Creates SekerTakip.txt and opens the share sheet; send it by mail, message or save it to Files.",
      "f6.title": "Local Storage",
      "f6.text": "The whole history is stored as JSON in AppStorage and restored when the app launches.",
      "screens.eyebrow": "Screens",
      "screens.title": "From inside the app",
      "screens.lead": "The measurement form and an info sheet that gathers everything in one place.",
      "s1": "Main screen",
      "s2": "Info sheet",
      "how.eyebrow": "How it works",
      "how.title": "Logged in three steps",
      "how.1t": "Enter the values",
      "how.1d": "The date is set to today. You do not have to fill in all six fields.",
      "how.2t": "Save to the list",
      "how.2d": "The record appears at the top of your history; swipe left to delete it.",
      "how.3t": "Share the report",
      "how.3d": "The share button creates the text file and opens the iOS share sheet.",
      "privacy.eyebrow": "Privacy",
      "privacy.title": "Your records stay on this device.",
      "privacy.lead": "Data is stored locally in UserDefaults; the app makes no network requests.",
      "privacy.1": "All records are kept on device as JSON in AppStorage (seker_takip_verileri).",
      "privacy.2": "No account, server, analytics or ad SDK.",
      "privacy.3": "The generated report is a temporary .txt file; it leaves the app only when you pick a share destination.",
      "privacy.link": "Explore the source code",
      "privacy.badge": "No network requests",
      "faq.eyebrow": "FAQ",
      "faq.title": "Frequently asked questions",
      "faq.1q": "Is the app paid?",
      "faq.1a": "No. The app is free of charge, in development, and its source code is open on GitHub.",
      "faq.2q": "Is this a medical device?",
      "faq.2a": "No. It is a personal tracking tool; it does not diagnose or treat and is not a substitute for medical advice. Consult your doctor for health decisions.",
      "faq.3q": "Where is my data stored?",
      "faq.3a": "Only on this device, as JSON in UserDefaults. There is no cloud backup or sync; deleting the app also deletes its data.",
      "faq.4q": "How do I create the report?",
      "faq.4a": "Tap the Share button on the Report card. The app creates SekerTakip.txt and opens the system share sheet.",
      "faq.5q": "Can I edit a saved record?",
      "faq.5a": "Not yet. If a value is wrong, swipe left to delete the record and enter it again.",
      "faq.6q": "How do I change the language?",
      "faq.6a": "Tap the info bar at the bottom and pick a language under Language. The whole interface updates without restarting.",
      "dl.title": "Source code on GitHub",
      "dl.lead": "Build it with Xcode 16 and run it on your iPhone or iPad.",
      "dl.github": "View on GitHub",
      "dl.docs": "User guide",
      "dl.note": "The app is in development; the App Store version has not been released yet.",
      "footer.tagline": "Your daily readings on one screen, organised and with you.",
      "footer.by": "Talat Özünal"
    }
  };

  var STORAGE_KEY = "kanSekeriTakibi.lang";
  var DEFAULT_LANG = "tr";
  var SUPPORTED = ["tr", "en"];
  var CODES = { tr: "TR", en: "EN" };

  var root = document.documentElement;
  var langBox = document.getElementById("lang");
  var langButton = document.getElementById("langButton");
  var langMenu = document.getElementById("langMenu");
  var langCode = document.getElementById("langCode");
  var burger = document.getElementById("burger");
  var nav = document.getElementById("nav");
  var header = document.getElementById("header");

  function normalize(code) {
    if (!code) return null;
    var base = String(code).toLowerCase().split("-")[0];
    return SUPPORTED.indexOf(base) >= 0 ? base : null;
  }

  function storedLang() {
    try { return normalize(localStorage.getItem(STORAGE_KEY)); } catch (e) { return null; }
  }

  function browserLang() {
    var list = navigator.languages || [navigator.language || ""];
    for (var i = 0; i < list.length; i++) {
      var found = normalize(list[i]);
      if (found) return found;
    }
    return null;
  }

  function translate(code) {
    var dict = I18N[code] || I18N[DEFAULT_LANG];
    var nodes = document.querySelectorAll("[data-i18n]");
    for (var i = 0; i < nodes.length; i++) {
      var key = nodes[i].getAttribute("data-i18n");
      if (Object.prototype.hasOwnProperty.call(dict, key)) {
        nodes[i].textContent = dict[key];
      }
    }
    document.title = dict["meta.title"] || document.title;
    var desc = document.querySelector('meta[name="description"]');
    if (desc && dict["meta.description"]) desc.setAttribute("content", dict["meta.description"]);
    root.setAttribute("lang", code);
    if (langCode) langCode.textContent = CODES[code] || code.toUpperCase();

    var items = document.querySelectorAll(".lang__item");
    for (var j = 0; j < items.length; j++) {
      var active = items[j].getAttribute("data-lang") === code;
      items[j].classList.toggle("is-active", active);
      items[j].setAttribute("aria-current", active ? "true" : "false");
    }
  }

  function setLang(code, remember) {
    var safe = SUPPORTED.indexOf(code) >= 0 ? code : DEFAULT_LANG;
    translate(safe);
    if (remember) {
      try { localStorage.setItem(STORAGE_KEY, safe); } catch (e) { /* yoksay */ }
    }
  }

  /* --- dil menüsü --- */
  function openLang(open) {
    if (!langBox || !langButton) return;
    langBox.classList.toggle("is-open", open);
    langButton.setAttribute("aria-expanded", open ? "true" : "false");
  }

  if (langButton) {
    langButton.addEventListener("click", function (event) {
      event.stopPropagation();
      openLang(!langBox.classList.contains("is-open"));
    });
  }

  if (langMenu) {
    langMenu.addEventListener("click", function (event) {
      var button = event.target.closest(".lang__item");
      if (!button) return;
      setLang(button.getAttribute("data-lang"), true);
      openLang(false);
      if (langButton) langButton.focus();
    });
  }

  document.addEventListener("click", function (event) {
    if (langBox && !langBox.contains(event.target)) openLang(false);
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      openLang(false);
      closeNav();
    }
  });

  /* --- mobil menü --- */
  function closeNav() {
    if (!nav || !burger) return;
    nav.classList.remove("is-open");
    burger.setAttribute("aria-expanded", "false");
  }

  if (burger) {
    burger.addEventListener("click", function () {
      var open = !nav.classList.contains("is-open");
      nav.classList.toggle("is-open", open);
      burger.setAttribute("aria-expanded", open ? "true" : "false");
    });
  }

  if (nav) {
    nav.addEventListener("click", function (event) {
      if (event.target.closest("a")) closeNav();
    });
  }

  /* --- kaydırma durumu --- */
  function onScroll() {
    if (!header) return;
    header.classList.toggle("is-scrolled", window.scrollY > 8);
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  /* --- görünürlük animasyonu --- */
  var revealItems = document.querySelectorAll("[data-reveal]");
  if ("IntersectionObserver" in window) {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-in");
          observer.unobserve(entry.target);
        }
      });
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.08 });

    for (var r = 0; r < revealItems.length; r++) {
      revealItems[r].classList.add("will-reveal");
      observer.observe(revealItems[r]);
    }
  } else {
    for (var s = 0; s < revealItems.length; s++) revealItems[s].classList.add("is-in");
  }

  /* --- SSS: aynı anda tek soru açık kalsın --- */
  var faqItems = document.querySelectorAll(".faq__item");
  for (var f = 0; f < faqItems.length; f++) {
    faqItems[f].addEventListener("toggle", function () {
      if (!this.open) return;
      for (var k = 0; k < faqItems.length; k++) {
        if (faqItems[k] !== this) faqItems[k].open = false;
      }
    });
  }

  /* --- başlangıç dili --- */
  var initial = storedLang() || DEFAULT_LANG;
  setLang(initial, false);
  if (!storedLang()) {
    var detected = browserLang();
    if (detected && detected !== DEFAULT_LANG) setLang(detected, false);
  }
})();
