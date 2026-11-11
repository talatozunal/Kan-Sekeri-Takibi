import SwiftUI

// MARK: - BİLGİLENDİRME BARI
// Alt kenarda duran ince bar; dokununca ayrıntılı bilgi paneli açılır.

struct BilgiBari: View {
    @Binding var acik: Bool

    var body: some View {
        Button {
            acik = true
        } label: {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Tema.anaRenk.opacity(0.12))
                        .frame(width: 30, height: 30)

                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Tema.anaRenk)
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text("Bilgi")
                        .font(.system(size: 12.5, weight: .bold, design: .rounded))
                        .foregroundStyle(Tema.metin)

                    Text("Ücretsiz uygulama • Sürüm 1.0.0")
                        .font(.system(size: 10.5, weight: .medium, design: .rounded))
                        .foregroundStyle(Tema.ikincil)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }

                Spacer(minLength: 6)

                HStack(spacing: 4) {
                    Text("Detaylar")
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                }
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Tema.anaRenk)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Tema.kart)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Tema.cizgi)
                .frame(height: 0.8)
        }
    }
}

// MARK: - BİLGİ PANELİ

struct BilgiSayfasi: View {
    @Environment(\.dismiss) private var kapat

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    baslik

                    metin("Bu uygulama herhangi bir ücret talep etmemektedir. Geliştirme aşamasındadır.")

                    surumKutusu

                    iletisimBolumu

                    Button {
                        kapat()
                    } label: {
                        Text("Kapat")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Tema.anaGecis)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(color: Tema.anaRenk.opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2)
                }
                .padding(20)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .background(Tema.zemin.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var baslik: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Tema.anaRenk.opacity(0.12))
                    .frame(width: 46, height: 46)

                Image(systemName: "info.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Tema.anaRenk)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Bilgi")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Tema.metin)

                Text("Uygulama hakkında")
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundStyle(Tema.ikincil)
            }

            Spacer(minLength: 0)
        }
    }

    private var surumKutusu: some View {
        VStack(alignment: .leading, spacing: 9) {
            satir(ikon: "number.circle.fill", metin: "Sürüm 1.0.0")
            satir(ikon: "calendar", metin: "Yıl: 2026")
            satir(ikon: "person.crop.circle.fill", metin: "Sorumlu: Talat Özünal")
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Tema.alan)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Tema.cizgi, lineWidth: 1)
        )
    }

    private var iletisimBolumu: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("İLETİŞİM")
                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                .tracking(1)
                .foregroundStyle(Tema.ikincil)

            Text("Hata ve bilgilendirmeler için iletişim:")
                .font(.system(size: 12.5, weight: .medium, design: .rounded))
                .foregroundStyle(Tema.ikincil)

            Link(destination: URL(string: "mailto:ozunaltalat@gmail.com")!) {
                Text("ozunaltalat@gmail.com")
                    .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                    .foregroundStyle(Tema.anaRenk)
            }
        }
    }

    private func metin(_ icerik: String) -> some View {
        Text(icerik)
            .font(.system(size: 13.5, weight: .medium, design: .rounded))
            .foregroundStyle(Tema.metin)
            .fixedSize(horizontal: false, vertical: true)
            .lineSpacing(2)
    }

    private func satir(ikon: String, metin: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: ikon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Tema.anaRenk)
                .frame(width: 16)

            Text(metin)
                .font(.system(size: 12.5, weight: .medium, design: .rounded))
                .foregroundStyle(Tema.metin)
        }
    }
}
