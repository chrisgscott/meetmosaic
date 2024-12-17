export default function Settings() {
    return (
      <div className="p-8">
        <h1 className="text-3xl font-bold mb-4">Settings</h1>
        <p>Update your personal preferences and settings here.</p>
        <div className="mt-6 space-y-4">
          <div>
            <label className="block font-medium mb-1">Email Notifications</label>
            <input type="checkbox" className="h-5 w-5" /> Enable email notifications
          </div>
          <div>
            <label className="block font-medium mb-1">Dark Mode</label>
            <input type="checkbox" className="h-5 w-5" /> Enable dark mode
          </div>
        </div>
      </div>
    );
  }
  