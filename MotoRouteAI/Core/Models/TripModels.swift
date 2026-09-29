import Foundation

enum TripType: String, CaseIterable, Identifiable, Hashable {
    case weekend = "Weekend"
    case scenic = "Scenic"
    case endurance = "Endurance"
    case camping = "Camping"

    var id: String { rawValue }
}

enum RidingStyle: String, CaseIterable, Identifiable, Hashable {
    case relaxed = "Relaxeddd"
    case balanced = "Balanced"
    case spirited = "Spirited"

    var id: String { rawValue }
}

enum AccommodationPreference: String, CaseIterable, Identifiable, Hashable {
    case hotel = "Hotel"
    case camping = "Camping"
    case flexible = "Flexible"

    var id: String { rawValue }
}

enum WeatherRisk: String, Hashable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
}

enum TripStopKind: String, Hashable {
    case fuel = "Fuel"
    case food = "Food"
    case lodging = "Lodging"
    case camping = "Camping"
    case viewpoint = "Viewpoint"
    case repair = "Repair"
    case rest = "Rest"
}

struct RiderProfile: Identifiable, Hashable {
    let id: UUID
    var name: String
    var ridingStyle: RidingStyle
    var accommodationPreference: AccommodationPreference
    var maxDailyDistance: Int

    init(
        id: UUID = UUID(),
        name: String = "Rider",
        ridingStyle: RidingStyle = .balanced,
        accommodationPreference: AccommodationPreference = .flexible,
        maxDailyDistance: Int = 250
    ) {
        self.id = id
        self.name = name
        self.ridingStyle = ridingStyle
        self.accommodationPreference = accommodationPreference
        self.maxDailyDistance = maxDailyDistance
    }
}

struct TripRequest: Identifiable, Hashable {
    let id: UUID
    var origin: String
    var destination: String
    var tripType: TripType
    var ridingStyle: RidingStyle
    var accommodationPreference: AccommodationPreference
    var numberOfDays: Int

    init(
        id: UUID = UUID(),
        origin: String,
        destination: String,
        tripType: TripType,
        ridingStyle: RidingStyle,
        accommodationPreference: AccommodationPreference,
        numberOfDays: Int
    ) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.tripType = tripType
        self.ridingStyle = ridingStyle
        self.accommodationPreference = accommodationPreference
        self.numberOfDays = numberOfDays
    }
}

struct RoutePlan: Identifiable, Hashable {
    let id: UUID
    var title: String
    var summary: String
    var totalDistance: Int
    var estimatedRideHours: Double
    var days: [RouteDayPlan]
    var safetyInsights: [SafetyInsight]

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        totalDistance: Int,
        estimatedRideHours: Double,
        days: [RouteDayPlan],
        safetyInsights: [SafetyInsight]
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.totalDistance = totalDistance
        self.estimatedRideHours = estimatedRideHours
        self.days = days
        self.safetyInsights = safetyInsights
    }
}

struct RouteDayPlan: Identifiable, Hashable {
    let id: UUID
    var dayNumber: Int
    var title: String
    var distance: Int
    var rideHours: Double
    var weatherRisk: WeatherRisk
    var stops: [TripStop]

    init(
        id: UUID = UUID(),
        dayNumber: Int,
        title: String,
        distance: Int,
        rideHours: Double,
        weatherRisk: WeatherRisk,
        stops: [TripStop]
    ) {
        self.id = id
        self.dayNumber = dayNumber
        self.title = title
        self.distance = distance
        self.rideHours = rideHours
        self.weatherRisk = weatherRisk
        self.stops = stops
    }
}

struct TripStop: Identifiable, Hashable {
    let id: UUID
    var name: String
    var kind: TripStopKind
    var note: String

    init(id: UUID = UUID(), name: String, kind: TripStopKind, note: String) {
        self.id = id
        self.name = name
        self.kind = kind
        self.note = note
    }
}

struct SafetyInsight: Identifiable, Hashable {
    let id: UUID
    var title: String
    var detail: String
    var risk: WeatherRisk

    init(id: UUID = UUID(), title: String, detail: String, risk: WeatherRisk) {
        self.id = id
        self.title = title
        self.detail = detail
        self.risk = risk
    }
}
