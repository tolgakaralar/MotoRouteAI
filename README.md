# MotoRouteAI

SwiftUI tabanlı, motosiklet rota planlama uygulaması.

## Özellikler

- **Trip Planning** — yapay zeka destekli rota önerileri (`Core/Agents/TripPlannerAgent.swift`)
- **Route Detail** — planlanan rotanın detaylı görünümü
- **Saved Trips** — kaydedilen rotaların listesi
- **Settings** — uygulama ayarları

## Proje Yapısı

```
MotoRouteAI/
├── MotoRouteAIApp.swift # Uygulama giriş noktası (@main)
├── App/                 # Root view (TabView + navigation)
├── Core/
│   ├── Agents/          # Trip planning agent
│   ├── Models/          # Paylaşılan veri modelleri
│   └── Services/        # Servis katmanı (ör. mock trip planning service)
└── Features/
    ├── TripPlanning/    # Rota planlama ekranı
    ├── RouteDetail/     # Rota detay ekranı
    ├── SavedTrips/      # Kaydedilen rotalar
    └── Settings/        # Ayarlar
```

## Gereksinimler

- Xcode 26.5+ (iOS 26.5 SDK)
- iOS 26.5+
- Swift 5.0
