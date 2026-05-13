# سهم — دراسة السوق الأردني وتحليل الأعمال
# Sahm — Jordan Market Study & Business Analysis

> **Date:** May 2026
> **App:** سهم (Sahm) — Ride-Sharing, Carpooling & Restaurant Order Delivery Platform
> **Market:** Jordan 🇯🇴
> **Currency:** JOD (Jordanian Dinar)

> **⚠️ CORE ARCHITECTURE PRINCIPLE — READ FIRST:**
>
> **سهم is a two-sided marketplace connecting drivers with empty seats to passengers going the same way — plus restaurant order delivery along the same routes.**
>
> - ✅ Drivers create one-time trips between cities with available seats
> - ✅ Passengers search, find, and book seats on trips
> - ✅ Recurring commute lines (خطوط) with daily/weekly/monthly subscriptions
> - ✅ Restaurant order delivery (طلبات) — drivers deliver restaurant orders along their existing routes
> - ✅ Trip requests — passengers post demand, drivers respond
> - ✅ Driver credits system — drivers buy credit bundles to list trips
> - ✅ Wallet + recharge cards for passengers
> - ✅ Dual-confirmation attendance for recurring trips
> - ✅ In-app chat and ratings
>
> **Revenue model:** Platform takes a service fee (%) on recurring trip subscriptions + drivers purchase credit bundles to operate. Passengers pay per-seat prices set by drivers.

---

## Table of Contents

1. [Market Overview](#1-market-overview)
2. [Target Audience](#2-target-audience)
3. [Competitive Landscape](#3-competitive-landscape)
4. [Pain Points & Market Gap](#4-pain-points--market-gap)
5. [Business Model](#5-business-model)
6. [Money Flow](#6-money-flow)
7. [Cultural & UX Considerations](#7-cultural--ux-considerations)
8. [Feature Audit & Recommendations](#8-feature-audit--recommendations)
9. [UI/UX Enhancement Plan](#9-uiux-enhancement-plan)
10. [Trip Matching Algorithm — The Core Engine](#10-trip-matching-algorithm)
11. [Unhappy Path Scenarios & Recovery](#11-unhappy-path-scenarios--recovery)
12. [Trip Lifecycle & State Machine](#12-trip-lifecycle--state-machine)
13. [Go-to-Market Strategy](#13-go-to-market-strategy)
14. [Legal & Regulatory](#14-legal--regulatory)
15. [KPIs & Success Metrics](#15-kpis--success-metrics)
16. [Roadmap Priority Matrix](#16-roadmap-priority-matrix)

---

## 1. Market Overview

### 1.1 Jordan Demographics

| Metric | Value |
|--------|-------|
| Population | ~11.59 million |
| Median age | 24.9 years |
| Under 25 | 42.4% |
| Urbanization | 92.3% |
| Smartphone penetration | ~92% |
| Internet users | 10.7M (92.5%) |
| Average salary | ~551 JOD/month |
| Minimum wage | 260 JOD/month |
| Unemployment | 16.1% |
| Car ownership | ~1.8M registered vehicles |
| Daily inter-city commuters | ~800,000+ |
| Avg monthly transport spending | ~40-80 JOD/month |
| % of commuters using shared transport | ~35% |

### 1.2 Population Concentration

75% of Jordan's population lives in just 3 governorates — these are the prime ride-sharing corridors:

| City | Population | % of Total | Commuter Demand |
|------|-----------|-----------|-----------------|
| **Amman** | ~4,000,000 | 42% | 🔴 Very High (hub city) |
| **Irbid** | ~1,770,000 | 18.5% | 🟠 High |
| **Zarqa** | ~1,360,000 | 14.3% | 🟠 High (Amman commuter belt) |
| Salt (Balqa) | ~500,000 | 5% | 🟡 Medium |
| Mafraq | ~600,000 | 5% | 🟡 Medium |
| Karak | ~316,000 | 3% | 🟢 Low |
| Aqaba | ~200,000 | 2% | 🟡 Seasonal |
| Madaba | ~200,000 | 2% | 🟡 Medium (Amman commuter) |

### 1.3 Inter-City Transport Market in Jordan

| Metric | Value |
|--------|-------|
| Daily inter-city trips | ~1.2M |
| Public transport share | ~14% (buses, minibuses) |
| Private car (solo driver) | ~60% |
| Shared rides (informal) | ~20% |
| Ride-hailing (Careem, Uber) | ~6% |
| Avg inter-city fare (bus) | 0.75-2.50 JOD |
| Avg inter-city fare (shared ride) | 1.50-5.00 JOD |
| Avg intra-city commute cost | 1.00-3.00 JOD/day |
| Peak commute hours | 6:30-8:30 AM, 2:00-5:00 PM |
| University commute surge | Sep-Jun, 7:00-8:00 AM |

### 1.4 Current Transport Landscape Problems

| Problem | Impact |
|---------|--------|
| **Expensive daily commute** | Workers spend 10-15% of salary on transport |
| **Empty seats everywhere** | Average car occupancy is 1.2 — 3-4 empty seats per car |
| **Unreliable public buses** | No fixed schedules, overcrowded, limited routes |
| **No formal carpooling** | Informal ride-sharing via WhatsApp/word of mouth only |
| **Fuel prices rising** | Drivers looking for cost-sharing solutions |
| **Traffic congestion** | Amman choked at peak — fewer cars = faster commute |
| **University students stranded** | No affordable transport to campus from distant towns |
| **Women safety concerns** | No female-only transport option exists |
| **Restaurant delivery gaps** | No affordable way for restaurants to deliver orders to nearby cities |

**Key Insight:** Jordan has ~800,000+ daily inter-city commuters, millions of empty car seats, and no organized platform to connect them. The informal "ask around on Facebook/WhatsApp" model is inefficient, unsafe, and unscalable. سهم fills this gap with a structured, safe, and affordable ride-sharing marketplace — plus restaurant order delivery as a bonus revenue stream for drivers.

---

## 2. Target Audience

### 2.1 Primary Stakeholders (Two-Sided Marketplace)

```
┌──────────────┐                        ┌──────────────┐
│   Drivers    │────────  سهم  ─────────│  Passengers  │
│   (Supply)   │       (Platform)       │   (Demand)   │
└──────────────┘                        └──────────────┘
                    │           │
             ┌──────┘           └──────┐
             │                         │
      ┌──────────────┐          ┌──────────────┐
      │  Recurring    │          │  Restaurant  │
      │  Commuters    │          │   Orders     │
      │  (خطوط)      │          │  (طلبات)     │
      └──────────────┘          └──────────────┘

Money flow:
  Passenger  → سهم Wallet     (top-up via recharge cards)
  Passenger  → Driver         (per-seat price for trip)
  Passenger  → Driver + سهم   (subscription with service fee for خطوط)
  Driver     → سهم            (credit bundles to list trips)
  Restaurant → Driver         (order delivery fee)
```

### 2.2 Driver Segments

#### Driver A: Daily Commuters with Empty Seats
- **Age:** 25-45
- **Vehicle:** Personal car (sedan/SUV)
- **Route:** Fixed daily commute (e.g., Zarqa → Amman)
- **Motivation:** Offset fuel costs, earn extra income
- **Empty seats:** 3-4 per trip
- **Avg extra income target:** 50-150 JOD/month
- **Why they'll love سهم:** Turn dead commute costs into income, structured platform vs WhatsApp chaos

#### Driver B: Part-Time Ride Providers
- **Age:** 22-40
- **Vehicle:** Personal car
- **Hours:** Weekends, holidays, university trips
- **Motivation:** Side income, flexible schedule
- **Target income:** 100-300 JOD/month
- **Why they'll love سهم:** Create trips on demand, set their own prices

#### Driver C: Recurring Line Operators (خطوط)
- **Age:** 28-50
- **Vehicle:** Car or minivan
- **Schedule:** Fixed daily route (e.g., Irbid → Amman, Mon-Fri, 7:00 AM)
- **Motivation:** Reliable monthly income from subscribers
- **Target income:** 300-600 JOD/month from subscriptions
- **Why they'll love سهم:** Guaranteed subscribers, automatic scheduling, attendance tracking

### 2.3 Passenger Segments

#### Passenger 1: "أحمد" — Daily Worker Commuter
- 28 years old, works in Abdali (Amman), lives in Zarqa
- Commutes daily, currently pays 2-3 JOD/day on shared taxis
- Monthly transport: ~60 JOD
- Pain: Unreliable pickup times, crowded public transport, no guaranteed seat
- **Loves:** Recurring line subscriptions, guaranteed daily seat, known driver

#### Passenger 2: "سارة" — University Student
- 21 years old, studies at University of Jordan, lives in Salt
- Commutes 5x/week, budget-conscious
- Monthly transport: ~45 JOD (can barely afford)
- Pain: No direct bus route, expensive taxis, safety concerns
- **Loves:** Female-only rides option, affordable weekly subscriptions, known route

#### Passenger 3: "أبو خالد" — Weekend Traveler
- 42 years old, visits family in Irbid from Amman on weekends
- Travels 2-4x/month, currently drives alone (expensive fuel)
- Monthly transport: ~30 JOD fuel
- **Loves:** One-time trip booking, price comparison, rated drivers

#### Stakeholder 4: "أبو أحمد" — Restaurant Owner
- 45 years old, owns a popular shawarma restaurant in Zarqa
- Gets 15-30 delivery orders/day from customers in nearby cities
- Current cost: no inter-city delivery option, loses those customers
- **Loves:** Drivers already traveling to Amman deliver his orders cheaply along the way

---

## 3. Competitive Landscape

### 3.1 Direct & Indirect Competitors

| App | Type | Pricing | Coverage | Strengths | Weaknesses |
|-----|------|---------|----------|-----------|------------|
| **Careem** | Ride-hailing | Per-ride metered | Amman mainly | Brand, trust, convenience | Expensive (not shared), no inter-city focus |
| **Uber** | Ride-hailing | Per-ride metered | Amman limited | Global brand | Limited Jordan coverage, expensive |
| **JETT Bus** | Public bus | Fixed fare | Major cities | Cheap, reliable on major routes | Limited schedule, no door flexibility |
| **WhatsApp Groups** | Informal carpool | Negotiated | Everywhere | Free, existing network | No trust, no tracking, no safety, chaotic |
| **Facebook Groups** | Informal carpool | Negotiated | Everywhere | Large audience | No verification, scams, no structure |
| **سهم (us)** | **Ride-sharing + restaurant orders** | **Driver-set per seat + subscriptions** | **All Jordan** | **Structured carpooling, subscriptions, خطوط, restaurant delivery, credits, verified drivers** | **New, building network** |

### 3.2 Our Competitive Advantages

1. **Structured Carpooling** — Replace chaotic WhatsApp/Facebook with a real platform: search, book, track, rate
2. **Recurring Lines (خطوط)** — Daily commute subscriptions with attendance tracking — no competitor has this
3. **Restaurant Order Delivery on Routes** — Drivers earn extra by delivering restaurant orders along their route — zero incremental cost
4. **Driver Credits System** — Fair monetization — drivers pay per-ride listing fee, not commission on earnings
5. **Female-Only Rides** — Safety feature critical for Jordan market — mothers/students need this
6. **Inter-City Focus** — Careem/Uber focus on intra-city; we own the inter-city corridor
7. **Arabic-First** — Built for Jordan, not adapted from a global product
8. **Flexible Pricing** — Drivers set prices, market finds equilibrium, passengers compare

### 3.3 Competitive Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|-----------|
| Careem launches carpooling feature | Medium | High | First-mover on خطوط subscriptions, deep inter-city focus |
| WhatsApp groups remain dominant | High | Medium | Better UX, trust, safety features, restaurant delivery bonus |
| New entrant copies model | Medium | Medium | Network effects, driver loyalty, subscription lock-in |
| Government regulates ride-sharing | Medium | High | Proactive engagement with LTRC, operate transparently |
| Fuel prices drop, less sharing incentive | Low | Medium | Convenience + time savings still compelling |

---

## 4. Pain Points & Market Gap

### 4.1 Driver Pain Points (ranked)

| # | Pain Point | Severity | How سهم Solves |
|---|-----------|----------|----------------|
| 1 | **Fuel costs eating into salary** | 🔴 Critical | Share ride costs — 3 passengers × 2 JOD = 6 JOD/trip income |
| 2 | **Empty seats = wasted money** | 🔴 Critical | Monetize every empty seat on every trip |
| 3 | **Finding riders is chaotic** | 🟠 High | Structured platform replaces WhatsApp groups |
| 4 | **No trust with strangers** | 🟠 High | Verified profiles, ratings, chat, trip tracking |
| 5 | **No recurring income from commute** | 🟠 High | خطوط subscriptions = guaranteed monthly income |
| 6 | **Restaurant delivery = extra income potential** | 🟡 Medium | Deliver restaurant orders on same route for additional fees |

### 4.2 Passenger Pain Points

| # | Pain Point | Severity | How سهم Solves |
|---|-----------|----------|----------------|
| 1 | **Expensive daily commute** | 🔴 Critical | Shared rides at 30-50% cheaper than taxi |
| 2 | **Unreliable public transport** | 🔴 Critical | Scheduled trips with tracked drivers |
| 3 | **No guaranteed daily seat** | 🟠 High | خطوط subscriptions guarantee your seat |
| 4 | **Safety concerns (especially women)** | 🟠 High | Verified drivers, ratings, female-only option, trip tracking |
| 5 | **No direct routes between smaller cities** | 🟡 Medium | Drivers create custom routes with waypoints |
| 6 | **Can't find rides for off-peak times** | 🟡 Medium | Trip requests — post demand, drivers respond |

### 4.3 Restaurant Pain Points

| # | Pain Point | Severity | How سهم Solves |
|---|-----------|----------|----------------|
| 1 | **No inter-city delivery option** | 🔴 Critical | Drivers already traveling deliver orders along the way |
| 2 | **Delivery platforms take 30%+ commission** | 🔴 Critical | Fixed delivery fee, no commission on food price |
| 3 | **Slow delivery to nearby cities** | 🟠 High | Same-day delivery via drivers on the route |
| 4 | **Limited delivery radius** | 🟡 Medium | Reach customers in other cities via ride-sharing network |

---

## 5. Business Model

### 5.1 Revenue Stream #1: Driver Credit Bundles

Drivers purchase credit bundles to list trips. Each trip listing costs 1 credit. This is سهم's primary revenue for one-time trips.

| Bundle | Price (JOD) | Credits | Per-Trip Cost | Bonus |
|--------|-------------|---------|---------------|-------|
| Starter | 5 | 20 | 0.25 JOD | — |
| Standard | 10 | 40 | 0.25 JOD | — |
| Pro | 25 | 110 | 0.23 JOD | +10 free rides |
| Premium | 50 | 230 | 0.22 JOD | +30 free rides |

A listing fee of ~0.25 JOD per trip is negligible compared to what a driver earns (3-10 JOD per trip from passengers). This ensures:
- Serious listings only (no spam)
- Predictable revenue for سهم
- No commission on driver earnings — drivers keep 100% of passenger payments

### 5.2 Revenue Stream #2: Subscription Service Fees (خطوط)

For recurring commute lines, سهم charges a **service fee percentage** on subscription payments.

| Subscription Type | How It Works | Service Fee |
|-------------------|-------------|-------------|
| Monthly | Passenger pays monthly price to driver via platform | 10% default (configurable per line) |
| Weekly | Passenger pays weekly price | 10% |
| Daily | Passenger pays daily price | 10% |

**Example:**
- Driver sets monthly subscription at 60 JOD for Zarqa → Amman daily line
- Passenger pays 60 JOD + 6 JOD service fee = 66 JOD total
- Driver receives 60 JOD, سهم receives 6 JOD

### 5.3 Revenue Stream #3: Restaurant Order Delivery Fees

Order delivery prices are calculated based on route distance, order size, and urgency. سهم facilitates the transaction between restaurants and drivers.

| Route Example | Small | Medium | Large | Urgent Multiplier |
|---------------|-------|--------|-------|-------------------|
| Amman ↔ Zarqa | 2.0 JOD | 3.0 JOD | 4.0 JOD | ×2.5 |
| Amman ↔ Irbid | 3.5 JOD | 5.25 JOD | 7.0 JOD | ×2.5 |
| Amman ↔ Aqaba | 5.5 JOD | 8.25 JOD | 11.0 JOD | ×2.5 |
| Same city | 1.5 JOD | 2.25 JOD | 3.0 JOD | ×2.5 |

### 5.4 Revenue Stream #4: Wallet Recharge Cards

Passengers top up their wallet via recharge cards (sold through retail points or online). سهم earns margin on card distribution.

### 5.5 Unit Economics

**Per active driver (recurring line, 4 subscribers at 60 JOD/month):**
- Subscription revenue to سهم: 4 × 6 JOD = 24 JOD/month service fee
- Credit purchases: ~5-10 JOD/month for additional one-time trips
- Total سهم revenue per active line driver: ~30-35 JOD/month

**At 2,000 active recurring lines:**
- Service fee revenue: ~48,000 JOD/month
- Credit bundle revenue: ~20,000 JOD/month
- Shipment revenue: ~10,000 JOD/month
- **Total: ~78,000 JOD/month**

---

## 6. Money Flow

### 6.1 Flow #1: One-Time Trip Booking

```
Step 1: Driver buys credit bundle (e.g., 10 JOD = 40 credits)
        → سهم receives 10 JOD

Step 2: Driver creates trip (Zarqa → Amman, 2 JOD/seat, 4 seats)
        → 1 credit deducted from driver balance

Step 3: Passenger finds trip, taps "Book"
        → Passenger's wallet charged 2 JOD
        → Driver receives booking notification

Step 4: Driver confirms or auto-accepts booking
        → Seat count decremented

Step 5: Trip completed
        → Driver receives payment
        → Both parties can rate each other
```

### 6.2 Flow #2: Recurring Line Subscription (خطوط)

```
Step 1: Driver creates recurring line:
        "Zarqa → Amman, Mon-Fri, 7:00 AM"
        Monthly: 60 JOD, Weekly: 18 JOD, Daily: 4 JOD
        Service fee: 10%

Step 2: Passenger subscribes (monthly):
        Pays 60 JOD + 6 JOD service fee = 66 JOD
        → Driver gets 60 JOD
        → سهم gets 6 JOD

Step 3: Each day, trip instance auto-generated
        Driver starts trip → marks attendance for each rider
        Rider confirms attendance (dual confirmation)

Step 4: At subscription end:
        Auto-renewal or manual renewal
        Passenger can pause/cancel
```

### 6.3 Flow #3: Restaurant Order Delivery (طلبات)

```
Step 1: Restaurant creates delivery request:
        From: Zarqa, To: Amman, Size: medium
        Suggested price: 3.00 JOD
        Receiver (customer) name + phone

Step 2: System auto-matches with drivers on same route
        Matched drivers get notification: "طلب على طريقك!"

Step 3: Driver accepts the order
        Can accept during existing trip or create a trip for it

Step 4: Driver picks up order from restaurant → marks "picked_up"
        Restaurant notified

Step 5: Driver delivers to customer → marks "delivered"
        Restaurant notified: "تم توصيل طلبك بنجاح"
```

### 6.4 Flow #4: Trip Requests (Demand-Side)

```
Step 1: Passenger can't find a trip for their route/time
        Creates trip request: "Need ride Salt → Amman, Sunday 8 AM"

Step 2: Nearby drivers see demand on their feed
        "3 people need rides near your route!"

Step 3: Driver creates a trip matching the demand
        Accepts the request → passenger auto-booked

Step 4: Trip proceeds as normal one-time trip
```

---

## 7. Cultural & UX Considerations

### 7.1 Religious & Cultural Sensitivities

| Consideration | Implementation |
|---------------|----------------|
| **Friday prayers** | Auto-adjust departure times around Friday 12:30-1:30 PM |
| **Ramadan** | Adjusted commute patterns — earlier departures, iftar-time surge |
| **Gender separation** | Female-only rides option — critical for women's adoption |
| **Family travel** | Multi-seat booking (up to 4 seats per booking) |
| **Trust with strangers** | Driver verification (ID + license + car photo), ratings, chat before trip |

### 7.2 Address & Location Challenges

Jordan has no formal addressing system. Most locations are landmark-based:
- "Behind the gas station next to the mosque"
- "University gate #3"
- "Opposite the mall"

**Solution: flexible location system**
1. Map pin drop (required) — precise GPS coordinates
2. City name (required) — from/to cities
3. Pooling point option — driver sets a meeting point with name
4. Door-to-door option — driver picks up from passenger's location
5. Waypoints — intermediate stops along the route

### 7.3 Language & Localization

- **Arabic first (RTL)** — primary language
- **English support** — for expats, tourists
- **City name normalization** — "عمان" = "عمّان" = "Amman" all match in search
- **Arabic-Indic numerals** option (٠١٢٣) toggle

### 7.4 Trust Signals

Jordanians need strong trust signals before riding with a stranger:
- Verified driver badge (ID + license + car photo checked)
- Real profile photos
- Rating with number of completed trips
- Car details: make, model, plate number, photo
- Trip rules visible: smoking, pets, luggage, female-only
- Dual confirmation attendance (driver + rider both confirm)
- In-app chat before trip
- Real-time trip tracking for shared trips

---

## 8. Feature Audit & Recommendations

### 8.1 Core Features (Built)

| Feature | Priority | Status | Notes |
|---------|----------|--------|-------|
| Phone OTP Auth (Firebase) | P0 | ✅ Built | Firebase + backend OTP |
| Role selection (Passenger/Driver) | P0 | ✅ Built | During onboarding |
| Driver document verification | P0 | ✅ Built | National ID, license, car image upload |
| Trip creation (one-time) | P0 | ✅ Built | From/to, seats, price, time, rules |
| Trip search (city, date) | P0 | ✅ Built | Filter by route and date |
| Seat booking | P0 | ✅ Built | Book 1-4 seats per trip |
| Booking management | P0 | ✅ Built | Confirm, reject, cancel |
| **Recurring trips (خطوط)** | P0 | ✅ Built | Daily lines with subscriptions |
| **Subscriptions (daily/weekly/monthly)** | P0 | ✅ Built | With service fee model |
| **Attendance tracking** | P0 | ✅ Built | Dual confirmation (driver + rider) |
| **Driver credits** | P0 | ✅ Built | Credit bundles for trip listing |
| **Restaurant order delivery (طلبات)** | P0 | ✅ Built | Auto-matching with trip routes |
| **Trip requests (demand)** | P0 | ✅ Built | Passenger posts need, driver responds |
| Wallet + recharge cards | P0 | ✅ Built | Top-up system |
| Push notifications (FCM) | P0 | ✅ Built | All status changes |
| In-app chat | P0 | ✅ Built | Conversations between users |
| Ratings | P0 | ✅ Built | Mutual driver ↔ passenger |
| Profile management | P0 | ✅ Built | Avatar, name, edit |
| Admin dashboard | P0 | ✅ Built | Stats, user management, document approval |
| Home with role toggle | P0 | ✅ Built | Switch between driver/passenger views |
| Saved commute routes | P1 | ✅ Built | Quick repeat booking |

### 8.2 Future Features (Not Yet Built)

| Feature | Priority | Notes |
|---------|----------|-------|
| Live trip tracking (map) | P1 | Real-time driver location during trip |
| Scheduled notifications before trip | P1 | "Your trip departs in 30 min" |
| Price negotiation | P2 | Passenger can suggest lower price |
| Group trip creation | P2 | Multiple passengers coordinate together |
| Loyalty program | P2 | Frequent rider rewards |
| Driver analytics dashboard | P2 | Earnings, ratings trends, popular routes |
| Voice search in Arabic | P3 | For low-literacy users |
| Integration with Google Maps | P3 | Turn-by-turn navigation for drivers |

### 8.3 Feature Detail: Recurring Lines (خطوط) — The Killer Feature

This is سهم's most differentiating feature. No competitor in Jordan offers structured daily commute subscriptions.

**How it works:**

```
1. Driver Creates a Line
   ├── Route: Zarqa → Amman
   ├── Schedule: Sun-Thu, 7:00 AM departure
   ├── Return time (optional): 4:00 PM
   ├── Total seats: 4
   ├── Pricing:
   │     Monthly: 60 JOD
   │     Weekly:  18 JOD
   │     Daily:    4 JOD
   ├── Service fee: 10%
   ├── Meeting point: "Near Zarqa bus station" (pin + name)
   ├── OR door-to-door pickup
   ├── Female only: Yes/No
   └── Notes: "Non-smoking, AC available"

2. Passengers Subscribe
   ├── Browse available lines for their route
   ├── See driver rating, car details, schedule
   ├── Choose: monthly / weekly / daily
   ├── Pay subscription + service fee
   └── Guaranteed seat every day

3. Daily Operation
   ├── Trip instance auto-created each scheduled day
   ├── Driver taps "Start Trip"
   ├── Driver marks attendance for each subscriber
   ├── Subscriber confirms attendance (dual confirmation)
   ├── Trip completes → both sides confirmed
   └── No-show tracked for reliability scores

4. Management
   ├── Driver can pause/resume line
   ├── Passenger can pause/cancel subscription
   ├── Auto-renewal at period end
   └── Payment history tracking
```

### 8.4 Feature Detail: Restaurant Order Delivery (طلبات)

**Smart matching:** When a restaurant creates a delivery request, سهم automatically finds drivers with active trips on the same route and notifies them.

```
1. Restaurant Creates Delivery Request
   ├── From city → To city
   ├── Size: small / medium / large
   ├── Urgency: normal / urgent (×2.5 price)
   ├── Description of order
   ├── Customer (receiver) name + phone
   ├── Optional notes
   └── Price: suggested by algorithm or custom

2. Auto-Matching
   ├── System searches active trips on same route
   ├── Matching drivers notified: "طلب على طريقك!"
   ├── Drivers see available orders in "On Route" tab
   └── Driver accepts → order linked to their trip

3. Delivery Flow
   ├── Driver picks up order from restaurant → status: picked_up
   ├── Restaurant notified at each status change
   ├── Driver delivers to customer → status: delivered
   └── Restaurant notified: "تم توصيل طلبك بنجاح"
```

---

## 9. UI/UX Enhancement Plan

### 9.1 Color Palette

**Current:** Platform uses a green-based palette reflecting travel, trust, and eco-friendliness.

- **Primary green** — trust, environment, movement (carpooling is green)
- **Warm accent** — for CTAs, notifications, alerts
- **Light backgrounds** — clean, inviting, easy to scan trip cards
- **Dark text** — high readability for Arabic content

### 9.2 Typography

- **Headings:** Tajawal (Arabic) / Inter (Latin) — bold, modern
- **Body:** IBM Plex Sans Arabic — high readability
- **Numbers/prices:** Tabular figures so prices align in trip cards

### 9.3 Iconography

Use transport-relevant icons consistently:
- 🚗 Trip / ride
- 🪑 Available seats
- 📦 Restaurant order / delivery
- 🔁 Recurring line
- 📍 Location pin
- ⏰ Departure time
- ⭐ Rating
- 🛡️ Verified driver
- 👩 Female-only
- 🚭 No smoking

### 9.4 Critical UX Patterns

| Pattern | Implementation |
|---------|---------------|
| **Role toggle** | Easy switch between driver/passenger mode on home screen |
| **Quick search** | From/To city + date = find trips instantly |
| **Trip cards** | Show driver, rating, price, seats, time at a glance |
| **One-tap booking** | Book a seat with single tap from trip details |
| **Saved commute** | Set home→work route once, find trips instantly each day |
| **Seat indicator** | Visual seat count (filled vs available) on every trip card |
| **Arabic RTL** | Full right-to-left layout, Arabic-first experience |
| **Pull to refresh** | Standard on all list screens |
| **Skeleton loaders** | Never blank screens while loading |
| **Haptic feedback** | On booking confirmed, trip started, attendance marked |

---

## 10. Trip Matching Algorithm — The Core Engine

### 10.1 Algorithm Goals (in priority order)

1. **Route relevance** — show trips that actually match the passenger's route
2. **Time proximity** — prioritize trips departing near the requested time
3. **Price attractiveness** — surface best value options first
4. **Driver quality** — higher-rated drivers rank better
5. **Seat availability** — trips with more available seats rank higher (more likely to succeed)
6. **Freshness** — newer listings appear before stale ones

### 10.2 Search & Matching Logic

```
When passenger searches for "Zarqa → Amman, tomorrow":

1. Query trips where:
   - from_city matches (normalized: الزرقاء = Zarqa = zarqa)
   - to_city matches
   - departure_time falls on requested date
   - status = active
   - available_seats > 0
   - driver_id ≠ current_user (can't book own trip)

2. Sort by departure_time ascending (soonest first)

3. Return paginated results with driver profile, rating, car info
```

### 10.3 Recurring Line Matching

```
When passenger searches for recurring lines:

1. Query recurring_trips where:
   - from_city matches
   - to_city matches
   - status = active
   - available_seats > 0

2. Include driver info: name, rating, reliability score, avatar

3. Sort by: rating desc, available_seats desc
```

### 10.4 Shipment Auto-Matching

```
When shipment is created:

1. Find all active trips where:
   - from_city matches shipment from_city
   - to_city matches shipment to_city
   - driver_id ≠ sender_id

2. Notify matching drivers:
   "طلب توصيل من {from} إلى {to} على مسار رحلتك"

3. Driver sees matched shipments in "On Route" tab
   Sorted: urgent first, then by creation time
```

### 10.5 City Name Normalization

Critical for Jordan where cities have multiple spellings (Arabic/English/informal):

```
City groups (all treated as equivalent):
  amman:   ['عمان', 'عمّان', 'amman']
  zarqa:   ['الزرقاء', 'zarqa']
  irbid:   ['إربد', 'اربد', 'irbid']
  salt:    ['السلط', 'salt']
  ajloun:  ['عجلون', 'ajloun']
  jerash:  ['جرش', 'jerash']
  madaba:  ['مادبا', 'madaba']
  karak:   ['الكرك', 'karak']
  aqaba:   ['العقبة', 'aqaba']
  mafraq:  ['المفرق', 'mafraq']
  ...
```

---

## 11. Unhappy Path Scenarios & Recovery

### 11.1 Scenario Matrix

| # | Scenario | Frequency | Severity | Auto-Handled? |
|---|----------|-----------|----------|---------------|
| 1 | Driver cancels trip | Low | High | ✅ Notify passengers, refund |
| 2 | Passenger cancels booking | Medium | Low | ✅ Free seat, notify driver |
| 3 | Driver no-show for recurring trip | Rare | High | ⚠️ Reliability score penalty |
| 4 | Passenger no-show for recurring trip | Medium | Medium | ✅ Attendance not confirmed |
| 5 | Driver rejects booking request | Medium | Low | ✅ Notify passenger |
| 6 | No trips available for route | High | Medium | ✅ Trip request feature |
| 7 | Order not picked up | Low | Medium | ⚠️ Re-match or cancel |
| 8 | Driver delivers to wrong customer | Rare | High | ⚠️ Manual support |
| 9 | Payment dispute | Low | Medium | ⚠️ Admin review |
| 10 | Accident during trip | Rare | Critical | ⚠️ Emergency flow |

### 11.2 Driver Cancels Trip

```
1. Driver taps "Cancel Trip"
2. If passengers have booked:
   - All passengers notified immediately
   - Wallet refunded (if pre-paid)
   - Passengers shown alternative trips on same route
3. Driver consequences:
   - Cancellation recorded
   - Rating impact for repeated cancellations
   - Credit NOT refunded (trip was listed)
```

### 11.3 Passenger No-Show (Recurring Trip)

```
1. Driver starts daily trip instance
2. Driver marks attendance for each subscriber
3. If passenger doesn't show:
   - Driver marks "absent"
   - System tracks no-show count
   - Reliability score updated
   - 3+ no-shows in a month → warning notification
   - Persistent no-shows → subscription may be cancelled
```

### 11.4 No Trips Available

```
1. Passenger searches, no trips found
2. System suggests:
   - "Post a trip request — drivers will see your demand"
   - Nearby routes that partially match
   - Different dates/times with availability
3. Trip request is visible to drivers near that route
4. Matching drivers can create trips to fulfill demand
```

### 11.5 Safety: Emergency During Trip

```
1. SOS feature available during active trips (future)
2. Emergency contact notified
3. Last known location shared
4. Admin alerted
5. Local emergency services contacted if needed
```

---

## 12. Trip Lifecycle & State Machine

### 12.1 One-Time Trip State Diagram

```
┌──────────┐
│  DRAFT   │  (driver filling in trip details)
└────┬─────┘
     │ create_trip (1 credit deducted)
     ▼
┌──────────┐
│  ACTIVE  │  (visible to passengers, bookable)
└────┬──┬──┘
     │  │
     │  │ cancel
     │  ▼
     │ ┌───────────┐
     │ │ CANCELLED │──→ END (passengers refunded)
     │ └───────────┘
     │
     │ all_seats_filled OR departure_time_passed
     ▼
┌───────────┐
│ COMPLETED │──→ END (ratings prompted)
└───────────┘
```

### 12.2 Booking State Diagram

```
┌──────────┐
│ PENDING  │  (passenger requested booking)
└────┬──┬──┘
     │  │
     │  │ reject
     │  ▼
     │ ┌──────────┐
     │ │ REJECTED │──→ END (passenger notified)
     │ └──────────┘
     │
     │ confirm (or auto-confirm)
     ▼
┌───────────┐
│ CONFIRMED │
└────┬──┬───┘
     │  │
     │  │ cancel (by either party)
     │  ▼
     │ ┌───────────┐
     │ │ CANCELLED │──→ END (seat freed, refund if applicable)
     │ └───────────┘
     │
     │ trip_completed
     ▼
┌───────────┐
│ COMPLETED │──→ END (rate each other)
└───────────┘
```

### 12.3 Recurring Trip Instance States

```
┌────────────┐
│ SCHEDULED  │  (auto-created for each day in schedule)
└─────┬──────┘
      │ driver_starts
      ▼
┌────────────┐
│  STARTED   │  (driver is active, marking attendance)
└─────┬──┬───┘
      │  │
      │  │ cancel_today
      │  ▼
      │ ┌───────────┐
      │ │ CANCELLED │──→ END (subscribers notified)
      │ └───────────┘
      │
      │ complete
      ▼
┌────────────┐
│ COMPLETED  │  (attendance recorded, dual confirmation done)
└────────────┘
```

### 12.4 Shipment States

```
┌──────────┐
│ PENDING  │  (sender created, awaiting driver)
└────┬──┬──┘
     │  │ cancel
     │  ▼
     │ ┌───────────┐
     │ │ CANCELLED │──→ END
     │ └───────────┘
     │
     │ driver_accepts
     ▼
┌──────────┐
│ ACCEPTED │  (driver committed to deliver)
└────┬─────┘
     │ picked_up
     ▼
┌───────────┐
│ PICKED_UP │  (order with driver)
└─────┬─────┘
      │ delivered
      ▼
┌───────────┐
│ DELIVERED │──→ END (sender notified)
└───────────┘
```

---

## 13. Go-to-Market Strategy

### 13.1 Launch Plan

**Phase 1: Soft Launch (Weeks 1-4) — Zarqa ↔ Amman Corridor**
- The busiest inter-city commute in Jordan (~200,000+ daily commuters)
- 50 seed drivers (recruited from existing informal carpool communities)
- 200 beta passengers (university students + office workers)
- Goal: validate matching, booking, and credit system
- Focus on morning commute (6:30-8:30 AM)

**Phase 2: Amman Hub Expansion (Month 2-3)**
- Add corridors: Salt ↔ Amman, Madaba ↔ Amman
- 200 drivers, 1,000 passengers
- Launch خطوط (recurring lines) feature prominently
- Marketing: "اشتركي بخط يومي بـ60 دينار بالشهر" (Subscribe to a daily line for 60 JOD/month)
- Launch restaurant order delivery feature
- Goal: 500 trips/day

**Phase 3: Northern Jordan (Month 4-5)**
- Add Irbid ↔ Amman, Jerash ↔ Amman, Ajloun ↔ Amman
- Target university students (Yarmouk, JUST, Irbid Private Universities)
- 500 drivers, 3,000 passengers
- Goal: 2,000 trips/day

**Phase 4: All Jordan (Month 6-8)**
- Karak, Tafileh, Ma'an, Aqaba routes
- 1,000+ drivers, 10,000+ passengers
- Goal: 5,000 trips/day

### 13.2 Acquisition Channels

**Drivers:**
- Target existing informal carpool drivers on Facebook groups
- "تحول من واتساب لسهم — نفس الركاب، دخل أكثر، وكل شي منظم" (Switch from WhatsApp to سهم — same riders, more income, everything organized)
- University gate ambassador program
- Gas station partnerships — flyers at pumps
- Free 20 credits on signup (first 20 trips free to list)

**Passengers:**
- University campus campaigns — the #1 commuter segment
- Office building partnerships — post in lobbies
- Social media: "وفر ٣٠٪ من مصاريف المواصلات" (Save 30% on transport costs)
- Referral: invite friend, both get 5 JOD wallet credit
- Female-only rides marketed specifically to women: "رحلتك آمنة مع سهم"

**Restaurants:**
- Door-to-door sales to restaurants in target corridors
- "وصّل طلبات مطعمك للمدن المجاورة" (Deliver your restaurant orders to nearby cities)
- Free onboarding + first 10 orders free

### 13.3 Retention Strategy

**Passenger retention:**
- خطوط subscriptions = automatic retention (daily habit)
- Saved commute routes = one-tap rebooking
- Trip requests = always find a ride even when no listings exist
- Rating system = trust builds over time
- Notifications: "رحلتك بعد ٣٠ دقيقة" (Your trip is in 30 minutes)

**Driver retention:**
- Recurring line subscribers = guaranteed monthly income
- Restaurant order delivery = bonus revenue on same routes
- Credit bundles = sunk-cost retention (credits already bought)
- Fair system = no commission on earnings, just listing fee
- Nearby demand alerts = see unmet demand in your area

---

## 14. Legal & Regulatory

### 14.1 Required Licenses

| License | Authority | Status |
|---------|-----------|--------|
| Commercial Registration | Ministry of Industry | Required at incorporation |
| Trade Name Registration | Ministry of Industry | Required |
| Income Tax | Income Tax Department | Annual |
| Sales Tax | Department of Sales Tax | Monthly filing |
| Telecom License (for SMS) | TRC | If sending bulk SMS |
| Data Protection compliance | Personal Data Protection Law (PDPL) | Mandatory |
| Transport intermediary clearance | LTRC | Consult — carpooling may need classification |
| Driver requirements | Valid license, vehicle insurance, clean record | Verify at onboarding |

**Key legal consideration:** سهم is a carpooling/ride-sharing platform (not a taxi service). Jordan's Land Transport Regulatory Commission (LTRC) regulates public transport — سهم should position as a "cost-sharing" platform where drivers share expenses, not operate as commercial transport. This distinction is critical for regulatory positioning.

### 14.2 Driver Requirements

- Valid Jordanian driver's license
- Vehicle registration and insurance
- National ID verification
- Car photo upload
- Criminal background check (self-declaration + admin review)
- Minimum age: 21 years
- Vehicle age: less than 15 years (recommended)

### 14.3 Passenger Terms

- Age 18+ for account creation
- Personal data: stored per PDPL, can request deletion
- Passenger agrees to platform rules and code of conduct
- Disputes: in-app support → email → arbitration

### 14.4 Insurance Considerations

| Coverage | Required? | Notes |
|----------|-----------|-------|
| Driver's personal vehicle insurance | Yes (driver responsibility) | Verified at onboarding |
| Platform liability insurance | Recommended | For dispute coverage |
| Passenger accident coverage | Recommended | Partnership with insurer |
| Cyber / data breach insurance | Recommended | User data protection |

---

## 15. KPIs & Success Metrics

### 15.1 North Star Metric

**Daily Completed Trips** — the single number that captures platform health.

### 15.2 Operational KPIs

| KPI | Target | Notes |
|-----|--------|-------|
| Daily active trips | 5,000+ (Year 1) | Supply health |
| Booking success rate | >85% | Passenger finds & books a trip |
| Trip completion rate | >95% | Booked trips that actually happen |
| Search-to-book conversion | >30% | UX quality indicator |
| Avg driver rating | 4.5+ | Quality of service |
| Recurring line fill rate | >75% | Subscription seat utilization |
| Order match rate | >60% | Restaurant orders matched to drivers |
| Order delivery rate | >90% | Matched orders delivered |
| Time to first booking (new user) | <24 hours | Onboarding quality |
| Driver credit purchase rate | >70% of active drivers | Revenue health |

### 15.3 Business KPIs

| KPI | Target Month 6 | Target Year 1 |
|-----|---------------|---------------|
| Daily completed trips | 2,000 | 8,000 |
| Active drivers | 500 | 2,000 |
| Active passengers | 3,000 | 15,000 |
| Active recurring lines | 200 | 1,000 |
| Active subscriptions | 600 | 3,500 |
| Daily restaurant orders delivered | 100 | 500 |
| Monthly credit bundle revenue | 10,000 JOD | 50,000 JOD |
| Monthly subscription service fee revenue | 12,000 JOD | 60,000 JOD |
| Monthly restaurant delivery revenue | 3,000 JOD | 15,000 JOD |
| **Total Monthly Revenue** | **~25,000 JOD** | **~125,000 JOD** |

### 15.4 Customer Satisfaction

| Metric | Target |
|--------|--------|
| App store rating | 4.5+ |
| Passenger NPS | 50+ |
| Driver NPS | 55+ |

### 15.5 Cohort Metrics

Track passenger cohorts monthly:
- Month 1 retention: 50%+
- Month 3 retention: 30%+
- Month 6 retention: 20%+
- Trips per active passenger per month: 8+ (daily commuters drive this up)
- Subscription conversion rate: 15%+ of active passengers

---

## 16. Roadmap Priority Matrix

### 16.1 Impact vs Effort Matrix

```
HIGH IMPACT
    │
    │  ★ Recurring lines (خطوط)      ★ Trip search + booking
    │  ★ Driver credits system        ★ Restaurant order delivery
    │  ★ Attendance tracking          ★ Subscription payments
    │  ★ Trip requests (demand)       ★ Driver verification
    │
    │  ○ Live trip tracking (map)     ○ Price negotiation
    │  ○ Loyalty program              ○ Driver analytics
    │  ○ Group trip booking           ○ Scheduled reminders
    │
LOW IMPACT
    └──────────────────────────────────
       LOW EFFORT              HIGH EFFORT

★ = Built (P0)
○ = Future (P1/P2)
```

### 16.2 Current Sprint Status

**All P0 features are built:**
- [x] Auth (Phone OTP + Firebase)
- [x] Role selection + driver verification
- [x] Trip CRUD + search + booking
- [x] Recurring trips (خطوط) + subscriptions
- [x] Attendance tracking with dual confirmation
- [x] Driver credits (bundles + per-trip deduction)
- [x] Restaurant order delivery (shipments) with auto-matching
- [x] Trip requests (demand-side matching)
- [x] Wallet + recharge cards
- [x] Chat + ratings + notifications
- [x] Admin dashboard
- [x] Home with role toggle + saved commutes

### 16.3 Next Sprint Priorities

**Sprint Next: Polish & Launch Prep**
- [ ] Live trip tracking on map (driver location during trip)
- [ ] Pre-trip reminder notifications (30 min before departure)
- [ ] Improved onboarding flow with tutorial
- [ ] App store / Play store listings
- [ ] Soft launch marketing materials
- [ ] Performance optimization + testing

### 16.4 Post-Launch Roadmap

**Months 4-6:**
- Price suggestion algorithm (based on route + demand)
- Driver earnings dashboard
- Loyalty / rewards program
- Multi-language polish (English)
- Voice search

**Months 7-12:**
- Live GPS tracking during trips
- Integration with Google Maps for navigation
- Predictive demand (suggest when to create trips)
- Corporate accounts (company commute programs)
- Expand feature set for Aqaba tourism routes

**Year 2:**
- Minibus/van support (more seats, different pricing)
- Cross-border routes (Jordan ↔ border crossings)
- API for corporate fleet integration
- Government partnership for public transport supplementation

---

## Appendix A: Jordanian Inter-City Routes & Pricing

**Primary corridors (by volume):**

| Route | Distance | Bus Fare | سهم Target Price/Seat | Daily Commuters |
|-------|----------|----------|----------------------|-----------------|
| Zarqa ↔ Amman | 25 km | 0.75 JOD | 1.50-2.00 JOD | ~200,000 |
| Salt ↔ Amman | 30 km | 1.00 JOD | 2.00-2.50 JOD | ~80,000 |
| Madaba ↔ Amman | 35 km | 1.00 JOD | 2.00-2.50 JOD | ~40,000 |
| Irbid ↔ Amman | 90 km | 2.50 JOD | 3.00-4.00 JOD | ~50,000 |
| Jerash ↔ Amman | 50 km | 1.50 JOD | 2.50-3.00 JOD | ~30,000 |
| Ajloun ↔ Amman | 75 km | 2.00 JOD | 3.00-3.50 JOD | ~20,000 |
| Karak ↔ Amman | 130 km | 3.00 JOD | 3.50-4.50 JOD | ~15,000 |
| Aqaba ↔ Amman | 330 km | 7.00 JOD | 5.00-6.00 JOD | ~5,000 |

**Pricing sweet spot:** سهم rides should be 50-100% more than public bus fares (for comfort, reliability, and door-to-door service) but 40-60% cheaper than solo taxi/Careem rides.

## Appendix B: Key Data Sources

- Jordan Department of Statistics (DOS)
- DataReportal Digital 2025: Jordan
- Land Transport Regulatory Commission (LTRC)
- Personal Data Protection Law (PDPL) Jordan
- Greater Amman Municipality transport reports

## Appendix C: Glossary

| Term | Meaning |
|------|---------|
| **خط (khat)** | A recurring commute line — driver operates daily route with subscriber passengers |
| **طلب (talab)** | A restaurant order for inter-city delivery via ride-sharing drivers |
| **رصيد (raseed)** | Driver credits — purchased bundles used to list trips |
| **اشتراك (ishtirak)** | Subscription — passenger subscribes to a recurring line |
| **مقعد (maq'ad)** | Seat — unit of booking on a trip |
| **نقطة تجمع (nuqtat tajammu')** | Pooling/meeting point — agreed pickup location |
| **حضور (hudoor)** | Attendance — dual confirmation that rider was on the trip |
| **سهم** | Share/arrow — the platform name, reflecting ride-sharing |
| **NPS** | Net Promoter Score (customer satisfaction) |
| **LTRC** | Land Transport Regulatory Commission (Jordan) |
| **PDPL** | Personal Data Protection Law (Jordan) |

---

> **This document should be referenced when making product, design, or business decisions for سهم. Update it as the market evolves and user feedback is collected.**
>
> **سهم is a ride-sharing, carpooling, and restaurant order delivery platform — not a taxi service. Product decisions should always align with the peer-to-peer cost-sharing model + restaurant delivery as a bonus revenue stream.**
