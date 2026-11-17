# Wallmarkt

A neighborhood marketplace built with Next.js 15, React 19, Tailwind CSS 4, and shadcn/ui conventions.

## Getting started

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000). Browse categories, search listings, change the sort order, and save items with the heart button.

Product photos are served by Unsplash. The listing data is sample content in `src/app/page.tsx`.

## Supabase listings

Copy `.env.example` to `.env.local` and set your Supabase project URL and anon key. Run `supabase/schema.sql` in the Supabase SQL Editor to create the listings table, storage bucket, and public listing policies. Restart the development server, then use **Create new listing** to upload a photo and publish a listing.

Buyer messages are saved in the `messages` table created by the same SQL file. The current message form stores messages in Supabase without sending email notifications.
