import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

interface EmailMarketingData {
  emailTone?: string;
  emailFrequency?: string;
  welcomeEmailContent?: string;
  emailContentTypes?: string;
  [key: string]: any;
}

interface EmailMarketingInputsProps {
  data: EmailMarketingData;
  onChange: (update: Partial<EmailMarketingData>) => void;
}

export default function EmailMarketingInputs({ data, onChange }: EmailMarketingInputsProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  const handleEmailToneChange = (value: string) => {
    onChange({ emailTone: value })
  }

  const handleFrequencyChange = (value: string) => {
    onChange({ emailFrequency: value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label>Email Tone</Label>
        <RadioGroup
          onValueChange={handleEmailToneChange}
          defaultValue={data.emailTone}
          className="flex flex-col space-y-1 mt-2"
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="conversational" id="conversational" />
            <Label htmlFor="conversational">Conversational</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="punchy" id="punchy" />
            <Label htmlFor="punchy">Punchy</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="educational" id="educational" />
            <Label htmlFor="educational">Educational</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="persuasive" id="persuasive" />
            <Label htmlFor="persuasive">Persuasive</Label>
          </div>
        </RadioGroup>
      </div>
      <div>
        <Label htmlFor="emailFrequency">Frequency Preferences</Label>
        <Select onValueChange={handleFrequencyChange} defaultValue={data.emailFrequency}>
          <SelectTrigger className="w-full">
            <SelectValue placeholder="Select email frequency" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="daily">Daily</SelectItem>
            <SelectItem value="weekly">Weekly</SelectItem>
            <SelectItem value="monthly">Monthly</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <div>
        <Label htmlFor="listBuildingGoals">List Building Goals</Label>
        <Input
          id="listBuildingGoals"
          name="listBuildingGoals"
          value={data.listBuildingGoals || ''}
          onChange={handleChange}
          placeholder="e.g., nurture leads, promote products, build authority"
        />
      </div>
    </div>
  )
}
