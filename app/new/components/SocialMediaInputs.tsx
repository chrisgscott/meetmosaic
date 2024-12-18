import { Checkbox } from "@/components/ui/checkbox"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"

interface SocialMediaData {
  socialPlatforms?: string[];
  [key: string]: any;
}

interface SocialMediaInputsProps {
  data: SocialMediaData;
  onChange: (update: Partial<SocialMediaData>) => void;
}

export default function SocialMediaInputs({ data, onChange }: SocialMediaInputsProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    onChange({ [e.target.name]: e.target.value })
  }

  const handleCheckboxChange = (platform: string) => {
    const updatedPlatforms = data.socialPlatforms ? [...data.socialPlatforms] : []
    if (updatedPlatforms.includes(platform)) {
      updatedPlatforms.splice(updatedPlatforms.indexOf(platform), 1)
    } else {
      updatedPlatforms.push(platform)
    }
    onChange({ socialPlatforms: updatedPlatforms })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label>Social Platforms</Label>
        <div className="flex space-x-4 mt-2">
          {['LinkedIn', 'Instagram', 'Twitter', 'Facebook'].map((platform) => (
            <div key={platform} className="flex items-center space-x-2">
              <Checkbox
                id={platform}
                checked={data.socialPlatforms?.includes(platform)}
                onCheckedChange={() => handleCheckboxChange(platform)}
              />
              <Label htmlFor={platform}>{platform}</Label>
            </div>
          ))}
        </div>
      </div>
      <div>
        <Label htmlFor="platformPreferences">Platform-Specific Content Preferences</Label>
        <Textarea
          id="platformPreferences"
          name="platformPreferences"
          value={data.platformPreferences || ''}
          onChange={handleChange}
          placeholder="Any formatting or style guidelines specific to platforms?"
        />
      </div>
      <div>
        <Label htmlFor="competitorSocial">Competitor Social Accounts</Label>
        <Input
          id="competitorSocial"
          name="competitorSocial"
          value={data.competitorSocial || ''}
          onChange={handleChange}
          placeholder="URLs for inspiration and differentiation"
        />
      </div>
    </div>
  )
}
