export default function NotFound() {
    return (
      <div className="flex flex-col items-center justify-center h-screen text-center">
        <h1 className="text-6xl font-bold mb-4">404</h1>
        <p className="text-xl mb-6">Sorry, the page you’re looking for doesn’t exist.</p>
        <a
          href="/"
          className="text-blue-600 hover:underline text-lg"
        >
          Go back home
        </a>
      </div>
    );
  }
  