import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

interface ContentSpecificData {
  primaryCTA?: string;
  awarenessStage?: string;
  contentFormat?: string;
  [key: string]: any;
}

interface ContentSpecificProps {
  data: ContentSpecificData;
  onChange: (update: Partial<ContentSpecificData>) => void;
}

export default function ContentSpecific({ data, onChange }: ContentSpecificProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  const handleSelectChange = (value: string) => {
    onChange({ awarenessStage: value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label htmlFor="primaryCTA">Primary CTA (Call to Action)</Label>
        <Input
          id="primaryCTA"
          name="primaryCTA"
          value={data.primaryCTA || ''}
          onChange={handleChange}
          placeholder="e.g., Sign up for a free trial, Download the guide"
        />
      </div>
      <div>
        <Label htmlFor="awarenessStage">Stages of Awareness Focus</Label>
        <Select onValueChange={handleSelectChange} defaultValue={data.awarenessStage}>
          <SelectTrigger className="w-full">
            <SelectValue placeholder="Select awareness stage" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="unaware">Unaware</SelectItem>
            <SelectItem value="problem-aware">Problem-Aware</SelectItem>
            <SelectItem value="solution-aware">Solution-Aware</SelectItem>
            <SelectItem value="product-aware">Product-Aware</SelectItem>
            <SelectItem value="ready-to-buy">Ready-to-Buy</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <div>
        <Label htmlFor="promotions">Promotions/Offers</Label>
        <Textarea
          id="promotions"
          name="promotions"
          value={data.promotions || ''}
          onChange={handleChange}
          placeholder="Any offers, discounts, or lead magnets the content should tie into"
        />
      </div>
    </div>
  )
}
