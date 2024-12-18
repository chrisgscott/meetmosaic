import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"

interface BusinessOverviewData {
  businessName?: string;
  businessType?: string;
  primaryProduct?: string;
  coreOfferDescription?: string;
  [key: string]: any;
}

interface BusinessOverviewProps {
  data: BusinessOverviewData;
  onChange: (update: Partial<BusinessOverviewData>) => void;
}

export default function BusinessOverview({ data, onChange }: BusinessOverviewProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label htmlFor="businessName">Business Name</Label>
        <Input
          id="businessName"
          name="businessName"
          value={data.businessName || ''}
          onChange={handleChange}
          placeholder="Enter your business name"
        />
      </div>
      <div>
        <Label htmlFor="businessType">Business Type/Industry</Label>
        <Input
          id="businessType"
          name="businessType"
          value={data.businessType || ''}
          onChange={handleChange}
          placeholder="e.g., SaaS, E-commerce, Consulting"
        />
      </div>
      <div>
        <Label htmlFor="primaryProduct">Primary Product/Service</Label>
        <Input
          id="primaryProduct"
          name="primaryProduct"
          value={data.primaryProduct || ''}
          onChange={handleChange}
          placeholder="What does your business offer?"
        />
      </div>
      <div>
        <Label htmlFor="coreOfferDescription">Core Offer Description</Label>
        <Textarea
          id="coreOfferDescription"
          name="coreOfferDescription"
          value={data.coreOfferDescription || ''}
          onChange={handleChange}
          placeholder="Describe your main product or service"
        />
      </div>
    </div>
  )
}
