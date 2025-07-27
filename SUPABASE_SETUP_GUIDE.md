# Supabase Setup Guide for Court Cases

## 🚀 Complete Supabase Integration Process

### 1. **Create Supabase Project**

1. Go to [supabase.com](https://supabase.com) and sign up
2. Click **"New Project"**
3. Fill in project details:
   - **Name**: `ISSI Court Cases`
   - **Database Password**: (Choose a strong password)
   - **Region**: Select closest to your location
4. Wait for project creation (takes ~2 minutes)

### 2. **Get Your Credentials**

From your Supabase dashboard:
1. Go to **Settings** → **API**
2. Copy these values:
   - **Project URL**: `https://your-project-id.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiI...` (long string)

### 3. **Secure Environment Configuration** ✅

**IMPORTANT**: Never commit your Supabase credentials to version control!

1. **Create a `.env` file** in your project root:
```bash
# Create the .env file
touch .env
```

2. **Add your credentials to `.env`**:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_actual_anon_key_here
```

3. **Ensure `.env` is in `.gitignore`** (already done):
```gitignore
# Environment variables - contains sensitive credentials
.env
```

4. **Create a template file** `.env.example`:
```env
# Supabase Configuration
# Copy this file to .env and replace with your actual credentials

SUPABASE_URL=your_supabase_project_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

The app now loads credentials securely from environment variables!

### 4. **Update main.dart with Your Credentials**

Replace the placeholder values in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'https://your-project-id.supabase.co', // Your actual URL
  anonKey: 'your-anon-key-here',              // Your actual anon key
);
```

### 5. **Create Database Schema**

In your Supabase dashboard:
1. Go to **SQL Editor**
2. Click **"New Query"**
3. Paste and run this SQL:

```sql
-- Enable Row Level Security
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Court Cases Table
CREATE TABLE court_cases (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  case_number VARCHAR(50) UNIQUE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  case_type VARCHAR(50) NOT NULL,
  status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'closed', 'appealed')),
  -- or we can change the statuses later?
  court_name VARCHAR(100) NOT NULL,
  judge_name VARCHAR(100),
  filing_date DATE NOT NULL,
  hearing_date TIMESTAMP,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Parties Table
CREATE TABLE case_parties (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  case_id UUID REFERENCES court_cases(id) ON DELETE CASCADE,
  party_type VARCHAR(30) NOT NULL CHECK (party_type IN ('plaintiff', 'defendant', 'witness', 'attorney')),
  name VARCHAR(100) NOT NULL,
  contact_info JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Documents Table
CREATE TABLE case_documents (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  case_id UUID REFERENCES court_cases(id) ON DELETE CASCADE,
  document_name VARCHAR(200) NOT NULL,
  document_type VARCHAR(50),
  file_url TEXT,
  uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Case Events/Timeline
CREATE TABLE case_events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  case_id UUID REFERENCES court_cases(id) ON DELETE CASCADE,
  event_type VARCHAR(50) NOT NULL,
  event_description TEXT NOT NULL,
  event_date TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable realtime for all tables
ALTER PUBLICATION supabase_realtime ADD TABLE court_cases;
ALTER PUBLICATION supabase_realtime ADD TABLE case_parties;
ALTER PUBLICATION supabase_realtime ADD TABLE case_documents;
ALTER PUBLICATION supabase_realtime ADD TABLE case_events;

-- Row Level Security Policies
ALTER TABLE court_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE case_parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE case_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE case_events ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (adjust based on your auth requirements)
CREATE POLICY "Allow all for court_cases" ON court_cases FOR ALL USING (true);
CREATE POLICY "Allow all for case_parties" ON case_parties FOR ALL USING (true);
CREATE POLICY "Allow all for case_documents" ON case_documents FOR ALL USING (true);
CREATE POLICY "Allow all for case_events" ON case_events FOR ALL USING (true);

-- Create indexes for better performance
CREATE INDEX idx_court_cases_case_number ON court_cases(case_number);
CREATE INDEX idx_court_cases_status ON court_cases(status);
CREATE INDEX idx_court_cases_court_name ON court_cases(court_name);
CREATE INDEX idx_case_parties_case_id ON case_parties(case_id);
CREATE INDEX idx_case_documents_case_id ON case_documents(case_id);
CREATE INDEX idx_case_events_case_id ON case_events(case_id);
```

### 6. **Add Sample Data**

Run this query to add some test data:

```sql
INSERT INTO court_cases (case_number, title, description, case_type, status, court_name, judge_name, filing_date, hearing_date) VALUES
('CV-2024-001', 'Smith vs. Johnson', 'Contract dispute regarding property sale', 'civil', 'active', 'Superior Court of Justice', 'Hon. Judge Williams', '2024-01-15', '2024-02-20 10:00:00'),
('CR-2024-002', 'State vs. Brown', 'Theft charges', 'criminal', 'pending', 'Criminal Court District 1', 'Hon. Judge Davis', '2024-01-20', '2024-02-25 14:00:00'),
('FAM-2024-003', 'Wilson Custody Case', 'Child custody arrangement', 'family', 'active', 'Family Court Central', 'Hon. Judge Martinez', '2024-01-10', '2024-02-18 09:30:00'),
('COM-2024-004', 'TechCorp vs. StartupXYZ', 'Patent infringement lawsuit', 'commercial', 'pending', 'Commercial Court Downtown', 'Hon. Judge Thompson', '2024-01-25', NULL),
('ADM-2024-005', 'City Planning Appeal', 'Zoning variance appeal', 'administrative', 'closed', 'Administrative Court', 'Hon. Judge Garcia', '2023-12-15', '2024-01-30 11:00:00');
```

### 7. **Test Your App**

1. Update your main navigation to include the Court Cases page
2. Add this to your routing or navigation:

```dart
// Add this to your main.dart or routing
import 'presentation/pages/court_cases_page.dart';

// In your app navigation
MaterialPageRoute(builder: (context) => CourtCasesPage())
```

### 8. **Features You Get**

✅ **Realtime Updates**: Changes appear instantly across all connected devices  
✅ **Search**: Search across case numbers, titles, court names, and judges  
✅ **Filtering**: Filter by status (pending, active, closed, appealed) and case type  
✅ **CRUD Operations**: Create, read, update, delete court cases  
✅ **Responsive UI**: Modern, clean interface with status chips  
✅ **Error Handling**: Proper error messages and loading states  

### 9. **Realtime Magic** 🪄

The realtime functionality means:
- If you add a case in the Supabase dashboard → It appears in your app instantly
- If someone else adds/updates a case → You see it in real-time
- Multiple users can collaborate simultaneously
- No refresh needed!

### 10. **Testing Realtime**

1. Open your app and go to Court Cases page
2. Open Supabase dashboard → Table Editor → court_cases
3. Add/edit/delete a row in the dashboard
4. Watch it appear/change/disappear in your app instantly! 🎉

### 11. **Security Notes**

- Current setup allows all operations (good for development)
- For production, implement proper RLS policies based on user authentication
- Consider adding user authentication with Supabase Auth

### 12. **Next Steps**

- Implement case creation/editing forms
- Add user authentication
- Add file attachments for case documents
- Implement case timeline/events
- Add push notifications for case updates

## 🎯 Key Benefits of This Setup

1. **Zero Backend Code**: No server setup needed
2. **Realtime by Default**: Live updates across all devices
3. **Scalable**: Handles from 1 to millions of users
4. **Free Tier**: Generous free limits for development
5. **PostgreSQL**: Full SQL database with relationships
6. **Production Ready**: Used by companies worldwide

## 🚨 Important Notes

- Replace placeholder credentials with your actual Supabase project credentials
- The current RLS policies allow all operations - adjust for production
- Test the realtime functionality - it's the coolest feature!

---

**Need Help?** 
- Check the [Supabase docs](https://supabase.com/docs)
- Join the [Supabase Discord](https://discord.supabase.com)
- Review the code in this project for examples 