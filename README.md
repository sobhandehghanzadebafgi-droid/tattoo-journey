# SBN TATTOO — Production Starter

Next.js + Supabase + Vercel. The app has public portfolio/FAQ/booking and an authenticated admin area with booking management and customer records.

## 1. Supabase
Create a project, open SQL Editor, run `supabase/schema.sql`, then create an admin user in Supabase Auth.

## 2. Local
Copy `.env.example` to `.env.local`, fill:
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY

Then:
`npm install`
`npm run dev`

## 3. GitHub + Vercel
Push this repository to GitHub and import it in Vercel. Add the same two environment variables in Vercel. Vercel will build the Next.js app.

## Security
Customer records are authenticated-only through Supabase RLS. Do not put secret/service-role keys in `.env` exposed to the browser. Customer photos are kept in a private Storage bucket.

## Next production upgrades
- Admin CRUD for every portfolio image/style/FAQ (current schema is ready)
- Real image upload UI for portfolio/customer files
- SMS provider
- WhatsApp integration
- calendar and appointment conflict detection
- consent/privacy workflow for storing customer photos
