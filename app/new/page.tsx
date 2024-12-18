'use client'

import OnboardingForm from './onboarding-form'

export default function Home() {
  return (
    <main className="container mx-auto py-10">
      <h1 className="text-3xl font-bold mb-6 text-center">Content Strategy Onboarding</h1>
      <OnboardingForm />
    </main>
  )
}