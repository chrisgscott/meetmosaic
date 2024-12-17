export default function Account() {
    return (
      <div className="p-8">
        <h1 className="text-3xl font-bold mb-4">Account Settings</h1>
        <p>Manage your billing information and subscription here.</p>
        <div className="mt-4">
          <button className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-500">
            Update Billing Info
          </button>
        </div>
      </div>
    );
  }
  