'use client'

import { useState } from 'react'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import BusinessOverview from './components/BusinessOverview'
import TargetAudience from './components/TargetAudience'
import ContentStrategy from './components/ContentStrategy'
import ContentSpecific from './components/ContentSpecific'
import SocialMediaInputs from './components/SocialMediaInputs'
import BlogContentInputs from './components/BlogContentInputs'
import EmailMarketingInputs from './components/EmailMarketingInputs'
import LongTermGoals from './components/LongTermGoals'

const steps = [
  { title: 'Business Overview', component: BusinessOverview },
  { title: 'Target Audience', component: TargetAudience },
  { title: 'Content Strategy', component: ContentStrategy },
  { title: 'Content-Specific Inputs', component: ContentSpecific },
  { title: 'Social Media Inputs', component: SocialMediaInputs },
  { title: 'Blog and Content Upgrade Inputs', component: BlogContentInputs },
  { title: 'Email Marketing Inputs', component: EmailMarketingInputs },
  { title: 'Long-Term Goals', component: LongTermGoals },
]

export default function OnboardingForm() {
  const [currentStep, setCurrentStep] = useState(0)
  const [formData, setFormData] = useState({})

  const handleNext = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1)
    } else {
      console.log('Form submitted:', formData)
      // Here you would typically send the data to your backend
    }
  }

  const handlePrevious = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1)
    }
  }

  const handleInputChange = (stepData: object) => {
    setFormData({ ...formData, ...stepData })
  }

  const CurrentStepComponent = steps[currentStep].component

  return (
    <Card className="w-full max-w-4xl mx-auto">
      <CardHeader>
        <CardTitle>{steps[currentStep].title}</CardTitle>
      </CardHeader>
      <CardContent>
        <CurrentStepComponent data={formData} onChange={handleInputChange} />
      </CardContent>
      <CardFooter className="flex justify-between">
        <Button onClick={handlePrevious} disabled={currentStep === 0}>Previous</Button>
        <Button onClick={handleNext}>
          {currentStep === steps.length - 1 ? 'Submit' : 'Next'}
        </Button>
      </CardFooter>
    </Card>
  )
}

