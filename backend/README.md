# DriveBook Mock Backend

Static JSON API for the DriveBook iOS app. Responses are served from GitHub's raw content CDN — no server required.

**Base URL**

```
https://raw.githubusercontent.com/thiagopac/DriveBook/main/backend/api/v1
```

---

## Data Source

Vehicle data is sourced from the [auto.dev API](https://auto.dev) (Starter plan). The `/listings` endpoint was used to search by make, model, and year, and `/photos` to retrieve gallery URLs per VIN. Responses were collected and stored as static JSON to eliminate runtime API calls and rate limit concerns.

Photo URLs point directly to auto.dev's CDN (`https://api.auto.dev/photos/retail/{VIN}-{N}.jpg`) and are served live — images are not cached in this repository.

---

## Endpoints

### Home

| Path | Description |
|------|-------------|
| `/home/featured.json` | Two featured vehicles for the home carousel |
| `/home/popular.json` | Three vehicles for the "Popular This Week" section |
| `/home/brands.json` | Eight brands for the "Browse by Brand" section |

### Browse

| Path | Description |
|------|-------------|
| `/browse/all.json` | All 12 vehicles |
| `/browse/sports.json` | Sports cars |
| `/browse/suv.json` | SUVs |
| `/browse/sedan.json` | Sedans |
| `/browse/electric.json` | Electric vehicles |
| `/browse/hybrid.json` | Plug-in and mild hybrids |

### Vehicles

| Path | Description |
|------|-------------|
| `/vehicles/{VIN}/detail.json` | Full vehicle detail including `appSpecs` |
| `/vehicles/{VIN}/photos.json` | Ordered array of photo URLs |

---

## Vehicle Index

| VIN | Make | Model | Year | Categories |
|-----|------|-------|------|------------|
| WP0AF2A91SS279431 | Porsche | 911 GT3 RS | 2025 | Sports |
| ZHWUC1ZM0SLA02427 | Lamborghini | Revuelto | 2025 | Sports, Hybrid |
| ZFF01SMA0S0313341 | Ferrari | 296 GTS | 2025 | Sports, Hybrid |
| WBS13HJ01SFT79303 | BMW | M3 Competition | 2025 | Sedan |
| SBM14ACA0SW009520 | McLaren | 750S | 2025 | Sports |
| ZPBUD6ZL0SLA37064 | Lamborghini | Urus SE | 2025 | SUV, Hybrid |
| WP1AG2AY0SDA25474 | Porsche | Cayenne GTS | 2025 | SUV |
| WA124BGF8SA006865 | Audi | Q6 e-tron | 2025 | Electric |
| WBY43HD0XSFU69399 | BMW | i4 xDrive40 | 2025 | Electric |
| 7SAXCDE53SF467194 | Tesla | Model X | 2025 | Electric |
| SBM16AEA0PW001481 | McLaren | Artura | 2023 | Sports, Hybrid |
| WBS83FK01SCT91714 | BMW | M5 | 2025 | Sedan, Hybrid |

---

## Response Shapes

### VehicleSummary

Used in all `home/*.json` and `browse/*.json` responses.

```json
{
  "vin": "WP0AF2A91SS279431",
  "vehicle": {
    "make": "Porsche",
    "model": "911",
    "year": 2025,
    "trim": "GT3 RS",
    "bodyStyle": "Car",
    "style": "Coupe",
    "type": "Coupe",
    "engine": "4.0L 6Cyl Gasoline",
    "cylinders": 6,
    "fuel": "Gasoline",
    "drivetrain": "RWD",
    "transmission": "Automated Manual",
    "seats": 2,
    "doors": 2,
    "exteriorColor": "Green",
    "interiorColor": "Tan",
    "baseMsrp": 241300,
    "baseInvoice": 217170,
    "series": "GT3 RS 2dr Coupe (4.0L 6cyl 7AM)",
    "squishVin": "WP0AF2A9SS",
    "confidence": 0.995
  },
  "retailListing": {
    "price": 759999,
    "miles": 57,
    "used": true,
    "cpo": false,
    "dealer": "EuroCar",
    "city": "Costa Mesa",
    "state": "CA",
    "zip": "92626",
    "photoCount": 51,
    "primaryImage": "https://api.auto.dev/photos/retail/WP0AF2A91SS279431-1.jpg",
    "carfaxUrl": "https://www.carfax.com/..."
  },
  "appSpecs": {
    "horsepower": 518,
    "acceleration": "3.2s",
    "topSpeed": "296 km/h",
    "fuelEconomy": "13.1 L/100km",
    "drivetrain": "RWD",
    "category": "Sports Car",
    "description": "The 911 GT3 RS is built for performance...",
    "keyFeatures": [
      "4.0L Naturally Aspirated Flat-6",
      "7-speed PDK Transmission",
      "Rear-Wheel Drive",
      "Carbon Fiber Aerodynamics Package"
    ]
  }
}
```

The `appSpecs` field is not part of the auto.dev API response. It was added to each vehicle record to supply the performance data and display copy required by the app UI.

### VehicleDetail

`vehicles/{VIN}/detail.json` wraps a full record in a `data` key and includes the `history` object.

```json
{
  "data": {
    "vin": "WP0AF2A91SS279431",
    "createdAt": "2026-04-27 22:45:57",
    "vehicle": { },
    "retailListing": { },
    "history": {
      "accidents": false,
      "accidentCount": 0,
      "oneOwner": true,
      "ownerCount": 1,
      "personalUse": true,
      "usageType": "Personal Use"
    },
    "appSpecs": { }
  }
}
```

### VehiclePhotos

```json
{
  "data": {
    "retail": [
      "https://api.auto.dev/photos/retail/WP0AF2A91SS279431-1.jpg",
      "https://api.auto.dev/photos/retail/WP0AF2A91SS279431-2.jpg"
    ],
    "wholesale": []
  }
}
```

Photo arrays are ordered — the first item is the primary image. Photo counts per vehicle range from 1 to 199 depending on listing availability at the time of collection.

### BrowseResponse

`browse/*.json` files include a `total` count alongside the item array.

```json
{
  "total": 5,
  "data": [ ]
}
```

`home/featured.json` and `home/popular.json` omit `total` and return `{ "data": [] }` directly.

### BrandList

```json
{
  "data": [
    { "id": "porsche", "name": "Porsche" },
    { "id": "bmw", "name": "BMW" }
  ]
}
```
