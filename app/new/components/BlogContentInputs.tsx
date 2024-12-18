import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

interface BlogContentData {
  blogStyle?: string;
  contentUpgradePreference?: string;
  [key: string]: any;
}

interface BlogContentInputsProps {
  data: BlogContentData;
  onChange: (update: Partial<BlogContentData>) => void;
}

export default function BlogContentInputs({ data, onChange }: BlogContentInputsProps) {
  const handleBlogStyleChange = (value: string) => {
    onChange({ blogStyle: value })
  }

  const handleContentUpgradeChange = (value: string) => {
    onChange({ contentUpgradePreference: value })
  }

  return (
    <div className="space-y-4">
      <div>
        <Label>Blog Style</Label>
        <RadioGroup
          onValueChange={handleBlogStyleChange}
          defaultValue={data.blogStyle}
          className="flex flex-col space-y-1 mt-2"
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="informational" id="informational" />
            <Label htmlFor="informational">Informational/Educational</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="storytelling" id="storytelling" />
            <Label htmlFor="storytelling">Storytelling</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="seo-optimized" id="seo-optimized" />
            <Label htmlFor="seo-optimized">SEO-Optimized</Label>
          </div>
        </RadioGroup>
      </div>
      <div>
        <Label htmlFor="contentUpgrade">Content Upgrade Preference</Label>
        <Select onValueChange={handleContentUpgradeChange} defaultValue={data.contentUpgradePreference}>
          <SelectTrigger className="w-full">
            <SelectValue placeholder="Select content upgrade type" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="checklist">Checklists</SelectItem>
            <SelectItem value="ebook">eBooks</SelectItem>
            <SelectItem value="template">Templates</SelectItem>
            <SelectItem value="video">Videos</SelectItem>
          </SelectContent>
        </Select>
      </div>
    </div>
  )
}
