import SwiftUI
import UIKit

// MARK: - 1. VERİ MODELİ
struct SekerOlcer: Identifiable, Codable {
    var id = UUID()
    var tarih: Date
    var kahvaltiAc: String
    var kahvaltiTok: String
    var oglenAc: String
    var oglenTok: String
    var aksamAc: String
    var aksamTok: String
}

// MARK: - 2. TEMA (renkler & tipografi)
enum Tema {
    static let arkaPlanUst = dinamik(0xF4F8FF, 0x0A1120)
    static let arkaPlanAlt = dinamik(0xE4EEFC, 0x111C30)

    static let zemin = dinamik(0xF8FBFF, 0x0F1728)
    static let kart = dinamik(0xFFFFFF, 0x16223A)
    static let alan = dinamik(0xF3F7FE, 0x0F1A2E)
    static let cizgi = dinamik(0xE1EAF7, 0x27354F)

    static let metin = dinamik(0x14243C, 0xF3F7FF)
    static let ikincil = dinamik(0x5E718B, 0x9CAEC7)

    static let anaRenk = dinamik(0x2F6FED, 0x6FA8FF)
    static let anaRenkAcik = dinamik(0x37C2E8, 0x8FD6FF)
    static let vurgu = dinamik(0xFF5F6D, 0xFF8A94)

    static let turuncu = dinamik(0xF29A3D, 0xFFC46B)
    static let mor = dinamik(0x7B61FF, 0xA995FF)

    static var anaGecis: LinearGradient {
        LinearGradient(colors: [anaRenk, anaRenkAcik],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }

    private static func dinamik(_ aydinlik: UInt32, _ karanlik: UInt32) -> Color {
        Color(uiColor: UIColor { trait in
            UIColor(hex: trait.userInterfaceStyle == .dark ? karanlik : aydinlik)
        })
    }
}

private extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}

// MARK: - 3. ODAK ALANLARI
private enum OdakAlani: Hashable {
    case kahvaltiAc, kahvaltiTok
    case oglenAc, oglenTok
    case aksamAc, aksamTok
}

// MARK: - 4. ANA EKRAN
struct ContentView: View {
    @EnvironmentObject private var dil: Yerellestirme
    @Environment(\.editMode) private var duzenlemeModu

    @State private var secilenTarih = Date()
    @State private var kAc = ""; @State private var kTok = ""
    @State private var oAc = ""; @State private var oTok = ""
    @State private var aAc = ""; @State private var aTok = ""
    @FocusState private var odak: OdakAlani?

    @AppStorage("seker_takip_verileri") private var saklananVeri: Data = Data()
    @State private var kayitListesi: [SekerOlcer] = []
    @State private var raporURL: URL?
    @State private var bilgiAcik = false

    var body: some View {
        NavigationStack {
            ZStack {
                arkaPlan
                cerceve
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(dil.metin("ortak.bitti")) { odak = nil }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
            }
            .onAppear(perform: yukle)
            .sheet(isPresented: $bilgiAcik) {
                BilgiSayfasi()
            }
        }
        .tint(Tema.anaRenk)
    }

    // MARK: - Görsel katmanlar

    private var cerceve: some View {
        VStack(spacing: 0) {
            ustBaslik

            List {
                olcumKarti
                paylasimKarti
                gecmisBolumu
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            BilgiBari(acik: $bilgiAcik)
        }
        .background(Tema.zemin)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Tema.cizgi, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.10), radius: 24, x: 0, y: 12)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: 620, maxHeight: .infinity)
    }

    private var arkaPlan: some View {
        ZStack {
            LinearGradient(colors: [Tema.arkaPlanUst, Tema.arkaPlanAlt],
                           startPoint: .top,
                           endPoint: .bottom)

            Circle()
                .fill(Tema.anaRenk.opacity(0.18))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -140, y: -280)

            Circle()
                .fill(Tema.vurgu.opacity(0.14))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: 160, y: -180)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private var ustBaslik: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 7) {
                ZStack {
                    Circle()
                        .fill(Tema.anaGecis)
                        .frame(width: 46, height: 46)
                        .shadow(color: Tema.anaRenk.opacity(0.35), radius: 12, x: 0, y: 7)

                    Image(systemName: "drop.fill")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Text(dil.metin("ks.baslik"))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Tema.metin)

                Text(dil.metin("ks.altbaslik"))
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundStyle(Tema.ikincil)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .padding(.bottom, 8)

            if !kayitListesi.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        duzenlemeModu?.wrappedValue = duzenlemeModu?.wrappedValue == .active ? .inactive : .active
                    }
                } label: {
                    Text(duzenlemeModu?.wrappedValue == .active
                         ? dil.metin("ortak.tamam")
                         : dil.metin("ks.duzenle"))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Tema.anaRenk)
                }
                .buttonStyle(.plain)
                .padding(.top, 14)
                .padding(.trailing, 16)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Tema.cizgi)
                .frame(height: 0.8)
        }
    }

    private var olcumKarti: some View {
        kart {
            VStack(alignment: .leading, spacing: 12) {
                BolumBasligi(ikon: "plus.circle.fill",
                             baslik: dil.metin("ks.yeniOlcum"),
                             ipucu: "mg/dL")

                tarihSatiri

                VStack(spacing: 11) {
                    OlcumSatiri(baslik: dil.metin("ks.kahvalti"),
                                ikon: "sunrise.fill",
                                renk: Tema.turuncu,
                                ac: $kAc, tok: $kTok,
                                odak: $odak,
                                acOdak: .kahvaltiAc,
                                tokOdak: .kahvaltiTok)

                    OlcumSatiri(baslik: dil.metin("ks.ogle"),
                                ikon: "sun.max.fill",
                                renk: Tema.anaRenk,
                                ac: $oAc, tok: $oTok,
                                odak: $odak,
                                acOdak: .oglenAc,
                                tokOdak: .oglenTok)

                    OlcumSatiri(baslik: dil.metin("ks.aksam"),
                                ikon: "moon.stars.fill",
                                renk: Tema.mor,
                                ac: $aAc, tok: $aTok,
                                odak: $odak,
                                acOdak: .aksamAc,
                                tokOdak: .aksamTok)
                }

                Button(action: kaydet) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text(dil.metin("ks.kaydet"))
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Tema.anaGecis)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Tema.anaRenk.opacity(0.30), radius: 10, x: 0, y: 6)
                }
                .buttonStyle(.plain)
                .disabled(girdiBosMu)
                .opacity(girdiBosMu ? 0.55 : 1)
            }
        }
    }

    private var tarihSatiri: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Tema.anaRenk)

            DatePicker(dil.metin("ks.tarih"), selection: $secilenTarih, displayedComponents: .date)
                .font(.system(size: 15, weight: .semibold, design: .rounded))

            Spacer(minLength: 0)

            if !Calendar.current.isDateInToday(secilenTarih) {
                Button {
                    secilenTarih = Date()
                } label: {
                    Text(dil.metin("ks.bugun"))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Tema.anaRenk)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Tema.anaRenk.opacity(0.10))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 2)
    }

    private var paylasimKarti: some View {
        kart {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(Tema.anaRenk.opacity(0.10))
                        .frame(width: 40, height: 40)

                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Tema.anaRenk)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(dil.metin("ks.rapor"))
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1)
                        .foregroundStyle(Tema.ikincil)

                    Text(raporURL == nil
                         ? dil.metin("ks.raporBos")
                         : dil.metin("ks.raporHazir"))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Tema.ikincil)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer(minLength: 6)

                if let raporURL {
                    ShareLink(item: raporURL,
                              preview: SharePreview("Seker_Takip_Raporu.txt",
                                                    image: Image(systemName: "doc.text.fill"))) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                            Text(dil.metin("ks.paylas"))
                        }
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(Tema.anaGecis)
                        .clipShape(Capsule())
                        .shadow(color: Tema.anaRenk.opacity(0.25), radius: 6, x: 0, y: 3)
                    }
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Tema.ikincil.opacity(0.45))
                        .frame(width: 38, height: 38)
                        .background(Tema.alan)
                        .clipShape(Circle())
                }
            }
        }
    }

    @ViewBuilder
    private var gecmisBolumu: some View {
        BolumBasligi(ikon: "clock.arrow.circlepath",
                     baslik: dil.metin("ks.gecmis"),
                     ipucu: dil.metin("ks.kayitSayisi", kayitListesi.count))
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 2)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

        if kayitListesi.isEmpty {
            bosDurum
        } else {
            ForEach(kayitListesi) { kayit in
                kart {
                    KayitKarti(kayit: kayit)
                }
            }
            .onDelete(perform: sil)

            Text(dil.metin("ks.silmeIpucu"))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Tema.ikincil.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
                .padding(.bottom, 12)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
    }

    private var bosDurum: some View {
        VStack(spacing: 6) {
            Image(systemName: "tray")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(Tema.ikincil.opacity(0.55))

            Text(dil.metin("ks.bosBaslik"))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Tema.metin)

            Text(dil.metin("ks.bosAlt"))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Tema.ikincil)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [7, 7]))
                .foregroundStyle(Tema.cizgi)
        )
        .frame(maxWidth: 620)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    // MARK: - Kart iskeleti

    private func kart<Content: View>(@ViewBuilder icerik: () -> Content) -> some View {
        icerik()
            .padding(16)
            .background(Tema.kart)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Tema.cizgi, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 18)
            .padding(.vertical, 7)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }

    // MARK: - 5. FONKSİYONLAR

    private var girdiBosMu: Bool {
        [kAc, kTok, oAc, oTok, aAc, aTok]
            .allSatisfy { $0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    private func kaydet() {
        let yeni = SekerOlcer(tarih: secilenTarih,
                              kahvaltiAc: kAc, kahvaltiTok: kTok,
                              oglenAc: oAc, oglenTok: oTok,
                              aksamAc: aAc, aksamTok: aTok)

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            kayitListesi.insert(yeni, at: 0)
        }

        sakla()
        raporuGuncelle()

        kAc = ""; kTok = ""
        oAc = ""; oTok = ""
        aAc = ""; aTok = ""
        odak = nil
    }

    private func sakla() {
        if let encoded = try? JSONEncoder().encode(kayitListesi) {
            saklananVeri = encoded
        }
    }

    private func yukle() {
        if let decoded = try? JSONDecoder().decode([SekerOlcer].self, from: saklananVeri) {
            kayitListesi = decoded
        }
        raporuGuncelle()
    }

    private func sil(at offsets: IndexSet) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            kayitListesi.remove(atOffsets: offsets)
        }
        sakla()
        raporuGuncelle()
    }

    private func raporuGuncelle() {
        raporURL = raporDosyasiOlustur()
    }

    private func raporDosyasiOlustur() -> URL? {
        guard !kayitListesi.isEmpty else { return nil }

        var raporMetni = "--- \(dil.metin("ks.raporBaslik")) ---\n\n"
        for k in kayitListesi {
            raporMetni += "\(dil.metin("ks.raporTarih")): \(TarihYardimci.uzun(dil.locale).string(from: k.tarih))\n"
            raporMetni += "\(dil.metin("ks.kahvalti")): \(k.kahvaltiAc)/\(k.kahvaltiTok) | \(dil.metin("ks.ogle")): \(k.oglenAc)/\(k.oglenTok) | \(dil.metin("ks.aksam")): \(k.aksamAc)/\(k.aksamTok)\n"
            raporMetni += "--------------------------------\n"
        }

        let dosyaURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("SekerTakip.txt")

        do {
            try raporMetni.write(to: dosyaURL, atomically: true, encoding: .utf8)
            return dosyaURL
        } catch {
            return nil
        }
    }
}

// MARK: - 6. YARDIMCI GÖRÜNÜMLER

private struct BolumBasligi: View {
    let ikon: String
    let baslik: String
    var ipucu: String? = nil

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: ikon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Tema.anaRenk)

            Text(baslik)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(1.1)
                .foregroundStyle(Tema.ikincil)

            Spacer(minLength: 8)

            if let ipucu {
                Text(ipucu)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Tema.anaRenk)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Tema.anaRenk.opacity(0.10))
                    .clipShape(Capsule())
            }
        }
    }
}

private struct OlcumSatiri: View {
    @EnvironmentObject private var dil: Yerellestirme

    let baslik: String
    let ikon: String
    let renk: Color

    @Binding var ac: String
    @Binding var tok: String
    var odak: FocusState<OdakAlani?>.Binding
    let acOdak: OdakAlani
    let tokOdak: OdakAlani

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            VStack(spacing: 4) {
                Image(systemName: ikon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(renk)

                Text(baslik)
                    .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                    .foregroundStyle(Tema.ikincil)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 54)

            DegerAlani(etiket: dil.metin("ks.ac"), metin: $ac, odak: odak, alan: acOdak)
            DegerAlani(etiket: dil.metin("ks.tok"), metin: $tok, odak: odak, alan: tokOdak)
        }
    }
}

private struct DegerAlani: View {
    let etiket: String
    @Binding var metin: String
    var odak: FocusState<OdakAlani?>.Binding
    let alan: OdakAlani

    var body: some View {
        VStack(spacing: 5) {
            Text(etiket)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(Tema.ikincil)

            TextField("0", text: $metin)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .semibold, design: .rounded).monospacedDigit())
                .foregroundStyle(Tema.metin)
                .focused(odak, equals: alan)
                .padding(.vertical, 7)
                .padding(.horizontal, 6)
                .background(Tema.alan)
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(Tema.cizgi, lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

private struct KayitKarti: View {
    @EnvironmentObject private var dil: Yerellestirme

    let kayit: SekerOlcer

    var body: some View {
        HStack(spacing: 14) {
            tarihRozeti

            VStack(alignment: .leading, spacing: 10) {
                Text(TarihYardimci.uzun(dil.locale).string(from: kayit.tarih))
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Tema.metin)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 8) {
                    rozet(baslik: "K", ac: kayit.kahvaltiAc, tok: kayit.kahvaltiTok)
                    rozet(baslik: "Ö", ac: kayit.oglenAc, tok: kayit.oglenTok)
                    rozet(baslik: "A", ac: kayit.aksamAc, tok: kayit.aksamTok)
                }
            }
        }
    }

    private var tarihRozeti: some View {
        VStack(spacing: 1) {
            Text(TarihYardimci.gun(dil.locale).string(from: kayit.tarih))
                .font(.system(size: 20, weight: .bold, design: .rounded))

            Text(TarihYardimci.ay(dil.locale).string(from: kayit.tarih).uppercased(with: dil.locale))
                .font(.system(size: 10, weight: .bold, design: .rounded))
        }
        .foregroundStyle(.white)
        .frame(width: 52, height: 52)
        .background(Tema.anaGecis)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Tema.anaRenk.opacity(0.25), radius: 8, x: 0, y: 4)
    }

    private func rozet(baslik: String, ac: String, tok: String) -> some View {
        VStack(spacing: 3) {
            Text(baslik)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundStyle(Tema.ikincil)

            Text("\(deger(ac)) / \(deger(tok))")
                .font(.system(size: 13, weight: .semibold, design: .rounded).monospacedDigit())
                .foregroundStyle(Tema.metin)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .padding(.horizontal, 4)
        .background(Tema.alan)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func deger(_ metin: String) -> String {
        let temiz = metin.trimmingCharacters(in: .whitespaces)
        return temiz.isEmpty ? "–" : temiz
    }
}

// MARK: - 7. TARİH YARDIMCISI

private enum TarihYardimci {
    private static var onbellek: [String: DateFormatter] = [:]

    private static func bicimlendirici(_ desen: String, _ locale: Locale) -> DateFormatter {
        let anahtar = "\(desen)-\(locale.identifier)"
        if let hazir = onbellek[anahtar] { return hazir }

        let f = DateFormatter()
        f.locale = locale
        f.setLocalizedDateFormatFromTemplate(desen)
        onbellek[anahtar] = f
        return f
    }

    static func uzun(_ locale: Locale) -> DateFormatter {
        bicimlendirici("dMMMMyyyyEEEE", locale)
    }

    static func gun(_ locale: Locale) -> DateFormatter {
        bicimlendirici("d", locale)
    }

    static func ay(_ locale: Locale) -> DateFormatter {
        bicimlendirici("MMM", locale)
    }
}

// MARK: - 8. ÖNİZLEME

#Preview {
    ContentView()
        .environmentObject(Yerellestirme())
}
