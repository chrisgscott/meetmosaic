import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"

interface LongTermGoalsData {
  primaryContentGoal?: string;
  [key: string]: any;
}

interface LongTermGoalsProps {
  data: LongTermGoalsData;
  onChange: (update: Partial<LongTermGoalsData>) => void;
}

export default function LongTermGoals({ data, onChange }: LongTermGoalsProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  const handlePrimaryGoalChange = (value: string) => {
    onChange({ primaryContentGoal: value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label>Primary Content Goal</Label>
        <RadioGroup
          onValueChange={handlePrimaryGoalChange}
          defaultValue={data.primaryContentGoal}
          className="flex flex-col space-y-1 mt-2"
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="brand-awareness" id="brand-awareness" />
            <Label htmlFor="brand-awareness">Build brand awareness</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="drive-traffic" id="drive-traffic" />
            <Label htmlFor="drive-traffic">Drive traffic to the website</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="grow-subscribers" id="grow-subscribers" />
            <Label htmlFor="grow-subscribers">Grow email subscribers</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="generate-sales" id="generate-sales" />
            <Label htmlFor="generate-sales">Generate direct sales/leads</Label>
          </div>
        </RadioGroup>
      </div>
      <div>
        <Label htmlFor="revenueTargets">Revenue or Growth Targets</Label>
        <Input
          id="revenueTargets"
          name="revenueTargets"
          value={data.revenueTargets || ''}
          onChange={handleChange}
          placeholder="e.g., Add 10,000 new email subscribers this year"
        />
      </div>
    </div>
  )
}
