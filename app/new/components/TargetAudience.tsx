import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"

interface TargetAudienceData {
  demographics?: string;
  psychographics?: string;
  painPoints?: string;
  jobRole?: string;
  desiredOutcomes?: string;
  [key: string]: any;
}

interface TargetAudienceProps {
  data: TargetAudienceData;
  onChange: (update: Partial<TargetAudienceData>) => void;
}

export default function TargetAudience({ data, onChange }: TargetAudienceProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label htmlFor="demographics">Demographics</Label>
        <Input
          id="demographics"
          name="demographics"
          value={data.demographics || ''}
          onChange={handleChange}
          placeholder="Age, gender, location, income level"
        />
      </div>
      <div>
        <Label htmlFor="psychographics">Psychographics</Label>
        <Textarea
          id="psychographics"
          name="psychographics"
          value={data.psychographics || ''}
          onChange={handleChange}
          placeholder="Goals, pain points, values, interests"
        />
      </div>
      <div>
        <Label htmlFor="jobRole">Job Role/Persona</Label>
        <Input
          id="jobRole"
          name="jobRole"
          value={data.jobRole || ''}
          onChange={handleChange}
          placeholder="e.g., Small business owner, e-commerce manager"
        />
      </div>
      <div>
        <Label htmlFor="painPoints">Primary Pain Points</Label>
        <Textarea
          id="painPoints"
          name="painPoints"
          value={data.painPoints || ''}
          onChange={handleChange}
          placeholder="What problems is the audience experiencing?"
        />
      </div>
      <div>
        <Label htmlFor="desiredOutcomes">Desired Outcomes</Label>
        <Textarea
          id="desiredOutcomes"
          name="desiredOutcomes"
          value={data.desiredOutcomes || ''}
          onChange={handleChange}
          placeholder="What does success look like for the audience?"
        />
      </div>
    </div>
  )
}
