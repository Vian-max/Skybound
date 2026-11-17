# SKYBOUND cloud account setup

SKYBOUND is hosted as a static GitHub Pages site. Static hosting cannot securely create user accounts or store cross-device saves by itself, so the game uses Supabase Auth and a small Postgres save table. Device-only Save/Load continues to work without this setup.

## 1. Create a Supabase project

1. Create a project at [supabase.com](https://supabase.com/). Ask a parent or guardian before creating an online account.
2. Open **Project Settings → API** (or **API Keys**) and copy the **Project URL** and the **publishable key** (or legacy **anon** key).
3. In Supabase **Authentication → URL Configuration**, set the Site URL to:

   `https://vian-max.github.io/Skybound/`

4. Add this exact URL to the allowed Redirect URLs as well:

   `https://vian-max.github.io/Skybound/**`

## 2. Create the private save table

1. Open **SQL Editor** in your Supabase project.
2. Open `supabase-schema.sql` from this repository.
3. Paste the complete SQL into the editor and run it.

The table has Row Level Security enabled. The policies only allow an authenticated player to read or change the row whose `user_id` matches their own Supabase user ID. The browser never receives a service-role key.

## 3. Connect SKYBOUND to the project

Edit `supabase-config.js` in this repository:

- Set `url` to your Supabase Project URL.
- Set `anonKey` to your public publishable key, or legacy anon key.

Do **not** use a service_role key, secret key, database password, or personal access token in this file. It is a public website, so all visitors can inspect browser JavaScript and the public key. Row Level Security is what protects each player's saved row.

Commit the updated file to the `main` branch. After GitHub Pages publishes it, open SKYBOUND, choose **SIGN IN**, and create an account or sign in. If email confirmation is enabled, confirm the email first and then sign in.

## What is saved

The cloud save includes the aircraft drawing, wing/engine settings, paint, selected map and difficulty, pilot callsign, local race records, and simple flight/progress statistics. The Save button writes to this browser and, when signed in, syncs to the account. Load prefers the signed-in cloud save.

## Troubleshooting

- **Sign-in buttons disabled:** the placeholder values in `supabase-config.js` have not been replaced, or the config file has not been published.
- **Table not found:** run `supabase-schema.sql` in the Supabase SQL Editor.
- **Not allowed / permission error:** check that the table has Row Level Security enabled and that the three policies in the SQL file exist.
- **Confirmation link returns to the wrong place:** add the GitHub Pages URL above to the Authentication Redirect URLs.

Never share your password, Supabase database password, or secret/service-role key with anyone.
