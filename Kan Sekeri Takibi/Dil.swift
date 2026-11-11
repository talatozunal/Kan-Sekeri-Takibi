import SwiftUI
import Combine

// MARK: - DİL YÖNETİMİ
//
// Uygulama içi dil seçimi. Seçim UserDefaults'ta saklanır; dil değişince tüm
// metinler ve tarih biçimleri anında güncellenir. Yeniden başlatma veya
// yeniden derleme gerekmez.
//
// Çeviriler projedeki <dil>.lproj/Localizable.strings dosyalarında durur.
// Yeni bir dil eklemek için: aynı anahtarlarla yeni bir .lproj klasörü açın,
// desteklenenDiller listesine kodunu ekleyin ve UygulamaDili'ne bir case yazın.

enum UygulamaDili: String, CaseIterable, Identifiable {
    case sistem
    case tr
    case en
    case de
    case fr
    case it

    var id: String { rawValue }

    /// Dilin kendi dilindeki adı. Çevrilmez.
    var ozAd: String {
        switch self {
        case .sistem: return ""
        case .tr: return "Türkçe"
        case .en: return "English"
        case .de: return "Deutsch"
        case .fr: return "Français"
        case .it: return "Italiano"
        }
    }
}

final class Yerellestirme: ObservableObject {
    static let dilAnahtari = "appLanguage"
    static let desteklenenDiller = ["tr", "en", "de", "fr", "it"]

    /// Eksik anahtar tespiti için görünmez işaret.
    private static let eksik = "\u{0}__eksik__"

    @Published var secim: String {
        didSet {
            UserDefaults.standard.set(secim, forKey: Self.dilAnahtari)
        }
    }

    init() {
        let kayitli = UserDefaults.standard.string(forKey: Self.dilAnahtari)
            ?? UygulamaDili.sistem.rawValue
        secim = UygulamaDili(rawValue: kayitli) != nil ? kayitli : UygulamaDili.sistem.rawValue
    }

    /// "sistem" seçiliyse cihazın bu uygulama için tercih ettiği dil,
    /// değilse kullanıcının seçtiği dil.
    var kod: String {
        let aday = secim == UygulamaDili.sistem.rawValue ? Self.sistemKodu : secim
        return Self.desteklenenDiller.contains(aday) ? aday : "tr"
    }

    static var sistemKodu: String {
        let aday = Bundle.main.preferredLocalizations.first ?? "tr"
        let kisa = String(aday.prefix(2)).lowercased()
        return desteklenenDiller.contains(kisa) ? kisa : "tr"
    }

    var locale: Locale { Locale(identifier: kod) }

    private var paket: Bundle {
        guard let yol = Bundle.main.path(forResource: kod, ofType: "lproj"),
              let paket = Bundle(path: yol) else { return .main }
        return paket
    }

    private static var turkcePaket: Bundle? {
        guard let yol = Bundle.main.path(forResource: "tr", ofType: "lproj") else { return nil }
        return Bundle(path: yol)
    }

    /// Seçili dildeki metni döndürür. Anahtar o dilde yoksa Türkçe metne,
    /// o da yoksa anahtarın kendisine düşer.
    func metin(_ anahtar: String) -> String {
        let deger = paket.localizedString(forKey: anahtar, value: Self.eksik, table: nil)
        if deger != Self.eksik { return deger }

        if kod != "tr", let tr = Self.turkcePaket {
            let trDeger = tr.localizedString(forKey: anahtar, value: Self.eksik, table: nil)
            if trDeger != Self.eksik { return trDeger }
        }

        return anahtar
    }

    /// Biçimlendirilebilir anahtarlar için (ör. "%d KAYIT").
    func metin(_ anahtar: String, _ degerler: CVarArg...) -> String {
        String(format: metin(anahtar), locale: locale, arguments: degerler)
    }
}

// MARK: - DİL SEÇİCİ

struct DilSecici: View {
    @EnvironmentObject private var dil: Yerellestirme

    private func gorunenAd(_ secenek: UygulamaDili) -> String {
        secenek == .sistem ? dil.metin("ortak.sistem") : secenek.ozAd
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(dil.metin("ortak.dil"))
                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                .tracking(1)
                .foregroundStyle(Tema.ikincil)

            Menu {
                ForEach(UygulamaDili.allCases) { secenek in
                    Button {
                        dil.secim = secenek.rawValue
                    } label: {
                        if dil.secim == secenek.rawValue {
                            Label(gorunenAd(secenek), systemImage: "checkmark")
                        } else {
                            Text(gorunenAd(secenek))
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Tema.anaRenk)
                        .frame(width: 16)

                    Text(gorunenAd(UygulamaDili(rawValue: dil.secim) ?? .sistem))
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Tema.metin)

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Tema.anaRenk)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Tema.alan)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Tema.cizgi, lineWidth: 1)
                )
            }
        }
    }
}
