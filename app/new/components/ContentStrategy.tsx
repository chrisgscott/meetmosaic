import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"

interface ContentStrategyData {
  primaryTopics?: string;
  toneOfVoice?: string;
  contentPillars?: string;
  contentMix?: string;
  brandKeywords?: string;
  competitors?: string;
  [key: string]: any;
}

interface ContentStrategyProps {
  data: ContentStrategyData;
  onChange: (update: Partial<ContentStrategyData>) => void;
}

export default function ContentStrategy({ data, onChange }: ContentStrategyProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  const handleToneChange = (value: string) => {
    onChange({ toneOfVoice: value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label htmlFor="primaryTopics">Primary Topics/Content Themes</Label>
        <Textarea
          id="primaryTopics"
          name="primaryTopics"
          value={data.primaryTopics || ''}
          onChange={handleChange}
          placeholder="Key topics or themes the business wants to be known for"
        />
      </div>
      <div>
        <Label>Tone of Voice</Label>
        <RadioGroup
          onValueChange={handleToneChange}
          defaultValue={data.toneOfVoice}
          className="flex flex-col space-y-1"
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="formal" id="formal" />
            <Label htmlFor="formal">Formal/Professional</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="conversational" id="conversational" />
            <Label htmlFor="conversational">Conversational/Relatable</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="playful" id="playful" />
            <Label htmlFor="playful">Playful/Quirky</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="authoritative" id="authoritative" />
            <Label htmlFor="authoritative">Authoritative/Expert</Label>
          </div>
        </RadioGroup>
      </div>
      <div>
        <Label htmlFor="brandKeywords">Brand Keywords</Label>
        <Input
          id="brandKeywords"
          name="brandKeywords"
          value={data.brandKeywords || ''}
          onChange={handleChange}
          placeholder="Words or phrases that should appear often in content"
        />
      </div>
      <div>
        <Label htmlFor="competitors">Competitors</Label>
        <Textarea
          id="competitors"
          name="competitors"
          value={data.competitors || ''}
          onChange={handleChange}
          placeholder="List of key competitors for research and differentiation"
        />
      </div>
    </div>
  )
}
